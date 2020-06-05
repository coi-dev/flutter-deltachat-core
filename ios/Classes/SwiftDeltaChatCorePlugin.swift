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
    
    fileprivate var dcContext: DcContext!
    fileprivate var dcEventHandler: DCEventHandler!

    fileprivate var chatCache: IdCache<DcChat> = IdCache()
    fileprivate var contactCache: IdCache<DcContact> = IdCache()
    fileprivate var messageCache: IdCache<DcMsg> = IdCache()

    fileprivate var chatCallHandler: ChatCallHandler!
    fileprivate var chatListCallHandler: ChatListCallHandler!
    fileprivate var contactCallHandler: ContactCallHandler!
    fileprivate var contextCallHandler: ContextCallHandler!
    fileprivate var messageCallHandler: MessageCallHandler!
    fileprivate var eventChannelHandler: EventChannelHandler!

    // MARK: - Initialization

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar

        self.dcContext = DcContext()
        self.dcEventHandler = DCEventHandler()
        
        self.contextCallHandler  = ContextCallHandler(context: dcContext, contactCache: contactCache, messageCache: messageCache, chatCache: chatCache)
        self.chatCallHandler     = ChatCallHandler(contextCalHandler: contextCallHandler)
        self.chatListCallHandler = ChatListCallHandler(context: dcContext, chatCache: chatCache)
        self.contactCallHandler  = ContactCallHandler(context: dcContext, contextCallHandler: contextCallHandler)
        self.messageCallHandler  = MessageCallHandler(context: dcContext, contextCallHandler: contextCallHandler)
        
        self.eventChannelHandler = EventChannelHandler.sharedInstance
        self.eventChannelHandler.messenger = registrar.messenger()
        
        super.init()
    }
    
    // MARK: - FlutterPlugin

    // This is our entry point
    public static func register(with registrar: FlutterPluginRegistrar) {
        Utils.logEventAndDelegate(logLevel: .info, message: "Attaching plugin via v2 embedding")
        let channel = FlutterMethodChannel(name: MethodChannel.DeltaChat.Core, binaryMessenger: registrar.messenger())
        let delegate = SwiftDeltaChatCorePlugin(registrar: registrar)
        registrar.addMethodCallDelegate(delegate, channel: channel)
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        Utils.logEventAndDelegate(logLevel: .info, message: "Detaching plugin via v2 embedding")
        teardown()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Utils.logEventAndDelegate(logLevel: .debug, message: "Dart MethodCall: \(call.method)")
        
        if call.contains(key: Argument.REMOVE_CACHE_IDENTIFIER) {
            removeFromCache(with: call, result: result)
        }

        switch (call.methodPrefix) {
        case Method.Prefix.CONTEXT:
            contextCallHandler.handle(call, result: result)
        case Method.Prefix.BASE:
            handleBaseCalls(with: call, result: result)
        case Method.Prefix.CHAT:
            chatCallHandler.handle(call, result: result)
        case Method.Prefix.CHAT_LIST:
            chatListCallHandler.handle(call, result: result)
        case Method.Prefix.CONTACT:
            contactCallHandler.handle(call, result: result)
        case Method.Prefix.MSG:
            messageCallHandler.handle(call, result: result)
        default:
            Utils.logEventAndDelegate(logLevel: .debug, message: "Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
        }

    }

    func handleBaseCalls(with call: FlutterMethodCall, result: FlutterResult) {
        switch (call.method) {
        case Method.Base.INIT:
            baseInit(with: call, result: result)
        case Method.Base.LOGOUT:
            teardown()
            logout(result: result)
            result(nil)
        case Method.Base.TEARDOWN:
            teardown()
            result(nil)
        default:
            Utils.logEventAndDelegate(logLevel: .error, message: "Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Cache Handling
    
    fileprivate func removeFromCache(with call: FlutterMethodCall, result: FlutterResult) {
        guard let identifier = call.stringValue(for: Argument.REMOVE_CACHE_IDENTIFIER, result: result),
            let cacheIdentifier = CacheIdentifier(rawValue: identifier) else {
                return
        }
        
        let id = UInt32(call.intValue(for: Argument.ID, result: result))
        
        switch cacheIdentifier {
            case .chat:
                _ = chatCache.removeValue(for: id)
            case .chatMessage:
                if let msg = messageCache.removeValue(for: id) {
                    Utils.logEventAndDelegate(logLevel: .info, message: "removed message: \(msg.type)")
                }
            case .contact:
                _ = contactCache.removeValue(for: id)
            default:
                break
        }
        
    }
    
    // MARK: - Handle Base Calls

    fileprivate func baseInit(with call: FlutterMethodCall, result: FlutterResult) {
        let minimalSetup = call.boolValue(for: Argument.MINIMAL_SETUP, result: result)
        
        Utils.logEventAndDelegate(logLevel: .info, message: "Init started, with minimal setup: \(minimalSetup ? "YES": "NO")")
        
        if dcContext.openUserDataBase() {
            if !minimalSetup {
                dcEventHandler.start()
            }
            _ = dcContext.getCoreInfo()
            result(dcContext.userDatabasePath)
            return
        }

        Utils.logEventAndDelegate(logLevel: .error, message: "Couldn't open user database at path: \(dcContext.userDatabasePath)")
        result(DCPluginError.couldNotOpenDataBase())
    }
    
    func logout(result: FlutterResult) {
        let application = UIApplication.shared
        let sel = Selector(("suspend"))

        if application.responds(to: sel) {
            UserDefaults.applicationShouldTerminate = true
            application.perform(sel)
            result(nil)
        }
    }
    
    func teardown() {
        Utils.logEventAndDelegate(logLevel: .info, message: "Teardown started")

        dcContext.teardown()
        dcContext = nil
        dcEventHandler.stop()
        dcEventHandler = nil
        contextCallHandler  = nil
        chatCallHandler     = nil
        chatListCallHandler = nil
        contactCallHandler  = nil
        messageCallHandler  = nil
        eventChannelHandler = nil
        
        chatCache.clear()
        contactCache.clear()
        messageCache.clear()

        Utils.logEventAndDelegate(logLevel: .info, message: "Teardown finished")
    }

}
