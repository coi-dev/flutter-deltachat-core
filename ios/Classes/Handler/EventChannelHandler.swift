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

class EventChannelHandler: NSObject, FlutterStreamHandler, DcEventDelegate {
    
    fileprivate let CHANNEL_DELTA_CHAT_CORE_EVENTS = "deltaChatCoreEvents"
    
    fileprivate let messenger: FlutterBinaryMessenger!
    fileprivate var eventSink: FlutterEventSink?
    fileprivate var eventDelegate: DcEventDelegate!
    fileprivate var listeners: [Int: Int] = [:]
    fileprivate var listenerId = 0
    fileprivate var eventChannel: FlutterEventChannel!
    
    let dcEventCenter: DcEventCenter = DcEventCenter()

    // MARK: - Initialization
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        self.eventChannel = FlutterEventChannel(name: CHANNEL_DELTA_CHAT_CORE_EVENTS, binaryMessenger: messenger)

        super.init()

        self.eventDelegate = self
        self.eventChannel.setStreamHandler(self)
    }
    
    // MARK: - Public API
    
    func addListener(eventId: Int) -> Int {
        guard !hasListeners(for: eventId) else {
            return -1
        }

        listenerId += 1
        listeners[listenerId] = eventId
        dcEventCenter.add(observer: eventDelegate, for: eventId)

        return listenerId
    }
    
    func remove(listener listenerId: Int) {
        guard listeners[listenerId] != nil else {
            return
        }
        
        listeners.removeValue(forKey: listenerId)
    }
 
    // MARK: - FlutterStreamHandler
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if nil != self.eventSink {
            return nil
        }
        
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    // MARK: - DcEventDelegate
    
    func handle(eventWith eventId: Int, data1: Any, data2: Any) {
        if !hasListeners(for: eventId) {
            return
        }

        let result = [eventId, data1, data2]
        self.eventSink?(result)
    }
    
    // MARK: - Private Helper
    
    private func hasListeners(for eventId: Int) -> Bool {
        let values =  Array(listeners.values)
        guard let index = values.firstIndex(of: eventId) else {
            return false
        }
        return eventId != 0 && index >= 0
    }

}
