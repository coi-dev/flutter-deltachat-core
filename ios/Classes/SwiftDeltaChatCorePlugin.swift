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
    
    fileprivate let registrar: FlutterPluginRegistrar!
    fileprivate let dcContext: DCContext!

    fileprivate let chatCallHandler: ChatCallHandler!
    fileprivate let chatListCallHandler: ChatListCallHandler!
    fileprivate let contactCallHandler: ContactCallHandler!
    fileprivate let contextCallHandler: ContextCallHandler!
    fileprivate let messageCallHandler: MessageCallHandler!
    fileprivate let eventChannelHandler: EventChannelHandler!
    

    // MARK: - Initialization

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        self.dcContext = DCContext("OX Coi iOS")

        self.chatCallHandler = ChatCallHandler(context: dcContext)
        self.chatListCallHandler = ChatListCallHandler(context: dcContext)
        self.contactCallHandler = ContactCallHandler(context: dcContext)
        self.contextCallHandler = ContextCallHandler(context: dcContext)
        self.messageCallHandler = MessageCallHandler(context: dcContext)
        self.eventChannelHandler = EventChannelHandler(messanger: registrar.messenger())
    }
    
    // MARK: - Pubic API
    
    // This is out entry point
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "deltaChatCore", binaryMessenger: registrar.messenger())
        let delegate = SwiftDeltaChatCorePlugin(registrar: registrar)
        registrar.addMethodCallDelegate(delegate, channel: channel)
    }
    
    // MARK: - FlutterPlugin

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        log.debug("MethodCall: \(call.method)")

        switch (call.methodPrefix) {
        case Method.Prefix.BASE:
            handle(baseCall: call, result: result)
            break
        case Method.Prefix.CHAT:
            handle(chatCall: call, result: result)
            break
        case Method.Prefix.CHAT_LIST:
            handle(chatListCall: call, result: result)
            break
        case Method.Prefix.CONTACT:
            handle(contactCall: call, result: result)
            break
        case Method.Prefix.CONTEXT:
            handle(contextCall: call, result: result)
            break
        case Method.Prefix.MSG:
            handle(messageCall: call, result: result)
            break
        default:
            log.debug("Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
        }

    }
    
    // MARK: - MethodChannel Calls
    
    fileprivate func handle(baseCall call: FlutterMethodCall, result: FlutterResult) {
        switch (call.method) {
        case Method.Base.INIT:
            baseInit(result: result)
            break
        case Method.Base.SYSTEM_INFO:
            systemInfo(result: result)
            break
        case Method.Base.CORE_LISTENER:
            coreListener(methodCall: call, result: result);
            break
        case Method.Base.SET_CORE_STRINGS:
            setCoreStrings(methodCall: call, result: result);
            break
        default:
            log.error("Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
        }
    }
    
    fileprivate func handle(chatCall call: FlutterMethodCall, result: FlutterResult) {
        chatCallHandler.handle(call, result: result);
    }
    
    fileprivate func handle(chatListCall call: FlutterMethodCall, result: FlutterResult) {
        chatListCallHandler.handle(call, result: result);
    }
    
    fileprivate func handle(contactCall call: FlutterMethodCall, result: FlutterResult) {
        contactCallHandler.handle(call, result: result);
    }
    
    fileprivate func handle(contextCall call: FlutterMethodCall, result: FlutterResult) {
        contextCallHandler.handle(call, result: result);
    }
    
    fileprivate func handle(messageCall call: FlutterMethodCall, result: FlutterResult) {
        messageCallHandler.handle(call, result: result);
    }
    
    // MARK: - Private Helper

    fileprivate func baseInit(result: FlutterResult) {
        if dcContext.openUserDataBase() {
            result(dcContext.userDatabasePath)
            return
        }
        log.error("Couldn't open user database at path: \(dcContext.userDatabasePath)")
        result(DCPluginError.couldNotOpenDataBase())
    }
    
    fileprivate func systemInfo(result: FlutterResult) {
        result(UIApplication.version)
    }

    fileprivate func coreListener(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let add: Bool = methodCall.value(for: Argument.ADD, result: result) as? Bool,
            let eventId: Int = methodCall.value(for: Argument.EVENT_ID, result: result) as? Int else {
                result(nil)
                return
        }
        
        // Add a new Listener
        if true == add {
            let listenerId = Int(1 /* TODO: Add new Listener here */)
            result(listenerId)
        }
        
        // Remove a given Listener
        if let listenerId: Int = methodCall.value(for: Argument.LISTENER_ID, result: result) as? Int {
            // TODO: Add logic to remove the listener with listenerId
        }
        
        result(nil)
        
        //        Boolean add = methodCall.argument(ARGUMENT_ADD);
        //        Integer eventId = methodCall.argument(ARGUMENT_EVENT_ID);
        //        Integer listenerId = methodCall.argument(ARGUMENT_LISTENER_ID);
        //        if (eventId == null || add == null) {
        //        return;
        //        }
        //        if (add) {
        //        int newListenerId = eventChannelHandler.addListener(eventId);
        //        result.success(newListenerId);
        //        } else {
        //        if (listenerId == null) {
        //        return;
        //        }
        //        eventChannelHandler.removeListener(listenerId);
        //        result.success(null);
        //        }
    }
    
    fileprivate func setCoreStrings(methodCall: FlutterMethodCall, result: FlutterResult) {
        // TODO: Ask Daniel for NativeInteractionManager
        //        guard let coreStrings = methodCall.arguments else {
        //            return
        //        }
        //
        //    Map<Long, String> coreStrings = methodCall.arguments();
        //    nativeInteractionManager.setCoreStrings(coreStrings);
        //    result.success(null);
        result(nil)
    }

}
