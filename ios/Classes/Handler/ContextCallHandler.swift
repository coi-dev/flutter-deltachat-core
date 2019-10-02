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

class ContextCallHandler: MethodCallHandling {

    fileprivate let context: DcContext!
    fileprivate let contactCache: Cache<DcContact>!
    fileprivate let messageCache: Cache<DcMsg>!
    fileprivate let chatCache: Cache<DcChat>!
    
    init(context: DcContext, contactCache: Cache<DcContact>, messageCache: Cache<DcMsg>, chatCache: Cache<DcChat>) {
        self.context = context
        self.contactCache = contactCache
        self.messageCache = messageCache
        self.chatCache = chatCache
    }

    // MARK: - Protocol MethodCallHandling

    func handle(_ call: FlutterMethodCall, result: FlutterResult) {
        switch (call.method) {
        case Method.Context.CONFIG_SET:
            setConfig(methodCall: call, result: result)
            break
        case Method.Context.CONFIG_GET:
            getConfig(methodCall: call, result: result, type: ArgumentType.STRING)
            break
        case Method.Context.CONFIG_GET_INT:
            getConfig(methodCall: call, result: result, type: ArgumentType.INT)
            break
        case Method.Context.CONFIGURE:
            configure(result: result)
            break
        case Method.Context.IS_CONFIGURED:
            result(DcConfig.isConfigured)
            break
        case Method.Context.ADD_ADDRESS_BOOK:
            addAddressBook(methodCall: call, result: result)
            break
        case Method.Context.CREATE_CONTACT:
            createContact(methodCall: call, result: result)
            break
        case Method.Context.DELETE_CONTACT:
            deleteContact(methodCall: call, result: result)
            break
        case Method.Context.BLOCK_CONTACT:
            blockContact(methodCall: call, result: result)
            break
        case Method.Context.UNBLOCK_CONTACT:
            unblockContact(methodCall: call, result: result)
            break
        case Method.Context.CREATE_CHAT_BY_CONTACT_ID:
            createChatByContactId(methodCall: call, result: result)
            break
        case Method.Context.CREATE_CHAT_BY_MESSAGE_ID:
            createChatByMessageId(methodCall: call, result: result)
            break
        case Method.Context.CREATE_GROUP_CHAT:
            createGroupChat(methodCall: call, result: result)
            break
        case Method.Context.GET_CONTACT:
            getContact(methodCall: call, result: result)
            break
        case Method.Context.GET_CONTACTS:
            getContacts(methodCall: call, result: result)
            break
        case Method.Context.GET_CHAT_CONTACTS:
            getChatContacts(methodCall: call, result: result)
            break
        case Method.Context.GET_CHAT:
            getChat(methodCall: call, result: result)
            break
        case Method.Context.GET_CHAT_MESSAGES:
            getChatMessages(methodCall: call, result: result)
            break
        case Method.Context.CREATE_CHAT_MESSAGE:
            createChatMessage(methodCall: call, result: result)
            break
        case Method.Context.CREATE_CHAT_ATTACHMENT_MESSAGE:
            createChatAttachmentMessage(methodCall: call, result: result)
            break
        case Method.Context.ADD_CONTACT_TO_CHAT:
            addContactToChat(methodCall: call, result: result)
            break
        case Method.Context.GET_CHAT_BY_CONTACT_ID:
            getChatByContactId(methodCall: call, result: result)
            break
        case Method.Context.GET_BLOCKED_CONTACTS:
            getBlockedContacts(result: result)
            break
        case Method.Context.GET_FRESH_MESSAGE_COUNT:
            getFreshMessageCount(methodCall: call, result: result)
            break
        case Method.Context.MARK_NOTICED_CHAT:
            markNoticedChat(methodCall: call, result: result)
            break
        case Method.Context.DELETE_CHAT:
            deleteChat(methodCall: call, result: result)
            break
        case Method.Context.REMOVE_CONTACT_FROM_CHAT:
            removeContactFromChat(methodCall: call, result: result)
            break
        case Method.Context.EXPORT_KEYS:
            //exportImportKeys(methodCall, result, DcContext.DC_IMEX_EXPORT_SELF_KEYS)
            break
        case Method.Context.IMPORT_KEYS:
            //exportImportKeys(methodCall, result, DcContext.DC_IMEX_IMPORT_SELF_KEYS)
            break
        case Method.Context.GET_FRESH_MESSAGES:
            getFreshMessages(result: result)
            break
        case Method.Context.FORWARD_MESSAGES:
            forwardMessages(methodCall: call, result: result)
            break
        case Method.Context.MARK_SEEN_MESSAGES:
            markSeenMessages(methodCall: call, result: result)
            break
        case Method.Context.INITIATE_KEY_TRANSFER:
            initiateKeyTransfer(result: result)
            break
        case Method.Context.CONTINUE_KEY_TRANSFER:
            continueKeyTransfer(methodCall: call, result: result)
        case Method.Context.GET_SECUREJOIN_QR:
            getSecurejoinQr(methodCall: call, result: result)
            break
        case Method.Context.JOIN_SECUREJOIN:
            joinSecurejoin(methodCall: call, result: result)
            break
        case Method.Context.CHECK_QR:
            checkQr(methodCall: call, result: result)
            break
        case Method.Context.STOP_ONGOING_PROCESS:
            dc_stop_ongoing_process(DcContext.contextPointer)
            result(nil)
            break
        case Method.Context.DELETE_MESSAGES:
            deleteMessages(methodCall: call, result: result)
        case Method.Context.STAR_MESSAGES:
            starMessages(methodCall: call, result: result)
            break
        case Method.Context.SET_CHAT_NAME:
            setChatName(methodCall: call, result: result)
            break
        case Method.Context.SET_CHAT_PROFILE_IMAGE:
            setChatProfileImage(methodCall: call, result: result)
            break
        case Method.Context.IS_COI_SUPPORTED:
            isCoiSupported(result: result)
            break
        case Method.Context.IS_COI_ENABLED:
            isCoiEnabled(result: result)
            break
        case Method.Context.IS_WEB_PUSH_SUPPORTED:
            isWebPushSupported(result: result)
            break
        case Method.Context.GET_WEB_PUSH_VAPID_KEY:
            getWebPushVapidKey(result: result)
            break
        case Method.Context.SUBSCRIBE_WEB_PUSH:
            subscribeWebPush(methodCall: call, result: result)
            break
        case Method.Context.GET_WEB_PUSH_SUBSCRIPTION:
            getWebPushSubscription(methodCall: call, result: result)
            break
        case Method.Context.SET_COI_ENABLED:
            setCoiEnabled(methodCall: call, result: result)
            break
        case Method.Context.SET_COI_MESSAGE_FILTER:
            setCoiMessageFilter(methodCall: call, result: result)
            break
        case Method.Context.VALIDATE_WEB_PUSH:
            validateWebPush(methodCall: call, result: result)
            break
        default:
            log.error("Context: Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Configuration
    
    fileprivate func setConfig(methodCall: FlutterMethodCall, result: FlutterResult) {
        let parameters = methodCall.parameters
        
        if let key = parameters["key"] as? String,
            let configKey = DcConfigKey(rawValue: key) {
            let value = parameters["value"] as? String
            
            let dc_result = DcConfig.set(key: configKey, value: value)
            result(NSNumber(value: dc_result))
        }
        else {
            result("iOS could not extract flutter arguments in method: (sendParams)")
        }
    }
    
    fileprivate func getConfig(methodCall: FlutterMethodCall, result: FlutterResult, type: String) {
        let parameters = methodCall.parameters
        
        if let key = parameters["key"] as? String {
            
            switch (type) {
            case ArgumentType.STRING:
                let value = dc_get_config(DcContext.contextPointer, key)
                if let pSafe = value {
                    let c = String(cString: pSafe)
                    if c.isEmpty {
                        result(nil)
                    }
                    result(c)
                }
                break
                
            case ArgumentType.INT:
                let value = dc_get_config(DcContext.contextPointer, key)
                if let pSafe = value {
                    let c = Int(bitPattern: pSafe)
                    
                    result(c)
                }
                break
                
            default: break
            }
            
        } else {
            result("iOS could not extract flutter arguments in method: (sendParams)")
        }
    }
    
    fileprivate func configure(result: FlutterResult) {
        dc_configure(DcContext.contextPointer)

        result(nil)
    }
    
    // MARK: - Addressbook & Contacts
    
    fileprivate func addAddressBook(methodCall: FlutterMethodCall, result: FlutterResult) {
        if !methodCall.contains(keys: [Argument.ADDRESS_BOOK]) {
            Method.Error.missingArgument(result: result);
            return
        }
        
        let parameters = methodCall.parameters
        
        if let addressBook = parameters[Argument.ADDRESS_BOOK] as? String {
            let dc_result = dc_add_address_book(DcContext.contextPointer, addressBook)
            result(dc_result)
        }
        else {
            Method.Error.missingArgumentValue(for: Argument.ADDRESS_BOOK, result: result)
            return
        }
        
    }
    
    fileprivate func createContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let name = methodCall.stringValue(for: Argument.NAME, result: result),
            let emailAddress = methodCall.stringValue(for: Argument.ADDRESS, result: result) else {
                Method.Error.missingArgument(result: result)
                return
        }
        let contactId = context.createContact(name: name, emailAddress: emailAddress)
        
        result(NSNumber(value: contactId))
    }
    
    fileprivate func deleteContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contactId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        let deleted = context.deleteContact(contactId: contactId)
        
        result(NSNumber(value: deleted))
    }
    
    fileprivate func blockContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contactId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        context.blockContact(contactId: contactId, block: true)

        result(nil)
    }
    
    fileprivate func unblockContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contactId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        context.blockContact(contactId: contactId, block: false)

        result(nil)
    }

    fileprivate func getBlockedContacts(result: FlutterResult) {
        let blockedIds = context.getBlockedContacts()
        let buffer = blockedIds.withUnsafeBufferPointer { Data(buffer: $0) }
        
        result(FlutterStandardTypedData(int32: buffer))
    }
    
    fileprivate func getContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.Error.missingArgument(result: result)
            return
        }
        if let myArgs = args as? [String: Any], let id = myArgs[Argument.ID] as? UInt32 {
            result(dc_array_get_contact_id(DcContext.contextPointer, Int(id)))
        }
        
    }
    
    fileprivate func getContacts(methodCall: FlutterMethodCall, result: FlutterResult) {
        let flags = methodCall.intValue(for: Argument.FLAGS, result: result)
        let query = methodCall.stringValue(for: Argument.QUERY, result: result)

        let contactIds = context.getContacts(flags: Int32(flags), query: query)
        let buffer = contactIds.withUnsafeBufferPointer { Data(buffer: $0) }

        result(FlutterStandardTypedData(int32: buffer))
    }
    
    fileprivate func getChatContacts(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = methodCall.intValue(for: Argument.CHAT_ID, result: result)
        let contactIds = context.getChatContacts(for: chatId)
        let buffer = contactIds.withUnsafeBufferPointer { Data(buffer: $0) }

        result(FlutterStandardTypedData(int32: buffer))
    }

    // MARK: - Chat Related
    
    fileprivate func createChatByContactId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contactId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        let chat = context.createChatByContactId(contactId: contactId)
        
        result(NSNumber(value: chat.id))
    }
    
    fileprivate func createChatByMessageId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let messageId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        let chat = context.createChatByMessageId(messageId: messageId)
        
        result(NSNumber(value: chat.id))
    }
    
    fileprivate func createGroupChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.VERIFIED, Argument.NAME]) {
            Method.Error.missingArgument(result: result)
            return
        }
        
        if let myArgs = args as? [String: Any] {
            let verified = myArgs[Argument.VERIFIED] as? Bool
            if (verified == nil) {
                Method.Error.missingArgument(result: result)
                return
            }
            
            let name = myArgs[Argument.NAME] as? String
            let chatId = dc_create_group_chat(DcContext.contextPointer, Int32(truncating: verified! as NSNumber), name)
            
            result(chatId)
        }
    }
    
    fileprivate func addContactToChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.CONTACT_ID]) {
            Method.Error.missingArgument(result: result)
            return
        }
        
        if let myArgs = args as? [String: Any] {
            let chatId = myArgs[Argument.CHAT_ID] as? UInt32
            let contactId = myArgs[Argument.CONTACT_ID] as? UInt32
            
            if (chatId == nil || contactId == nil) {
                Method.Error.missingArgument(result: result)
                return
            }
            
            let successfullyAdded = dc_add_contact_to_chat(DcContext.contextPointer, chatId!, contactId!)
            
            result(successfullyAdded)
        }
        
    }
    
    fileprivate func getChatByContactId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contactId = UInt32(methodCall.intValue(for: Argument.CONTACT_ID, result: result))
        guard let chat = context.getChatByContactId(contactId: contactId) else {
            result(NSNull())
            return
        }
        result(NSNumber(value: chat.id))
    }
    
    fileprivate func getChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        let id = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        let chat = context.getChat(with: id)
        
        result(NSNumber(value: chat.id))
    }
    
    fileprivate func getChatMessages(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = methodCall.intValue(for: Argument.CHAT_ID, result: result)
        let flags = methodCall.intValue(for: Argument.FLAGS, result: result)
        
        let messageIds = context.getMessageIds(for: UInt32(chatId), flags: UInt32(flags), marker1before: 0).map { Int32($0) }
        let buffer = messageIds.withUnsafeBufferPointer { Data(buffer: $0) }

        for id: Int32 in messageIds {
            if id != DC_MSG_ID_MARKER1 && id != DC_MSG_ID_DAYMARKER {
                guard nil != messageCache.value(for: UInt32(id)) else {
                    let message = context.getMsg(with: UInt32(id))
                    messageCache.set(value: message, for: UInt32(id))
                    continue
                }
            }
        }

        result(FlutterStandardTypedData(int32: buffer))
    }
    
    fileprivate func createChatMessage(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        guard let text = methodCall.stringValue(for: Argument.TEXT, result: result) else {
            Method.Error.missingArgument(result: result);
            return
        }
        let messageId = context.sendText(text, forChatId: chatId)
        
        result(NSNumber(value: messageId))
    }
    
    fileprivate func createChatAttachmentMessage(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = methodCall.intValue(for: Argument.CHAT_ID, result: result)
        let type = methodCall.intValue(for: Argument.TYPE, result: result)
        let text = methodCall.stringValue(for: Argument.TEXT, result: result)

        guard let path = methodCall.stringValue(for: Argument.PATH, result: result) else {
            Method.Error.missingArgumentValue(for: Argument.PATH, result: result)
            return
        }

        do {
            let messageId = try context.sendAttachment(fromPath: path, withType: type, text: text, forChatId: UInt32(chatId))
            result(NSNumber(value: messageId))
            
        } catch DcContextError.ErrorKind.missingImageAtPath(let path) {
            log.error("Can't find image at given path: \(path)")
        } catch DcContextError.ErrorKind.wrongAttachmentType(let type) {
            log.error("Wrong attachment type given: \(type)!")
        } catch {
            log.error("Unhandled error: \(error)")
        }
    }
    
    fileprivate func markNoticedChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID]) {
            Method.Error.missingArgument(result: result)
            return
        }
        
        if let myArgs = args as? [String: Any] {
            let chatId = myArgs[Argument.CHAT_ID] as? UInt32
            
            if chatId == nil {
                Method.Error.missingArgument(result: result)
                return
            }
            
            dc_marknoticed_chat(DcContext.contextPointer, chatId!)
            result(nil)
        }
        
    }
    
    fileprivate func deleteChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        context.deleteChat(chatId: chatId)
        
        result(nil)
    }
    
    fileprivate func removeContactFromChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.CONTACT_ID]) {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any], let chatId = myArgs[Argument.CHAT_ID], let contactId = myArgs[Argument.CONTACT_ID] {
            result(dc_remove_contact_from_chat(DcContext.contextPointer, chatId as! UInt32, contactId as! UInt32))
        }
        else {
            Method.Error.missingArgument(result: result);
        }
        
    }
    
    fileprivate func setChatProfileImage(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.VALUE]) {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let chatId = myArgs[Argument.CHAT_ID],
            let value = myArgs[Argument.VALUE] {
            
            dc_set_chat_profile_image(DcContext.contextPointer, chatId as! UInt32, value as? UnsafePointer<Int8>)
            result(nil)
        }
        else {
            Method.Error.missingArgument(result: result)
            return
        }
        
    }
    
    fileprivate func setChatName(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.VALUE]) {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let chatId = myArgs[Argument.CHAT_ID],
            let value = myArgs[Argument.VALUE] {
            
            dc_set_chat_name(DcContext.contextPointer, chatId as! UInt32, value as? UnsafePointer<Int8>)
            result(nil)
        }
        else {
            Method.Error.missingArgument(result: result)
            return
        }
        
    }

    // MARK: - Message Related
    
    fileprivate func getFreshMessageCount(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = methodCall.intValue(for: Argument.CHAT_ID, result: result)
        let messageCount = context.getFreshMessageCount(for: UInt32(chatId))

        result(NSNumber(value: messageCount))
    }
    
    fileprivate func getFreshMessages(result: FlutterResult) {
        let freshMessages = context.getFreshMessageIds()
        let buffer = freshMessages.withUnsafeBufferPointer { Data(buffer: $0) }

        result(FlutterStandardTypedData(int32: buffer))
    }
    
    fileprivate func forwardMessages(methodCall: FlutterMethodCall, result: FlutterResult){
        guard let args = methodCall.arguments else {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.MESSAGE_IDS]) {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any], let chatId = myArgs[Argument.CHAT_ID], let msgIdArray = myArgs[Argument.MESSAGE_IDS] {
            
            result(dc_forward_msgs(DcContext.contextPointer, msgIdArray as? UnsafePointer<UInt32>, Int32((msgIdArray as AnyObject).count), chatId as! UInt32))
        }
        else {
            Method.Error.missingArgument(result: result);
        }
        
    }
    
    fileprivate func markSeenMessages(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let msgIds = methodCall.value(for: Argument.MESSAGE_IDS, result: result) as? [UInt32] else {
            Method.Error.generic(methodCall: methodCall, result: result)
            return
        }

        let buffer = msgIds.withUnsafeBufferPointer { Data(buffer: $0) }
        context.markSeenMessages(messageIds: msgIds)

        result(FlutterStandardTypedData(int32: buffer))
    }
    
    fileprivate func deleteMessages(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let msgIds = methodCall.intArrayValue(for: Argument.MESSAGE_IDS, result: result) else {
            result(nil)
            return
        }
        
        context.deleteMessages(messageIds: msgIds)
        result(nil)
    }
    
    fileprivate func starMessages(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let msgIds = methodCall.intArrayValue(for: Argument.MESSAGE_IDS, result: result) else {
            result(nil)
            return
        }
        
        let star = methodCall.intValue(for: Argument.VALUE, result: result)
        context.starMessages(messageIds: msgIds, star: star)
        
        result(nil)
    }

    // MARK: - Secure Stuff
    
    fileprivate func initiateKeyTransfer(result: FlutterResult) {
        //    new Thread(() -> {
        //    String setupKey = dcContext.initiateKeyTransfer();
        //    getUiThreadHandler().post(() -> {
        //    result.success(setupKey);
        //    });
        //    }).start();
    }
    
    fileprivate func continueKeyTransfer(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.ID, Argument.SETUP_CODE]) {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let messageId = myArgs[Argument.ID],
            let setupCode = myArgs[Argument.SETUP_CODE] {
            
            result(dc_continue_key_transfer(DcContext.contextPointer, messageId as! UInt32, setupCode as? UnsafePointer<Int8>))
        }
        else {
            Method.Error.missingArgument(result: result);
        }
        
    }
    
    fileprivate func getSecurejoinQr(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        
        result(context.getSecurejoinQr(chatId: chatId))
    }
    
    fileprivate func  joinSecurejoin(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.QR_TEXT]) {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let qrText = myArgs[Argument.QR_TEXT] {
            //            new Thread(() -> {
            //                int chatId = dcContext.joinSecurejoin(qrText);
            //                getUiThreadHandler().post(() -> {
            //                    result.success(chatId);
            //                    });
            //                }).start();
        }
        else {
            Method.Error.missingArgument(result: result);
        }
        
    }
    
    fileprivate func checkQr(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.QR_TEXT]) {
            Method.Error.missingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let qrText = myArgs[Argument.QR_TEXT] {
            //            DcLot qrCode = dcContext.checkQr(qrText);
            //            result.success(mapLotToList(qrCode));
        }
        else {
            Method.Error.missingArgument(result: result);
        }
        
    }
    
    // MARK: - Cache Handling
    
    func loadAndCacheChat(with id: UInt32) -> DcChat {
        guard let chat = chatCache.value(for: id) else {
            let chat = self.context.getChat(with: id)
            _ = self.chatCache.add(object: chat)
            return chat
        }
        return chat
    }
    
    func loadAndCacheContact(with id: UInt32) -> DcContact {
        guard let contact = contactCache.value(for: id) else {
            let contact = self.context.getContact(with: id)
            _ = self.contactCache.add(object: contact)
            return contact
        }
        return contact
    }
    
    func loadAndCacheChatMessage(with id: UInt32) -> DcMsg {
        guard let msg = messageCache.value(for: id) else {
            let msg = self.context.getMsg(with: id)
            _ = self.messageCache.add(object: msg)
            return msg
        }
        return msg
    }
    
    // MARK: - Coi Related
    
    fileprivate func isCoiSupported(result: FlutterResult) {
        result(NSNumber(value: context.isCoiSupported()))
    }
    
    fileprivate func isCoiEnabled(result: FlutterResult) {
        result(NSNumber(value: context.isCoiEnabled()))
    }
    
    fileprivate func setCoiEnabled(methodCall: FlutterMethodCall, result: FlutterResult) {
        let id = methodCall.intValue(for: Argument.ID, result: result)
        let enable = methodCall.intValue(for: Argument.ENABLE, result: result)
        
        context.setCoiEnabled(enable: enable, id: id)
        result(nil)
    }
    
    fileprivate func setCoiMessageFilter(methodCall: FlutterMethodCall, result: FlutterResult) {
        let id = methodCall.intValue(for: Argument.ID, result: result)
        let mode = methodCall.intValue(for: Argument.MODE, result: result)
        
        context.setCoiMessageFilter(mode: mode, id: id)
        result(nil)
    }

    // MARK: - Webpush Related
    
    fileprivate func isWebPushSupported(result: FlutterResult) {
        result(NSNumber(value: context.isWebPushSupported()))
    }
    
    fileprivate func getWebPushVapidKey(result: FlutterResult) {
        result(context.getWebPushVapidKey() ?? NSNull())
    }
    
    fileprivate func subscribeWebPush(methodCall: FlutterMethodCall, result: FlutterResult) {
        let id = methodCall.intValue(for: Argument.ID, result: result)
        
        guard let uid = methodCall.stringValue(for: Argument.UID, result: result),
            let json = methodCall.stringValue(for: Argument.JSON, result: result) else {
                Method.Error.missingArgument(result: result)
                return
        }
        
        if uid.isEmpty || json.isEmpty {
            Method.Error.missingArgumentValue(for: "[\(Argument.UID), \(Argument.JSON)]", result: result)
            return
        }
        
        context.subscribeWebPush(uid: uid, json: json, id: id)
        result(nil)
    }
    
    fileprivate func getWebPushSubscription(methodCall: FlutterMethodCall, result: FlutterResult) {
        let id = methodCall.intValue(for: Argument.ID, result: result)
        
        guard let uid = methodCall.stringValue(for: Argument.UID, result: result) else {
                Method.Error.missingArgument(result: result)
                return
        }
        
        if uid.isEmpty {
            Method.Error.missingArgumentValue(for: Argument.UID, result: result)
            return
        }
        
        context.getWebPushSubscription(uid: uid, id: id)
        result(nil)
    }
    
    fileprivate func validateWebPush(methodCall: FlutterMethodCall, result: FlutterResult) {
        let id = methodCall.intValue(for: Argument.ID, result: result)
        
        guard let uid = methodCall.stringValue(for: Argument.UID, result: result),
            let message = methodCall.stringValue(for: Argument.MESSAGE, result: result) else {
            Method.Error.missingArgument(result: result)
            return
        }
        
        if uid.isEmpty || message.isEmpty {
            Method.Error.missingArgumentValue(for: "[\(Argument.UID), \(Argument.MESSAGE)]", result: result)
            return
        }
        
        context.validateWebPush(uid: uid, message: message, id: id)
        result(nil)
    }

}
