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

import android.util.Log;

import com.b44t.messenger.DcChat;
import com.b44t.messenger.DcChatlist;
import com.b44t.messenger.DcContext;
import com.b44t.messenger.DcLot;
import com.b44t.messenger.DcMsg;

import java.util.Collections;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class ChatListCallHandler extends AbstractCallHandler {
    private static final String METHOD_CHAT_GET_CNT = "chatList_getCnt";
    private static final String METHOD_CHAT_GET_ID = "chatList_getId";
    private static final String METHOD_CHAT_GET_CHAT = "chatList_getChat";
    private static final String METHOD_CHAT_GET_MSG_ID = "chatList_getMsgId";
    private static final String METHOD_CHAT_GET_MSG = "chatList_getMsg";
    private static final String METHOD_CHAT_GET_SUMMARY = "chatList_getSummary";

    private final DcChatlist dcChatlist;

    private Cache<DcChat> chatCache;

    ChatListCallHandler(DcContext dcContext, MethodCall methodCall, MethodChannel.Result result, Cache<DcChat> chatCache) {
        super(dcContext, methodCall, result);
        this.chatCache = chatCache;
        dcChatlist = dcContext.getChatlist(0, null, 0);
        switch (methodCall.method) {
            case METHOD_CHAT_GET_CNT:
                getChatCnt();
                break;
            case METHOD_CHAT_GET_ID:
                getChatId();
                break;
            case METHOD_CHAT_GET_MSG_ID:
                getChatMsgId();
                break;
            case METHOD_CHAT_GET_CHAT:
                getChat();
                break;
            case METHOD_CHAT_GET_MSG:
                getChatMsg();
                break;
            case METHOD_CHAT_GET_SUMMARY:
                getChatSummary();
                break;
            default:
                result.notImplemented();
        }
    }

    private void getChatSummary() {
        Integer index = getArgumentValueAsInt(ARGUMENT_INDEX);
        if (isArgumentIntValueValid(index)) {
            DcChat chat = dcChatlist.getChat(index);
            DcLot summary = dcChatlist.getSummary(index, chat);
            List<Object> summaryResult = Collections.singletonList(summary);
            result.success(summaryResult);
        }
    }

    private void getChatMsg() {
        Integer index = getArgumentValueAsInt(ARGUMENT_INDEX);
        if (isArgumentIntValueValid(index)) {
            DcMsg msg = dcChatlist.getMsg(index);
            List<Object> msgResult = Collections.singletonList(msg);
            result.success(msgResult);
        }
    }

    private void getChat() {
        Integer index = getArgumentValueAsInt(ARGUMENT_INDEX);
        if (isArgumentIntValueValid(index)) {
            DcChat chat = chatCache.get(index);
            if (chat == null) {
                chat = dcChatlist.getChat(index);
                chatCache.put(chat.getId(), chat);
            }
            result.success(chat.getId());
        }
    }

    private void getChatMsgId() {
        Integer index = getArgumentValueAsInt(ARGUMENT_INDEX);
        if (isArgumentIntValueValid(index)) {
            result.success(dcChatlist.getMsgId(index));
        }
    }

    private void getChatId() {
        Integer index = getArgumentValueAsInt(ARGUMENT_INDEX);
        if (isArgumentIntValueValid(index)) {
            result.success(dcChatlist.getChatId(index));
        }
    }

    private void getChatCnt() {
        result.success(dcChatlist.getCnt());
    }

}
