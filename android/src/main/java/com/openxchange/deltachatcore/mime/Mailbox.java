package com.openxchange.deltachatcore.mime;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class Mailbox {
    @Nullable
    public String displayName;
    @NonNull
    public String address;

    @Keep
    public Mailbox(@Nullable String displayName, @NonNull String address) {
        this.displayName = displayName;
        this.address = address;
    }

    @NonNull
    @Override
    public String toString() {
        return displayName == null ? address : "\"" + displayName + "\" <" + address + ">";
    }
}
