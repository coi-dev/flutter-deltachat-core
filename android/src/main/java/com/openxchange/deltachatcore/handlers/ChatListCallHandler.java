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
import com.b44t.messenger.DcChatlist;
import com.b44t.messenger.DcContext;
import com.b44t.messenger.DcLot;
import com.b44t.messenger.DcMsg;
import com.openxchange.deltachatcore.Cache;

import java.util.Collections;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ChatListCallHandler extends AbstractCallHandler {
    private static final String METHOD_CHAT_GET_CNT = "chatList_getCnt";
    private static final String METHOD_CHAT_GET_ID = "chatList_getId";
    private static final String METHOD_CHAT_GET_CHAT = "chatList_getChat";
    private static final String METHOD_CHAT_GET_MSG_ID = "chatList_getMsgId";
    private static final String METHOD_CHAT_GET_MSG = "chatList_getMsg";
    private static final String METHOD_CHAT_GET_SUMMARY = "chatList_getSummary";

    private DcChatlist dcChatlist;

    private Cache<DcChat> chatCache;

    public ChatListCallHandler(DcContext dcContext, Cache<DcChat> chatCache) {
        super(dcContext);
        this.chatCache = chatCache;
    }

    @Override
    public void handleCall(MethodCall methodCall, MethodChannel.Result result) {
        int chatListFlag;
        Integer type = methodCall.argument(ARGUMENT_KEY_TYPE);
        if (type != null) {
            chatListFlag = type;
        } else {
            chatListFlag = 0;
        }
        dcChatlist = dcContext.getChatlist(chatListFlag, null, 0);
        switch (methodCall.method) {
            case METHOD_CHAT_GET_CNT:
                getChatCnt(result);
                break;
            case METHOD_CHAT_GET_ID:
                getChatId(methodCall, result);
                break;
            case METHOD_CHAT_GET_MSG_ID:
                getChatMsgId(methodCall, result);
                break;
            case METHOD_CHAT_GET_CHAT:
                getChat(methodCall, result);
                break;
            case METHOD_CHAT_GET_MSG:
                getChatMsg(methodCall, result);
                break;
            case METHOD_CHAT_GET_SUMMARY:
                getChatSummary(methodCall, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void getChatSummary(MethodCall methodCall, MethodChannel.Result result) {
        Integer index = getArgumentValueAsInt(methodCall, result, ARGUMENT_INDEX);
        if (!isArgumentIntValueValid(index)) {
            resultErrorArgumentNoValidInt(result, ARGUMENT_INDEX);
            return;
        }
        DcChat chat = dcChatlist.getChat(index);
        DcLot summary = dcChatlist.getSummary(index, chat);
        List<Object> summaryResult = Collections.singletonList(summary);
        result.success(summaryResult);
    }

    private void getChatMsg(MethodCall methodCall, MethodChannel.Result result) {
        Integer index = getArgumentValueAsInt(methodCall, result, ARGUMENT_INDEX);
        if (!isArgumentIntValueValid(index)) {
            resultErrorArgumentNoValidInt(result, ARGUMENT_INDEX);
            return;
        }
        DcMsg msg = dcChatlist.getMsg(index);
        List<Object> msgResult = Collections.singletonList(msg);
        result.success(msgResult);
    }

    private void getChat(MethodCall methodCall, MethodChannel.Result result) {
        Integer index = getArgumentValueAsInt(methodCall, result, ARGUMENT_INDEX);
        if (!isArgumentIntValueValid(index)) {
            resultErrorArgumentNoValidInt(result, ARGUMENT_INDEX);
            return;
        }
        int chatId = dcChatlist.getChatId(index);
        DcChat chat = chatCache.get(chatId);
        if (chat == null) {
            chat = dcChatlist.getChat(index);
            chatCache.put(chat.getId(), chat);
        }
        result.success(chat.getId());
    }

    private void getChatMsgId(MethodCall methodCall, MethodChannel.Result result) {
        Integer index = getArgumentValueAsInt(methodCall, result, ARGUMENT_INDEX);
        if (!isArgumentIntValueValid(index)) {
            resultErrorArgumentNoValidInt(result, ARGUMENT_INDEX);
            return;
        }
        result.success(dcChatlist.getMsgId(index));
    }

    private void getChatId(MethodCall methodCall, MethodChannel.Result result) {
        Integer index = getArgumentValueAsInt(methodCall, result, ARGUMENT_INDEX);
        if (!isArgumentIntValueValid(index)) {
            resultErrorArgumentNoValidInt(result, ARGUMENT_INDEX);
            return;
        }
        result.success(dcChatlist.getChatId(index));
    }

    private void getChatCnt(MethodChannel.Result result) {
        result.success(dcChatlist.getCnt());
    }
}
