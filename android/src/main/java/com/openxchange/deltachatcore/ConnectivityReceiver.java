package com.openxchange.deltachatcore;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;

import static com.openxchange.deltachatcore.DeltaChatCorePlugin.TAG;

public class ConnectivityReceiver extends BroadcastReceiver {

    private final NativeInteractionManager nativeInteractionManager;

    ConnectivityReceiver(NativeInteractionManager nativeInteractionManager) {
        this.nativeInteractionManager = nativeInteractionManager;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivityManager == null) {
            return;
        }
        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
        boolean isConnected = networkInfo != null && networkInfo.isConnected();
        if (isConnected) {
            Log.i(TAG, "###################### Network is connected again. ######################");
            nativeInteractionManager.start();
        }
    }
}
