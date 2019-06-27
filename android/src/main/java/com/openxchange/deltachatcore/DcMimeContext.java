package com.openxchange.deltachatcore;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.b44t.messenger.DcContext;

import java.util.List;
import java.util.Map;

public class DcMimeContext extends DcContext {
    static { init(); }

    private static native void init();
    private native void initInstance(long contextCPtr);

    public DcMimeContext(String osName) {
        super(osName);
        initInstance(contextCPtr);
    }

    public class ContentType {
        private String type;
        private String subtype;
        private Map<String, String> params;

        @Keep
        private ContentType(String type, String subtype, Map<String, String> params) {
            this.type = type;
            this.subtype = subtype;
            this.params = params;
        }

        public String getType() { return type; }
        public String getSubtype() { return subtype; }
        public String getParameter(String name) { return params.get(name); }
    }

    public class Mail {
        private long cPtr;
        private Mail parent;
        private byte[] body = null;
        private ContentType contentType = null;

        private Mail(long mailmime, Mail parent) {
            cPtr = mailmime;
            this.parent = parent;
        }

        @Nullable Mail getParent() { return parent; }

        private native byte[] getBody(long cPtr);
        public byte[] getBody() {
            if (body == null) body = getBody(cPtr);
            return body;
        }

        private native ContentType getContentType(long cPtr);
        public ContentType GetContentType() {
            if (contentType == null) contentType = getContentType(cPtr);
            return contentType;
        }
    }

    protected void receiveMail(long mime) {
        if (mime == 0) return;
        receiveMail(new Mail(mime, null));
    }

    // MIME API - @Override the method to be notified about received mails
    public void receiveMail(@NonNull Mail mime) {}
}
