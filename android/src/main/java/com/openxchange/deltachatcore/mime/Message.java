package com.openxchange.deltachatcore.mime;

import java.util.ArrayList;
import java.util.List;

public class Message {
    private long cPtr;
    private boolean multipart;
    private byte[] body = null;
    private ParamHeader contentType = null;
    private HeaderMap headers = null;
    private List<Message> parts = null;

    Message(long mailmime, boolean multipart) {
        cPtr = mailmime;
        this.multipart = multipart;
        if (!multipart) parts = new ArrayList<>();
    }

    private native byte[] getBody(long cPtr);
    public byte[] getBody() {
        if (body == null) body = getBody(cPtr);
        return body;
    }

    private native ParamHeader getContentType(long cPtr);
    public ParamHeader getContentType() {
        if (contentType == null) contentType = getContentType(cPtr);
        return contentType;
    }

    private native List<Header> getHeaders(long cPtr);
    public Header getHeader(String name) {
        if (headers == null) headers = new HeaderMap(getHeaders(cPtr));
        return headers.getHeader(name);
    }
    public Iterable<Header> listHeaders() {
        if (headers == null) headers = new HeaderMap(getHeaders(cPtr));
        return headers;
    }

    private native List<Message> getParts(long cPtr);
    public List<Message> getParts() {
        if (parts == null) parts = getParts(cPtr);
        return parts;
    }
}
