//
//  Method.swift
//  delta_chat_core
//
//  Created by Cihan Oezkan on 12.08.19.
//

import Foundation


struct Method {}

extension Method {

    struct Prefix {
        static let SEPERATOR: Character           = "_"
        static let BASE                           = "base"
        static let CHAT                           = "chat"
        static let CHAT_LIST                      = "chatList"
        static let CONTACT                        = "contact"
        static let CONTEXT                        = "context"
        static let LOT                            = "lot"
        static let MEDIA                          = "media"
        static let MSG                            = "msg"
    }

}

extension Method {
    
    struct Base {
        static let INIT                           = "base_init"
        static let SYSTEM_INFO                    = "base_systemInfo"
        static let CORE_LISTENER                  = "base_coreListener"
        static let SET_CORE_STRINGS               = "base_setCoreStrings"
    }

}

extension Method {
    
    struct Chat {
        static let GET_ID                         = "chat_getId"
        static let IS_GROUP                       = "chat_isGroup"
        static let GET_ARCHIVED                   = "chat_getArchived"
        static let GET_COLOR                      = "chat_getColor"
        static let GET_NAME                       = "chat_getName"
        static let GET_SUBTITLE                   = "chat_getSubtitle"
        static let GET_PROFILE_IMAGE              = "chat_getProfileImage"
        static let IS_UNPROMOTED                  = "chat_isUnpromoted"
        static let IS_SELF_TALK                   = "chat_isSelfTalk"
        static let IS_VERIFIED                    = "chat_isVerified"
    }

}

extension Method {
    
    struct ChatList {
        static let INTERNAL_SETUP                 = "chatList_internal_setup"
        static let INTERNAL_TEAR_DOWN             = "chatList_internal_tearDown"
        static let GET_CNT                        = "chatList_getCnt"
        static let GET_ID                         = "chatList_getId"
        static let GET_CHAT                       = "chatList_getChat"
        static let GET_MSG_ID                     = "chatList_getMsgId"
        static let GET_MSG                        = "chatList_getMag"
        static let GET_SUMMARY                    = "chatList_getSummary"
    }

}

extension Method {
    
    struct Contact {
        static let GET_ID                         = "contact_getId"
        static let GET_NAME                       = "contact_getName"
        static let GET_DISPLAY_NAME               = "contact_getDisplayName"
        static let GET_FIRST_NAME                 = "contact_getFirstName"
        static let GET_ADDRESS                    = "contact_getAddress"
        static let GET_NAME_AND_ADDRESS           = "contact_getNameAndAddress"
        static let GET_PROFILE_IMAGE              = "contact_getProfileImage"
        static let GET_COLOR                      = "contact_getColor"
        static let IS_BLOCKED                     = "contact_isBlocked"
        static let IS_VERIFIED                    = "contact_isVerified"
    }

}

extension Method {
    
    struct Message {
        static let GET_ID                         = "msg_getId"
        static let GET_TEXT                       = "msg_getText"
        static let GET_TIMESTAMP                  = "msg_getTimestamp"
        static let GET_TYPE                       = "msg_getType"
        static let GET_STATE                      = "msg_getState"
        static let GET_CHAT_ID                    = "msg_getChatId"
        static let GET_FROM_ID                    = "msg_getFromId"
        static let GET_WIDTH                      = "msg_getWidth"
        static let GET_HEIGHT                     = "msg_getHeight"
        static let GET_DURATION                   = "msg_getDuration"
        static let LATE_FILING_MEDIA_SIZE         = "msg_lateFilingMediaSize"
        static let GET_SUMMARY                    = "msg_getSummary"
        static let GET_SUMMARY_TEXT               = "msg_getSummaryText"
        static let SHOW_PADLOCK                   = "msg_showPadlock"
        static let HAS_FILE                       = "msg_hasFile"
        static let GET_FILE                       = "msg_getFile"
        static let GET_FILE_MIME                  = "msg_getFileMime"
        static let GET_FILENAME                   = "msg_getFilename"
        static let GET_FILE_BYTES                 = "msg_getFileBytes"
        static let IS_FORWARDED                   = "msg_isForwarded"
        static let IS_INFO                        = "msg_isInfo"
        static let IS_SETUP_MESSAGE               = "msg_isSetupMessage"
        static let GET_SETUP_CODE_BEGIN           = "msg_getSetupCodeBegin"
        static let IS_INCREATION                  = "msg_isInCreation"
        static let SET_TEXT                       = "msg_setText"
        static let SET_FILE                       = "msg_setFile"
        static let SET_DIMENSION                  = "msg_setDimension"
        static let SET_DURATION                   = "msg_setDuration"
        static let IS_OUTGOING                    = "msg_isOutgoing"
        static let IS_STARRED                     = "msg_isStarred"
    }

}

extension Method {
    
    struct Context {
        static let CONFIG_SET                     = "context_configSet"
        static let CONFIG_GET                     = "context_configGet"
        static let CONFIG_GET_INT                 = "context_configGetInt"
        static let CONFIGURE                      = "context_configure"
        static let IS_CONFIGURED                  = "context_isConfigured"
        static let ADD_ADDRESS_BOOK               = "context_addAddressBook"
        static let CREATE_CONTACT                 = "context_createContact"
        static let DELETE_CONTACT                 = "context_deleteContact"
        static let BLOCK_CONTACT                  = "context_blockContact"
        static let UNBLOCK_CONTACT                = "context_unblockContact"
        static let GET_BLOCKED_CONTACTS           = "context_getBlockedContacts"
        static let CREATE_CHAT_BY_CONTACT_ID      = "context_createChatByContactId"
        static let CREATE_CHAT_BY_MESSAGE_ID      = "context_createChatByMessageId"
        static let CREATE_GROUP_CHAT              = "context_createGroupChat"
        static let GET_CONTACT                    = "context_getContact"
        static let GET_CONTACTS                   = "context_getContacts"
        static let GET_CHAT_CONTACTS              = "context_getChatContacts"
        static let GET_CHAT                       = "context_getChat"
        static let GET_CHAT_MESSAGES              = "context_getChatMessages"
        static let CREATE_CHAT_MESSAGE            = "context_createChatMessage"
        static let CREATE_CHAT_ATTACHMENT_MESSAGE = "context_createChatAttachmentMessage"
        static let ADD_CONTACT_TO_CHAT            = "context_addContactToChat"
        static let GET_CHAT_BY_CONTACT_ID         = "context_getChatByContactId"
        static let GET_FRESH_MESSAGE_COUNT        = "context_getFreshMessageCount"
        static let MARK_NOTICED_CHAT              = "context_markNoticedChat"
        static let DELETE_CHAT                    = "context_deleteChat"
        static let REMOVE_CONTACT_FROM_CHAT       = "context_removeContactFromChat"
        static let IMPORT_KEYS                    = "context_importKeys"
        static let EXPORT_KEYS                    = "context_exportKeys"
        static let GET_FRESH_MESSAGES             = "context_getFreshMessages"
        static let FORWARD_MESSAGES               = "context_forwardMessages"
        static let INITIATE_KEY_TRANSFER          = "context_initiateKeyTransfer"
        static let CONTINUE_KEY_TRANSFER          = "context_continueKeyTransfer"
        static let MARK_SEEN_MESSAGES             = "context_markSeenMessages"
        static let GET_SECUREJOIN_QR              = "context_getSecurejoinQr"
        static let JOIN_SECUREJOIN                = "context_joinSecurejoin"
        static let CHECK_QR                       = "context_checkQr"
        static let STOP_ONGOING_PROCESS           = "context_stopOngoingProcess"
        static let DELETE_MESSAGES                = "context_deleteMessages"
        static let STAR_MESSAGES                  = "context_starMessages"
        static let SET_CHAT_NAME                  = "context_setChatName"
        static let SET_CHAT_PROFILE_IMAGE         = "context_setChatProfileImage"
        static let GET_SHARED_DATA                = "context_getSharedData"
        static let IS_COI_SUPPORTED               = "context_isCoiSupported"
        static let IS_COI_ENABLED                 = "context_isCoiEnabled"
        static let IS_WEB_PUSH_SUPPORTED          = "context_isWebPushSupported"
        static let GET_WEB_PUSH_VAPID_KEY         = "context_getWebPushVapidKey"
        static let SUBSCRIBE_WEB_PUSH             = "context_subscribeWebPush"
        static let VALIDATE_WEB_PUSH              = "context_validateWebPush"
        static let GET_WEB_PUSH_SUBSCRIPTION      = "context_getWebPushSubscription"
        static let SET_COI_ENABLED                = "context_setCoiEnabled"
        static let SET_COI_MESSAGE_FILTER         = "context_setCoiMessageFilter"
    }

}

extension Method {
    
    struct Error {
        static func missingArgument(result: FlutterResult) {
            result(FlutterError(code: Argument.Error.MISSING, message: "Argument is missing", details: nil))
        }
        
        static func missingArgumentValue(result: FlutterResult) {
            result(FlutterError(code: Argument.Error.MISSING_VALUE, message: "Argument value is missing or null", details: nil))
        }

        static func typeMismatch(for argument: String, result: FlutterResult) {
            result(FlutterError(code: Argument.Error.TYPE_MISMATCH, message: "Wrong type for argument " + argument, details: nil))
        }
        
        static func noInt(for argument: String, result: FlutterResult) {
            result(FlutterError(code: Argument.Error.NO_INT, message: "Argument is no integer: " + argument, details: nil))
        }
        
        static func generic(methodCall: FlutterMethodCall, result: FlutterResult) {
            result(FlutterError(code: methodCall.method, message: nil, details: nil));
        }
    }

}
