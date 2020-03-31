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

class ChatCallHandler: MethodCallHandling {

    fileprivate let contextCalHandler: ContextCallHandler!

    // MARK: - Initialization

    init(contextCalHandler: ContextCallHandler) {
        self.contextCalHandler = contextCalHandler
    }

    // MARK: - Protocol MethodCallHandling

    func handle(_ call: FlutterMethodCall, result: FlutterResult) {
        switch (call.method) {
        case Method.Chat.GET_ID:
            getChatId(methodCall: call, result: result)
            break
        case Method.Chat.IS_GROUP:
            isGroup(methodCall: call, result: result)
            break
        case Method.Chat.GET_ARCHIVED:
//            getArchived(methodCall: call, result: result)
            break
        case Method.Chat.GET_COLOR:
            getColor(methodCall: call, result: result)
            break
        case Method.Chat.GET_NAME:
            getName(methodCall: call, result: result)
            break
        case Method.Chat.GET_PROFILE_IMAGE:
            getProfileImage(methodCall: call, result: result)
            break
        case Method.Chat.IS_UNPROMOTED:
            isUnpromoted(methodCall: call, result: result)
            break
        case Method.Chat.IS_SELF_TALK:
            isSelfTalk(methodCall: call, result: result)
            break
        case Method.Chat.IS_VERIFIED:
            isVerified(methodCall: call, result: result)
            break
        default:
            Utils.logEventAndDelegate(logLevel: SwiftyBeaver.Level.error, message: "Context: Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
        }
    }

    private func isSelfTalk(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chat = getChat(methodCall: methodCall, result: result)
        result(NSNumber(value: chat.isSelfTalk))
    }

    private func isUnpromoted(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chat = getChat(methodCall: methodCall, result: result)
        result(NSNumber(value: chat.isUnpromoted))
    }

    private func getProfileImage(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chat = getChat(methodCall: methodCall, result: result)
        result(chat.profileImageFilePath)
    }

    private func getName(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chat = getChat(methodCall: methodCall, result: result)
        result(chat.name)
    }

//    private func getArchived(methodCall: FlutterMethodCall, result: FlutterResult) {
//        let chat = getChat(methodCall: methodCall, result: result)
//        result(NSNumber(value: chat.archived))
//    }

    private func getColor(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chat = getChat(methodCall: methodCall, result: result)
        result(NSNumber(value: chat.color))
    }

    private func isGroup(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chat = getChat(methodCall: methodCall, result: result)
        result(NSNumber(value: chat.isGroup))
    }

    private func getChatId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chat = getChat(methodCall: methodCall, result: result)
        result(NSNumber(value: chat.id))
    }

    private func isVerified(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chat = getChat(methodCall: methodCall, result: result)
        result(NSNumber(value: chat.isVerified))
    }

    // MARK: - Helper

    private func getChat(methodCall: FlutterMethodCall, result: FlutterResult) -> DcChat {
        let id = methodCall.intValue(for: Argument.ID, result: result)
        let chat = contextCalHandler.loadAndCacheChat(with: UInt32(id))
        return chat
    }
}
