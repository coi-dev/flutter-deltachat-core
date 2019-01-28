/*
 * OPEN-XCHANGE legal information
 *
 * All intellectual property rights in the Software are protected by
 * international copyright laws.
 *
 *
 * In some countries OX, OX Open-Xchange and open xchange
 * as well as the corresponding Logos OX Open-Xchange and OX are registered
 * trademarks of the OX Software GmbH group of companies.
 * The use of the Logos is not covered by the Mozilla Public License 2.0 (MPL 2.0).
 * Instead, you are allowed to use these Logos according to the terms and
 * conditions of the Creative Commons License, Version 2.5, Attribution,
 * Non-commercial, ShareAlike, and the interpretation of the term
 * Non-commercial applicable to the aforementioned license is published
 * on the web site https://www.open-xchange.com/terms-and-conditions/.
 *
 * Please make sure that third-party modules and libraries are used
 * according to their respective licenses.
 *
 * Any modifications to this package must retain all copyright notices
 * of the original copyright holder(s) for the original code used.
 *
 * After any such modifications, the original and derivative code shall remain
 * under the copyright of the copyright holder(s) and/or original author(s) as stated here:
 * https://www.open-xchange.com/legal/. The contributing author shall be
 * given Attribution for the derivative code and a license granting use.
 *
 * Copyright (C) 2016-2020 OX Software GmbH
 * Mail: info@open-xchange.com
 *
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the Mozilla Public License 2.0
 * for more details.
 */

package com.openxchange.deltachatcore;

import com.b44t.messenger.DcContact;
import com.b44t.messenger.DcContext;
import com.b44t.messenger.DcMsg;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class ContextCallHandler extends AbstractCallHandler {

    private static final String METHOD_CONFIG_SET = "context_configSet";
    private static final String METHOD_CONFIG_GET = "context_configGet";
    private static final String METHOD_CONFIG_GET_INT = "context_configGetInt";
    private static final String METHOD_CONFIGURE = "context_configure";
    private static final String METHOD_IS_CONFIGURED = "context_isConfigured";
    private static final String METHOD_ADD_ADDRESS_BOOK = "context_addAddressBook";
    private static final String METHOD_CREATE_CONTACT = "context_createContact";
    private static final String METHOD_DELETE_CONTACT = "context_deleteContact";
    private static final String METHOD_CREATE_CHAT_BY_CONTACT_ID = "context_createChatByContactId";
    private static final String METHOD_CREATE_CHAT_BY_MESSAGE_ID = "context_createChatByMessageId";
    private static final String METHOD_CREATE_GROUP_CHAT = "context_createGroupChat";
    private static final String METHOD_GET_CONTACTS = "context_getContacts";
    private static final String METHOD_GET_CHAT_MESSAGES = "context_getChatMessages";
    private static final String METHOD_CREATE_CHAT_MESSAGE = "context_createChatMessage";

    private static final String TYPE_INT = "int";
    private static final String TYPE_STRING = "String";

    private static final int DC_MSG_UNDEFINED = 0;
    private static final int DC_MSG_TEXT = 10;
    private static final int DC_MSG_IMAGE = 20;
    private static final int DC_MSG_GIF = 21;
    private static final int DC_MSG_AUDIO = 40;
    private static final int DC_MSG_VOICE = 41;
    private static final int DC_MSG_VIDEO = 50;
    private static final int DC_MSG_FILE = 60;

    private final Cache<DcContact> contactCache;
    private final Cache<DcMsg> messageCache;

    ContextCallHandler(DcContext dcContext, MethodCall methodCall, MethodChannel.Result result, Cache<DcContact> contactCache, Cache<DcMsg> messageCache) {
        super(dcContext, methodCall, result);
        this.contactCache = contactCache;
        this.messageCache = messageCache;
        switch (methodCall.method) {
            case METHOD_CONFIG_SET:
                setConfig();
                break;
            case METHOD_CONFIG_GET:
                getConfig(TYPE_STRING);
                break;
            case METHOD_CONFIG_GET_INT:
                getConfig(TYPE_INT);
                break;
            case METHOD_CONFIGURE:
                configure();
                break;
            case METHOD_IS_CONFIGURED:
                isConfigured();
                break;
            case METHOD_ADD_ADDRESS_BOOK:
                addAddressBook();
                break;
            case METHOD_CREATE_CONTACT:
                createContact();
                break;
            case METHOD_DELETE_CONTACT:
                deleteContact();
                break;
            case METHOD_CREATE_CHAT_BY_CONTACT_ID:
                createChatByContactId();
                break;
            case METHOD_CREATE_CHAT_BY_MESSAGE_ID:
                createChatByMessageId();
                break;
            case METHOD_CREATE_GROUP_CHAT:
                createGroupChat();
                break;
            case METHOD_GET_CONTACTS:
                getContacts();
                break;
            case METHOD_GET_CHAT_MESSAGES:
                getChatMessages();
                break;
            case METHOD_CREATE_CHAT_MESSAGE:
                createChatMessage();
                break;
            default:
                result.notImplemented();
        }
    }

    private void setConfig() {
        if (!hasArgumentKeys(ARGUMENT_KEY_TYPE, ARGUMENT_KEY_KEY, ARGUMENT_KEY_VALUE)) {
            errorArgumentMissing();
            return;
        }
        String type = methodCall.argument(ARGUMENT_KEY_TYPE);
        if (type == null) {
            errorArgumentMissingValue();
            return;
        }
        String key = methodCall.argument(ARGUMENT_KEY_KEY);
        switch (type) {
            case TYPE_INT: {
                Integer value = methodCall.argument(ARGUMENT_KEY_VALUE);
                if (value == null) {
                    errorArgumentMissingValue();
                    return;
                }
                dcContext.setConfigInt(key, value);
                break;
            }
            case TYPE_STRING: {
                String value = methodCall.argument(ARGUMENT_KEY_VALUE);
                dcContext.setConfig(key, value);
                break;
            }
            default:
                errorArgumentTypeMismatch(ARGUMENT_KEY_TYPE);
                break;
        }
        result.success(null);
    }


    private void getConfig(String type) {
        if (!hasArgumentKeys(ARGUMENT_KEY_KEY)) {
            errorArgumentMissing();
            return;
        }
        String key = methodCall.argument(ARGUMENT_KEY_KEY);
        switch (type) {
            case TYPE_INT: {
                int resultValue = dcContext.getConfigInt(key, -1);
                result.success(resultValue);
                break;
            }
            case TYPE_STRING: {
                String resultValue = dcContext.getConfig(key, "");
                result.success(resultValue);
                break;
            }
            default:
                errorArgumentTypeMismatch(ARGUMENT_KEY_TYPE);
                break;
        }
    }

    private void configure() {
        dcContext.configure();
        result.success(null);
    }

    private void isConfigured() {
        boolean configured = dcContext.isConfigured() == 1;
        result.success(configured);
    }

    private void addAddressBook() {
        if (!hasArgumentKeys(ARGUMENT_ADDRESS_BOOK)) {
            errorArgumentMissing();
            return;
        }
        String addressBook = methodCall.argument(ARGUMENT_ADDRESS_BOOK);
        if (addressBook == null || addressBook.isEmpty()) {
            errorArgumentMissingValue();
            return;
        }
        contactCache.clear();
        int changedCount = dcContext.addAddressBook(addressBook);
        result.success(changedCount);
    }

    private void createContact() {
        if (!hasArgumentKeys(ARGUMENT_ADDRESS)) {
            errorArgumentMissing();
            return;
        }
        String name = methodCall.argument(ARGUMENT_NAME);
        String address = methodCall.argument(ARGUMENT_ADDRESS);
        int contactId = dcContext.createContact(name, address);
        contactCache.put(contactId, dcContext.getContact(contactId));
        result.success(contactId);
    }

    private void deleteContact() {
        if (!hasArgumentKeys(ARGUMENT_ID)) {
            errorArgumentMissing();
            return;
        }
        Integer contactId = methodCall.argument(ARGUMENT_ID);
        if (contactId == null) {
            errorArgumentMissingValue();
            return;
        }
        boolean deleted = dcContext.deleteContact(contactId);
        if (deleted) {
            contactCache.delete(contactId);
        }
        result.success(deleted);
    }

    private void createChatByContactId() {
        if (!hasArgumentKeys(ARGUMENT_ID)) {
            errorArgumentMissing();
            return;
        }
        Integer contactId = methodCall.argument(ARGUMENT_ID);
        if (contactId == null) {
            errorArgumentMissingValue();
            return;
        }
        int chatId = dcContext.createChatByContactId(contactId);
        result.success(chatId);
    }

    private void createChatByMessageId() {
        if (!hasArgumentKeys(ARGUMENT_ID)) {
            errorArgumentMissing();
            return;
        }
        Integer messageId = methodCall.argument(ARGUMENT_ID);
        if (messageId == null) {
            errorArgumentMissingValue();
            return;
        }
        int chatId = dcContext.createChatByMsgId(messageId);
        result.success(chatId);
    }

    private void createGroupChat() {
        if (!hasArgumentKeys(ARGUMENT_VERIFIED, ARGUMENT_NAME)) {
            errorArgumentMissing();
            return;
        }
        Boolean verified = methodCall.argument(ARGUMENT_VERIFIED);
        if (verified == null) {
            errorArgumentMissingValue();
            return;
        }
        String name = methodCall.argument(ARGUMENT_NAME);
        int chatId = dcContext.createGroupChat(verified, name);
        result.success(chatId);
    }


    private void getContacts() {
        if (!hasArgumentKeys(ARGUMENT_FLAGS, ARGUMENT_QUERY)) {
            errorArgumentMissing();
            return;
        }
        Integer flags = methodCall.argument(ARGUMENT_FLAGS);
        String query = methodCall.argument(ARGUMENT_QUERY);
        if (flags == null) {
            errorArgumentMissingValue();
            return;
        }
        int[] contactIds = dcContext.getContacts(flags, query);
        for (int contactId : contactIds) {
            DcContact contact = contactCache.get(contactId);
            if (contact == null) {
                contactCache.put(contactId, dcContext.getContact(contactId));
            }
        }
        result.success(contactIds);
    }

    private void getChatMessages() {
        if (!hasArgumentKeys(ARGUMENT_ID)) {
            errorArgumentMissing();
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_ID);
        if (id == null) {
            errorArgumentMissingValue();
            return;
        }

        int[] messageIds = dcContext.getChatMsgs(id, 0, 0);
        for (int messageId : messageIds) {
            DcMsg msg = messageCache.get(messageId);
            if (msg == null) {
                messageCache.put(messageId, dcContext.getMsg(messageId));
            }
        }
        result.success(messageIds);
    }

    private void createChatMessage() {
        if (!hasArgumentKeys(ARGUMENT_ID, ARGUMENT_KEY_VALUE)) {
            errorArgumentMissing();
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_ID);
        if (id == null) {
            errorArgumentMissingValue();
            return;
        }

        String text = methodCall.argument(ARGUMENT_KEY_VALUE);

        DcMsg newMsg = new DcMsg(dcContext, DcMsg.DC_MSG_TEXT);
        newMsg.setText(text);
        int msgId = dcContext.sendMsg(id, newMsg);
        result.success(msgId);
    }

}
