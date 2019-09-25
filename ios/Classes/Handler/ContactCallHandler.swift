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
 * Copyright (C) 2016-2019 OX Software GmbH
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

import Foundation

class ContactCallHandler: MethodCallHandling {
    
    fileprivate let context: DcContext!
    fileprivate let contextCallHandler: ContextCallHandler!
    
    // MARK: - Initialization
    
    init(context: DcContext, contextCallHandler: ContextCallHandler) {
        self.context = context
        self.contextCallHandler = contextCallHandler
    }

    // MARK: - Protocol MethodCallHandling

    func handle(_ call: FlutterMethodCall, result: FlutterResult) {
        switch (call.method) {
        case Method.Contact.GET_ID:
            getId(methodCall: call, result: result);
            break
        case Method.Contact.GET_NAME:
            getName(methodCall: call, result: result);
            break
        case Method.Contact.GET_DISPLAY_NAME:
            getDisplayName(methodCall: call, result: result);
            break
        case Method.Contact.GET_FIRST_NAME:
            getFirstName(methodCall: call, result: result);
            break
        case Method.Contact.GET_ADDRESS:
            getAddress(methodCall: call, result: result);
            break
        case Method.Contact.GET_NAME_AND_ADDRESS:
            getNameAndAddress(methodCall: call, result: result);
            break
        case Method.Contact.GET_PROFILE_IMAGE:
            getProfileImage(methodCall: call, result: result);
            break
        case Method.Contact.GET_COLOR:
            getColor(methodCall: call, result: result);
            break
        case Method.Contact.IS_BLOCKED:
            isBlocked(methodCall: call, result: result);
            break
        case Method.Contact.IS_VERIFIED:
            isVerified(methodCall: call, result: result);
            break
        default:
            log.error("Context: Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Private Helper
    
    fileprivate func getId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contact = getContact(methodCall: methodCall, result: result)
        result(contact.id)
    }
    
    fileprivate func getName(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contact = getContact(methodCall: methodCall, result: result)
        result(contact.name)
    }
    
    fileprivate func getDisplayName(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contact = getContact(methodCall: methodCall, result: result)
        result(contact.displayName)
    }
    
    fileprivate func getFirstName(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contact = getContact(methodCall: methodCall, result: result)
        result(contact.firstName)
    }
    
    fileprivate func getAddress(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contact = getContact(methodCall: methodCall, result: result)
        result(contact.email)
    }
    
    fileprivate func getNameAndAddress(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contact = getContact(methodCall: methodCall, result: result)
        result(contact.nameAndAddress)
    }
    
    fileprivate func getProfileImage(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contact = getContact(methodCall: methodCall, result: result)
        result(contact.profileImage)
    }
    
    fileprivate func getColor(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contact = getContact(methodCall: methodCall, result: result)
        result(contact.color)
    }
    
    fileprivate func isBlocked(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contact = getContact(methodCall: methodCall, result: result)
        result(contact.isBlocked)
    }
    
    fileprivate func isVerified(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contact = getContact(methodCall: methodCall, result: result)
        result(contact.isVerified)
    }
    
    // MARK: - Private Helper
    
    fileprivate func getContact(methodCall: FlutterMethodCall, result: FlutterResult) -> DcContact {
        let id = methodCall.intValue(for: Argument.ID, result: result)
        let contact = contextCallHandler.loadAndCacheContact(with: id)
        
        return contact
    }
}
