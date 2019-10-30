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
import com.openxchange.deltachatcore.IdCache;
import com.openxchange.deltachatcore.IncrementalCache;

import java.util.Collections;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ChatListCallHandler extends AbstractCallHandler {
    private static final String METHOD_CHAT_LIST_INTERNAL_SETUP = "chatList_internal_setup";
    private static final String METHOD_CHAT_LIST_INTERNAL_TEAR_DOWN = "chatList_internal_tearDown";
    private static final String METHOD_CHAT_LIST_GET_CNT = "chatList_getCnt";
    private static final String METHOD_CHAT_LIST_GET_ID = "chatList_getId";
    private static final String METHOD_CHAT_LIST_GET_CHAT = "chatList_getChat";
    private static final String METHOD_CHAT_LIST_GET_MSG_ID = "chatList_getMsgId";
    private static final String METHOD_CHAT_LIST_GET_MSG = "chatList_getMsg";
    private static final String METHOD_CHAT_LIST_GET_SUMMARY = "chatList_getSummary";

    private IncrementalCache<DcChatlist> chatListCache = new IncrementalCache<>();

    private IdCache<DcChat> chatCache;

    public ChatListCallHandler(DcContext dcContext, IdCache<DcChat> chatCache) {
        super(dcContext);
        this.chatCache = chatCache;
    }

    @Override
    public void handleCall(MethodCall methodCall, MethodChannel.Result result) {
        DcChatlist dcChatlist = null;
        if (!methodCall.method.equals(METHOD_CHAT_LIST_INTERNAL_SETUP)) {
            if (!hasArgumentKeys(methodCall, ARGUMENT_CACHE_ID)) {
                resultErrorArgumentMissing(result);
                return;
            }
            Integer cacheId = methodCall.argument(ARGUMENT_CACHE_ID);
            if (!isArgumentIntValueValid(cacheId)) {
                resultErrorArgumentNoValidInt(result, ARGUMENT_CACHE_ID);
                return;
            }
            //noinspection ConstantConditions
            dcChatlist = chatListCache.get(cacheId);
            if (dcChatlist == null) {
                resultErrorGeneric(methodCall, result);
                return;
            }
        }
        switch (methodCall.method) {
            case METHOD_CHAT_LIST_INTERNAL_SETUP:
                setup(methodCall, result);
                break;
            case METHOD_CHAT_LIST_INTERNAL_TEAR_DOWN:
                tearDown(methodCall, result);
                break;
            case METHOD_CHAT_LIST_GET_CNT:
                getChatCnt(dcChatlist, result);
                break;
            case METHOD_CHAT_LIST_GET_ID:
                getChatId(dcChatlist, methodCall, result);
                break;
            case METHOD_CHAT_LIST_GET_MSG_ID:
                getChatMsgId(dcChatlist, methodCall, result);
                break;
            case METHOD_CHAT_LIST_GET_CHAT:
                getChat(dcChatlist, methodCall, result);
                break;
            case METHOD_CHAT_LIST_GET_MSG:
                getChatMsg(dcChatlist, methodCall, result);
                break;
            case METHOD_CHAT_LIST_GET_SUMMARY:
                getChatSummary(dcChatlist, methodCall, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void setup(MethodCall methodCall, MethodChannel.Result result) {
        int chatListFlag;
        Integer type = methodCall.argument(ARGUMENT_TYPE);
        if (type != null) {
            chatListFlag = type;
        } else {
            chatListFlag = 0;
        }
        String query = methodCall.argument(ARGUMENT_QUERY);
        DcChatlist dcChatlist = dcContext.getChatlist(chatListFlag, query, 0);
        int cacheId = chatListCache.put(dcChatlist);
        result.success(cacheId);
    }

    private void tearDown(MethodCall methodCall, MethodChannel.Result result) {
        Integer cacheId = methodCall.argument(ARGUMENT_CACHE_ID);
        //noinspection ConstantConditions
        chatListCache.delete(cacheId);
        result.success(null);
    }

    private void getChatSummary(DcChatlist dcChatlist, MethodCall methodCall, MethodChannel.Result result) {
        Integer index = getArgumentValueAsInt(methodCall, result, ARGUMENT_INDEX);
        if (!isArgumentIntValueValid(index)) {
            resultErrorArgumentNoValidInt(result, ARGUMENT_INDEX);
            return;
        }
        DcChat chat = dcChatlist.getChat(index);
        DcLot summary = dcChatlist.getSummary(index, chat);
        result.success(mapLotToList(summary));
    }

    private void getChatMsg(DcChatlist dcChatlist, MethodCall methodCall, MethodChannel.Result result) {
        Integer index = getArgumentValueAsInt(methodCall, result, ARGUMENT_INDEX);
        if (!isArgumentIntValueValid(index)) {
            resultErrorArgumentNoValidInt(result, ARGUMENT_INDEX);
            return;
        }
        DcMsg msg = dcChatlist.getMsg(index);
        List<Object> msgResult = Collections.singletonList(msg);
        result.success(msgResult);
    }

    private void getChat(DcChatlist dcChatlist, MethodCall methodCall, MethodChannel.Result result) {
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

    private void getChatMsgId(DcChatlist dcChatlist, MethodCall methodCall, MethodChannel.Result result) {
        Integer index = getArgumentValueAsInt(methodCall, result, ARGUMENT_INDEX);
        if (!isArgumentIntValueValid(index)) {
            resultErrorArgumentNoValidInt(result, ARGUMENT_INDEX);
            return;
        }
        result.success(dcChatlist.getMsgId(index));
    }

    private void getChatId(DcChatlist dcChatlist, MethodCall methodCall, MethodChannel.Result result) {
        Integer index = getArgumentValueAsInt(methodCall, result, ARGUMENT_INDEX);
        if (!isArgumentIntValueValid(index)) {
            resultErrorArgumentNoValidInt(result, ARGUMENT_INDEX);
            return;
        }
        result.success(dcChatlist.getChatId(index));
    }

    private void getChatCnt(DcChatlist dcChatlist, MethodChannel.Result result) {
        result.success(dcChatlist.getCnt());
    }
}
