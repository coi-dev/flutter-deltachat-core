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

import android.util.SparseArray;

import com.b44t.messenger.ApplicationDcContext;
import com.b44t.messenger.DcChat;
import com.b44t.messenger.DcContact;
import com.b44t.messenger.DcMsg;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StringCodec;

public class DeltaChatCorePlugin implements MethodCallHandler {
    private static final String LIBRARY_NAME = "native-utils";

    private static final String CHANNEL_DELTA_CHAT_CORE = "deltaChatCore";
    private static final String CHANNEL_DELTA_CHAT_CORE_MESSAGES = "deltaChatCoreMessages";

    private static final String METHOD_PREFIX_SEPARATOR = "_";
    private static final String METHOD_PREFIX_BASE = "base";
    private static final String METHOD_PREFIX_CHAT = "chat";
    private static final String METHOD_PREFIX_CHAT_LIST = "chatList";
    private static final String METHOD_PREFIX_CONTACT = "contact";
    private static final String METHOD_PREFIX_CONTEXT = "context";
    private static final String METHOD_PREFIX_LOT = "lot";
    private static final String METHOD_PREFIX_MEDIA = "media";
    private static final String METHOD_PREFIX_MSG = "msg";

    private static final String METHOD_BASE_INIT = "base_init";
    private static final String METHOD_BASE_SYSTEM_INFO = "base_systemInfo";
    private static final String METHOD_BASE_CORE_LISTENER = "base_coreListener";

    private static final String ARGUMENT_ADD = "add";
    private static final String ARGUMENT_EVENT_ID = "eventId";
    private static final String ARGUMENT_LISTENER_ID = "listenerId";

    private static BasicMessageChannel<String> messageChannel;
    private Registrar registrar;
    private ApplicationDcContext applicationDcContext;
    private SparseArray<EventChannelHandler> eventHandlers = new SparseArray<>();

    private Cache<DcChat> chatCache = new Cache<>();
    private Cache<DcContact> contactCache = new Cache<>();
    private Cache<DcMsg> messageCache = new Cache<>();

    private ChatCallHandler chatCallHandler;
    private ChatListCallHandler chatListCallHandler;
    private ContactCallHandler contactCallHandler;
    private ContextCallHandler contextCallHandler;
    private MessageCallHandler messageCallHandler;

    private DeltaChatCorePlugin(Registrar registrar) {
        this.registrar = registrar;
        messageChannel = new BasicMessageChannel<>(registrar.messenger(), CHANNEL_DELTA_CHAT_CORE_MESSAGES, StringCodec.INSTANCE);
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_DELTA_CHAT_CORE);
        channel.setMethodCallHandler(new DeltaChatCorePlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        delegateMethodCall(call, result);
    }

    private void delegateMethodCall(MethodCall call, Result result) {
        String methodPrefix = extractMethodPrefix(call.method);
        switch (methodPrefix) {
            case METHOD_PREFIX_BASE:
                handleBaseCalls(call, result);
                break;
            case METHOD_PREFIX_CHAT_LIST:
                handleChatListCalls(call, result);
                break;
            case METHOD_PREFIX_CHAT:
                handleChatCalls(call, result);
                break;
            case METHOD_PREFIX_CONTACT:
                handleContactCalls(call, result);
                break;
            case METHOD_PREFIX_CONTEXT:
                handleContextCalls(call, result);
                break;
            case METHOD_PREFIX_LOT:
                break;
            case METHOD_PREFIX_MEDIA:
                break;
            case METHOD_PREFIX_MSG:
                handleMessageCalls(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private String extractMethodPrefix(String methodCall) {
        return methodCall.split(METHOD_PREFIX_SEPARATOR)[0];
    }

    private void handleBaseCalls(MethodCall call, Result result) {
        switch (call.method) {
            case METHOD_BASE_INIT:
                init(result);
                break;
            case METHOD_BASE_SYSTEM_INFO:
                systemInfo(result);
                break;
            case METHOD_BASE_CORE_LISTENER:
                coreListener(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void init(Result result) {
        System.loadLibrary(LIBRARY_NAME);
        applicationDcContext = new ApplicationDcContext(registrar.activity());
        result.success(null);
        contextCallHandler = new ContextCallHandler(applicationDcContext, contactCache, messageCache, chatCache);
        chatListCallHandler = new ChatListCallHandler(applicationDcContext, chatCache);
        messageCallHandler = new MessageCallHandler(applicationDcContext, messageCache);
        contactCallHandler = new ContactCallHandler(applicationDcContext, contactCache, contextCallHandler);
        chatCallHandler = new ChatCallHandler(applicationDcContext, chatCache, contextCallHandler);
    }

    private void systemInfo(Result result) {
        result.success(android.os.Build.VERSION.RELEASE);
    }

    private void coreListener(MethodCall call, Result result) {
        Boolean add = call.argument(ARGUMENT_ADD);
        Integer eventId = call.argument(ARGUMENT_EVENT_ID);
        Integer listenerId = call.argument(ARGUMENT_LISTENER_ID);
        if (eventId == null || add == null) {
            return;
        }
        EventChannelHandler eventHandler;
        if (eventHandlers.indexOfKey(eventId) < 0) {
            eventHandler = new EventChannelHandler(applicationDcContext, registrar.messenger(), eventId);
            eventHandlers.put(eventId, eventHandler);
        } else {
            eventHandler = eventHandlers.get(eventId);
        }
        if (add) {
            int newObserverId = eventHandler.addObserver();
            result.success(newObserverId);
        } else {
            if (listenerId == null) {
                return;
            }
            eventHandler.removeListener(listenerId);
            result.success(null);
        }
    }

    private void handleContextCalls(MethodCall call, Result result) {
        contextCallHandler.handleCall(call, result);
    }

    private void handleChatListCalls(MethodCall call, Result result) {
        chatListCallHandler.handleCall(call, result);
    }

    private void handleChatCalls(MethodCall call, Result result) {
        chatCallHandler.handleCall(call, result);
    }

    private void handleContactCalls(MethodCall call, Result result) {
        contactCallHandler.handleCall(call, result);
    }

    private void handleMessageCalls(MethodCall call, Result result) {
        messageCallHandler.handleCall(call, result);
    }

    public static void showToast(String message) {
        if (messageChannel != null) {
            messageChannel.send(message);
        } else {
            throw new IllegalStateException("Call to uninitialized message channel in DeltaChatCorePlugin");
        }
    }

}
