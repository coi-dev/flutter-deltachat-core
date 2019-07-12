package com.openxchange.deltachatcore.mime;

import androidx.annotation.NonNull;

import com.b44t.messenger.DcContext;

public class DcMimeContext extends DcContext {
    static { init(); }

    private static native void init();
    private native void initInstance(long contextCPtr);

    public DcMimeContext(String osName) {
        super(osName);
        initInstance(contextCPtr);
    }

    // MIME API - @Override the method to be notified about received mails
    public void receiveMail(@NonNull Message message) {}
}
