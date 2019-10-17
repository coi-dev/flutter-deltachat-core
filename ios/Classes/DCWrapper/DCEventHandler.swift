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

    var state: ApplicationState = .stopped
    fileprivate var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    // MARK: - Public API
    
    func start(_ completion: (() -> Void)? = nil) {
        if state == .running {
            return
        }
        
        state = .running

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            self.registerBackgroundTask()
            while self.state == .running {
                dc_perform_imap_jobs(DcContext.contextPointer)
                dc_perform_imap_fetch(DcContext.contextPointer)
                dc_perform_imap_idle(DcContext.contextPointer)
            }
            if self.backgroundTask != .invalid {
                completion?()
                self.endBackgroundTask()
            }
        }
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            self.registerBackgroundTask()
            while self.state == .running {
                dc_perform_smtp_jobs(DcContext.contextPointer)
                dc_perform_smtp_idle(DcContext.contextPointer)
            }
            if self.backgroundTask != .invalid {
                self.endBackgroundTask()
            }
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            while self.state == .running {
                dc_perform_sentbox_fetch(DcContext.contextPointer)
                dc_perform_sentbox_idle(DcContext.contextPointer)
            }
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            while self.state == .running {
                dc_perform_mvbox_fetch(DcContext.contextPointer)
                dc_perform_mvbox_idle(DcContext.contextPointer)
            }
        }
    }
    
    func stop() {
        state = .background

        dc_interrupt_imap_idle(DcContext.contextPointer)
        dc_interrupt_smtp_idle(DcContext.contextPointer)
        dc_interrupt_mvbox_idle(DcContext.contextPointer)
        dc_interrupt_sentbox_idle(DcContext.contextPointer)
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
