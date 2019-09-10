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

class DCEventHandler {

    enum ApplicationState {
        case stopped
        case running
        case background
        case backgroundFetch
    }

    fileprivate var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    fileprivate var state = ApplicationState.stopped
    fileprivate let dcContext: DCContext!

    init(context: DCContext) {
        self.dcContext = context
    }
    
    func start() {
        DispatchQueue.global(qos: .background).async {
            self.registerBackgroundTask()
            while self.state == .running {
                dc_perform_imap_jobs(self.dcContext.context)
                dc_perform_imap_fetch(self.dcContext.context)
                dc_perform_imap_idle(self.dcContext.context)
            }
            if self.backgroundTask != .invalid {
//                completion?()
                self.endBackgroundTask()
            }
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.registerBackgroundTask()
            while self.state == .running {
                dc_perform_smtp_jobs(self.dcContext.context)
                dc_perform_smtp_idle(self.dcContext.context)
            }
            if self.backgroundTask != .invalid {
                self.endBackgroundTask()
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            while self.state == .running {
                dc_perform_sentbox_fetch(self.dcContext.context)
                dc_perform_sentbox_idle(self.dcContext.context)
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            while self.state == .running {
                dc_perform_mvbox_fetch(self.dcContext.context)
                dc_perform_mvbox_idle(self.dcContext.context)
            }
        }
    }
    
    func stop() {
        
    }

    // MARK: - BackgroundTask
    
    private func registerBackgroundTask() {
        log.info("background task registered")
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    private func endBackgroundTask() {
        log.info("background task ended")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }

}

@_silgen_name("handleDeltaChatEvent")
public func handleDeltaChatEvent(event: CInt, data1: CUnsignedLong, data2: CUnsignedLong, data1String: UnsafePointer<Int8>, data2String: UnsafePointer<Int8>) -> UnsafePointer<Int8>? {
    log.debug("Received event: \(event)")

    switch event {
    case DcEvent.INFO.rawValue:
        log.debug("event: \(String(cString: data2String))")
        
    case DcEvent.INCOMING_MSG.rawValue:
        log.debug("Message ID: \(Int(data2))")
        
    default:
        log.error("Unknown event: \(event)")
    }
    
    return nil
}


enum DcEvent: CInt {
    case INFO                        = 100
    case WARNING                     = 300
    case ERROR                       = 400
    case ERROR_NETWORK               = 401
    case ERROR_SELF_NOT_IN_GROUP     = 410
    case MSGS_CHANGED                = 2000
    case INCOMING_MSG                = 2005
    case MSG_DELIVERED               = 2010
    case MSG_FAILED                  = 2012
    case MSG_READ                    = 2015
    case CHAT_MODIFIED               = 2020
    case CONTACTS_CHANGED            = 2030
    case CONFIGURE_PROGRESS          = 2041
    case IMEX_PROGRESS               = 2051
    case IMEX_FILE_WRITTEN           = 2052
    case SECUREJOIN_INVITER_PROGRESS = 2060
    case SECUREJOIN_JOINER_PROGRESS  = 2061
    case IS_OFFLINE                  = 2081
    case GET_STRING                  = 2091
    case GET_QUANTITIY_STRING        = 2092
    case HTTP_GET                    = 2100
    case HTTP_POST                   = 2110
}
