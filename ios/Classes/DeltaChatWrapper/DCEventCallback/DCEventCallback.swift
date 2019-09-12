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
    log.debug("Received event: \(event)")
    
    guard let callbackEvent = DcEvent(rawValue: event) else {
        log.error("Unknown event: \(event), '\(String(cString: data2String))'")
        return nil
    }
    
    switch callbackEvent {
    case .info:
        log.debug("event: \(String(cString: data2String))")
        
    case .warning:
        log.debug("event: \(String(cString: data2String))")
        
    case .error:
        log.debug("event: \(String(cString: data2String))")
        
    case .errorNetwork:
        log.debug("event: \(String(cString: data2String))")
        
    case .errorSelfNotInGroup:
        log.debug("event: \(String(cString: data2String))")
        
    case .msgsChanged:
        log.debug("event: \(String(cString: data2String))")
        
    case .msgIncoming:
        log.debug("event: \(String(cString: data2String))")
        
    case .msgDelivered:
        log.debug("event: \(String(cString: data2String))")
        
    case .msgFailed:
        log.debug("event: \(String(cString: data2String))")
        
    case .msgRead:
        log.debug("event: \(String(cString: data2String))")
        
    case .chatModified:
        log.debug("event: \(String(cString: data2String))")
        
    case .contactsChanged:
        log.debug("event: \(String(cString: data2String))")
        
    case .configureProgress:
        log.debug("event: \(String(cString: data2String))")
        
    case .imexProgress:
        log.debug("event: \(String(cString: data2String))")
        
    case .imexFileWritten:
        log.debug("event: \(String(cString: data2String))")
        
    case .secureJoinJoinerProgress:
        log.debug("event: \(String(cString: data2String))")
        
    case .secureJoinInviterProgress:
        log.debug("event: \(String(cString: data2String))")
        
    case .isOffline:
        log.debug("event: \(String(cString: data2String))")
        
    case .getString:
//        log.debug("event: \(String(cString: data2String))")
        break
        
    case .getQuantityString:
        log.debug("event: \(String(cString: data2String))")
        
    case .HTTP_GET:
        log.debug("event: \(String(cString: data2String))")
        
    case .HTTP_POST:
        log.debug("event: \(String(cString: data2String))")
    }
    
    return nil
}

enum DcEvent: CInt {
    case info                      = 100
    case warning                   = 300
    case error                     = 400
    case errorNetwork              = 401
    case errorSelfNotInGroup       = 410
    case msgsChanged               = 2000
    case msgIncoming               = 2005
    case msgDelivered              = 2010
    case msgFailed                 = 2012
    case msgRead                   = 2015
    case chatModified              = 2020
    case contactsChanged           = 2030
    case configureProgress         = 2041
    case imexProgress              = 2051
    case imexFileWritten           = 2052
    case secureJoinInviterProgress = 2060
    case secureJoinJoinerProgress  = 2061
    case isOffline                 = 2081
    case getString                 = 2091
    case getQuantityString         = 2092
    case HTTP_GET                  = 2100
    case HTTP_POST                 = 2110
}
