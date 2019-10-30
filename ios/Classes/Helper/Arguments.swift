//
//  Arguments.swift
//  delta_chat_core
//
//  Created by Cihan Oezkan on 12.08.19.
//

import Foundation

struct Argument {

    static let ID                = "id"
    static let TYPE              = "type"
    static let KEY               = "key"
    static let VALUE             = "value"
    static let ADDRESS           = "address"
    static let CACHE_ID          = "cacheId"
    static let VERIFIED          = "verified"
    static let NAME              = "name"
    static let INDEX             = "index"
    static let FLAGS             = "flags"
    static let QUERY             = "query"
    static let ADDRESS_BOOK      = "addressBook"
    static let CONTACT_ID        = "contactId"
    static let CHAT_ID           = "chatId"
    static let PATH              = "path"
    static let TEXT              = "text"
    static let COUNT             = "count"
    static let MESSAGE_IDS       = "messageIds"
    static let SETUP_CODE        = "setupCode"
    static let QR_TEXT           = "qrText"
    static let ADD               = "add"
    static let EVENT_ID          = "eventId"
    static let DB_NAME           = "dbName"
    static let UID               = "uid"
    static let JSON              = "json"
    static let ENABLE            = "enable"
    static let MODE              = "mode"
    static let MESSAGE           = "message"
    static let MIME_TYPE         = "mimeType"

    struct Error {
        static let MISSING       = "1"
        static let TYPE_MISMATCH = "2"
        static let MISSING_VALUE = "3"
        static let NO_INT        = "4"
        static let NO_BOOL       = "5"
    }

}

enum ArgumentType: String {
    case `int` = "int"
    case string = "String"
}
