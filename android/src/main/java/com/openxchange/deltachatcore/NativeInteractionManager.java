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

import static android.util.Log.DEBUG;
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
    private final EventChannelHandler eventChannelHandler;

    private final Object threadsSynchronized = new Object();
    private final Object imapThreadSynchronized = new Object();
    private final Object mvboxThreadSynchronized = new Object();
    private final Object sentBoxThreadSynchronized = new Object();
    private final Object smtpThreadSynchronized = new Object();
    private Thread imapThread = null;
    private PowerManager.WakeLock imapWakeLock = null;
    private Thread mvboxThread = null;
    private PowerManager.WakeLock mvboxWakeLock = null;
    private Thread sentBoxThread = null;
    private PowerManager.WakeLock sentBoxWakeLock = null;
    private Thread smtpThread = null;
    private PowerManager.WakeLock smtpWakeLock = null;
    private boolean imapThreadStarted;
    private boolean mvboxThreadStarted;
    private boolean sentBoxThreadStarted;
    private boolean smtpThreadStarted;

    NativeInteractionManager(Context context, String dbName, EventChannelHandler eventChannelHandler) {
        super("Android " + BuildConfig.VERSION_NAME);
        this.eventChannelHandler = eventChannelHandler;

        File databaseFile = new File(context.getFilesDir(), dbName);
        dbPath = databaseFile.getAbsolutePath();
        open(databaseFile.getAbsolutePath());

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
        start();
        setupConnectivityObserver(context);
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

    private void start() {
        logEventAndDelegate(eventChannelHandler, DEBUG, TAG, "Starting threads");
        startThreads(INTERRUPT_IDLE);
        waitForThreadsRunning();
    }

    private void startThreads(@SuppressWarnings("SameParameterValue") int flags) {
        synchronized (threadsSynchronized) {

            if (imapThread == null || !imapThread.isAlive()) {

                synchronized (imapThreadSynchronized) {
                    imapThreadStarted = false;
                }

                imapThread = new Thread(() -> {
                    // raise the starting condition
                    // after acquiring a wakelock so that the process is not terminated.
                    // as imapWakeLock is not reference counted that would result in a wakelock-gap is not needed here.
                    imapWakeLock.acquire(wakeLockTimeout);
                    synchronized (imapThreadSynchronized) {
                        imapThreadStarted = true;
                        imapThreadSynchronized.notifyAll();
                    }

                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "###################### IMAP-Thread " + Thread.currentThread().getId() + " started. ######################");


                    while (true) {
                        if (Thread.interrupted()) {
                            synchronized (imapThreadSynchronized) {
                                imapThreadStarted = false;
                                imapThreadSynchronized.notifyAll();
                            }
                            logEventAndDelegate(eventChannelHandler, INFO, TAG, "###################### IMAP-Thread " + Thread.currentThread().getId() + " stopped. ######################");
                            return;
                        }
                        imapWakeLock.acquire(wakeLockTimeout);
                        performImapJobs();
                        performImapFetch();
                        imapWakeLock.release();
                        performImapIdle();
                    }
                }, "imapThread");
                imapThread.setPriority(Thread.NORM_PRIORITY);
                imapThread.start();
            } else {
                if ((flags & INTERRUPT_IDLE) != 0) {
                    interruptImapIdle();
                }
            }


            if (mvboxThread == null || !mvboxThread.isAlive()) {

                synchronized (mvboxThreadSynchronized) {
                    mvboxThreadStarted = false;
                }

                mvboxThread = new Thread(() -> {
                    mvboxWakeLock.acquire(wakeLockTimeout);
                    synchronized (mvboxThreadSynchronized) {
                        mvboxThreadStarted = true;
                        mvboxThreadSynchronized.notifyAll();
                    }

                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "###################### MVBOX-Thread " + Thread.currentThread().getId() + " started. ######################");


                    while (true) {
                        if (Thread.interrupted()) {
                            synchronized (mvboxThreadSynchronized) {
                                mvboxThreadStarted = false;
                                mvboxThreadSynchronized.notifyAll();
                            }
                            logEventAndDelegate(eventChannelHandler, INFO, TAG, "###################### MVBOX-Thread " + Thread.currentThread().getId() + " stopped. ######################");
                            return;
                        }
                        mvboxWakeLock.acquire(wakeLockTimeout);
                        performMvboxJobs();
                        performMvboxFetch();
                        mvboxWakeLock.release();
                        performMvboxIdle();
                    }
                }, "mvboxThread");
                mvboxThread.setPriority(Thread.NORM_PRIORITY);
                mvboxThread.start();
            } else {
                if ((flags & INTERRUPT_IDLE) != 0) {
                    interruptMvboxIdle();
                }
            }


            if (sentBoxThread == null || !sentBoxThread.isAlive()) {

                synchronized (sentBoxThreadSynchronized) {
                    sentBoxThreadStarted = false;
                }

                sentBoxThread = new Thread(() -> {
                    sentBoxWakeLock.acquire(wakeLockTimeout);
                    synchronized (sentBoxThreadSynchronized) {
                        sentBoxThreadStarted = true;
                        sentBoxThreadSynchronized.notifyAll();
                    }

                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "###################### SENTBOX-Thread " + Thread.currentThread().getId() + " started. ######################");


                    while (true) {
                        if (Thread.interrupted()) {
                            synchronized (sentBoxThreadSynchronized) {
                                sentBoxThreadStarted = false;
                                sentBoxThreadSynchronized.notifyAll();
                            }
                            logEventAndDelegate(eventChannelHandler, INFO, TAG, "###################### SENTBOX-Thread " + Thread.currentThread().getId() + " stopped. ######################");
                            return;
                        }
                        sentBoxWakeLock.acquire(wakeLockTimeout);
                        performSentboxJobs();
                        performSentboxFetch();
                        sentBoxWakeLock.release();
                        performSentboxIdle();
                    }
                }, "sentBoxThread");
                sentBoxThread.setPriority(Thread.NORM_PRIORITY - 1);
                sentBoxThread.start();
            } else {
                if ((flags & INTERRUPT_IDLE) != 0) {
                    interruptSentboxIdle();
                }
            }


            if (smtpThread == null || !smtpThread.isAlive()) {

                synchronized (smtpThreadSynchronized) {
                    smtpThreadStarted = false;
                }

                smtpThread = new Thread(() -> {
                    smtpWakeLock.acquire(wakeLockTimeout);
                    synchronized (smtpThreadSynchronized) {
                        smtpThreadStarted = true;
                        smtpThreadSynchronized.notifyAll();
                    }

                    logEventAndDelegate(eventChannelHandler, INFO, TAG, "###################### SMTP-Thread " + Thread.currentThread().getId() + " started. ######################");


                    while (true) {
                        if (Thread.interrupted()) {
                            synchronized (smtpThreadSynchronized) {
                                smtpThreadStarted = false;
                                smtpThreadSynchronized.notifyAll();
                            }
                            logEventAndDelegate(eventChannelHandler, INFO, TAG, "###################### SMTP-Thread " + Thread.currentThread().getId() + " stopped. ######################");
                            return;
                        }
                        smtpWakeLock.acquire(wakeLockTimeout);
                        performSmtpJobs();
                        smtpWakeLock.release();
                        performSmtpIdle();
                    }
                }, "smtpThread");
                smtpThread.setPriority(Thread.MAX_PRIORITY);
                smtpThread.start();
            }
        }
    }

    private void waitForThreadsRunning() {
        try {
            synchronized (imapThreadSynchronized) {
                while (!imapThreadStarted) {
                    imapThreadSynchronized.wait();
                }
            }

            synchronized (mvboxThreadSynchronized) {
                while (!mvboxThreadStarted) {
                    mvboxThreadSynchronized.wait();
                }
            }

            synchronized (sentBoxThreadSynchronized) {
                while (!sentBoxThreadStarted) {
                    sentBoxThreadSynchronized.wait();
                }
            }

            synchronized (smtpThreadSynchronized) {
                while (!smtpThreadStarted) {
                    smtpThreadSynchronized.wait();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void stop() {
        logEventAndDelegate(eventChannelHandler, DEBUG, TAG, "Stopping threads");
        stopThreads();
        interruptImapIdle();
        interruptMvboxIdle();
        interruptSentboxIdle();
        interruptSmtpIdle();
        imapThread = null;
        mvboxThread = null;
        sentBoxThread = null;
        smtpThread = null;
        logEventAndDelegate(eventChannelHandler, DEBUG, TAG, "Closing database");
        close();
    }

    private void stopThreads() {
        if (imapThread != null) {
            imapThread.interrupt();
        }
        if (mvboxThread != null) {
            mvboxThread.interrupt();
        }
        if (sentBoxThread != null) {
            sentBoxThread.interrupt();
        }
        if (smtpThread != null) {
            smtpThread.interrupt();
        }
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
        logEventAndDelegate(eventChannelHandler, INFO, TAG, "###################### Network is connected again. ######################");
        start();
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

