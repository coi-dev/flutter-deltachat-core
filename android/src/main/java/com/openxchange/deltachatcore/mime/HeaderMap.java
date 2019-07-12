package com.openxchange.deltachatcore.mime;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class HeaderMap implements Iterable<Header> {
    private List<Header> list;
    private Map<String, Header> map = new HashMap<>();

    HeaderMap(List<Header> headers) {
        list = headers;
        for (Header header : headers) map.put(header.getName(), header);
    }

    public Header getHeader(String name) { return map.get(name); }

    @NonNull
    @Override
    public Iterator<Header> iterator() { return list.iterator(); }
}
