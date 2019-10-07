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

public func isData2AString(for event: CInt) -> Bool {
    return (event >= 100 && event <= 499)
}

@_silgen_name("handleDeltaChatEvent")
public func handleDeltaChatEvent(event: CInt, data1: CUnsignedLong, data2: CUnsignedLong, data1String: UnsafePointer<Int8>, data2String: UnsafePointer<Int8>) -> UnsafePointer<Int8>? {
    var logMessage = "Received DCC event [\(event)]"
    
    if isData2AString(for: event) {
        logMessage = "\(logMessage): \(String(cString: data2String))"
    }
    
    switch Int32(event) {
        case DC_EVENT_INFO:
            log.info(logMessage)
            break
        
        case DC_EVENT_WARNING:
            log.warning(logMessage)
            break
        
        case DC_EVENT_ERROR,
             DC_EVENT_ERROR_NETWORK,
             DC_EVENT_ERROR_SELF_NOT_IN_GROUP:
            log.error(logMessage)
            break
        
        case DC_EVENT_GET_STRING:
            log.info(logMessage)
            break
        
        default:
            log.info(logMessage)
            DcEventCenter.sharedInstance.send(data1: data1, data2: data2, toObserversWith: Int(event))
    }
    
    return nil
}
