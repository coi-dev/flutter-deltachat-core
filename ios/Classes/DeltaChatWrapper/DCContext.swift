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

class DcContext {
    static private(set) var contextPointer: OpaquePointer?
    
    var userDatabasePath: String {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        return "\(paths[0])/messenger.db"
    }
    
    init() {
        DcContext.contextPointer = dc_context_new(dc_event_callback, nil, UIApplication.name)
    }
    
    deinit {
        dc_context_unref(DcContext.contextPointer)
    }
    
    func openUserDataBase() -> Bool {
        let result = NSNumber(value: dc_open(DcContext.contextPointer, userDatabasePath, nil))
        return Bool(truncating: result)
    }
    
    func closeUserDataBase() {
        dc_close(DcContext.contextPointer)
        DcContext.contextPointer = nil
    }
    
    func getChatlist(flags: Int32, queryString: String?, queryId: Int) -> DcChatlist {
        let chatlistPointer = dc_get_chatlist(DcContext.contextPointer, flags, queryString, UInt32(queryId))
        let chatlist = DcChatlist(chatListPointer: chatlistPointer)
        return chatlist
    }
    
    func deleteChat(chatId: Int) {
        dc_delete_chat(DcContext.contextPointer, UInt32(chatId))
    }
    
    func archiveChat(chatId: Int, archive: Bool) {
        dc_archive_chat(DcContext.contextPointer, UInt32(chatId), Int32(archive ? 1 : 0))
    }
    
    func getSecurejoinQr (chatId: Int) -> String? {
        if let cString = dc_get_securejoin_qr(DcContext.contextPointer, UInt32(chatId)) {
            let swiftString = String(cString: cString)
            free(cString)
            return swiftString
        }
        return nil
    }
    
    func joinSecurejoin (qrCode: String) -> Int {
        return Int(dc_join_securejoin(DcContext.contextPointer, qrCode))
    }
    
    func checkQR(qrCode: String) -> DcLot {
        return DcLot(dc_check_qr(DcContext.contextPointer, qrCode))
    }
    
    func stopOngoingProcess() {
        dc_stop_ongoing_process(DcContext.contextPointer)
    }
    
    func getMsgInfo(msgId: Int) -> String {
        if let cString = dc_get_msg_info(DcContext.contextPointer, UInt32(msgId)) {
            let swiftString = String(cString: cString)
            free(cString)
            return swiftString
        }
        return "ErrGetMsgInfo"
    }
    
}
