/*
 * Copyright (C) 2018 Delta Chat contributors
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.b44t.messenger;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.PowerManager;
import android.util.Log;

import com.openxchange.deltachatcore.BuildConfig;
import com.openxchange.deltachatcore.DeltaChatCorePlugin;
import com.openxchange.deltachatcore.ForegroundDetector;
import com.openxchange.deltachatcore.Utils;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;


public class ApplicationDcContext extends DcContext {

    private static final String OX_TALK_IMAP_WAKE_LOCK = "ox.talk:imapWakeLock";
    private static final String OX_TALK_SMTP_WAKE_LOCK = "ox.talk:smtpWakeLock";
    private static final String OX_TALK_AFTER_FOREGROUND_WAKE_LOCK = "ox.talk:afterForegroundWakeLock";
    private Context context;
    private ForegroundDetector foregroundDetector;

    public ApplicationDcContext(Activity activity) {
        super("android-dev");
        this.context = activity;

        File dbfile = new File(activity.getFilesDir(), "messenger.db");
        open(dbfile.getAbsolutePath());
        setConfig("e2ee_enabled", "1");

        try {
            PowerManager pm = (PowerManager) activity.getSystemService(Context.POWER_SERVICE);

            imapWakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, OX_TALK_IMAP_WAKE_LOCK);
            imapWakeLock.setReferenceCounted(false); // if the idle-thread is killed for any reasons, it is better not to rely on reference counting

            smtpWakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, OX_TALK_SMTP_WAKE_LOCK);
            smtpWakeLock.setReferenceCounted(false); // if the idle-thread is killed for any reasons, it is better not to rely on reference counting

            afterForegroundWakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, OX_TALK_AFTER_FOREGROUND_WAKE_LOCK);
            afterForegroundWakeLock.setReferenceCounted(false);

        } catch (Exception e) {
            Log.e("DeltaChat", "Cannot create wakeLocks");
        }

        foregroundDetector = new ForegroundDetector(activity, new ForegroundDetector.LifeCycleListener() {
            @Override
            public void onForeground() {
                startThreads(); // we call this without checking getPermanentPush() to have a simple guarantee that push is always active when the app is in foregroud (startIdleThread makes sure the thread is not started twice)
            }

            @Override
            public void onBackground() {
                afterForegroundWakeLock.acquire(60 * 1000);
            }
        });
        startThreads();
    }

    public File getImexDir()
    {
        // DIRECTORY_DOCUMENTS is only available since KitKat;
        // as we also support Ice Cream Sandwich and Jellybean (2017: 11% in total), this is no option.
        // Moreover, DIRECTORY_DOWNLOADS seems to be easier accessible by the user,
        // eg. "Download Managers" are nearly always installed.
        // CAVE: do not use DownloadManager to add the file as it is deleted on uninstall then ...
        return Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
    }

    public static HashMap<String, Integer> sharedFiles = new HashMap<>();

    public void openForViewOrShare(int msg_id, String cmd)
    {
        DcMsg msg = getMsg(msg_id);
        String path = msg.getFile();
        String mimeType = msg.getFilemime();
        try {
            File file = new File(path);
            if( !file.exists() ) {
                DeltaChatCorePlugin.showToast("share_file_not_found");
                return;
            }

            Uri uri = null;
            if (path.startsWith(getBlobdir())) {
                uri = Uri.parse("content://" + BuildConfig.APPLICATION_ID + ".attachments/" + file.getName());
                sharedFiles.put("/"+file.getName(), 1); // as different Android version handle uris in putExtra differently, we also check them on our own
            } else {
                if (Build.VERSION.SDK_INT >= 24) {
                    //uri = FileProvider.getUriForFile(context, BuildConfig.APPLICATION_ID + ".fileprovider", file);
                }
                else {
                    uri = Uri.fromFile(file);
                }
            }

            if( cmd.equals(Intent.ACTION_VIEW) ) {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setDataAndType(uri, mimeType);
                intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                context.startActivity(intent);
            }
            else {
                Intent intent = new Intent(Intent.ACTION_SEND);
                intent.setType(mimeType);
                intent.putExtra(Intent.EXTRA_STREAM, uri);
                intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                //context.startActivity(Intent.createChooser(intent, context.getString(R.string.ShareActivity_share_with)));
            }

        }
        catch (Exception e) {
            DeltaChatCorePlugin.showToast("share_unable_to_open_media");
        }
    }

    /***********************************************************************************************
     * Working Threads
     **********************************************************************************************/

    private final Object threadsCritical = new Object();

    private boolean imapThreadStartedVal;
    private final Object imapThreadStartedCond = new Object();
    public Thread imapThread = null;
    private PowerManager.WakeLock imapWakeLock = null;

    private boolean smtpThreadStartedVal;
    private final Object smtpThreadStartedCond = new Object();
    public Thread smtpThread = null;
    private PowerManager.WakeLock smtpWakeLock = null;

    public PowerManager.WakeLock afterForegroundWakeLock = null;

    public void startThreads()
    {
        synchronized(threadsCritical) {

            if (imapThread == null || !imapThread.isAlive()) {

                synchronized (imapThreadStartedCond) {
                    imapThreadStartedVal = false;
                }

                imapThread = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        // raise the starting condition
                        // after acquiring a wakelock so that the process is not terminated.
                        // as imapWakeLock is not reference counted that would result in a wakelock-gap is not needed here.
                        imapWakeLock.acquire();
                        synchronized (imapThreadStartedCond) {
                            imapThreadStartedVal = true;
                            imapThreadStartedCond.notifyAll();
                        }

                        Log.i("DeltaChat", "###################### IMAP-Thread started. ######################");


                        while (true) {
                            imapWakeLock.acquire();
                            performImapJobs();
                            performImapFetch();
                            imapWakeLock.release();
                            performImapIdle();
                        }
                    }
                }, "imapThread");
                imapThread.setPriority(Thread.NORM_PRIORITY);
                imapThread.start();
            }

            if (smtpThread == null || !smtpThread.isAlive()) {

                synchronized (smtpThreadStartedCond) {
                    smtpThreadStartedVal = false;
                }

                smtpThread = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        smtpWakeLock.acquire();
                        synchronized (smtpThreadStartedCond) {
                            smtpThreadStartedVal = true;
                            smtpThreadStartedCond.notifyAll();
                        }

                        Log.i("DeltaChat", "###################### SMTP-Thread started. ######################");


                        while (true) {
                            smtpWakeLock.acquire();
                            performSmtpJobs();
                            smtpWakeLock.release();
                            performSmtpIdle();
                        }
                    }
                }, "smtpThread");
                smtpThread.setPriority(Thread.MAX_PRIORITY);
                smtpThread.start();
            }
        }
    }

    public void waitForThreadsRunning()
    {
        try {
            synchronized( imapThreadStartedCond ) {
                while( !imapThreadStartedVal ) {
                    imapThreadStartedCond.wait();
                }
            }

            synchronized( smtpThreadStartedCond ) {
                while( !smtpThreadStartedVal ) {
                    smtpThreadStartedCond.wait();
                }
            }
        }
        catch( Exception e ) {
            e.printStackTrace();
        }
    }


    /***********************************************************************************************
     * Event Handling
     **********************************************************************************************/

    public DcEventCenter eventCenter = new DcEventCenter();

    private final Object lastErrorLock = new Object();
    private String lastErrorString = "";
    private boolean showNextErrorAsToast = true;

    public void captureNextError() {
        synchronized (lastErrorLock) {
            showNextErrorAsToast = false;
            lastErrorString = "";
        }
    }

    public boolean hasCapturedError() {
        synchronized (lastErrorLock) {
            return !lastErrorString.isEmpty();
        }
    }

    public String getCapturedError() {
        synchronized (lastErrorLock) {
            return lastErrorString;
        }
    }

    public void endCaptureNextError() {
        synchronized (lastErrorLock) {
            showNextErrorAsToast = true;
        }
    }

    @Override
    public long handleEvent(final int event, long data1, long data2) {
        switch(event) {
            case DC_EVENT_INFO:
                Log.i("DeltaChat", dataToString(data2));
                break;

            case DC_EVENT_WARNING:
                Log.w("DeltaChat", dataToString(data2));
                break;

            case DC_EVENT_ERROR:
                Log.e("DeltaChat", dataToString(data2));
                synchronized (lastErrorLock) {
                    lastErrorString = dataToString(data2);
                }
                Utils.runOnMain(new Runnable() {
                    @Override
                    public void run() {
                        synchronized (lastErrorLock) {
                            if (showNextErrorAsToast) {
                                if (foregroundDetector.isForeground()) {
                                    DeltaChatCorePlugin.showToast(lastErrorString);
                                }
                            }
                            showNextErrorAsToast = true;
                        }
                    }
                });
                break;

            case DC_EVENT_HTTP_GET:
                String httpContent = null;
                try {
                    URL url = new URL(dataToString(data1));
                    HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
                    try {
                        urlConnection.setConnectTimeout(10*1000);
                        InputStream inputStream = new BufferedInputStream(urlConnection.getInputStream());

                        BufferedReader r = new BufferedReader(new InputStreamReader(inputStream));

                        StringBuilder total = new StringBuilder();
                        String line;
                        while ((line = r.readLine()) != null) {
                            total.append(line).append('\n');
                        }
                        httpContent = total.toString();
                    } finally {
                        urlConnection.disconnect();
                    }
                }
                catch(Exception e) {
                    e.printStackTrace();
                }
                return stringToData(httpContent);

            case DC_EVENT_GET_STRING:
                String s;
                switch( (int)data1 ) { // the integers are defined in the core and used only here, an enum or sth. like that won't have a big benefit
                    //case  8: s = context.getString(R.string.menu_deaddrop); break;
                    //case 13: s = context.getString(R.string.default_status_text); break;
                    //case 42: s = context.getString(R.string.autocrypt__asm_subject); break;
                    //case 43: s = context.getString(R.string.autocrypt__asm_general_body); break;
                    default: s = null; break;
                }
                return stringToData(s);

            default:
                {
                    final Object data1obj = data1IsString(event)? dataToString(data1) : data1;
                    final Object data2obj = data2IsString(event)? dataToString(data2) : data2;
                    if(eventCenter!=null) {
                        eventCenter.sendToObservers(event, data1obj, data2obj);
                    }
                }
                break;
        }
        return 0;
    }
}
