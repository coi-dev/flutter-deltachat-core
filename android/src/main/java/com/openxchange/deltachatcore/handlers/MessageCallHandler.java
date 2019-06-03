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

import com.b44t.messenger.DcContext;
import com.b44t.messenger.DcMsg;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MessageCallHandler extends AbstractCallHandler {
    private static final String METHOD_MESSAGE_GET_ID = "msg_getId";
    private static final String METHOD_MESSAGE_GET_TEXT = "msg_getText";
    private static final String METHOD_MESSAGE_GET_TIMESTAMP = "msg_getTimestamp";
    private static final String METHOD_MESSAGE_GET_TYPE = "msg_getType";
    private static final String METHOD_MESSAGE_GET_STATE = "msg_getState";
    private static final String METHOD_MESSAGE_GET_CHAT_ID = "msg_getChatId";
    private static final String METHOD_MESSAGE_GET_FROM_ID = "msg_getFromId";
    private static final String METHOD_MESSAGE_GET_WIDTH = "msg_getWidth";
    private static final String METHOD_MESSAGE_GET_HEIGHT = "msg_getHeight";
    private static final String METHOD_MESSAGE_GET_DURATION = "msg_getDuration";
    private static final String METHOD_MESSAGE_LATE_FILING_MEDIA_SIZE = "msg_lateFilingMediaSize";
    private static final String METHOD_MESSAGE_GET_SUMMARY = "msg_getSummary";
    private static final String METHOD_MESSAGE_GET_SUMMARY_TEXT = "msg_getSummaryText";
    private static final String METHOD_MESSAGE_SHOW_PADLOCK = "msg_showPadlock";
    private static final String METHOD_MESSAGE_HAS_FILE = "msg_hasFile";
    private static final String METHOD_MESSAGE_GET_FILE = "msg_getFile";
    private static final String METHOD_MESSAGE_GET_FILE_MIME = "msg_getFileMime";
    private static final String METHOD_MESSAGE_GET_FILENAME = "msg_getFilename";
    private static final String METHOD_MESSAGE_GET_FILE_BYTES = "msg_getFileBytes";
    private static final String METHOD_MESSAGE_IS_FORWARDED = "msg_isForwarded";
    private static final String METHOD_MESSAGE_IS_INFO = "msg_isInfo";
    private static final String METHOD_MESSAGE_IS_SETUP_MESSAGE = "msg_isSetupMessage";
    private static final String METHOD_MESSAGE_GET_SETUP_CODE_BEGIN = "msg_getSetupCodeBegin";
    private static final String METHOD_MESSAGE_IS_INCREATION = "msg_isInCreation";
    private static final String METHOD_MESSAGE_SET_TEXT = "msg_setText";
    private static final String METHOD_MESSAGE_SET_FILE = "msg_setFile";
    private static final String METHOD_MESSAGE_SET_DIMENSION = "msg_setDimension";
    private static final String METHOD_MESSAGE_SET_DURATION = "msg_setDuration";
    private static final String METHOD_MESSAGE_IS_OUTGOING = "msg_isOutgoing";
    private final ContextCallHandler contextCallHandler;

    public MessageCallHandler(DcContext dcContext, ContextCallHandler contextCallHandler) {
        super(dcContext);
        this.contextCallHandler = contextCallHandler;
    }

    @Override
    public void handleCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case METHOD_MESSAGE_GET_ID:
                getId(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_TEXT:
                getText(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_TIMESTAMP:
                getTimestamp(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_CHAT_ID:
                getChatId(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_FROM_ID:
                getFromId(methodCall, result);
                break;
            case METHOD_MESSAGE_IS_OUTGOING:
                isOutgoing(methodCall, result);
                break;
            case METHOD_MESSAGE_HAS_FILE:
                hasFile(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_TYPE:
                getType(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_FILE:
                getFile(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_FILE_BYTES:
                getFileBytes(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_FILENAME:
                getFileName(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_FILE_MIME:
                getFileMime(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_SUMMARY_TEXT:
                getSummaryText(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_STATE:
                getState(methodCall, result);
                break;
            case METHOD_MESSAGE_IS_SETUP_MESSAGE:
                isSetupMessage(methodCall, result);
                break;
            case METHOD_MESSAGE_IS_INFO:
                isInfo(methodCall, result);
                break;
            case METHOD_MESSAGE_GET_SETUP_CODE_BEGIN:
                getSetupCodeBegin(methodCall, result);
            case METHOD_MESSAGE_SHOW_PADLOCK:
                showPadlock(methodCall, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void isOutgoing(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.isOutgoing());
    }

    private void hasFile(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.hasFile());
    }

    private void getType(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getType());
    }

    private void getFile(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getFile());
    }

    private void getFileBytes(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getFilebytes());
    }

    private void getFileName(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getFilename());
    }

    private void getFileMime(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getFilemime());
    }

    private void getFromId(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getFromId());
    }

    private void getChatId(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getChatId());
    }

    private void getTimestamp(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getTimestamp());
    }

    private void getText(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getText());
    }

    private void getId(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getId());
    }

    private void getSummaryText(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        if (!hasArgumentKeys(methodCall, ARGUMENT_COUNT)) {
            resultErrorArgumentMissing(result);
            return;
        }
        Integer characterCount = methodCall.argument(ARGUMENT_COUNT);
        if (characterCount == null) {
            resultErrorArgumentMissingValue(result);
            return;
        }
        result.success(message.getSummarytext(characterCount));
    }

    private void isSetupMessage(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.isSetupMessage());
    }

    private void isInfo(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.isInfo());
    }

    private void getSetupCodeBegin(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getSetupCodeBegin());
    }

    private void getState(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.getState());
    }


    private void showPadlock(MethodCall methodCall, MethodChannel.Result result) {
        DcMsg message = getMessage(methodCall, result);
        if (message == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(message.showPadlock());
    }

    private DcMsg getMessage(MethodCall methodCall, MethodChannel.Result result) {
        Integer id = getArgumentValueAsInt(methodCall, result, ARGUMENT_ID);
        DcMsg message = null;
        if (isArgumentIntValueValid(id)) {
            message = contextCallHandler.loadAndCacheChatMessage(id);
        }
        return message;
    }
}
