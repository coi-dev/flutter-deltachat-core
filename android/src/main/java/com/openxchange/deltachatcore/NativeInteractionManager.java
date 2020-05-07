package com.openxchange.deltachatcore;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.PowerManager;

import com.b44t.messenger.DcContext;
import com.openxchange.deltachatcore.handlers.EventChannelHandler;

import java.io.File;
import java.util.Objects;

import androidx.annotation.RequiresApi;

import static android.util.Log.ERROR;
import static android.util.Log.INFO;
import static android.util.Log.WARN;
import static com.openxchange.deltachatcore.DeltaChatCorePlugin.TAG;
import static com.openxchange.deltachatcore.Utils.logEventAndDelegate;

public class NativeInteractionManager extends DcContext {

    private static final String COI_IMAP_WAKE_LOCK = "coi:imapWakeLock";
    private static final String COI_MVBOX_WAKE_LOCK = "coi:mvboxWakeLock";
    private static final String COI_SENT_BOX_WAKE_LOCK = "coi:sentBoxWakeLock";
    private static final String COI_SMTP_WAKE_LOCK = "coi:smtpWakeLock";
    private static final int INTERRUPT_IDLE = 0x01; // interrupt idle if the thread is already running

    private final long wakeLockTimeout = 10 * 60 * 1000L; /*10 minutes*/
    private final String dbPath;
    private final boolean minimalSetup;
    private final EventChannelHandler eventChannelHandler;

    private final Object threadsSynchronized = new Object();
    private final Object loopsSynchronized = new Object();

    // IMAP thread for the inbox folder
    private Thread inboxThread = null;
    private PowerManager.WakeLock imapWakeLock = null;
    private int inboxLoops = 0;

    // IMAP thread for the move-to folder (Deltachat or coi/chats)
    private Thread mvboxThread = null;
    private PowerManager.WakeLock mvboxWakeLock = null;
    private int mvboxLoops = 0;

    // IMAP thread for the sent folder
    private Thread sentBoxThread = null;
    private PowerManager.WakeLock sentBoxWakeLock = null;
    private int sentBoxLoops = 0;

    // SMTP thread for sending messages
    private Thread smtpThread = null;
    private PowerManager.WakeLock smtpWakeLock = null;
    private int smtpLoops = 0;

    // Only relevant if minimalSetup = false, as if minimalSetup = true no threads are used at all
    private boolean threadsRunning = true;

    NativeInteractionManager(Context context, String dbName, boolean minimalSetup, EventChannelHandler eventChannelHandler) {
        super("Android " + BuildConfig.VERSION_NAME);
        this.eventChannelHandler = eventChannelHandler;
        this.minimalSetup = minimalSetup;

        File databaseFile = new File(context.getFilesDir(), dbName);
        dbPath = databaseFile.getAbsolutePath();

        init(context, databaseFile);
    }

    private void init(Context context, File databaseFile) {
        logEventAndDelegate(eventChannelHandler, INFO, TAG, "Opening database");
        open(databaseFile.getAbsolutePath());
        logEventAndDelegate(eventChannelHandler, INFO, TAG, "Database opened");
        if (!minimalSetup) {
            try {
                PowerManager powerManager = (PowerManager) context.getSystemService(Context.POWER_SERVICE);

                imapWakeLock = Objects.requireNonNull(powerManager).newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, COI_IMAP_WAKE_LOCK);
                imapWakeLock.setReferenceCounted(false); // if the idle-thread is killed for any reasons, it is better not to rely on reference counting

                mvboxWakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, COI_MVBOX_WAKE_LOCK);
                mvboxWakeLock.setReferenceCounted(false); // if the idle-thread is killed for any reasons, it is better not to rely on reference counting

                sentBoxWakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, COI_SENT_BOX_WAKE_LOCK);
                sentBoxWakeLock.setReferenceCounted(false); // if the idle-thread is killed for any reasons, it is better not to rely on reference counting

                smtpWakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, COI_SMTP_WAKE_LOCK);
                smtpWakeLock.setReferenceCounted(false); // if the idle-thread is killed for any reasons, it is better not to rely on reference counting
            } catch (Exception e) {
                logEventAndDelegate(eventChannelHandler, ERROR, TAG, "Cannot create wakeLocks");
            }
            startThreads(INTERRUPT_IDLE);
            setupConnectivityObserver(context);
        }
    }

    @Override
    public long handleEvent(final int eventId, long data1, long data2) {
        switch (eventId) {
            case DC_EVENT_INFO:
                logEventAndDelegate(eventChannelHandler, INFO, TAG, dataToString(data2));
                break;

            case DC_EVENT_WARNING:
                logEventAndDelegate(eventChannelHandler, WARN, TAG, dataToString(data2));
                break;

            case DC_EVENT_ERROR:
                // Intended fall through
            case DC_EVENT_ERROR_NETWORK:
                // Intended fall through
            case DC_EVENT_ERROR_SELF_NOT_IN_GROUP:
                delegateError(eventId, data1, dataToString(data2));
                break;
            default:
                delegateEvent(eventId, data1, data2);
                break;
        }
        return 0;
    }

    private void delegateEvent(int eventId, long data1, long data2) {
        final Object data1Object = getData1Object(eventId, data1);
        final Object data2Object = getData2Object(eventId, data2);
        if (eventChannelHandler != null) {
            eventChannelHandler.handleEvent(eventId, data1Object, data2Object);
        }
    }

    private Object getData1Object(int eventId, long data1) {
        return data1IsString(eventId) ? dataToString(data1) : data1;
    }

    private Object getData2Object(int eventId, long data2) {
        return data2IsString(eventId) ? dataToString(data2) : data2;
    }

    private void delegateError(int eventId, long data1, String error) {
        final Object data1Object = getData1Object(eventId, data1);
        eventChannelHandler.handleEvent(eventId, data1Object, error);
    }

    private void startThreads(@SuppressWarnings("SameParameterValue") int flags) {
        logEventAndDelegate(eventChannelHandler, INFO, TAG, "Starting / reusing threads");
        synchronized (threadsSynchronized) {
            if (inboxThread == null || !inboxThread.isAlive()) {

                inboxThread = new Thread(() -> {
                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "INBOX-Thread " + Thread.currentThread().getId() + " started.");
                    while (threadsRunning) {
                        imapWakeLock.acquire(wakeLockTimeout);
                        performImapJobs();
                        performImapFetch();
                        imapWakeLock.release();
                        synchronized (loopsSynchronized) {
                            inboxLoops++;
                        }
                        performImapIdle();
                    }
                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "INBOX-Thread " + Thread.currentThread().getId() + " stopped.");
                }, "inboxThread");
                inboxThread.setPriority(Thread.NORM_PRIORITY);
                inboxThread.start();
            } else {
                if ((flags & INTERRUPT_IDLE) != 0) {
                    interruptImapIdle();
                }
            }

            if (mvboxThread == null || !mvboxThread.isAlive()) {

                mvboxThread = new Thread(() -> {
                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "MVBOX-Thread " + Thread.currentThread().getId() + " started.");
                    while (threadsRunning) {
                        mvboxWakeLock.acquire(wakeLockTimeout);
                        performMvboxJobs();
                        performMvboxFetch();
                        mvboxWakeLock.release();
                        synchronized (loopsSynchronized) {
                            mvboxLoops++;
                        }
                        performMvboxIdle();
                    }
                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "MVBOX-Thread " + Thread.currentThread().getId() + " stopped.");
                }, "mvboxThread");
                mvboxThread.setPriority(Thread.NORM_PRIORITY);
                mvboxThread.start();
            } else {
                if ((flags & INTERRUPT_IDLE) != 0) {
                    interruptMvboxIdle();
                }
            }

            if (sentBoxThread == null || !sentBoxThread.isAlive()) {

                sentBoxThread = new Thread(() -> {
                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "SENTBOX-Thread " + Thread.currentThread().getId() + " started.");
                    while (threadsRunning) {
                        sentBoxWakeLock.acquire(wakeLockTimeout);
                        performSentboxJobs();
                        performSentboxFetch();
                        sentBoxWakeLock.release();
                        synchronized (loopsSynchronized) {
                            sentBoxLoops++;
                        }
                        performSentboxIdle();
                    }
                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "SENTBOX-Thread " + Thread.currentThread().getId() + " stopped.");
                }, "sentBoxThread");
                sentBoxThread.setPriority(Thread.NORM_PRIORITY - 1);
                sentBoxThread.start();
            } else {
                if ((flags & INTERRUPT_IDLE) != 0) {
                    interruptSentboxIdle();
                }
            }

            if (smtpThread == null || !smtpThread.isAlive()) {
                smtpThread = new Thread(() -> {
                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "SMTP-Thread " + Thread.currentThread().getId() + " started.");
                    while (threadsRunning) {
                        smtpWakeLock.acquire(wakeLockTimeout);
                        performSmtpJobs();
                        smtpWakeLock.release();
                        synchronized (loopsSynchronized) {
                            smtpLoops++;
                        }
                        performSmtpIdle();
                    }
                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "SMTP-Thread " + Thread.currentThread().getId() + " stopped.");
                }, "smtpThread");
                smtpThread.setPriority(Thread.MAX_PRIORITY);
                smtpThread.start();
            }
        }
        waitForThreadsExecutedOnce();
        logEventAndDelegate(eventChannelHandler, INFO, TAG, "Threads started / reused");
    }

    private void waitForThreadsExecutedOnce() {
        while (true) {
            synchronized (loopsSynchronized) {
                if (inboxLoops > 0 && mvboxLoops > 0 && sentBoxLoops > 0 && smtpLoops > 0) {
                    break;
                }
            }
            Utils.sleep(500);
        }
    }

    void tearDown() {
        if (!minimalSetup) {
            logEventAndDelegate(eventChannelHandler, INFO, TAG, "Stopping threads");
            stopThreads();
            logEventAndDelegate(eventChannelHandler, INFO, TAG, "Threads stopped");
        }
        logEventAndDelegate(eventChannelHandler, INFO, TAG, "Closing database");
        close();
        logEventAndDelegate(eventChannelHandler, INFO, TAG, "Database closed");
    }

    private void stopThreads() {
        threadsRunning = false;
        synchronized (threadsSynchronized) {
            do {
                // in theory, interrupting once outside the loop should be sufficient,
                // but there are some corner cases, see https://github.com/deltachat/deltachat-core-rust/issues/925
                if (inboxThread != null && inboxThread.isAlive()) {
                    interruptImapIdle();
                }
                if (mvboxThread != null && mvboxThread.isAlive()) {
                    interruptMvboxIdle();
                }
                if (sentBoxThread != null && sentBoxThread.isAlive()) {
                    interruptSentboxIdle();
                }
                if (smtpThread != null && smtpThread.isAlive()) {
                    interruptSmtpIdle();
                }

                Utils.sleep(300);

            } while ((inboxThread != null && inboxThread.isAlive())
                    || (mvboxThread != null && mvboxThread.isAlive())
                    || (sentBoxThread != null && sentBoxThread.isAlive())
                    || (smtpThread != null && smtpThread.isAlive()));
        }
        inboxThread = null;
        mvboxThread = null;
        sentBoxThread = null;
        smtpThread = null;
        inboxLoops = 0;
        mvboxLoops = 0;
        sentBoxLoops = 0;
        smtpLoops = 0;
    }

    private void setupConnectivityObserver(Context context) {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivityManager != null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                registerConnectivityReceiverAndroidN(connectivityManager);
            } else {
                registerConnectivityReceiver(context, connectivityManager);
            }
        }
    }

    private void registerConnectivityReceiver(Context context, ConnectivityManager connectivityManager) {
        context.registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
                boolean isConnected = networkInfo != null && networkInfo.isConnected();
                if (isConnected) {
                    startOnNetworkAvailable();
                }
            }
        }, new IntentFilter(android.net.ConnectivityManager.CONNECTIVITY_ACTION));
    }

    private void startOnNetworkAvailable() {
        logEventAndDelegate(eventChannelHandler, INFO, TAG, "Network is connected again.");
        startThreads(INTERRUPT_IDLE);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    private void registerConnectivityReceiverAndroidN(ConnectivityManager connectivityManager) {
        if (connectivityManager != null) {
            connectivityManager.registerDefaultNetworkCallback(new ConnectivityManager.NetworkCallback() {
                @Override
                public void onAvailable(Network network) {
                    startOnNetworkAvailable();
                }
            });
        }
    }

    String getDbPath() {
        return dbPath;
    }
}

