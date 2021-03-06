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

class DcChat {
    var chatPointer: OpaquePointer?

    init(id: UInt32) {
        if let pointer = dc_get_chat(DcContext.contextPointer, id) {
            chatPointer = pointer
        } else {
            fatalError("Invalid chatID opened \(id)")
        }
    }

    deinit {
        dc_chat_unref(chatPointer)
    }

    var id: UInt32 {
        return dc_chat_get_id(chatPointer)
    }

    var name: String {
        guard let cString = dc_chat_get_name(chatPointer) else { return "" }
        let swiftString = String(cString: cString)
        free(cString)
        return swiftString
    }

    var type: Int32 {
        return dc_chat_get_type(chatPointer)
    }
    
    var visibility: Int32 {
        return dc_chat_get_visibility(chatPointer)
    }

    var chatType: ChatType {
        return ChatType(rawValue: type) ?? .group // group as fallback - shouldn't get here
    }

    var isGroup: Bool {
        return (chatType == .group || chatType == .verifiedGroup)
    }

    var isVerified: Bool {
        return dc_chat_is_verified(chatPointer) > 0
    }

    var isUnpromoted: Bool {
        return dc_chat_is_unpromoted(chatPointer) > 0
    }

    var isSelfTalk: Bool {
        return dc_chat_is_self_talk(chatPointer) > 0
    }
    
    var isDeviceTalk: Bool {
        return dc_chat_is_device_talk(chatPointer) == 1
    }

    var contactIds: [UInt32] {
        let chatContacts = dc_get_chat_contacts(DcContext.contextPointer, UInt32(id))
        return Utils.copyAndFreeArray(inputArray: chatContacts)
    }

    lazy var profileImageFilePath: String? = {
        guard let cString = dc_chat_get_profile_image(chatPointer) else { return "" }
        let filePath = String(cString: cString)
        free(cString)

        let path: URL = URL(fileURLWithPath: filePath, isDirectory: false)

        if path.isFileURL {
            return path.path
        }

        return nil
    }()

    var color: UInt32 {
        return dc_chat_get_color(chatPointer)
    }

}

enum ChatType: Int32 {
    case single = 100
    case group = 120
    case verifiedGroup = 130
}
