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

@_silgen_name("handleDeltaChatEvent")
public func handleDeltaChatEvent(event: CInt, data1: CUnsignedLong, data2: CUnsignedLong, data1String: UnsafePointer<Int8>, data2String: UnsafePointer<Int8>) -> UnsafePointer<Int8>? {
    let logMessage = "Received DCC event [\(event)]"
    let eventMessage: UnsafePointer<Int8>? = data2String
    
    if nil != eventMessage {
        log.debug("\(logMessage): \(String(cString: data2String))")
    } else {
        log.debug(logMessage)
    }

    switch Int32(event) {
    case DC_EVENT_INFO:
        break
        
//    case DC_EVENT_SMTP_CONNECTED:
//        break
//        
//    case DC_EVENT_IMAP_CONNECTED:
//        break
//        
//    case DC_EVENT_SMTP_MESSAGE_SENT:
//        break

    case DC_EVENT_WARNING:
        break

    case DC_EVENT_ERROR:
        break

    case DC_EVENT_ERROR_NETWORK:
        break

    case DC_EVENT_ERROR_SELF_NOT_IN_GROUP:
        break
        
//    case DC_EVENT_MSGS_CHANGED:
//        break
//
//    case DC_EVENT_INCOMING_MSG:
//        break
//
//    case DC_EVENT_MSG_DELIVERED:
//        break
//
//    case DC_EVENT_MSG_FAILED:
//        break
//
//    case DC_EVENT_MSG_READ:
//        break
//
//    case DC_EVENT_CHAT_MODIFIED:
//        break
//
//    case DC_EVENT_CONTACTS_CHANGED:
//        break
//
//    case DC_EVENT_LOCATION_CHANGED:
//        break
//
//    case DC_EVENT_CONFIGURE_PROGRESS:
//        break
//
//    case DC_EVENT_IMEX_PROGRESS:
//        break
//
//    case DC_EVENT_IMEX_FILE_WRITTEN:
//        break
//
//    case DC_EVENT_SECUREJOIN_INVITER_PROGRESS:
//        break
//
//    case DC_EVENT_SECUREJOIN_JOINER_PROGRESS:
//        break
        
    case DC_EVENT_GET_STRING:
        break

    default:
        DcEventCenter.sharedInstance.send(data1: data1, data2: data2, toObserversWith: Int(event))
        break

    }
    
    return nil
}
