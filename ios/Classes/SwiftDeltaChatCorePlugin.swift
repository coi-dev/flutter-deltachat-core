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

import Flutter
import SwiftyBeaver
import UIKit

let log = SwiftyBeaver.self

public class SwiftDeltaChatCorePlugin: NSObject, FlutterPlugin {
    
    fileprivate let callHandler = CallHandler()
    fileprivate let registrar: FlutterPluginRegistrar!
    
    fileprivate let eventChannelHandler: EventChannelHandler!
    
    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        
        self.eventChannelHandler = EventChannelHandler(messanger: registrar.messenger())
    }
    
    // MARK: - Pubic API
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "deltaChatCore", binaryMessenger: registrar.messenger())
        let instance = SwiftDeltaChatCorePlugin(registrar: registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        log.debug("MethodCall: \(call.method)")

        switch (call.methodPrefix) {
        case Method.Prefix.BASE:
            callHandler.handleBaseCalls(methodCall: call, result: result);
            break
        case Method.Prefix.CONTEXT:
            callHandler.handleContextCalls(methodCall: call, result: result)
            break
        case Method.Prefix.CHAT_LIST:
            callHandler.handleChatListCalls(methodCall: call, result: result)
            break
        case Method.Prefix.CHAT:
            callHandler.handleChatCalls(methodCall: call, result: result)
            break
        case Method.Prefix.CONTACT:
            callHandler.handleContactCalls(methodCall: call, result: result)
            break
        case Method.Prefix.MSG:
            callHandler.handleMessageCalls(methodCall: call, result: result);
            break
        default:
            log.debug("Failing for \(call.method)")
            _ = FlutterMethodNotImplemented
        }

    }
    
}
