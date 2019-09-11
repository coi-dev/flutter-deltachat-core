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

class ContextCallHandler: MethodCallHandler, MethodCallHandling {

    // MARK: - Protocol MethodCallHandling

    func handle(_ call: FlutterMethodCall, result: (Any?) -> Void) {
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
        default:
            log.error("Context: Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    private func setConfig(methodCall: FlutterMethodCall, result: FlutterResult) {
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
    
    private func getConfig(methodCall: FlutterMethodCall, result: FlutterResult, type: String) {
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
    
    private func configure(result: FlutterResult) {
        dc_configure(DcContext.contextPointer)
        result(nil);
    }
    
    private func addAddressBook(methodCall: FlutterMethodCall, result: FlutterResult) {
        if !methodCall.contains(keys: [Argument.ADDRESS_BOOK]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        let parameters = methodCall.parameters
        
        if let addressBook = parameters[Argument.ADDRESS_BOOK] as? String {
            let dc_result = dc_add_address_book(DcContext.contextPointer, addressBook)
            result(dc_result)
        }
        else {
            Method.errorArgumentMissingValue(result: result)
            return
        }
        
    }
    
    private func createContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            return
        }
        if let myArgs = args as? [String: Any],
            let address = myArgs["address"] as? String {
            
            let name = myArgs["name"] as? String
            let contactId = dc_create_contact(DcContext.contextPointer, name, address)
            result(Int(contactId))
        }
        else {
            result(Method.errorArgumentMissingValue(result: result))
        }
    }
    
    private func deleteContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        if !methodCall.contains(keys: [Argument.ID]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        guard let args = methodCall.arguments else {
            return
        }
        
        if let myArgs = args as? [String: Any],
            let contactId = myArgs[Argument.ID] as? UInt32 {
            
            let deleted = dc_delete_contact(DcContext.contextPointer, contactId)
            result(deleted)
        }
        else {
            Method.errorArgumentMissingValue(result: result)
            return
        }
        
    }
    
    private func blockContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        if !methodCall.contains(keys: [Argument.ID]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        guard let args = methodCall.arguments else {
            return
        }
        
        if let myArgs = args as? [String: Any],
            let contactId = myArgs[Argument.ID] as? UInt32 {
            
            dc_block_contact(DcContext.contextPointer, contactId, 1)
            result(nil)
        }
        else {
            Method.errorArgumentMissingValue(result: result)
            return
        }
        
    }
    
    private func getBlockedContacts(result: FlutterResult) {
        let blockedIds = dc_get_blocked_contacts(DcContext.contextPointer)
        result(blockedIds)
        
    }
    
    private func unblockContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        if !methodCall.contains(keys: [Argument.ID]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        guard let args = methodCall.arguments else {
            return
        }
        
        if let myArgs = args as? [String: Any], let contactId = myArgs[Argument.ID] as? UInt32 {
            dc_block_contact(DcContext.contextPointer, contactId, 0)
            result(nil)
        }
        else {
            Method.errorArgumentMissingValue(result: result)
            return
        }
        
    }
    
    private func createChatByContactId(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            return
        }
        
        if let myArgs = args as? [String: Any],
            let contactId = myArgs[Argument.ID] as? UInt32 {
            
            let chatId = dc_create_chat_by_contact_id(DcContext.contextPointer, contactId)
            result(Int(chatId))
        }
        else {
            result(Method.errorMissingArgument(result: result))
        }
    }
    
    private func createChatByMessageId(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            return
        }
        
        if let myArgs = args as? [String: Any],
            let messageId = myArgs[Argument.ID] as? UInt32 {
            
            let chatId = dc_create_chat_by_msg_id(DcContext.contextPointer, messageId)
            result(Int(chatId))
        }
        else {
            result(Method.errorMissingArgument(result: result))
        }
        
    }
    
    private func createGroupChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.VERIFIED, Argument.NAME]) {
            result(Method.errorMissingArgument(result: result))
            return
        }
        
        if let myArgs = args as? [String: Any] {
            let verified = myArgs[Argument.VERIFIED] as? Bool
            if (verified == nil) {
                result(Method.errorMissingArgument(result: result))
                return
            }
            
            let name = myArgs[Argument.NAME] as? String
            let chatId = dc_create_group_chat(DcContext.contextPointer, Int32(truncating: verified! as NSNumber), name)
            
            result(chatId)
        }
    }
    
    private func addContactToChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.CONTACT_ID]) {
            result(Method.errorMissingArgument(result: result))
            return
        }
        
        if let myArgs = args as? [String: Any] {
            let chatId = myArgs[Argument.CHAT_ID] as? UInt32
            let contactId = myArgs[Argument.CONTACT_ID] as? UInt32
            
            if (chatId == nil || contactId == nil) {
                result(Method.errorMissingArgument(result: result))
                return
            }
            
            let successfullyAdded = dc_add_contact_to_chat(DcContext.contextPointer, chatId!, contactId!)
            
            result(successfullyAdded)
        }
        
    }
    
    private func getChatByContactId(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.CONTACT_ID]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let contactId = myArgs[Argument.CONTACT_ID] as? UInt32 {
            let chatId = dc_get_chat_id_by_contact_id(DcContext.contextPointer, contactId)
            result(chatId)
        }
        else {
            Method.errorArgumentMissingValue(result: result);
            return
        }
        
    }
    
    private func getContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result)
            return
        }
        if let myArgs = args as? [String: Any], let id = myArgs[Argument.ID] as? UInt32 {
            result(dc_array_get_contact_id(DcContext.contextPointer, Int(id)))
        }
        
    }
    
    private func getContacts(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.FLAGS, Argument.QUERY]) {
            result(Method.errorMissingArgument(result: result))
            return
        }
        
        if let myArgs = args as? [String: Any] {
            let flags = myArgs[Argument.FLAGS] as? UInt32
            let query = myArgs[Argument.QUERY]  as? String
            
            if (flags == nil) {
                result(Method.errorMissingArgument(result: result))
                return
            }
            
            var contactIds = dc_get_contacts(DcContext.contextPointer, flags!, query)
            
            result(FlutterStandardTypedData(int32: Data(bytes: &contactIds, count: MemoryLayout.size(ofValue: contactIds))))
        }
        
    }
    
    private func getChatContacts(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID]) {
            result(Method.errorMissingArgument(result: result))
            return
        }
        
        if let myArgs = args as? [String: Any] {
            let id = myArgs[Argument.CHAT_ID] as? UInt32
            
            if id == nil {
                result(Method.errorMissingArgument(result: result))
                return
            }
            
            var contactIds = dc_get_chat_contacts(DcContext.contextPointer, id!)
            
            result(FlutterStandardTypedData(int32: Data(bytes: &contactIds, count: MemoryLayout.size(ofValue: contactIds))))
        }
        
    }
    
    private func getChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result)
            return
        }
        
        if !methodCall.contains(keys: [Argument.ID]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let id = myArgs[Argument.ID] as? UInt32 {
            
            result(dc_get_chat(DcContext.contextPointer, id))
        }
        else {
            Method.errorMissingArgument(result: result);
        }
    }
    
    private func getChatMessages(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result)
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let chatId = myArgs[Argument.CHAT_ID] as? UInt32,
            let flags = myArgs[Argument.FLAGS] {
            //result(dc_get_chat(mailboxPointer, chatId))
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        //        Integer id = methodCall.argument(ARGUMENT_CHAT_ID);
        //        if (id == null) {
        //        resultErrorArgumentMissingValue(result);
        //        return;
        //        }
        //        Integer flags = methodCall.argument(ARGUMENT_FLAGS);
        //        if (flags == null) {
        //        flags = 0;
        //        }
        //
        //        int[] messageIds = dcContext.getChatMsgs(id, flags, 0);
        //        for (int messageId : messageIds) {
        //        if (messageId != DcMsg.DC_MSG_ID_MARKER1 && messageId != DcMsg.DC_MSG_ID_DAYMARKER) {
        //        DcMsg message = messageCache.get(messageId);
        //        if (message == null) {
        //        messageCache.put(messageId, dcContext.getMsg(messageId));
        //        }
        //        }
        //        }
        //        result.success(messageIds);
    }
    
    private func createChatMessage(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result)
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.TEXT]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let chatId = myArgs[Argument.CHAT_ID] as? UInt32,
            let flags = myArgs[Argument.TEXT] {
            //result(dc_get_chat(mailboxPointer, chatId))
            
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        
        //    Integer id = methodCall.argument(ARGUMENT_CHAT_ID);
        //    if (id == null) {
        //    resultErrorArgumentMissingValue(result);
        //    return;
        //    }
        //
        //    String text = methodCall.argument(ARGUMENT_TEXT);
        //
        //    DcMsg newMsg = new DcMsg(dcContext, DcMsg.DC_MSG_TEXT);
        //    newMsg.setText(text);
        //    int messageId = dcContext.sendMsg(id, newMsg);
        //    result.success(messageId);
    }
    
    private func createChatAttachmentMessage(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result)
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.TYPE, Argument.PATH, Argument.TEXT]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let chatId = myArgs[Argument.CHAT_ID] as? UInt32,
            let path = myArgs[Argument.PATH],
            let type = myArgs[Argument.TYPE] {
            
            let text = myArgs[Argument.TEXT]
            
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        
        //    Integer chatId = methodCall.argument(ARGUMENT_CHAT_ID);
        //    String path = methodCall.argument(ARGUMENT_PATH);
        //    Integer type = methodCall.argument(ARGUMENT_TYPE);
        //    if (chatId == null || path == null || type == null) {
        //    resultErrorArgumentMissingValue(result);
        //    return;
        //    }
        //
        //    String text = methodCall.argument(ARGUMENT_TEXT);
        //
        //    DcMsg newMsg = new DcMsg(dcContext, type);
        //    newMsg.setFile(path, null);
        //    newMsg.setText(text);
        //    int messageId = dcContext.sendMsg(chatId, newMsg);
        //    result.success(messageId);
    }
    
    private func getFreshMessageCount(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID]) {
            result(Method.errorMissingArgument(result: result))
            return
        }
        
        if let myArgs = args as? [String: Any] {
            let chatId = myArgs[Argument.CHAT_ID] as? UInt32
            
            if chatId == nil {
                result(Method.errorMissingArgument(result: result))
                return
            }
            
            let freshMessageCount = dc_get_fresh_msg_cnt(DcContext.contextPointer, chatId!)
            
            result(freshMessageCount)
        }
        
    }
    
    private func markNoticedChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID]) {
            result(Method.errorMissingArgument(result: result))
            return
        }
        
        if let myArgs = args as? [String: Any] {
            let chatId = myArgs[Argument.CHAT_ID] as? UInt32
            
            if chatId == nil {
                result(Method.errorMissingArgument(result: result))
                return
            }
            
            dc_marknoticed_chat(DcContext.contextPointer, chatId!)
            result(nil)
        }
        
    }
    
    private func deleteChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID]) {
            result(Method.errorMissingArgument(result: result))
            return
        }
        
        if let myArgs = args as? [String: Any] {
            let chatId = myArgs[Argument.CHAT_ID] as? UInt32
            
            if chatId == nil {
                result(Method.errorMissingArgument(result: result))
                return
            }
            
            dc_delete_chat(DcContext.contextPointer, chatId!)
            result(nil)
        }
        
    }
    
    private func removeContactFromChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.CONTACT_ID]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any], let chatId = myArgs[Argument.CHAT_ID], let contactId = myArgs[Argument.CONTACT_ID] {
            result(dc_remove_contact_from_chat(DcContext.contextPointer, chatId as! UInt32, contactId as! UInt32))
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        
    }
    
    private func getFreshMessages(result: FlutterResult) {
        let freshMessages = dc_get_fresh_msgs(DcContext.contextPointer)
        result(freshMessages)
    }
    
    private func forwardMessages(methodCall: FlutterMethodCall, result: FlutterResult){
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.MESSAGE_IDS]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any], let chatId = myArgs[Argument.CHAT_ID], let msgIdArray = myArgs[Argument.MESSAGE_IDS] {
            
            result(dc_forward_msgs(DcContext.contextPointer, msgIdArray as? UnsafePointer<UInt32>, Int32((msgIdArray as AnyObject).count), chatId as! UInt32))
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        
    }
    
    private func markSeenMessages(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.MESSAGE_IDS]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any], let msgIdArray = myArgs[Argument.MESSAGE_IDS] {
            result(dc_markseen_msgs(DcContext.contextPointer, msgIdArray as? UnsafePointer<UInt32>, Int32((msgIdArray as AnyObject).count)))
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        
    }
    
    private func initiateKeyTransfer(result: FlutterResult) {
        //    new Thread(() -> {
        //    String setupKey = dcContext.initiateKeyTransfer();
        //    getUiThreadHandler().post(() -> {
        //    result.success(setupKey);
        //    });
        //    }).start();
    }
    
    private func continueKeyTransfer(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.ID, Argument.SETUP_CODE]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let messageId = myArgs[Argument.ID],
            let setupCode = myArgs[Argument.SETUP_CODE] {
            
            result(dc_continue_key_transfer(DcContext.contextPointer, messageId as! UInt32, setupCode as? UnsafePointer<Int8>))
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        
    }
    
    private func getSecurejoinQr(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let chatId = myArgs[Argument.CHAT_ID] {
            result(dc_get_securejoin_qr(DcContext.contextPointer, chatId as! UInt32))
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        
    }
    
    private func  joinSecurejoin(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.QR_TEXT]) {
            Method.errorMissingArgument(result: result);
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
            Method.errorMissingArgument(result: result);
        }
        
    }
    
    private func checkQr(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.QR_TEXT]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let qrText = myArgs[Argument.QR_TEXT] {
            //            DcLot qrCode = dcContext.checkQr(qrText);
            //            result.success(mapLotToList(qrCode));
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        
    }
    
    private func deleteMessages(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.MESSAGE_IDS]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let msgIdArray = myArgs[Argument.MESSAGE_IDS] {
            result(dc_delete_msgs(DcContext.contextPointer, msgIdArray as? UnsafePointer<UInt32>, Int32((msgIdArray as AnyObject).count)))
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        
    }
    
    private func starMessages(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let arguments: [String: Any] = methodCall.arguments as? [String: Any] else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.MESSAGE_IDS, Argument.VALUE]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let msgIds = arguments[Argument.MESSAGE_IDS] {
            let star = methodCall.intValue(for: Argument.VALUE, result: result)
            
            dc_star_msgs(DcContext.contextPointer, msgIds as? UnsafePointer<UInt32>, Int32((msgIds as AnyObject).count), Int32(star))
            result(nil)
        }
        else {
            Method.errorMissingArgument(result: result);
        }
        
    }
    
    private func setChatProfileImage(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.VALUE]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let chatId = myArgs[Argument.CHAT_ID],
            let value = myArgs[Argument.VALUE] {
            
            dc_set_chat_profile_image(DcContext.contextPointer, chatId as! UInt32, value as? UnsafePointer<Int8>)
            result(nil)
        }
        else {
            Method.errorMissingArgument(result: result)
            return
        }
        
    }
    
    private func setChatName(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if !methodCall.contains(keys: [Argument.CHAT_ID, Argument.VALUE]) {
            Method.errorMissingArgument(result: result);
            return
        }
        
        if let myArgs = args as? [String: Any],
            let chatId = myArgs[Argument.CHAT_ID],
            let value = myArgs[Argument.VALUE] {
            
            dc_set_chat_name(DcContext.contextPointer, chatId as! UInt32, value as? UnsafePointer<Int8>)
            result(nil)
        }
        else {
            Method.errorMissingArgument(result: result)
            return
        }
        
    }
}
