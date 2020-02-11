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

public class SwiftDeltaChatCorePlugin: NSObject, FlutterPlugin, DcContextDelegate {

    fileprivate let registrar: FlutterPluginRegistrar!

    fileprivate let dcContext: DcContext!
    fileprivate let dcEventHandler: DCEventHandler!

    fileprivate let chatCache: IdCache<DcChat> = IdCache()
    fileprivate let contactCache: IdCache<DcContact> = IdCache()
    fileprivate let messageCache: IdCache<DcMsg> = IdCache()

    fileprivate let chatCallHandler: ChatCallHandler!
    fileprivate let chatListCallHandler: ChatListCallHandler!
    fileprivate let contactCallHandler: ContactCallHandler!
    fileprivate let contextCallHandler: ContextCallHandler!
    fileprivate let messageCallHandler: MessageCallHandler!

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
        
        let ech = EventChannelHandler.sharedInstance
        ech.messenger = registrar.messenger()
        
        super.init()

        self.dcContext.delegate = self
    }

    // This is our entry point
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "deltaChatCore", binaryMessenger: registrar.messenger())
        let delegate = SwiftDeltaChatCorePlugin(registrar: registrar)
        registrar.addMethodCallDelegate(delegate, channel: channel)
    }

    // MARK: - FlutterPlugin

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        log.debug("Dart MethodCall: \(call.method)")
        
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
            log.debug("Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
        }

    }

    func handleBaseCalls(with call: FlutterMethodCall, result: FlutterResult) {
        switch (call.method) {
        case Method.Base.INIT:
            baseInit(result: result)
        case Method.Base.SYSTEM_INFO:
            systemInfo(result: result)
        default:
            log.error("Failing for \(call.method)")
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
                    log.info("removed message: \(msg.type)")
                }
            case .contact:
                _ = contactCache.removeValue(for: id)
            default:
                break
        }
        
    }
    
    // MARK: - Handle Base Calls

    fileprivate func baseInit(result: FlutterResult) {
        if dcContext.openUserDataBase() {
            dcEventHandler.start()
            result(dcContext.userDatabasePath)
            return
        }
        log.error("Couldn't open user database at path: \(dcContext.userDatabasePath)")
        result(DCPluginError.couldNotOpenDataBase())
    }

    fileprivate func systemInfo(result: FlutterResult) {
        result(UIApplication.version)
    }
    
    // MARK: - DcContextDelegate
    
    func logout() throws {
        let application = UIApplication.shared
        let sel = Selector("suspend")

        if application.responds(to: sel) {
            do {
                try FileManager.default.removeItem(atPath: dcContext.userDatabasePath)
                UserDefaults.applicationShouldTerminate = true
                application.perform(sel)

            } catch {
                throw DcContextError(kind: .unableToDeleteDatabase(dcContext.userDatabasePath))
            }
        }
    }

}
