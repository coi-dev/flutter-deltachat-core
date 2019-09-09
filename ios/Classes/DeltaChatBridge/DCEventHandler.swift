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

struct DCEventHandler {

    @_silgen_name("handleDeltaChatEvent")
    public func handleDeltaChatEvent(event: CInt, data1: CUnsignedLong, data2: CUnsignedLong, data1String: UnsafePointer<Int8>, data2String: UnsafePointer<Int8>) -> UnsafePointer<Int8>? {
        log.debug("Received event: \(event)")

        switch event {
        case DC_EVENT_INCOMING_MSG:
            log.debug("Message ID: \(Int(data2))")
            
        default:
            log.error("Unknown event: \(event)")
        }
        
        return nil
    }
    
    public let DC_EVENT_INFO: CInt                        = 100
    public let DC_EVENT_WARNING: CInt                     = 300
    public let DC_EVENT_ERROR: CInt                       = 400
    public let DC_EVENT_ERROR_NETWORK: CInt               = 401
    public let DC_EVENT_ERROR_SELF_NOT_IN_GROUP: CInt     = 410
    public let DC_EVENT_MSGS_CHANGED: CInt                = 2000
    public let DC_EVENT_INCOMING_MSG: CInt                = 2005
    public let DC_EVENT_MSG_DELIVERED: CInt               = 2010
    public let DC_EVENT_MSG_FAILED: CInt                  = 2012
    public let DC_EVENT_MSG_READ: CInt                    = 2015
    public let DC_EVENT_CHAT_MODIFIED: CInt               = 2020
    public let DC_EVENT_CONTACTS_CHANGED: CInt            = 2030
    public let DC_EVENT_CONFIGURE_PROGRESS: CInt          = 2041
    public let DC_EVENT_IMEX_PROGRESS: CInt               = 2051
    public let DC_EVENT_IMEX_FILE_WRITTEN: CInt           = 2052
    public let DC_EVENT_SECUREJOIN_INVITER_PROGRESS: CInt = 2060
    public let DC_EVENT_SECUREJOIN_JOINER_PROGRESS: CInt  = 2061
    public let DC_EVENT_IS_OFFLINE: CInt                  = 2081
    public let DC_EVENT_GET_STRING: CInt                  = 2091
    public let DC_EVENT_GET_QUANTITIY_STRING: CInt        = 2092
    public let DC_EVENT_HTTP_GET: CInt                    = 2100
    public let DC_EVENT_HTTP_POST: CInt                   = 2110

}
