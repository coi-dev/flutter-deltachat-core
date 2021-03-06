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

import android.os.Handler;
import android.os.Looper;

import com.b44t.messenger.DcContext;
import com.b44t.messenger.DcLot;

import java.util.Arrays;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

abstract public class AbstractCallHandler {

    public static final String ARGUMENT_ID = "id";
    static final String ARGUMENT_TYPE = "type";
    static final String ARGUMENT_KEY = "key";
    static final String ARGUMENT_VALUE = "value";
    static final String ARGUMENT_ADDRESS = "address";
    static final String ARGUMENT_CACHE_ID = "cacheId";
    static final String ARGUMENT_VERIFIED = "verified";
    static final String ARGUMENT_NAME = "name";
    static final String ARGUMENT_INDEX = "index";
    static final String ARGUMENT_FLAGS = "flags";
    static final String ARGUMENT_QUERY = "query";
    static final String ARGUMENT_ADDRESS_BOOK = "addressBook";
    static final String ARGUMENT_CONTACT_ID = "contactId";
    static final String ARGUMENT_CHAT_ID = "chatId";
    static final String ARGUMENT_PATH = "path";
    static final String ARGUMENT_TEXT = "text";
    static final String ARGUMENT_COUNT = "count";
    static final String ARGUMENT_MESSAGE_ID = "messageId";
    static final String ARGUMENT_MESSAGE_IDS = "messageIds";
    static final String ARGUMENT_SETUP_CODE = "setupCode";
    static final String ARGUMENT_QR_TEXT = "qrText";
    static final String ARGUMENT_JSON = "json";
    static final String ARGUMENT_MESSAGE = "message";
    static final String ARGUMENT_UID = "uid";
    static final String ARGUMENT_MODE = "mode";
    static final String ARGUMENT_ENABLE = "enable";
    static final String ARGUMENT_CONTENT = "content";
    static final String ARGUMENT_CONTENT_TYPE = "contentType";
    static final String ARGUMENT_MIME_TYPE = "mimeType";
    static final String ARGUMENT_DURATION = "duration";
    static final String ARGUMENT_DIR = "dir";
    static final String ARGUMENT_MESSAGE_TYPE_ONE = "messageTypeOne";
    static final String ARGUMENT_MESSAGE_TYPE_TWO = "messageTypeTwo";
    static final String ARGUMENT_MESSAGE_TYPE_THREE = "messageTypeThree";
    private static final String ERROR_ARGUMENT_MISSING = "1";
    private static final String ERROR_ARGUMENT_TYPE_MISMATCH = "2";
    private static final String ERROR_ARGUMENT_MISSING_VALUE = "3";
    private static final String ERROR_ARGUMENT_NO_INT = "4";
    final DcContext dcContext;

    AbstractCallHandler(DcContext dcContext) {
        this.dcContext = dcContext;
    }

    void resultErrorArgumentMissing(MethodChannel.Result result) {
        result.error(ERROR_ARGUMENT_MISSING, "Argument is missing", null);
    }

    @SuppressWarnings("SameParameterValue")
    void resultErrorArgumentTypeMismatch(MethodChannel.Result result, String argument) {
        result.error(ERROR_ARGUMENT_TYPE_MISMATCH, "Wrong type for argument " + argument, null);
    }

    void resultErrorArgumentMissingValue(MethodChannel.Result result) {
        result.error(ERROR_ARGUMENT_MISSING_VALUE, "Argument value is missing or null", null);
    }

    @SuppressWarnings("WeakerAccess")
    void resultErrorArgumentNoInt(MethodChannel.Result result, String argument) {
        result.error(ERROR_ARGUMENT_NO_INT, "Argument is no integer: " + argument, null);
    }

    void resultErrorArgumentNoValidInt(MethodChannel.Result result, String argument) {
        result.error(ERROR_ARGUMENT_NO_INT, "Argument has no valid int value: " + argument, null);
    }

    void resultErrorGeneric(MethodCall methodCall, MethodChannel.Result result) {
        result.error(methodCall.method, null, null);
    }

    @SuppressWarnings("BooleanMethodIsAlwaysInverted")
    boolean hasArgumentKeys(MethodCall methodCall, String... arguments) {
        for (String argument : arguments) {
            if (!methodCall.hasArgument(argument)) {
                return false;
            }
        }
        return true;
    }

    Integer getArgumentValueAsInt(MethodCall methodCall, MethodChannel.Result result, String argument) {
        Integer id;
        if (!hasArgumentKeys(methodCall, argument)) {
            resultErrorArgumentMissing(result);
            return null;
        }
        if (!(methodCall.argument(argument) instanceof Integer)) {
            resultErrorArgumentNoInt(result, argument);
            return null;
        }
        id = methodCall.argument(argument);
        if (!isArgumentIntValueValid(id)) {
            resultErrorArgumentMissingValue(result);
            return null;
        }
        return id;
    }

    boolean isArgumentIntValueValid(Integer value) {
        return value != null;
    }

    List<Object> mapLotToList(DcLot lot) {
        return Arrays.asList(lot.getId(), lot.getText1(), lot.getText1Meaning(), lot.getText2(), lot.getTimestamp(), lot.getState());
    }

    Handler getUiThreadHandler() {
        return new Handler(Looper.getMainLooper());
    }

    abstract void handleCall(MethodCall methodCall, MethodChannel.Result result);

}
