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

package com.openxchange.deltachatcore.handlers;

import com.b44t.messenger.DcChat;
import com.b44t.messenger.DcContact;
import com.b44t.messenger.DcContext;
import com.b44t.messenger.DcLot;
import com.b44t.messenger.DcMsg;
import com.openxchange.deltachatcore.IdCache;

import java.util.ArrayList;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ContextCallHandler extends com.openxchange.deltachatcore.handlers.AbstractCallHandler {

    private static final String METHOD_CONFIG_SET = "context_configSet";
    private static final String METHOD_CONFIG_GET = "context_configGet";
    private static final String METHOD_CONFIG_GET_INT = "context_configGetInt";
    private static final String METHOD_CONFIGURE = "context_configure";
    private static final String METHOD_IS_CONFIGURED = "context_isConfigured";
    private static final String METHOD_ADD_ADDRESS_BOOK = "context_addAddressBook";
    private static final String METHOD_CREATE_CONTACT = "context_createContact";
    private static final String METHOD_DELETE_CONTACT = "context_deleteContact";
    private static final String METHOD_BLOCK_CONTACT = "context_blockContact";
    private static final String METHOD_UNBLOCK_CONTACT = "context_unblockContact";
    private static final String METHOD_GET_BLOCKED_CONTACTS = "context_getBlockedContacts";
    private static final String METHOD_CREATE_CHAT_BY_CONTACT_ID = "context_createChatByContactId";
    private static final String METHOD_CREATE_CHAT_BY_MESSAGE_ID = "context_createChatByMessageId";
    private static final String METHOD_CREATE_GROUP_CHAT = "context_createGroupChat";
    private static final String METHOD_GET_CONTACT = "context_getContact";
    private static final String METHOD_GET_CONTACTS = "context_getContacts";
    private static final String METHOD_GET_CHAT_CONTACTS = "context_getChatContacts";
    private static final String METHOD_GET_CHAT = "context_getChat";
    private static final String METHOD_GET_CHAT_MESSAGES = "context_getChatMessages";
    private static final String METHOD_CREATE_CHAT_MESSAGE = "context_createChatMessage";
    private static final String METHOD_CREATE_CHAT_ATTACHMENT_MESSAGE = "context_createChatAttachmentMessage";
    private static final String METHOD_ADD_CONTACT_TO_CHAT = "context_addContactToChat";
    private static final String METHOD_GET_CHAT_BY_CONTACT_ID = "context_getChatByContactId";
    private static final String METHOD_GET_FRESH_MESSAGE_COUNT = "context_getFreshMessageCount";
    private static final String METHOD_MARK_NOTICED_CHAT = "context_markNoticedChat";
    private static final String METHOD_DELETE_CHAT = "context_deleteChat";
    private static final String METHOD_REMOVE_CONTACT_FROM_CHAT = "context_removeContactFromChat";
    private static final String METHOD_IMPORT_KEYS = "context_importKeys";
    private static final String METHOD_EXPORT_KEYS = "context_exportKeys";
    private static final String METHOD_GET_FRESH_MESSAGES = "context_getFreshMessages";
    private static final String METHOD_FORWARD_MESSAGES = "context_forwardMessages";
    private static final String METHOD_INITIATE_KEY_TRANSFER = "context_initiateKeyTransfer";
    private static final String METHOD_CONTINUE_KEY_TRANSFER = "context_continueKeyTransfer";
    private static final String METHOD_MARK_SEEN_MESSAGES = "context_markSeenMessages";
    private static final String METHOD_GET_SECUREJOIN_QR = "context_getSecurejoinQr";
    private static final String METHOD_JOIN_SECUREJOIN = "context_joinSecurejoin";
    private static final String METHOD_CHECK_QR = "context_checkQr";
    private static final String METHOD_STOP_ONGOING_PROCESS = "context_stopOngoingProcess";
    private static final String METHOD_DELETE_MESSAGES = "context_deleteMessages";
    private static final String METHOD_STAR_MESSAGES = "context_starMessages";
    private static final String METHOD_SET_CHAT_NAME = "context_setChatName";
    private static final String METHOD_SET_CHAT_PROFILE_IMAGE = "context_setChatProfileImage";
    private static final String METHOD_INTERRUPT_IDLE_FOR_INCOMING_MESSAGES = "context_interruptIdleForIncomingMessages";
    private static final String METHOD_CLOSE = "context_close";
    private static final String METHOD_IS_COI_SUPPORTED = "context_isCoiSupported";
    private static final String METHOD_IS_COI_ENABLED = "context_isCoiEnabled";
    private static final String METHOD_IS_WEB_PUSH_SUPPORTED = "context_isWebPushSupported";
    private static final String METHOD_GET_WEB_PUSH_VAPID_KEY = "context_getWebPushVapidKey";
    private static final String METHOD_SUBSCRIBE_WEB_PUSH = "context_subscribeWebPush";
    private static final String METHOD_VALIDATE_WEB_PUSH = "context_validateWebPush";
    private static final String METHOD_GET_WEB_PUSH_SUBSCRIPTION = "context_getWebPushSubscription";
    private static final String METHOD_SET_COI_ENABLED = "context_setCoiEnabled";
    private static final String METHOD_SET_COI_MESSAGE_FILTER = "context_setCoiMessageFilter";
    private static final String METHOD_GET_MESSAGE_INFO = "context_getMessageInfo";
    private static final String METHOD_RETRY_SENDING_PENDING_MESSAGES = "context_retrySendingPendingMessages";
    private static final String METHOD_IS_KNOWN_CONTACT = "context_isKnownContact";

    private static final String TYPE_INT = "int";
    private static final String TYPE_STRING = "String";

    private final IdCache<DcContact> contactCache;
    private final IdCache<DcMsg> messageCache;
    private final IdCache<DcChat> chatCache;

    public ContextCallHandler(DcContext dcContext, IdCache<DcContact> contactCache, IdCache<DcMsg> messageCache, IdCache<DcChat> chatCache) {
        super(dcContext);
        this.contactCache = contactCache;
        this.messageCache = messageCache;
        this.chatCache = chatCache;
    }

    @Override
    public void handleCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case METHOD_CONFIG_SET:
                setConfig(methodCall, result);
                break;
            case METHOD_CONFIG_GET:
                getConfig(methodCall, result, TYPE_STRING);
                break;
            case METHOD_CONFIG_GET_INT:
                getConfig(methodCall, result, TYPE_INT);
                break;
            case METHOD_CONFIGURE:
                configure(result);
                break;
            case METHOD_IS_CONFIGURED:
                isConfigured(result);
                break;
            case METHOD_ADD_ADDRESS_BOOK:
                addAddressBook(methodCall, result);
                break;
            case METHOD_CREATE_CONTACT:
                createContact(methodCall, result);
                break;
            case METHOD_DELETE_CONTACT:
                deleteContact(methodCall, result);
                break;
            case METHOD_BLOCK_CONTACT:
                blockContact(methodCall, result);
                break;
            case METHOD_UNBLOCK_CONTACT:
                unblockContact(methodCall, result);
                break;
            case METHOD_CREATE_CHAT_BY_CONTACT_ID:
                createChatByContactId(methodCall, result);
                break;
            case METHOD_CREATE_CHAT_BY_MESSAGE_ID:
                createChatByMessageId(methodCall, result);
                break;
            case METHOD_CREATE_GROUP_CHAT:
                createGroupChat(methodCall, result);
                break;
            case METHOD_GET_CONTACT:
                getContact(methodCall, result);
                break;
            case METHOD_GET_CONTACTS:
                getContacts(methodCall, result);
                break;
            case METHOD_GET_CHAT_CONTACTS:
                getChatContacts(methodCall, result);
                break;
            case METHOD_GET_CHAT:
                getChat(methodCall, result);
                break;
            case METHOD_GET_CHAT_MESSAGES:
                getChatMessages(methodCall, result);
                break;
            case METHOD_CREATE_CHAT_MESSAGE:
                createChatMessage(methodCall, result);
                break;
            case METHOD_CREATE_CHAT_ATTACHMENT_MESSAGE:
                createChatAttachmentMessage(methodCall, result);
                break;
            case METHOD_ADD_CONTACT_TO_CHAT:
                addContactToChat(methodCall, result);
                break;
            case METHOD_GET_CHAT_BY_CONTACT_ID:
                getChatByContactId(methodCall, result);
                break;
            case METHOD_GET_BLOCKED_CONTACTS:
                getBlockedContacts(result);
                break;
            case METHOD_GET_FRESH_MESSAGE_COUNT:
                getFreshMessageCount(methodCall, result);
                break;
            case METHOD_MARK_NOTICED_CHAT:
                markNoticedChat(methodCall, result);
                break;
            case METHOD_DELETE_CHAT:
                deleteChat(methodCall, result);
                break;
            case METHOD_REMOVE_CONTACT_FROM_CHAT:
                removeContactFromChat(methodCall, result);
                break;
            case METHOD_EXPORT_KEYS:
                exportImportKeys(methodCall, result, DcContext.DC_IMEX_EXPORT_SELF_KEYS);
                break;
            case METHOD_IMPORT_KEYS:
                exportImportKeys(methodCall, result, DcContext.DC_IMEX_IMPORT_SELF_KEYS);
                break;
            case METHOD_GET_FRESH_MESSAGES:
                getFreshMessages(result);
                break;
            case METHOD_FORWARD_MESSAGES:
                forwardMessages(methodCall, result);
                break;
            case METHOD_MARK_SEEN_MESSAGES:
                markSeenMessages(methodCall, result);
                break;
            case METHOD_INITIATE_KEY_TRANSFER:
                initiateKeyTransfer(result);
                break;
            case METHOD_CONTINUE_KEY_TRANSFER:
                continueKeyTransfer(methodCall, result);
                break;
            case METHOD_GET_SECUREJOIN_QR:
                getSecurejoinQr(methodCall, result);
                break;
            case METHOD_JOIN_SECUREJOIN:
                joinSecurejoin(methodCall, result);
                break;
            case METHOD_CHECK_QR:
                checkQr(methodCall, result);
                break;
            case METHOD_STOP_ONGOING_PROCESS:
                stopOngoingProcess(result);
                break;
            case METHOD_DELETE_MESSAGES:
                deleteMessages(methodCall, result);
                break;
            case METHOD_STAR_MESSAGES:
                starMessages(methodCall, result);
                break;
            case METHOD_SET_CHAT_NAME:
                setChatName(methodCall, result);
                break;
            case METHOD_SET_CHAT_PROFILE_IMAGE:
                setChatProfileImage(methodCall, result);
                break;
            case METHOD_INTERRUPT_IDLE_FOR_INCOMING_MESSAGES:
                interruptIdleForIncomingMessages(result);
                break;
            case METHOD_CLOSE:
                close(result);
                break;
            case METHOD_IS_COI_SUPPORTED:
                isCoiSupported(result);
                break;
            case METHOD_IS_COI_ENABLED:
                isCoiEnabled(result);
                break;
            case METHOD_IS_WEB_PUSH_SUPPORTED:
                isWebPushSupported(result);
                break;
            case METHOD_GET_WEB_PUSH_VAPID_KEY:
                getWebPushVapidKey(result);
                break;
            case METHOD_SUBSCRIBE_WEB_PUSH:
                subscribeWebPush(methodCall, result);
                break;
            case METHOD_GET_WEB_PUSH_SUBSCRIPTION:
                getWebPushSubscription(methodCall, result);
                break;
            case METHOD_SET_COI_ENABLED:
                setCoiEnabled(methodCall, result);
                break;
            case METHOD_SET_COI_MESSAGE_FILTER:
                setCoiMessageFilter(methodCall, result);
                break;
            case METHOD_VALIDATE_WEB_PUSH:
                validateWebPush(methodCall, result);
                break;
            case METHOD_GET_MESSAGE_INFO:
                getMessageInfo(methodCall, result);
                break;
            case METHOD_RETRY_SENDING_PENDING_MESSAGES:
                retrySendingPendingMessages(result);
                break;
            case METHOD_IS_KNOWN_CONTACT:
                isKnownContact(methodCall, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void setConfig(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_TYPE, ARGUMENT_KEY, ARGUMENT_VALUE)) {
            resultErrorArgumentMissing(result);
            return;
        }
        String type = methodCall.argument(ARGUMENT_TYPE);
        if (type == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        String key = methodCall.argument(ARGUMENT_KEY);
        switch (type) {
            case TYPE_INT: {
                Integer value = methodCall.argument(ARGUMENT_VALUE);
                if (value == null) {
                    resultErrorArgumentMissingValue(result);
                    return;
                }
                dcContext.setConfigInt(key, value);
                break;
            }
            case TYPE_STRING: {
                String value = methodCall.argument(ARGUMENT_VALUE);
                dcContext.setConfig(key, value);
                break;
            }
            default:
                resultErrorArgumentTypeMismatch(result, ARGUMENT_TYPE);
                break;
        }
        result.success(null);
    }


    private void getConfig(MethodCall methodCall, MethodChannel.Result result, String type) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_KEY)) {
            resultErrorArgumentMissing(result);
            return;
        }
        String key = methodCall.argument(ARGUMENT_KEY);
        switch (type) {
            case TYPE_INT: {
                int resultValue = dcContext.getConfigInt(key);
                result.success(resultValue);
                break;
            }
            case TYPE_STRING: {
                String resultValue = dcContext.getConfig(key);
                result.success(resultValue);
                break;
            }
            default:
                resultErrorArgumentTypeMismatch(result, ARGUMENT_TYPE);
                break;
        }
    }

    private void configure(MethodChannel.Result result) {
        dcContext.configure();
        result.success(null);
    }

    private void isConfigured(MethodChannel.Result result) {
        boolean configured = dcContext.isConfigured() == 1;
        result.success(configured);
    }

    private void addAddressBook(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ADDRESS_BOOK)) {
            resultErrorArgumentMissing(result);
            return;
        }
        String addressBook = methodCall.argument(ARGUMENT_ADDRESS_BOOK);
        if (addressBook == null || addressBook.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        contactCache.clear();
        int changedCount = dcContext.addAddressBook(addressBook);
        result.success(changedCount);
    }

    private void createContact(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ADDRESS)) {
            resultErrorArgumentMissing(result);
            return;
        }
        String name = methodCall.argument(ARGUMENT_NAME);
        String address = methodCall.argument(ARGUMENT_ADDRESS);
        int contactId = dcContext.createContact(name, address);
        contactCache.put(contactId, dcContext.getContact(contactId));
        result.success(contactId);
    }

    private void deleteContact(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer contactId = methodCall.argument(ARGUMENT_ID);
        if (contactId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        boolean deleted = dcContext.deleteContact(contactId);
        if (deleted) {
            contactCache.delete(contactId);
        }
        result.success(deleted);
    }

    private void blockContact(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer contactId = methodCall.argument(ARGUMENT_ID);
        if (contactId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        dcContext.blockContact(contactId, 1);
        contactCache.delete(contactId);
        result.success(null);
    }

    private void unblockContact(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer contactId = methodCall.argument(ARGUMENT_ID);
        if (contactId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        dcContext.blockContact(contactId, 0);
        result.success(null);
    }

    private void createChatByContactId(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer contactId = methodCall.argument(ARGUMENT_ID);
        if (contactId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        int chatId = dcContext.createChatByContactId(contactId);
        chatCache.put(chatId, dcContext.getChat(chatId));
        result.success(chatId);
    }

    private void createChatByMessageId(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer messageId = methodCall.argument(ARGUMENT_ID);
        if (messageId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        int chatId = dcContext.createChatByMsgId(messageId);
        chatCache.put(chatId, dcContext.getChat(chatId));
        result.success(chatId);
    }

    private void createGroupChat(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_VERIFIED, ARGUMENT_NAME)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Boolean verified = methodCall.argument(ARGUMENT_VERIFIED);
        if (verified == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        String name = methodCall.argument(ARGUMENT_NAME);
        int chatId = dcContext.createGroupChat(verified, name);
        chatCache.put(chatId, dcContext.getChat(chatId));
        result.success(chatId);
    }


    private void getContact(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_ID);
        if (id == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        DcContact contact = loadAndCacheContact(id);
        result.success(contact.getId());
    }

    DcContact loadAndCacheContact(Integer id) {
        DcContact contact = contactCache.get(id);
        if (contact == null) {
            contact = dcContext.getContact(id);
            contactCache.put(contact.getId(), contact);
        }
        return contact;
    }

    private void getContacts(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_FLAGS, ARGUMENT_QUERY)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer flags = methodCall.argument(ARGUMENT_FLAGS);
        String query = methodCall.argument(ARGUMENT_QUERY);
        if (flags == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        int[] contactIds = dcContext.getContacts(flags, query);
        for (int contactId : contactIds) {
            loadAndCacheContact(contactId);
        }
        result.success(contactIds);
    }

    private void getChatContacts(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_CHAT_ID);
        if (id == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        int[] contactIds = dcContext.getChatContacts(id);
        for (int contactId : contactIds) {
            loadAndCacheContact(contactId);
        }
        result.success(contactIds);
    }

    private void getBlockedContacts(MethodChannel.Result result) {
        int[] blockedIds = dcContext.getBlockedContacts();
        for (int blockedContactId : blockedIds) {
            loadAndCacheContact(blockedContactId);
        }
        result.success(blockedIds);
    }

    private void getChat(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_ID);
        if (id == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        DcChat chat = loadAndCacheChat(id);
        result.success(chat.getId());
    }

    DcChat loadAndCacheChat(Integer id) {
        DcChat chat = chatCache.get(id);
        if (chat == null) {
            chat = dcContext.getChat(id);
            chatCache.put(chat.getId(), chat);
        }
        return chat;
    }

    private void getChatMessages(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_CHAT_ID);
        if (id == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        Integer flags = methodCall.argument(ARGUMENT_FLAGS);
        if (flags == null) {
            flags = 0;
        }

        int[] messageIds = dcContext.getChatMsgs(id, flags, 0);
        for (int messageId : messageIds) {
            if (messageId != DcMsg.DC_MSG_ID_MARKER1 && messageId != DcMsg.DC_MSG_ID_DAYMARKER) {
                DcMsg message = messageCache.get(messageId);
                if (message == null) {
                    messageCache.put(messageId, dcContext.getMsg(messageId));
                }
            }
        }
        result.success(messageIds);
    }

    DcMsg loadAndCacheChatMessage(Integer id) {
        DcMsg message = messageCache.get(id);
        if (message == null) {
            message = dcContext.getMsg(id);
            messageCache.put(message.getId(), message);
        }
        return message;
    }

    private void createChatMessage(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID, ARGUMENT_TEXT)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_CHAT_ID);
        if (id == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }

        String text = methodCall.argument(ARGUMENT_TEXT);

        DcMsg newMsg = new DcMsg(dcContext, DcMsg.DC_MSG_TEXT);
        newMsg.setText(text);
        int messageId = dcContext.sendMsg(id, newMsg);
        result.success(messageId);
    }

    private void createChatAttachmentMessage(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID, ARGUMENT_TYPE, ARGUMENT_PATH, ARGUMENT_MIME_TYPE, ARGUMENT_DURATION, ARGUMENT_TEXT)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        String path = methodCall.argument(ARGUMENT_PATH);
        Integer type = methodCall.argument(ARGUMENT_TYPE);
        if (chatId == null || path == null || type == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }

        String text = methodCall.argument(ARGUMENT_TEXT);
        String mimeType = methodCall.argument(ARGUMENT_MIME_TYPE);
        Integer duration = methodCall.argument(ARGUMENT_DURATION);

        DcMsg newMsg = new DcMsg(dcContext, type);
        newMsg.setText(text);
        newMsg.setFile(path, mimeType);
        if (duration != null) {
            newMsg.setDuration(duration);
        }
        int messageId = dcContext.sendMsg(chatId, newMsg);
        result.success(messageId);
    }

    private void addContactToChat(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID, ARGUMENT_CONTACT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        Integer contactId = methodCall.argument(ARGUMENT_CONTACT_ID);
        if (chatId == null || contactId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        int successfullyAdded = dcContext.addContactToChat(chatId, contactId);
        result.success(successfullyAdded);
    }

    private void getChatByContactId(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CONTACT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer contactId = methodCall.argument(ARGUMENT_CONTACT_ID);
        if (contactId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        int chatId = dcContext.getChatIdByContactId(contactId);
        result.success(chatId);
    }

    private void getFreshMessageCount(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        if (chatId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }

        int freshMessageCount = dcContext.getFreshMsgCount(chatId);
        result.success(freshMessageCount);
    }

    private void markNoticedChat(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        if (chatId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }

        dcContext.marknoticedChat(chatId);
        result.success(null);
    }

    private void deleteChat(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        if (chatId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }

        dcContext.deleteChat(chatId);

        chatCache.delete(chatId);

        result.success(null);
    }

    private void removeContactFromChat(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID, ARGUMENT_CONTACT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        Integer contactId = methodCall.argument(ARGUMENT_CONTACT_ID);
        if (chatId == null || contactId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        int deleted = dcContext.removeContactFromChat(chatId, contactId);

        result.success(deleted);
    }

    private void exportImportKeys(MethodCall methodCall, MethodChannel.Result result, int type) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_PATH)) {
            resultErrorArgumentMissing(result);
            return;
        }
        String path = methodCall.argument(ARGUMENT_PATH);
        if (path == null || path.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        dcContext.imex(type, path);

        result.success(null);
    }

    private void getFreshMessages(MethodChannel.Result result) {
        int[] freshMessages = dcContext.getFreshMsgs();
        result.success(freshMessages);
    }

    private void forwardMessages(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID, ARGUMENT_MESSAGE_IDS)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        if (chatId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        ArrayList<Integer> msgIdArray = methodCall.argument(ARGUMENT_MESSAGE_IDS);
        if (msgIdArray == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        int[] msgIds = new int[msgIdArray.size()];
        for (int i = 0; i < msgIds.length; i++) {
            msgIds[i] = msgIdArray.get(i);
        }

        dcContext.forwardMsgs(msgIds, chatId);
    }

    private void initiateKeyTransfer(MethodChannel.Result result) {
        new Thread(() -> {
            String setupKey = dcContext.initiateKeyTransfer();
            getUiThreadHandler().post(() -> result.success(setupKey));
        }).start();
    }

    private void continueKeyTransfer(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ID, ARGUMENT_SETUP_CODE)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer messageId = methodCall.argument(ARGUMENT_ID);
        String setupCode = methodCall.argument(ARGUMENT_SETUP_CODE);
        if (messageId == null || setupCode == null || setupCode.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        boolean transferResult = dcContext.continueKeyTransfer(messageId, setupCode);

        result.success(transferResult);
    }

    private void markSeenMessages(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_MESSAGE_IDS)) {
            resultErrorArgumentMissing(result);
            return;
        }

        ArrayList<Integer> msgIdArray = methodCall.argument(ARGUMENT_MESSAGE_IDS);
        if (msgIdArray == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        int[] msgIds = new int[msgIdArray.size()];
        for (int i = 0; i < msgIds.length; i++) {
            msgIds[i] = msgIdArray.get(i);
        }

        dcContext.markseenMsgs(msgIds);
    }

    private void getSecurejoinQr(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        if (chatId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }

        String qrCodeText = dcContext.getSecurejoinQr(chatId);
        result.success(qrCodeText);
    }

    private void joinSecurejoin(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_QR_TEXT)) {
            resultErrorArgumentMissing(result);
            return;
        }
        String qrText = methodCall.argument(ARGUMENT_QR_TEXT);
        if (qrText == null || qrText.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        new Thread(() -> {
            int chatId = dcContext.joinSecurejoin(qrText);
            getUiThreadHandler().post(() -> result.success(chatId));
        }).start();
    }

    private void checkQr(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_QR_TEXT)) {
            resultErrorArgumentMissing(result);
            return;
        }
        String qrText = methodCall.argument(ARGUMENT_QR_TEXT);
        if (qrText == null || qrText.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }

        DcLot qrCode = dcContext.checkQr(qrText);
        result.success(mapLotToList(qrCode));
    }

    private void deleteMessages(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_MESSAGE_IDS)) {
            resultErrorArgumentMissing(result);
            return;
        }
        ArrayList<Integer> msgIdArray = methodCall.argument(ARGUMENT_MESSAGE_IDS);
        if (msgIdArray == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        int[] msgIds = new int[msgIdArray.size()];
        for (int i = 0; i < msgIds.length; i++) {
            msgIds[i] = msgIdArray.get(i);
        }

        dcContext.deleteMsgs(msgIds);
    }

    private void stopOngoingProcess(MethodChannel.Result result) {
        dcContext.stopOngoingProcess();
        result.success(null);
    }

    private void starMessages(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_MESSAGE_IDS, ARGUMENT_VALUE)) {
            resultErrorArgumentMissing(result);
            return;
        }

        ArrayList<Integer> msgIdArray = methodCall.argument(ARGUMENT_MESSAGE_IDS);
        if (msgIdArray == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        Integer star = getArgumentValueAsInt(methodCall, result, ARGUMENT_VALUE);
        if (!isArgumentIntValueValid(star)) {
            resultErrorArgumentNoValidInt(result, ARGUMENT_VALUE);
            return;
        }

        int[] msgIds = new int[msgIdArray.size()];
        for (int i = 0; i < msgIds.length; i++) {
            msgIds[i] = msgIdArray.get(i);
        }

        dcContext.starMsgs(msgIds, star);
        result.success(null);
    }

    private void setChatProfileImage(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID, ARGUMENT_VALUE)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        if (chatId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        String newName = methodCall.argument(ARGUMENT_VALUE);
        Integer coreResult = dcContext.setChatProfileImage(chatId, newName);
        result.success(coreResult);
    }

    private void setChatName(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_CHAT_ID, ARGUMENT_VALUE)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        if (chatId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        String newName = methodCall.argument(ARGUMENT_VALUE);
        Integer coreResult = dcContext.setChatName(chatId, newName);
        result.success(coreResult);
    }

    private void interruptIdleForIncomingMessages(MethodChannel.Result result) {
        dcContext.interruptImapIdle();
        dcContext.interruptMvboxIdle();
        result.success(null);
    }

    private void close(MethodChannel.Result result) {
        dcContext.close();
        result.success(null);
    }

    private void isCoiSupported(MethodChannel.Result result) {
        int coiSupported = dcContext.isCoiSupported();
        result.success(coiSupported);
    }

    private void isCoiEnabled(MethodChannel.Result result) {
        int coiEnabled = dcContext.isCoiEnabled();
        result.success(coiEnabled);
    }

    private void isWebPushSupported(MethodChannel.Result result) {
        int webPushSupported = dcContext.isWebPushSupported();
        result.success(webPushSupported);
    }

    private void getWebPushVapidKey(MethodChannel.Result result) {
        String webPushVapidKey = dcContext.getWebPushVapidKey();
        result.success(webPushVapidKey);
    }

    private void setCoiEnabled(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_ENABLE, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer enable = methodCall.argument(ARGUMENT_ENABLE);
        if (enable == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_ID);
        if (id == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        dcContext.setCoiEnabled(enable, id);
        result.success(null);
    }

    private void setCoiMessageFilter(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_MODE, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer mode = methodCall.argument(ARGUMENT_MODE);
        if (mode == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_ID);
        if (id == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        dcContext.setCoiMessageFilter(mode, id);
        result.success(null);
    }

    private void subscribeWebPush(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_UID, ARGUMENT_JSON, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        String uid = methodCall.argument(ARGUMENT_UID);
        if (uid == null || uid.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        String json = methodCall.argument(ARGUMENT_JSON);
        if (json == null || json.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_ID);
        if (id == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        dcContext.subscribeWebPush(uid, json, id);
        result.success(null);
    }

    private void validateWebPush(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_UID, ARGUMENT_MESSAGE, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        String uid = methodCall.argument(ARGUMENT_UID);
        if (uid == null || uid.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        String message = methodCall.argument(ARGUMENT_MESSAGE);
        if (message == null || message.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_ID);
        if (id == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        dcContext.validateWebPush(uid, message, id);
        result.success(null);
    }

    private void getWebPushSubscription(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_UID, ARGUMENT_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        String uid = methodCall.argument(ARGUMENT_UID);
        if (uid == null || uid.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        Integer id = methodCall.argument(ARGUMENT_ID);
        if (id == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        dcContext.getWebPushSubscription(uid, id);
        result.success(null);
    }

    private void getMessageInfo(MethodCall methodCall, MethodChannel.Result result) {
        if (!hasArgumentKeys(methodCall, ARGUMENT_MESSAGE_ID)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer messageId = methodCall.argument(ARGUMENT_MESSAGE_ID);
        if (messageId == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }

        String messageInfo = dcContext.getMsgInfo(messageId);
        result.success(messageInfo);
    }

    private void isKnownContact(MethodCall methodCall, MethodChannel.Result result) {
        String address = methodCall.argument(ARGUMENT_ADDRESS);
        if (address == null || address.isEmpty()) {
            resultErrorArgumentMissingValue(result);
            return;
        }

        int isKnownContact = dcContext.lookupContactIdByAddr(address);
        result.success(isKnownContact == 1);
    }

    private void retrySendingPendingMessages(MethodChannel.Result result) {
        dcContext.maybeNetwork();
        result.success(null);
    }
}