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

import com.b44t.messenger.DcContext;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

abstract class AbstractCallHandler {

    static final String ARGUMENT_KEY_TYPE = "type";
    static final String ARGUMENT_KEY_KEY = "key";
    static final String ARGUMENT_KEY_VALUE = "value";
    static final String ARGUMENT_ADDRESS = "address";
    static final String ARGUMENT_ID = "id";
    static final String ARGUMENT_VERIFIED = "verified";
    static final String ARGUMENT_NAME = "name";
    static final String ARGUMENT_INDEX = "index";
    static final String ARGUMENT_FLAGS = "flags";
    static final String ARGUMENT_QUERY = "query";
    static final String ARGUMENT_ADDRESS_BOOK = "addressBook";
    private static final String ERROR_ARGUMENT_MISSING = "1";
    private static final String ERROR_ARGUMENT_TYPE_MISMATCH = "2";
    private static final String ERROR_ARGUMENT_MISSING_VALUE = "3";
    private static final String ERROR_ARGUMENT_NO_INT = "4";
    final DcContext dcContext;

    final MethodCall methodCall;

    final MethodChannel.Result result;

    AbstractCallHandler(DcContext dcContext, MethodCall methodCall, MethodChannel.Result result) {
        this.dcContext = dcContext;
        this.methodCall = methodCall;
        this.result = result;
    }

    void errorArgumentMissing() {
        result.error(ERROR_ARGUMENT_MISSING, "Argument is missing", null);
    }

    @SuppressWarnings("SameParameterValue")
    void errorArgumentTypeMismatch(String argument) {
        result.error(ERROR_ARGUMENT_TYPE_MISMATCH, "Wrong type for argument " + argument, null);
    }

    void errorArgumentMissingValue() {
        result.error(ERROR_ARGUMENT_MISSING_VALUE, "Argument value is missing or null", null);
    }

    void errorArgumentNoInt(String argument) {
        result.error(ERROR_ARGUMENT_NO_INT, "Argument is no integer: " + argument, null);
    }

    @SuppressWarnings("BooleanMethodIsAlwaysInverted")
    boolean hasArgumentKeys(String... arguments) {
        for (String argument : arguments) {
            if (!methodCall.hasArgument(argument)) {
                return false;
            }
        }
        return true;
    }

    Integer getArgumentValueAsInt(String argument) {
        Integer id;
        if (!hasArgumentKeys(argument)) {
            errorArgumentMissing();
            return null;
        }
        if (!(methodCall.argument(argument) instanceof Integer)) {
            errorArgumentNoInt(argument);
            return null;
        }
        id = methodCall.argument(argument);
        return id;
    }

    boolean isArgumentIntValueValid(Integer value) {
        return value != null && value != -1;
    }

}
