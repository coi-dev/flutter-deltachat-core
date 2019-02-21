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

import com.b44t.messenger.DcContact;
import com.b44t.messenger.DcContext;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


class ContactCallHandler extends AbstractCallHandler {
    private static final String METHOD_CONTACT_GET_ID = "contact_getId";
    private static final String METHOD_CONTACT_GET_NAME = "contact_getName";
    private static final String METHOD_CONTACT_GET_DISPLAY_NAME = "contact_getDisplayName";
    private static final String METHOD_CONTACT_GET_FIRST_NAME = "contact_getFirstName";
    private static final String METHOD_CONTACT_GET_ADDRESS = "contact_getAddress";
    private static final String METHOD_CONTACT_GET_NAME_AND_ADDRESS = "contact_getNameAndAddress";
    private static final String METHOD_CONTACT_GET_PROFILE_IMAGE = "contact_getProfileImage";
    private static final String METHOD_CONTACT_GET_COLOR = "contact_getColor";
    private static final String METHOD_CONTACT_IS_BLOCKED = "contact_isBlocked";
    private static final String METHOD_CONTACT_IS_VERIFIED = "contact_isVerified";

    private final Cache<DcContact> contactCache;
    private final ContextCallHandler contextCallHandler;

    ContactCallHandler(DcContext dcContext, Cache<DcContact> contactCache, ContextCallHandler contextCallHandler) {
        super(dcContext);
        this.contactCache = contactCache;
        this.contextCallHandler = contextCallHandler;
    }

    @Override
    public void handleCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case METHOD_CONTACT_GET_ID:
                getId(methodCall, result);
                break;
            case METHOD_CONTACT_GET_NAME:
                getName(methodCall, result);
                break;
            case METHOD_CONTACT_GET_DISPLAY_NAME:
                getDisplayName(methodCall, result);
                break;
            case METHOD_CONTACT_GET_FIRST_NAME:
                getFirstName(methodCall, result);
                break;
            case METHOD_CONTACT_GET_ADDRESS:
                getAddress(methodCall, result);
                break;
            case METHOD_CONTACT_GET_NAME_AND_ADDRESS:
                getNameAndAddress(methodCall, result);
                break;
            case METHOD_CONTACT_GET_PROFILE_IMAGE:
                getProfileImage(methodCall, result);
                break;
            case METHOD_CONTACT_GET_COLOR:
                getColor(methodCall, result);
                break;
            case METHOD_CONTACT_IS_BLOCKED:
                isBlocked(methodCall, result);
                break;
            case METHOD_CONTACT_IS_VERIFIED:
                isVerified(methodCall, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void getId(MethodCall methodCall, MethodChannel.Result result) {
        DcContact contact = getContact(methodCall, result);
        if (contact == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(contact.getId());
    }

    private void getName(MethodCall methodCall, MethodChannel.Result result) {
        DcContact contact = getContact(methodCall, result);
        if (contact == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(contact.getName());
    }

    private void getDisplayName(MethodCall methodCall, MethodChannel.Result result) {
        DcContact contact = getContact(methodCall, result);
        if (contact == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(contact.getDisplayName());
    }

    private void getFirstName(MethodCall methodCall, MethodChannel.Result result) {
        DcContact contact = getContact(methodCall, result);
        if (contact == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(contact.getFirstName());
    }


    private void getAddress(MethodCall methodCall, MethodChannel.Result result) {
        DcContact contact = getContact(methodCall, result);
        if (contact == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(contact.getAddr());
    }


    private void getNameAndAddress(MethodCall methodCall, MethodChannel.Result result) {
        DcContact contact = getContact(methodCall, result);
        if (contact == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(contact.getNameNAddr());
    }

    private void getProfileImage(MethodCall methodCall, MethodChannel.Result result) {
        DcContact contact = getContact(methodCall, result);
        if (contact == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(contact.getProfileImage());
    }

    private void getColor(MethodCall methodCall, MethodChannel.Result result) {
        DcContact contact = getContact(methodCall, result);
        if (contact == null) {
            result.error(methodCall.method, null, null);
            return;
        }
        result.success(contact.getColor());
    }

    private void isBlocked(MethodCall methodCall, MethodChannel.Result result) {
        DcContact contact = getContact(methodCall, result);
        if (contact == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(contact.isBlocked());

    }


    private void isVerified(MethodCall methodCall, MethodChannel.Result result) {
        DcContact contact = getContact(methodCall, result);
        if (contact == null) {
            resultErrorGeneric(methodCall, result);
            return;
        }
        result.success(contact.isVerified());
    }

    private DcContact getContact(MethodCall methodCall, MethodChannel.Result result) {
        Integer id = getArgumentValueAsInt(methodCall, result, ARGUMENT_ID);
        DcContact contact = null;
        if (isArgumentIntValueValid(id)) {
            contact = contactCache.get(id);
            if (contact == null) {
                contact = contextCallHandler.loadAndCacheContact(id);
            }
        }
        return contact;
    }
}
