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
    fileprivate let contactCache: IdCache<DcContact>!
    fileprivate let messageCache: IdCache<DcMsg>!
    fileprivate let chatCache: IdCache<DcChat>!

    init(context: DcContext, contactCache: IdCache<DcContact>, messageCache: IdCache<DcMsg>, chatCache: IdCache<DcChat>) {
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
        case Method.Context.CONFIG_GET:
            getConfig(methodCall: call, result: result, type: .string)
        case Method.Context.CONFIG_GET_INT:
            getConfig(methodCall: call, result: result, type: .int)
        case Method.Context.CONFIGURE:
            configure(result: result)
        case Method.Context.IS_CONFIGURED:
            result(context.isConfigured)
        case Method.Context.ADD_ADDRESS_BOOK:
            addAddressBook(methodCall: call, result: result)
        case Method.Context.CREATE_CONTACT:
            createContact(methodCall: call, result: result)
        case Method.Context.DELETE_CONTACT:
            deleteContact(methodCall: call, result: result)
        case Method.Context.BLOCK_CONTACT:
            blockUnblockContact(methodCall: call, result: result, block: true)
        case Method.Context.UNBLOCK_CONTACT:
            blockUnblockContact(methodCall: call, result: result, block: false)
        case Method.Context.CREATE_CHAT_BY_CONTACT_ID:
            createChatByContactId(methodCall: call, result: result)
        case Method.Context.CREATE_CHAT_BY_MESSAGE_ID:
            createChatByMessageId(methodCall: call, result: result)
        case Method.Context.CREATE_GROUP_CHAT:
            createGroupChat(methodCall: call, result: result)
        case Method.Context.GET_CONTACT:
            getContact(methodCall: call, result: result)
        case Method.Context.GET_CONTACTS:
            getContacts(methodCall: call, result: result)
        case Method.Context.GET_CHAT_CONTACTS:
            getChatContacts(methodCall: call, result: result)
        case Method.Context.GET_CHAT:
            getChat(methodCall: call, result: result)
        case Method.Context.GET_CHAT_MESSAGES:
            getChatMessages(methodCall: call, result: result)
        case Method.Context.CREATE_CHAT_MESSAGE:
            createChatMessage(methodCall: call, result: result)
        case Method.Context.CREATE_CHAT_ATTACHMENT_MESSAGE:
            createChatAttachmentMessage(methodCall: call, result: result)
        case Method.Context.ADD_CONTACT_TO_CHAT:
            addContactToChat(methodCall: call, result: result)
        case Method.Context.GET_CHAT_BY_CONTACT_ID:
            getChatByContactId(methodCall: call, result: result)
        case Method.Context.GET_BLOCKED_CONTACTS:
            getBlockedContacts(result: result)
        case Method.Context.GET_FRESH_MESSAGE_COUNT:
            getFreshMessageCount(methodCall: call, result: result)
        case Method.Context.MARK_NOTICED_CHAT:
            markNoticedChat(methodCall: call, result: result)
        case Method.Context.DELETE_CHAT:
            deleteChat(methodCall: call, result: result)
        case Method.Context.REMOVE_CONTACT_FROM_CHAT:
            removeContactFromChat(methodCall: call, result: result)
        case Method.Context.EXPORT_KEYS:
            exportImportKeys(methodCall: call, result: result, type: DC_IMEX_EXPORT_SELF_KEYS)
        case Method.Context.IMPORT_KEYS:
            exportImportKeys(methodCall: call, result: result, type: DC_IMEX_IMPORT_SELF_KEYS)
        case Method.Context.GET_FRESH_MESSAGES:
            getFreshMessages(result: result)
        case Method.Context.FORWARD_MESSAGES:
            forwardMessages(methodCall: call, result: result)
        case Method.Context.MARK_SEEN_MESSAGES:
            markSeenMessages(methodCall: call, result: result)
        case Method.Context.INITIATE_KEY_TRANSFER:
            initiateKeyTransfer(result: result)
        case Method.Context.CONTINUE_KEY_TRANSFER:
            continueKeyTransfer(methodCall: call, result: result)
        case Method.Context.GET_SECUREJOIN_QR:
            getSecurejoinQr(methodCall: call, result: result)
        case Method.Context.JOIN_SECUREJOIN:
            joinSecurejoin(methodCall: call, result: result)
        case Method.Context.CHECK_QR:
            checkQr(methodCall: call, result: result)
        case Method.Context.STOP_ONGOING_PROCESS:
            stopOngoingProcess(result: result)
        case Method.Context.DELETE_MESSAGES:
            deleteMessages(methodCall: call, result: result)
        case Method.Context.STAR_MESSAGES:
            starMessages(methodCall: call, result: result)
        case Method.Context.SET_CHAT_NAME:
            setChatName(methodCall: call, result: result)
        case Method.Context.SET_CHAT_PROFILE_IMAGE:
            setChatProfileImage(methodCall: call, result: result)
        case Method.Context.INTERRUPT_IDLE_FOR_INCOMING_MESSAGES:
            interruptIdleForIncomingMessages(result: result)
        case Method.Context.IS_COI_SUPPORTED:
            isCoiSupported(result: result)
        case Method.Context.IS_COI_ENABLED:
            isCoiEnabled(result: result)
        case Method.Context.IS_WEB_PUSH_SUPPORTED:
            isWebPushSupported(result: result)
        case Method.Context.GET_WEB_PUSH_VAPID_KEY:
            getWebPushVapidKey(result: result)
        case Method.Context.SUBSCRIBE_WEB_PUSH:
            subscribeWebPush(methodCall: call, result: result)
        case Method.Context.GET_WEB_PUSH_SUBSCRIPTION:
            getWebPushSubscription(methodCall: call, result: result)
        case Method.Context.SET_COI_ENABLED:
            setCoiEnabled(methodCall: call, result: result)
        case Method.Context.SET_COI_MESSAGE_FILTER:
            setCoiMessageFilter(methodCall: call, result: result)
        case Method.Context.VALIDATE_WEB_PUSH:
            validateWebPush(methodCall: call, result: result)
        case Method.Context.GET_MESSAGE_INFO:
            getMessageInfo(methodCall: call, result: result)
        case Method.Context.RETRY_SENDING_PENDING_MESSAGES:
            retrySendingPendingMessages(result: result)
        case Method.Context.GET_CONTACT_ID_BY_ADDRESS:
            getContactIdByAddress(methodCall: call, result: result)
        default:
            log.error("Context: Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Configuration

    fileprivate func setConfig(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let key = methodCall.stringValue(for: Argument.KEY, result: result),
            let type = methodCall.stringValue(for: Argument.TYPE, result: result),
            let argumentType = ArgumentType(rawValue: type) else {
                Method.Error.missingArgument(result: result)
                return
        }

        var configured: Int32 = 0
        switch argumentType {
            case .int:
                let value = methodCall.intValue(for: Argument.VALUE, result: result)
                configured = context.setConfigInt(value: value, forKey: key)

            case .string:
                if let value = methodCall.stringValue(for: Argument.VALUE, result: result) {
                    configured = context.setConfig(value: value, forKey: key)
                }
        }

        result(NSNumber(value: configured))
    }

    fileprivate func getConfig(methodCall: FlutterMethodCall, result: FlutterResult, type: ArgumentType) {
        guard let key = methodCall.stringValue(for: Argument.KEY, result: result) else {
            Method.Error.missingArgument(result: result)
            return
        }

        switch type {
            case .int:
                result(context.getConfigInt(for: key))

            case .string:
                result(context.getConfig(for: key))
        }
    }

    fileprivate func configure(result: FlutterResult) {
        context.configure()
        result(nil)
    }

    // MARK: - Addressbook & Contacts

    fileprivate func addAddressBook(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let addressBook = methodCall.stringValue(for: Argument.ADDRESS_BOOK, result: result) else {
            Method.Error.missingArgumentValue(for: Argument.ADDRESS_BOOK, result: result)
            return
        }

        let numberOfContacts = context.addAddressBook(addressBook: addressBook)
        result(NSNumber(value: numberOfContacts))
    }

    fileprivate func createContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let name = methodCall.stringValue(for: Argument.NAME, result: result),
            let emailAddress = methodCall.stringValue(for: Argument.ADDRESS, result: result) else {
                Method.Error.missingArgument(result: result)
                return
        }

        let contactId = context.createContact(name: name, emailAddress: emailAddress)
        contactCache.set(value: context.getContact(with: contactId), for: contactId)

        result(NSNumber(value: contactId))
    }

    fileprivate func deleteContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contactId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        let deleted = context.deleteContact(contactId: contactId)
        _ = contactCache.removeValue(for: contactId)

        result(NSNumber(value: deleted))
    }

    fileprivate func blockUnblockContact(methodCall: FlutterMethodCall, result: FlutterResult, block: Bool) {
        let contactId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        context.blockContact(contactId: contactId, block: block)

        result(nil)
    }

    fileprivate func getBlockedContacts(result: FlutterResult) {
        let blockedIds = context.getBlockedContacts()
        let buffer = blockedIds.withUnsafeBufferPointer { Data(buffer: $0) }

        result(FlutterStandardTypedData(int32: buffer))
    }

    fileprivate func getContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contactId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        let contact = context.getContact(with: contactId)

        result(NSNumber(value: contact.id))
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
    
    fileprivate func getContactIdByAddress(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let address = methodCall.stringValue(for: Argument.ADDRESS, result: result) else {
            Method.Error.missingArgumentValue(for: Argument.ADDRESS, result: result)
            return
        }
        let contactID = context.lookupContactIdByAddr(addr: address)
        
        result(contactID)
    }

    // MARK: - Chat Related

    fileprivate func createChatByContactId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contactId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        let chat = context.createChatByContactId(contactId: contactId)

        chatCache.set(value: chat, for: chat.id)

        result(NSNumber(value: chat.id))
    }

    fileprivate func createChatByMessageId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let messageId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        let chat = context.createChatByMessageId(messageId: messageId)

        chatCache.set(value: chat, for: chat.id)

        result(NSNumber(value: chat.id))
    }

    fileprivate func createGroupChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let chatName = methodCall.stringValue(for: Argument.NAME, result: result) else {
            Method.Error.missingArgumentValue(for: Argument.NAME, result: result)
            result(nil)
            return
        }

        let isVerified = methodCall.boolValue(for: Argument.VERIFIED, result: result)
        let chatId = context.createGroupChat(with: chatName, isVerified: isVerified)

        chatCache.set(value: context.getChat(with: chatId), for: chatId)

        result(NSNumber(value: chatId))
    }

    fileprivate func addContactToChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        let contactId = UInt32(methodCall.intValue(for: Argument.CONTACT_ID, result: result))

        let added = context.addContact(with: contactId, toChat: chatId)

        result(NSNumber(value: added))
    }

    fileprivate func getChatByContactId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let contactId = UInt32(methodCall.intValue(for: Argument.CONTACT_ID, result: result))
        let chatId = context.getChatByContactId(contactId: contactId)

        result(NSNumber(value: chatId))
    }

    fileprivate func getChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        let id = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        let chat = context.getChat(with: id)

        result(NSNumber(value: chat.id))
    }

    fileprivate func getChatMessages(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        let flags = UInt32(methodCall.intValue(for: Argument.FLAGS, result: result))

        let messageIds: [UInt32] = context.getMessageIds(for: chatId, flags: flags, marker1before: 0).map { UInt32($0) }
        let buffer = messageIds.withUnsafeBufferPointer { Data(buffer: $0) }

        for id in messageIds {
            if id != DC_MSG_ID_MARKER1 && id != DC_MSG_ID_DAYMARKER {
                guard nil != messageCache.value(for: id) else {
                    let message = context.getMsg(with: id)
                    messageCache.set(value: message, for: id)
                    continue
                }
            }
        }

        result(FlutterStandardTypedData(int32: buffer))
    }

    fileprivate func createChatMessage(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        guard let text = methodCall.stringValue(for: Argument.TEXT, result: result) else {
            Method.Error.missingArgument(result: result)
            return
        }
        let messageId = context.send(text: text, forChatId: chatId)

        result(NSNumber(value: messageId))
    }

    fileprivate func createChatAttachmentMessage(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = methodCall.intValue(for: Argument.CHAT_ID, result: result)
        let type = methodCall.intValue(for: Argument.TYPE, result: result)
        let text = methodCall.stringValue(for: Argument.TEXT, result: result)
        
        guard let mimeType = methodCall.stringValue(for: Argument.MIME_TYPE, result: result) else {
            Method.Error.missingArgument(result: result)
            return
        }
        
        let duration = methodCall.intValue(for: Argument.DURATION, result: result)

        guard let path = methodCall.stringValue(for: Argument.PATH, result: result) else {
            Method.Error.missingArgumentValue(for: Argument.PATH, result: result)
            return
        }
        
        do {
            let messageId = try context.sendAttachment(fromPath: path, withType: type, mimeType: mimeType, text: text, duration: duration, forChatId: UInt32(chatId))
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
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))

        context.markNoticedChat(with: chatId)

        result(nil)
    }

    fileprivate func deleteChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        context.deleteChat(chatId: chatId)
        _ = chatCache.removeValue(for: chatId)

        result(nil)
    }

    fileprivate func removeContactFromChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        let contactId = UInt32(methodCall.intValue(for: Argument.CONTACT_ID, result: result))

        let removed = context.removeContact(with: contactId, fromChat: chatId)

        result(NSNumber(value: removed))
    }
    
    fileprivate func exportImportKeys(methodCall: FlutterMethodCall, result: FlutterResult, type: Int32) {
        guard let path = methodCall.stringValue(for: Argument.PATH, result: result) else {
            return
        }
        
        if path.isEmpty {
            Method.Error.missingArgumentValue(for: Argument.PATH, result: result)
            return
        }
        
        context.imex(type: type, path: path)
        result(nil)
    }

    fileprivate func setChatName(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        guard let chatName = methodCall.stringValue(for: Argument.VALUE, result: result) else {
            result(NSNumber(value: false))
            return
        }

        let nameHasBeenSet = context.setChatName(chatName, forChatId: chatId)
        result(NSNumber(value: nameHasBeenSet))
    }

    fileprivate func setChatProfileImage(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        guard let imagePath = methodCall.stringValue(for: Argument.VALUE, result: result) else {
            result(NSNumber(value: false))
            return
        }

        let imageHasBeenSet = context.setChatProfileImage(withPath: imagePath, forChatId: chatId)
        result(NSNumber(value: imageHasBeenSet))
    }

    fileprivate func interruptIdleForIncomingMessages(result: FlutterResult) {
        context.interruptImapIdle()
        context.interruptMvboxIdle()

        result(nil)
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

    fileprivate func forwardMessages(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let msgIds = methodCall.intArrayValue(for: Argument.MESSAGE_IDS, result: result) else {
            result(nil)
            return
        }

        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))
        context.forwardMessages(messageIds: msgIds, chatId: chatId)

        result(nil)
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
//        _ = msgIds.map { loadAndCacheChatMessage(with: $0, update: true) }

        result(nil)
    }

    // MARK: - Secure Stuff

    fileprivate func initiateKeyTransfer(result: FlutterResult) {
        guard let setupCode = context.initiateKeyTransfer() else {
            result(nil)
            return
        }

        result(setupCode)
    }

    fileprivate func continueKeyTransfer(methodCall: FlutterMethodCall, result: FlutterResult) {
        let msgId = UInt32(methodCall.intValue(for: Argument.ID, result: result))
        guard let setupCode = methodCall.stringValue(for: Argument.SETUP_CODE, result: result) else {
            result(NSNumber(value: false))
            return
        }

        let setupResult = context.continueKeyTransfer(msgId: msgId, setupCode: setupCode)

        result(NSNumber(value: setupResult))
    }

    fileprivate func getSecurejoinQr(methodCall: FlutterMethodCall, result: FlutterResult) {
        let chatId = UInt32(methodCall.intValue(for: Argument.CHAT_ID, result: result))

        result(context.getSecurejoinQr(chatId: chatId))
    }

    fileprivate func  joinSecurejoin(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let qrText = methodCall.stringValue(for: Argument.QR_TEXT, result: result) else {
            Method.Error.missingArgumentValue(for: Argument.QR_TEXT, result: result)
            result(NSNumber(value: 0))
            return
        }

        let chatId = context.joinSecurejoin(qrCode: qrText)

        result(NSNumber(value: chatId))
    }

    fileprivate func checkQr(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let qrCode = methodCall.stringValue(for: Argument.QR_TEXT, result: result) else {
            Method.Error.missingArgument(result: result)
            return
        }

        let lot = context.checkQR(qrCode: qrCode)

        result(lot.propertyArray)
    }

    // MARK: - Cache Handling
    
    func loadAndCacheChat(with id: UInt32) -> DcChat {
        guard let chat = chatCache.value(for: id) else {
            let chat = context.getChat(with: id)
            chatCache.set(value: chat, for: id)
            return chat
        }
        return chat
    }
    
    func loadAndCacheContact(with id: UInt32) -> DcContact {
        guard let contact = contactCache.value(for: id) else {
            let contact = context.getContact(with: id)
            contactCache.set(value: contact, for: id)
            return contact
        }

        return contact
    }
    
    func loadAndCacheChatMessage(with id: UInt32) -> DcMsg {
        guard let msg = messageCache.value(for: id) else {
            let msg = context.getMsg(with: id)
            messageCache.set(value: msg, for: id)
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
    
    fileprivate func getMessageInfo(methodCall: FlutterMethodCall, result: FlutterResult) {
        let messageId = UInt32(methodCall.intValue(for: Argument.MESSAGE_ID, result: result))
        let messageInfo = context.getMsgInfo(msgId: messageId)
        
        result(messageInfo)
    }
    
    fileprivate func retrySendingPendingMessages(result: FlutterResult) {
        context.maybeNetwork()
        result(nil)
    }

    // MARK: - Context

    fileprivate func stopOngoingProcess(result: FlutterResult) {
        context.stopOngoingProcess()
        result(nil)
    }

}
