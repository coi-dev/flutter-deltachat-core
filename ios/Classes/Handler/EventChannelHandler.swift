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

class EventChannelHandler: NSObject, FlutterStreamHandler {

    fileprivate let CHANNEL_DELTA_CHAT_CORE_EVENTS = "deltaChatCoreEvents"
    fileprivate var eventSink: FlutterEventSink?
    fileprivate var eventChannel: FlutterEventChannel!
    
    fileprivate let delegateEvents: [Int32] = [
        DC_EVENT_INFO,
        DC_EVENT_WARNING,
        DC_EVENT_ERROR,
        DC_EVENT_ERROR_NETWORK,
        DC_EVENT_ERROR_SELF_NOT_IN_GROUP,
        DC_EVENT_MSGS_CHANGED,
        DC_EVENT_INCOMING_MSG,
        DC_EVENT_MSG_DELIVERED,
        DC_EVENT_MSG_FAILED,
        DC_EVENT_MSG_READ,
        DC_EVENT_CHAT_MODIFIED,
        DC_EVENT_CONTACTS_CHANGED,
        DC_EVENT_LOCATION_CHANGED,
        DC_EVENT_CONFIGURE_PROGRESS,
        DC_EVENT_IMEX_PROGRESS,
        DC_EVENT_IMEX_FILE_WRITTEN,
        DC_EVENT_SECUREJOIN_INVITER_PROGRESS,
        DC_EVENT_SECUREJOIN_JOINER_PROGRESS,
        DC_EVENT_IS_OFFLINE,
        DC_EVENT_GET_STRING,
        DC_EVENT_SET_METADATA_DONE,
        DC_EVENT_METADATA
    ]

    var messenger: FlutterBinaryMessenger? {
        didSet {
            if let messenger = messenger {
                self.eventChannel = FlutterEventChannel(name: CHANNEL_DELTA_CHAT_CORE_EVENTS, binaryMessenger: messenger)
            }
            self.eventChannel.setStreamHandler(self)
        }
    }

    static let sharedInstance: EventChannelHandler = EventChannelHandler()

    override init() {
        super.init()
    }
    
    deinit {
        self.eventChannel.setStreamHandler(nil)
        self.eventChannel = nil
    }

    // MARK: - FlutterStreamHandler

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if nil != eventSink { return nil }
        eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if nil == eventSink { return nil }
        eventSink = nil
        return nil
    }

    func handle(_ eventId: Int32, data1: Any, data2: Any) {
        if !isDelegateEvent(eventId: eventId) { return }

        let result = [eventId, data1, data2]
        self.eventSink?(result)
    }

    // MARK: - Private Helper
    
    fileprivate func isDelegateEvent(eventId: Int32) -> Bool {
        return delegateEvents.contains(eventId)
    }

}
