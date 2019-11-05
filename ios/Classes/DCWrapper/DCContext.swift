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
import AVFoundation

class DcContext {
    static private(set) var contextPointer: OpaquePointer?

    /// Returns the file path of the DeltaChat SQLite database.
    var userDatabasePath: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return "\(paths)/messenger.db"
    }

    init() {
        DcContext.contextPointer = dc_context_new(dc_event_callback, nil, UIApplication.name)
    }

    deinit {
        dc_context_unref(DcContext.contextPointer)
    }

    // MARK: - User Database

    func openUserDataBase() -> Bool {
        let result = NSNumber(value: dc_open(DcContext.contextPointer, userDatabasePath, nil))

        return Bool(truncating: result)
    }

    func closeUserDataBase() {
        dc_close(DcContext.contextPointer)
        DcContext.contextPointer = nil
    }

    // MARK: - Chats

    func getChatlist(flags: Int32, queryString: String?, queryId: Int) -> DcChatlist {
        let chatlistPointer = dc_get_chatlist(DcContext.contextPointer, flags, queryString, UInt32(queryId))
        return DcChatlist(chatListPointer: chatlistPointer)
    }

    func getChat(with id: UInt32) -> DcChat {
        return DcChat(id: id)
    }

    func getChatByContactId(contactId: UInt32) -> UInt32 {
        return dc_get_chat_id_by_contact_id(DcContext.contextPointer, contactId)
    }

    /**
    Delete a chat.

    - Discussion:
    Messages are deleted from the device and the chat database entry is deleted.
    After that, the event #DC_EVENT_MSGS_CHANGED is posted.
    
     Things that are _not_ done implicitly:
    
    - Messages are **not deleted from the server**.
    - The chat or the contact is **not blocked**, so new messages from the user/the group may appear
      and the user may create the chat again.
    - **Groups are not left** - this would
      be unexpected as (1) deleting a normal chat also does not prevent new mails
      from arriving, (2) leaving a group requires sending a message to
      all group members - especially for groups not used for a longer time, this is
      really unexpected when deletion results in contacting all members again,
      (3) only leaving groups is also a valid usecase.
    
    To leave a chat explicitly, use dc_remove_contact_from_chat() with
    chat_id=DC_CONTACT_ID_SELF)
    
    - Parameter chatId: The ID of the chat to delete.
    - Returns: None.
    */
    func deleteChat(chatId: UInt32) {
        dc_delete_chat(DcContext.contextPointer, UInt32(chatId))
    }

    func archiveChat(chatId: UInt32, archive: Bool) {
        dc_archive_chat(DcContext.contextPointer, UInt32(chatId), Int32(archive ? 1 : 0))
    }

    func createChatByMessageId(messageId: UInt32) -> DcChat {
        let chatId = dc_create_chat_by_msg_id(DcContext.contextPointer, messageId)
        return DcChat(id: chatId)
    }

    func createChatByContactId(contactId: UInt32) -> DcChat {
        let chatId = dc_create_chat_by_contact_id(DcContext.contextPointer, contactId)
        let chat = DcChat(id: chatId)

        return chat
    }

    func setChatName(_ chatName: String, forChatId chatId: UInt32) -> Int32 {
        return dc_set_chat_name(DcContext.contextPointer, chatId, chatName)
    }

    /// Sets the profile image for the chat with given chat ID
    /// - Parameter imagePath: The full file path where to find the profile image for that chat.
    /// - Parameter chatId: The chat ID of the chat whose image should be set.
    func setChatProfileImage(withPath imagePath: String, forChatId chatId: UInt32) -> Int32 {
        return dc_set_chat_profile_image(DcContext.contextPointer, chatId, imagePath)
    }

    /// Creates a Group Chat
    /// - Parameter chatName: The name of the chat.
    /// - Parameter isVerified: Flag which determines whether this is a verified chat. Only secure verified members are allowed in this chat.
    func createGroupChat(with chatName: String, isVerified: Bool) -> UInt32 {
        return dc_create_group_chat(DcContext.contextPointer, (isVerified ? 1 : 0), chatName)
    }

    func removeContact(with contactId: UInt32, fromChat chatId: UInt32) -> Int32 {
        return dc_remove_contact_from_chat(DcContext.contextPointer, chatId, contactId)
    }

    func markNoticedChat(with chatId: UInt32) {
        dc_marknoticed_chat(DcContext.contextPointer, chatId)
    }

    func addContact(with contactId: UInt32, toChat chatId: UInt32) -> Int32 {
        return dc_add_contact_to_chat(DcContext.contextPointer, chatId, contactId)
    }

    // MARK: - Contacts

    /// Returns an array of contact id's belonging to a chat with the given chat id.
    /// - Parameter chatId: The chat id whose members should be returned.
    /// - Returns: An array of contact id's belonging to the chat with the given chat id.
    func getChatContacts(for chatId: Int32) -> [UInt32] {
        let dcContacts = dc_get_chat_contacts(DcContext.contextPointer, UInt32(chatId))
        let contactIds = Utils.copyAndFreeArray(inputArray: dcContacts)

        return contactIds
    }

    /// Returns a DcChat object for the given contact id
    /// - Parameter id: The contact id whose DcContact object should be returned
    /// - Returns: The DcChat object for the given chat id
    func getContact(with id: UInt32) -> DcContact {
        return DcContact(id: id)
    }

    /**
    Returns an array of all unblocked and known contact id's.
    - Parameter flags: A combination of flags:
         - if the flag DC_GCL_ADD_SELF is set, SELF is added to the list unless filtered by other parameters
         - if the flag DC_GCL_VERIFIED_ONLY is set, only verified contacts are returned.
           if DC_GCL_VERIFIED_ONLY is not set, verified and unverified contacts are returned.
    - Parameter query: A string to filter the list. Typically used to implement an incremental search. NULL for no filtering.
    - Returns: An array containing all contact IDs.
    */
    func getContacts(flags: Int32, query: String?) -> [UInt32] {
        let dcContacts = dc_get_contacts(DcContext.contextPointer, UInt32(flags), query)
        let contacts = Utils.copyAndFreeArray(inputArray: dcContacts)

        return contacts
    }

    func blockContact(contactId: UInt32, block: Bool) {
        dc_block_contact(DcContext.contextPointer, contactId, (block ? 1 : 0))
    }

    func getBlockedContacts() -> [UInt32] {
        let blockedIds = dc_get_blocked_contacts(DcContext.contextPointer)
        return Utils.copyAndFreeArray(inputArray: blockedIds)
    }

    func deleteContact(contactId: UInt32) -> Bool {
        return 1 == dc_delete_contact(DcContext.contextPointer, contactId)
    }

    func createContact(name: String, emailAddress: String) -> UInt32 {
        return dc_create_contact(DcContext.contextPointer, name, emailAddress)
    }

    // MARK: - Addressbook

    func addAddressBook(addressBook: String) -> Int32 {
        return dc_add_address_book(DcContext.contextPointer, addressBook)
    }

    // MARK: - Messages

    func getMsg(with id: UInt32) -> DcMsg {
        return DcMsg(id: id)
    }

    func getMsgInfo(msgId: Int) -> String {
        if let cString = dc_get_msg_info(DcContext.contextPointer, UInt32(msgId)) {
            let swiftString = String(cString: cString)
            free(cString)
            return swiftString
        }

        return "ErrGetMsgInfo"
    }

    func getMessageIds(for chatId: UInt32, flags: UInt32, marker1before: UInt32) -> [UInt32] {
        let messageIds = dc_get_chat_msgs(DcContext.contextPointer, chatId, flags, marker1before)
        let ids = Utils.copyAndFreeArray(inputArray: messageIds)

        return ids
    }

    func getFreshMessageCount(for chatId: UInt32) -> Int32 {
        return dc_get_fresh_msg_cnt(DcContext.contextPointer, chatId)
    }

    func sendText(_ text: String, forChatId chatId: UInt32) -> UInt32 {
        let msg = dc_msg_new(DcContext.contextPointer, DC_MSG_TEXT)
        dc_msg_set_text(msg, text.cString(using: .utf8))
        let messageId = dc_send_msg(DcContext.contextPointer, chatId, msg)
        dc_msg_unref(msg)

        return messageId
    }

    func sendAttachment(fromPath path: String, withType type: Int32, mimeType: String, text: String?, forChatId chatId: UInt32) throws -> UInt32 {
        guard Int(type).isValidAttachmentType else {
            throw DcContextError(kind: .wrongAttachmentType(type))
        }

        let msg = dc_msg_new(DcContext.contextPointer, type)

        switch type {
            case DC_MSG_IMAGE, DC_MSG_GIF:
                guard let image = UIImage(contentsOfFile: path) else {
                    throw DcContextError(kind: .missingImageAtPath(path))
                }

                let pixelSize = image.sizeInPixel
                let width = Int32(exactly: pixelSize.width)!
                let height = Int32(exactly: pixelSize.height)!
                dc_msg_set_dimension(msg, width, height)
                break

            case DC_MSG_AUDIO:
                break

            case DC_MSG_VOICE:
                break

            case DC_MSG_VIDEO:
                break

            case DC_MSG_FILE:
                break

            default: break
        }

        dc_msg_set_file(msg, path, mimeType)

        if let text = text {
            dc_msg_set_text(msg, text.cString(using: .utf8))
        }
        let messageId = dc_send_msg(DcContext.contextPointer, chatId, msg)
        dc_msg_unref(msg)

        return messageId
    }

    func getFreshMessageIds() -> [UInt32] {
        let messageIds = dc_get_fresh_msgs(DcContext.contextPointer)
        let ids = Utils.copyAndFreeArray(inputArray: messageIds)

        return ids
    }

    func markSeenMessages(messageIds: [UInt32]) {
        dc_markseen_msgs(DcContext.contextPointer, UnsafePointer(messageIds), Int32(messageIds.count))
    }

    func starMessages(messageIds: [UInt32], star: Int32) {
        dc_star_msgs(DcContext.contextPointer, UnsafePointer(messageIds), Int32(messageIds.count), star)
    }

    func deleteMessages(messageIds: [UInt32]) {
        dc_delete_msgs(DcContext.contextPointer, UnsafePointer(messageIds), Int32(messageIds.count))
    }

    func forwardMessages(messageIds: [UInt32], chatId: UInt32) {
        dc_forward_msgs(DcContext.contextPointer, UnsafePointer(messageIds), Int32(messageIds.count), chatId)
    }

    // MARK: - General

    func getSecurejoinQr(chatId: UInt32) -> String? {
        if let cString = dc_get_securejoin_qr(DcContext.contextPointer, chatId) {
            let swiftString = String(cString: cString)
            free(cString)
            return swiftString
        }

        return nil
    }

    func joinSecurejoin (qrCode: String) -> UInt32 {
        return dc_join_securejoin(DcContext.contextPointer, qrCode)
    }

    func checkQR(qrCode: String) -> DcLot {
        return DcLot(dc_check_qr(DcContext.contextPointer, qrCode))
    }

    func stopOngoingProcess() {
        dc_stop_ongoing_process(DcContext.contextPointer)
    }

    func initiateKeyTransfer() -> String? {
        if let cString = dc_initiate_key_transfer(DcContext.contextPointer) {
            let swiftString = String(cString: cString)
            log.debug("AutoCrypt setup message code: \(swiftString)")
            free(cString)
            return swiftString
        }

        return nil
    }

    func continueKeyTransfer(msgId: UInt32, setupCode: String) -> Bool {
        return 1 == dc_continue_key_transfer(DcContext.contextPointer, msgId, setupCode)
    }

    // MARK: - COI related Stuff

    func isCoiSupported() -> Int32 {
        return dc_is_coi_supported(DcContext.contextPointer)
    }

    func isCoiEnabled() -> Int32 {
        return dc_is_coi_enabled(DcContext.contextPointer)
    }

    func isWebPushSupported() -> Int32 {
        return dc_is_webpush_supported(DcContext.contextPointer)
    }

    func getWebPushVapidKey() -> String? {
        if let cString = dc_get_webpush_vapid_key(DcContext.contextPointer) {
            let swiftString = String(cString: cString)
            free(cString)
            return swiftString
        }
        return nil
    }

    func subscribeWebPush(uid: String, json: String, id: Int32) {
        dc_subscribe_webpush(DcContext.contextPointer, uid, json, id)
    }

    func getWebPushSubscription(uid: String, id: Int32) {
        dc_get_webpush_subscription(DcContext.contextPointer, uid, id)
    }

    func setCoiEnabled(enable: Int32, id: Int32) {
        dc_set_coi_enabled(DcContext.contextPointer, enable, id)
    }

    func setCoiMessageFilter(mode: Int32, id: Int32) {
        dc_set_coi_message_filter(DcContext.contextPointer, mode, id)
    }

    func validateWebPush(uid: String, message: String, id: Int32) {
        dc_validate_webpush(DcContext.contextPointer, uid, message, id)
    }

    // MARK: - IMAP

    func interruptImapIdle() {
        dc_interrupt_imap_idle(DcContext.contextPointer)
    }

    func interruptMvboxIdle() {
        dc_interrupt_mvbox_idle(DcContext.contextPointer)
    }

    // MARK: - Config

    func setConfig(value: String, forKey key: String) -> Int32 {
        log.debug("setConfig value: '\(value)', for key: '\(key)'")
        return dc_set_config(DcContext.contextPointer, key, value)
    }

    func setConfigInt(value: Int32, forKey key: String) -> Int32 {
        return setConfig(value: "\(value)", forKey: key)
    }

    func getConfig(for key: String) -> String? {
        log.debug("getConfig for key: '\(key)'")
        let value = dc_get_config(DcContext.contextPointer, key)
        if let cString = value {
            let str = String(cString: cString)
            if !str.isEmpty {
                return str
            }
        }
        return nil
    }

    func getConfigInt(for key: String) -> Int32? {
        if let value = getConfig(for: key) {
            return Int32(value)
        }
        return nil
    }

    func configure() {
        if (!isConfigured) {
            dc_configure(DcContext.contextPointer)
        }
    }

    var isConfigured: Bool {
        return 1 == dc_is_configured(DcContext.contextPointer)
    }

}
