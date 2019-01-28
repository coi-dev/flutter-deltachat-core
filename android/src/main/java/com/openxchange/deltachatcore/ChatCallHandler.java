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

import com.b44t.messenger.DcChat;
import com.b44t.messenger.DcContext;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


class ChatCallHandler extends AbstractCallHandler {
    private static final String METHOD_CHAT_GET_ID = "chat_getId";
    private static final String METHOD_CHAT_IS_GROUP = "chat_isGroup";
    private static final String METHOD_CHAT_GET_ARCHIVED = "chat_getArchived";
    private static final String METHOD_CHAT_GET_NAME = "chat_getName";
    private static final String METHOD_CHAT_GET_SUBTITLE = "chat_getSubtitle";
    private static final String METHOD_CHAT_GET_PROFILE_IMAGE = "chat_getProfileImage";
    private static final String METHOD_CHAT_IS_UNPROMOTED = "chat_isUnpromoted";
    private static final String METHOD_CHAT_IS_SELF_TALK = "chat_isSelfTalk";
    private static final String METHOD_CHAT_IS_VERIFIED = "chat_isVerified";

    private final Cache<DcChat> chatCache;

    ChatCallHandler(DcContext dcContext, MethodCall methodCall, MethodChannel.Result result, Cache<DcChat> chatCache) {
        super(dcContext, methodCall, result);

        this.chatCache = chatCache;
        switch (methodCall.method) {
            case METHOD_CHAT_GET_ID:
                getChatId();
                break;
            case METHOD_CHAT_IS_GROUP:
                isGroup();
                break;
            case METHOD_CHAT_GET_ARCHIVED:
                getArchived();
                break;
            case METHOD_CHAT_GET_NAME:
                getName();
                break;
            case METHOD_CHAT_GET_SUBTITLE:
                getSubtitle();
                break;
            case METHOD_CHAT_GET_PROFILE_IMAGE:
                getProfileImage();
                break;
            case METHOD_CHAT_IS_UNPROMOTED:
                isUnpromoted();
                break;
            case METHOD_CHAT_IS_SELF_TALK:
                isSelfTalk();
                break;
            case METHOD_CHAT_IS_VERIFIED:
                isVerified();
                break;
            default:
                result.notImplemented();
        }
    }

    private void isSelfTalk() {
        DcChat chat = getChat();
        if (chat != null) {
            result.success(chat.isSelfTalk());
        }
    }

    private void isUnpromoted() {
        DcChat chat = getChat();
        if (chat != null) {
            result.success(chat.isUnpromoted());
        }
    }

    private void getProfileImage() {
        DcChat chat = getChat();
        if (chat != null) {
            result.success(chat.getProfileImage());
        }
    }

    private void getSubtitle() {
        DcChat chat = getChat();
        if (chat != null) {
            result.success(chat.getSubtitle());
        }
    }

    private void getName() {
        DcChat chat = getChat();
        if (chat != null) {
            result.success(chat.getName());
        }
    }

    private void getArchived() {
        DcChat chat = getChat();
        if (chat != null) {
            result.success(chat.getArchived());
        }
    }

    private void isGroup() {
        DcChat chat = getChat();
        if (chat != null) {
            result.success(chat.isGroup());
        }
    }

    private void getChatId() {
        DcChat chat = getChat();
        if (chat != null) {
            result.success(chat.getId());
        }
    }

    private void isVerified() {
        DcChat chat = getChat();
        if (chat != null) {
            result.success(chat.isVerified());
        }
    }

    private DcChat getChat() {
        Integer id = getArgumentValueAsInt(ARGUMENT_ID);
        if (isArgumentIntValueValid(id)) {
            return chatCache.get(id);
        }
        return null;
    }

}
