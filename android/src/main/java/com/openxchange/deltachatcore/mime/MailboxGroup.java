package com.openxchange.deltachatcore.mime;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class MailboxGroup {
    public String displayName;
    public final List<Mailbox> mailboxes;

    @Keep
    private MailboxGroup(String displayName, ArrayList<Mailbox> mailboxes) {
        this.displayName = displayName;
        this.mailboxes = mailboxes;
    }

    public MailboxGroup(String displayName, Collection<Mailbox> mailboxes) {
        this.displayName = displayName;
        this.mailboxes = new ArrayList<>(mailboxes);
    }

    @NonNull
    @Override
    public String toString() {
        return displayName + ": " + mailboxes + ";";
    }
}
