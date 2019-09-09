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

class ChatCallHandler: BaseCallHandler, MethodCallHandling {
    
    fileprivate var mailboxPointer: OpaquePointer!

    // MARK: - Protocol MethodCallHandling
    
    func handle(_ methodCall: FlutterMethodCall, result: (Any?) -> Void) {
        switch (methodCall.method) {
        case Method.Chat.GET_ID:
            getChatId(methodCall: methodCall, result: result);
            break
        case Method.Chat.IS_GROUP:
            isGroup(methodCall: methodCall, result: result);
            break
        case Method.Chat.GET_ARCHIVED:
            getArchived(methodCall: methodCall, result: result);
            break
        case Method.Chat.GET_COLOR:
            getColor(methodCall: methodCall, result: result);
            break
        case Method.Chat.GET_NAME:
            getName(methodCall: methodCall, result: result);
            break
        case Method.Chat.GET_SUBTITLE:
            getSubtitle(methodCall: methodCall, result: result);
            break
        case Method.Chat.GET_PROFILE_IMAGE:
            getProfileImage(methodCall: methodCall, result: result);
            break
        case Method.Chat.IS_UNPROMOTED:
            isUnpromoted(methodCall: methodCall, result: result);
            break
        case Method.Chat.IS_SELF_TALK:
            isSelfTalk(methodCall: methodCall, result: result);
            break
        case Method.Chat.IS_VERIFIED:
            isVerified(methodCall: methodCall, result: result);
            break
        default:
            log.error("Context: Failing for \(methodCall.method)")
            result(FlutterMethodNotImplemented)
        }
    }

    
    private func isSelfTalk(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_is_self_talk(getChat(methodCall: methodCall, result: result)))
    }
    
    private func isUnpromoted(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_is_unpromoted(getChat(methodCall: methodCall, result: result)))
    }
    
    private func getProfileImage(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_profile_image(getChat(methodCall: methodCall, result: result)))
        //    DcChat chat = getChat(methodCall, result);
        //    if (chat == null) {
        //    resultErrorGeneric(methodCall, result);
        //    return;
        //    }
        //    result.success(chat.getProfileImage());
    }
    
    private func getSubtitle(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_subtitle(getChat(methodCall: methodCall, result: result)))
        
    }
    
    private func getName(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_name(getChat(methodCall: methodCall, result: result)))
    }
    
    private func getArchived(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_archived(getChat(methodCall: methodCall, result: result)))
    }
    
    private func getColor(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_color(getChat(methodCall: methodCall, result: result)))
    }
    
    private func isGroup(methodCall: FlutterMethodCall, result: FlutterResult) {
        // TODO : ???
        result(nil)
        //    DcChat chat = getChat(methodCall, result);
        //    if (chat == null) {
        //    resultErrorGeneric(methodCall, result);
        //    return;
        //    }
        //    result.success(chat.isGroup());
    }
    
    private func getChatId(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_id(getChat(methodCall: methodCall, result: result)))
    }
    
    private func isVerified(methodCall: FlutterMethodCall, result: FlutterResult) {
        // TODO : ???
        result(dc_chat_is_verified(getChat(methodCall: methodCall, result: result)))
    }
    
    private func getChat(methodCall: FlutterMethodCall, result: FlutterResult) -> OpaquePointer {
        let id = methodCall.intValue(for: Argument.ID, result: result)
        let chat: OpaquePointer = dc_get_chat(mailboxPointer, UInt32(id))
        return chat;
    }
}
