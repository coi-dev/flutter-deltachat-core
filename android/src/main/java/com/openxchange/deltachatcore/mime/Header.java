package com.openxchange.deltachatcore.mime;

import androidx.annotation.Keep;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class Header<T> {
    private String name;
    private T value;

    public Header(String name, T value) {
        this.name = name;
        this.value = value;
    }

    public String getName() { return name; }

    public T getValue() { return value; }
}
