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

struct Argument {

    static let ID                      = "id"
    static let TYPE                    = "type"
    static let KEY                     = "key"
    static let VALUE                   = "value"
    static let ADDRESS                 = "address"
    static let CACHE_ID                = "cacheId"
    static let VERIFIED                = "verified"
    static let NAME                    = "name"
    static let INDEX                   = "index"
    static let FLAGS                   = "flags"
    static let QUERY                   = "query"
    static let ADDRESS_BOOK            = "addressBook"
    static let CONTACT_ID              = "contactId"
    static let CHAT_ID                 = "chatId"
    static let PATH                    = "path"
    static let TEXT                    = "text"
    static let COUNT                   = "count"
    static let MESSAGE_ID              = "messageId"
    static let MESSAGE_IDS             = "messageIds"
    static let SETUP_CODE              = "setupCode"
    static let QR_TEXT                 = "qrText"
    static let ADD                     = "add"
    static let EVENT_ID                = "eventId"
    static let DB_NAME                 = "dbName"
    static let UID                     = "uid"
    static let JSON                    = "json"
    static let ENABLE                  = "enable"
    static let MODE                    = "mode"
    static let MESSAGE                 = "message"
    static let MIME_TYPE               = "mimeType"
    static let REMOVE_CACHE_IDENTIFIER = "removeCacheIdentifier"
    static let DURATION                = "duration"

    struct Error {
        static let MISSING       = "1"
        static let TYPE_MISMATCH = "2"
        static let MISSING_VALUE = "3"
        static let NO_INT        = "4"
        static let NO_BOOL       = "5"
    }

}

enum ArgumentType: String {
    case `int`  = "int"
    case string = "String"
}
