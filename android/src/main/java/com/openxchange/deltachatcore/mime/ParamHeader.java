package com.openxchange.deltachatcore.mime;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import java.util.Map;

public class ParamHeader {
    private String value;
    private Map<String, String> params;

    @Keep
    private ParamHeader(String value, Map<String, String> params) {
        this.value = value;
        this.params = params;
    }

    public String getValue() { return value; }
    public String getParameter(String name) { return params.get(name); }

    @NonNull
    @Override
    public String toString() {
        return value + "; " + params;
    }
}
