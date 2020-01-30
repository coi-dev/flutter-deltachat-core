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

class DcContact {
    private var contactPointer: OpaquePointer?

    init(id: UInt32) {
        contactPointer = dc_get_contact(DcContext.contextPointer, id)
    }

    deinit {
        dc_contact_unref(contactPointer)
    }

    var displayName: String {
        guard let cString = dc_contact_get_display_name(contactPointer) else { return "" }
        let swiftString = String(cString: cString)
        free(cString)
        return swiftString
    }

    var nameAndAddress: String {
        guard let cString = dc_contact_get_name_n_addr(contactPointer) else { return "" }
        let swiftString = String(cString: cString)
        free(cString)
        return swiftString
    }

    var name: String {
        guard let cString = dc_contact_get_name(contactPointer) else { return "" }
        let swiftString = String(cString: cString)
        free(cString)
        return swiftString
    }

    var firstName: String {
        guard let cString = dc_contact_get_first_name(contactPointer) else { return "" }
        let swiftString = String(cString: cString)
        free(cString)
        return swiftString
    }

    var email: String {
        guard let cString = dc_contact_get_addr(contactPointer) else { return "" }
        let swiftString = String(cString: cString)
        free(cString)
        return swiftString
    }

    var isVerified: Bool {
        return dc_contact_is_verified(contactPointer) > 0
    }

    var isBlocked: Bool {
        return dc_contact_is_blocked(contactPointer) == 1
    }

    lazy var profileImageFilePath: String? = {
        guard let cString = dc_contact_get_profile_image(contactPointer) else { return nil }
        let filePath = String(cString: cString)
        free(cString)

        let path: URL = URL(fileURLWithPath: filePath, isDirectory: false)

        if path.isFileURL {
            return path.path
        }

        return nil
    }()

    var color: Int {
        return Int(dc_contact_get_color(contactPointer))
    }

    var id: UInt32 {
        return dc_contact_get_id(contactPointer)
    }

    func block() {
        dc_block_contact(DcContext.contextPointer, UInt32(id), 1)
    }

    func unblock() {
        dc_block_contact(DcContext.contextPointer, UInt32(id), 0)
    }

    func marknoticed() {
        dc_marknoticed_contact(DcContext.contextPointer, UInt32(id))
    }
}
