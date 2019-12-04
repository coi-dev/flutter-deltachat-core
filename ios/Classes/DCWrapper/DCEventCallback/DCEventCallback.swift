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
func handleDeltaChatEvent(event: CInt, data1: CUnsignedLong, data2: CUnsignedLong, data1String: UnsafePointer<Int8>, data2String: UnsafePointer<Int8>) -> UnsafePointer<Int8>? {
    let parameters = EventParameters(eventId: Int32(event), data1: data1, data2: data2, data1String: data1String, data2String: data2String)
    var logMessage = "Received DCC event [\(parameters.eventId)]"

    if parameters.data2IsString {
        logMessage = "\(logMessage): \(parameters.data2Object)"
    }

    switch parameters.eventId {
        case DC_EVENT_INFO:
            log.info(logMessage)

        case DC_EVENT_ERROR,
             DC_EVENT_ERROR_NETWORK,
             DC_EVENT_ERROR_SELF_NOT_IN_GROUP:
            log.error(logMessage)
            EventChannelHandler.sharedInstance.handle(parameters.eventId, data1: parameters.data1Object, data2: parameters.data2Object)

        default:
            log.info(logMessage)
            EventChannelHandler.sharedInstance.handle(parameters.eventId, data1: parameters.data1Object, data2: parameters.data2Object)
    }

    return nil
}

fileprivate struct EventParameters {
    var eventId: Int32
    var data1: CUnsignedLong
    var data2: CUnsignedLong
    var data1String: UnsafePointer<Int8>
    var data2String: UnsafePointer<Int8>
    
    var data1Object: Any {
        data1IsString ? String(cString: data1String) : data1
    }
    
    var data2Object: Any {
        data2IsString ? String(cString: data2String) : data2
    }

    var data1IsString: Bool {
        // according to deltachat.h
        (eventId == DC_EVENT_IMEX_FILE_WRITTEN || eventId == DC_EVENT_FILE_COPIED)
    }

    var data2IsString: Bool {
        // according to deltachat.h
        ((eventId >= 100 && eventId <= 499) || eventId == DC_EVENT_METADATA)
    }
}
