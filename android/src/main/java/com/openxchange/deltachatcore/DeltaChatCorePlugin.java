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


import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.b44t.messenger.DcChat;
import com.b44t.messenger.DcContact;
import com.b44t.messenger.DcMsg;
import com.openxchange.deltachatcore.handlers.AbstractCallHandler;
import com.openxchange.deltachatcore.handlers.ChatCallHandler;
import com.openxchange.deltachatcore.handlers.ChatListCallHandler;
import com.openxchange.deltachatcore.handlers.ContactCallHandler;
import com.openxchange.deltachatcore.handlers.ContextCallHandler;
import com.openxchange.deltachatcore.handlers.EventChannelHandler;
import com.openxchange.deltachatcore.handlers.MessageCallHandler;

import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterNativeView;

public class DeltaChatCorePlugin implements MethodCallHandler, PluginRegistry.ViewDestroyListener, FlutterPlugin, ActivityAware {
    static final String TAG = "coi";

    private static final String LIBRARY_NAME = "native-utils";
    private static final String CHANNEL_DELTA_CHAT_CORE = "deltaChatCore";

    private static final String METHOD_PREFIX_SEPARATOR = "_";
    private static final String METHOD_PREFIX_BASE = "base";
    private static final String METHOD_PREFIX_CHAT = "chat";
    private static final String METHOD_PREFIX_CHAT_LIST = "chatList";
    private static final String METHOD_PREFIX_CONTACT = "contact";
    private static final String METHOD_PREFIX_CONTEXT = "context";
    private static final String METHOD_PREFIX_MSG = "msg";

    private static final String METHOD_BASE_INIT = "base_init";
    private static final String METHOD_BASE_SYSTEM_INFO = "base_systemInfo";
    private static final String METHOD_BASE_START = "base_start";
    private static final String METHOD_BASE_STOP = "base_stop";

    private static final String ARGUMENT_REMOVE_CACHE_IDENTIFIER = "removeCacheIdentifier";
    private static final String ARGUMENT_DB_NAME = "dbName";

    private static final String CACHE_IDENTIFIER_CHAT = "chat";
    private static final String CACHE_IDENTIFIER_CHAT_LIST = "chatList";
    private static final String CACHE_IDENTIFIER_CHAT_MESSAGE = "chatMessage";
    private static final String CACHE_IDENTIFIER_CONTACT = "contact";

    private Context context;
    private BinaryMessenger messenger;
    private MethodChannel channel;

    private final IdCache<DcChat> chatCache = new IdCache<>();
    private final IdCache<DcContact> contactCache = new IdCache<>();
    private final IdCache<DcMsg> messageCache = new IdCache<>();

    private NativeInteractionManager nativeInteractionManager;
    private ChatCallHandler chatCallHandler;
    private ChatListCallHandler chatListCallHandler;
    private ContactCallHandler contactCallHandler;
    private ContextCallHandler contextCallHandler;
    private MessageCallHandler messageCallHandler;
    @SuppressWarnings("FieldCanBeLocal")
    private EventChannelHandler eventChannelHandler;

    @SuppressWarnings("WeakerAccess")
    public DeltaChatCorePlugin() {
        // Required for Flutter plugin embedding v2
    }

    // Flutter plugin v1 embedding
    public static void registerWith(Registrar registrar) {
        Log.d(TAG, "Attaching plugin via v1 embedding");
        DeltaChatCorePlugin plugin = new DeltaChatCorePlugin();
        plugin.onAttachedToEngine(registrar.context(), registrar.messenger());
        registrar.addViewDestroyListener(plugin);
    }

    // Flutter plugin v2 embedding
    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        Log.d(TAG, "Attaching plugin via v2 embedding");
        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    private void onAttachedToEngine(Context context, BinaryMessenger messenger) {
        this.context = context;
        this.messenger = messenger;
        channel = new MethodChannel(messenger, CHANNEL_DELTA_CHAT_CORE);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "Detaching plugin via v2 embedding");
        channel.setMethodCallHandler(null);
        channel = null;
        eventChannelHandler.close();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        // No implementation required, as no activity context is used by the plugin
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        // No implementation required, as no activity context is used by the plugin
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        // No implementation required, as no activity context is used by the plugin
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d(TAG, "Stopping threads via v2 embedding");
        stopNativeInteractionManager();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull Result result) {
        delegateMethodCall(methodCall, result);
    }

    private void delegateMethodCall(MethodCall methodCall, Result result) {
        String methodPrefix = extractMethodPrefix(methodCall.method);
        if (methodCall.hasArgument(ARGUMENT_REMOVE_CACHE_IDENTIFIER)) {
            removeFromJavaCache(methodCall);
        }
        switch (methodPrefix) {
            case METHOD_PREFIX_BASE:
                handleBaseCalls(methodCall, result);
                break;
            case METHOD_PREFIX_CHAT_LIST:
                handleChatListCalls(methodCall, result);
                break;
            case METHOD_PREFIX_CHAT:
                handleChatCalls(methodCall, result);
                break;
            case METHOD_PREFIX_CONTACT:
                handleContactCalls(methodCall, result);
                break;
            case METHOD_PREFIX_CONTEXT:
                handleContextCalls(methodCall, result);
                break;
            case METHOD_PREFIX_MSG:
                handleMessageCalls(methodCall, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private String extractMethodPrefix(String methodCall) {
        return methodCall.split(METHOD_PREFIX_SEPARATOR)[0];
    }

    private void removeFromJavaCache(MethodCall methodCall) {
        String identifier = methodCall.argument(ARGUMENT_REMOVE_CACHE_IDENTIFIER);
        Integer id = methodCall.argument(AbstractCallHandler.ARGUMENT_ID);
        switch (Objects.requireNonNull(identifier)) {
            case CACHE_IDENTIFIER_CHAT:
                chatCache.delete(Objects.requireNonNull(id));
                break;
            case CACHE_IDENTIFIER_CHAT_MESSAGE:
                messageCache.delete(Objects.requireNonNull(id));
                break;
            case CACHE_IDENTIFIER_CONTACT:
                contactCache.delete(Objects.requireNonNull(id));
                break;
            case CACHE_IDENTIFIER_CHAT_LIST:
                // No interaction required
                break;
        }
    }

    private void handleBaseCalls(MethodCall methodCall, Result result) {
        switch (methodCall.method) {
            case METHOD_BASE_INIT:
                init(methodCall, result);
                break;
            case METHOD_BASE_SYSTEM_INFO:
                systemInfo(result);
                break;
            case METHOD_BASE_START:
                start(result);
                break;
            case METHOD_BASE_STOP:
                stop(result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void init(MethodCall methodCall, Result result) {
        String dbName = methodCall.argument(ARGUMENT_DB_NAME);
        if (dbName == null || dbName.isEmpty()) {
            throw new IllegalArgumentException("No database name given, exiting.");
        }
        System.loadLibrary(LIBRARY_NAME);
        eventChannelHandler = new EventChannelHandler(messenger);
        nativeInteractionManager = new NativeInteractionManager(context, dbName, eventChannelHandler);
        contextCallHandler = new ContextCallHandler(nativeInteractionManager, contactCache, messageCache, chatCache);
        chatListCallHandler = new ChatListCallHandler(nativeInteractionManager, chatCache);
        messageCallHandler = new MessageCallHandler(nativeInteractionManager, contextCallHandler);
        contactCallHandler = new ContactCallHandler(nativeInteractionManager, contextCallHandler);
        chatCallHandler = new ChatCallHandler(nativeInteractionManager, contextCallHandler);
        result.success(nativeInteractionManager.getDbPath());
    }

    private void systemInfo(Result result) {
        result.success(android.os.Build.VERSION.RELEASE);
    }

    private void start(Result result) {
        nativeInteractionManager.start();
        result.success(null);
    }

    private void stop(Result result) {
        stopNativeInteractionManager();
        result.success(null);
    }

    private void stopNativeInteractionManager() {
        nativeInteractionManager.stop();
    }


    private void handleContextCalls(MethodCall methodCall, Result result) {
        contextCallHandler.handleCall(methodCall, result);
    }

    private void handleChatListCalls(MethodCall call, Result result) {
        chatListCallHandler.handleCall(call, result);
    }

    private void handleChatCalls(MethodCall methodCall, Result result) {
        chatCallHandler.handleCall(methodCall, result);
    }

    private void handleContactCalls(MethodCall methodCall, Result result) {
        contactCallHandler.handleCall(methodCall, result);
    }

    private void handleMessageCalls(MethodCall methodCall, Result result) {
        messageCallHandler.handleCall(methodCall, result);
    }

    @Override
    public boolean onViewDestroy(FlutterNativeView flutterNativeView) {
        stopNativeInteractionManager();
        return false;
    }
}
