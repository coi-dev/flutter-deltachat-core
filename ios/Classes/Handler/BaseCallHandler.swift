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

class BaseCallHandler: MethodCallHandling {
    
    fileprivate let context: DcContext!
    fileprivate let dcEventHandler: DCEventHandler!
    fileprivate let contextCallHandler: ContextCallHandler!
    fileprivate let eventChannelHandler: EventChannelHandler!

    // MARK: - Initialization
    
    init(context: DcContext, contextCallHandler: ContextCallHandler, eventChannelHandler: EventChannelHandler) {
        self.context = context
        self.contextCallHandler = contextCallHandler
        self.eventChannelHandler = eventChannelHandler

        self.dcEventHandler = DCEventHandler()
    }

    // MARK: - Protocol MethodCallHandling

    func handle(_ call: FlutterMethodCall, result: FlutterResult) {
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
    
    // MARK: - Private Helper
    
    fileprivate func baseInit(result: FlutterResult) {
        if context.openUserDataBase() {
            dcEventHandler.start()
            result(context.userDatabasePath)
            return
        }
        log.error("Couldn't open user database at path: \(context.userDatabasePath)")
        result(DCPluginError.couldNotOpenDataBase())
    }
    
    fileprivate func systemInfo(result: FlutterResult) {
        result(UIApplication.version)
    }
    
    fileprivate func coreListener(methodCall: FlutterMethodCall, result: FlutterResult) {
        let eventId = methodCall.intValue(for: Argument.EVENT_ID, result: result)
        let add = methodCall.boolValue(for: Argument.ADD, result: result)
        
        // Add a new Listener
        if true == add {
            let listenerId = eventChannelHandler.addListener(eventId: eventId)
            result(listenerId)
            return
        }

        // Remove a given Listener
        eventChannelHandler.remove(listener: eventId)
        
        result(nil)
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
