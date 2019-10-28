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
import MessageKit

class DcMsg: MessageType {
    private var messagePointer: OpaquePointer?

    init(id: UInt32) {
        messagePointer = dc_get_msg(DcContext.contextPointer, id)
    }

    deinit {
        dc_msg_unref(messagePointer)
    }
    
    // MARK: - Debugging
    
    func debugDescription() -> String {
        return "[id: \(id)] '\(String(describing: text))'"
    }

    // MARK: - MessageType Protocol

    lazy var sender: SenderType = {
        Sender(id: "\(fromContactId)", displayName: fromContact.displayName)
    }()

    var messageId: String {
        return "\(id)"
    }

    lazy var sentDate: Date = {
        Date(timeIntervalSince1970: Double(timestamp))
    }()

    lazy var kind: MessageKind = {
        if isInfoMessage {
            let text = NSAttributedString(string: self.text, attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                ])
            return MessageKind.attributedText(text)
        }

        if self.viewtype == nil {
            return MessageKind.text(self.text)
        }

        switch self.viewtype! {
        case .image:
            return MessageKind.photo(Media(image: image))
        case .video:
            return MessageKind.video(Media(url: fileURL))
        default:
            // TODO: custom views for audio, etc
            if !self.filename.isEmpty {
                return MessageKind.text("File: \(self.filename) (\(self.filesize) bytes)")
            }
            return MessageKind.text(text)
        }
    }()

    // MARK: - Helper

    let localDateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .none
        result.timeStyle = .short
        return result
    }()

    func formattedSentDate() -> String {
        return localDateFormatter.string(from: sentDate)
    }

    var id: UInt32 {
        return dc_msg_get_id(messagePointer)
    }

    var fromContactId: UInt32 {
        return dc_msg_get_from_id(messagePointer)
    }

    lazy var fromContact: DcContact = {
        DcContact(id: fromContactId)
    }()

    var chatId: UInt32 {
        return dc_msg_get_chat_id(messagePointer)
    }

    var text: String {
        guard let cString = dc_msg_get_text(messagePointer) else { return "" }
        let swiftString = String(cString: cString)
        free(cString)
        return swiftString
    }

    var viewtype: MessageViewType? {
        switch dc_msg_get_viewtype(messagePointer) {
        case DC_MSG_AUDIO:
            return .audio
        case DC_MSG_FILE:
            return .file
        case DC_MSG_GIF:
            return .gif
        case DC_MSG_TEXT:
            return .text
        case DC_MSG_IMAGE:
            return .image
        case DC_MSG_VIDEO:
            return .video
        case DC_MSG_VOICE:
            return .voice
        default:
            return nil
        }
    }

    var fileURL: URL? {
        if !self.file.isEmpty {
            return URL(fileURLWithPath: self.file, isDirectory: false)
        }
        return nil
    }

    private lazy var image: UIImage? = { [unowned self] in
        let filetype = dc_msg_get_viewtype(messagePointer)
        if let path = fileURL, filetype == DC_MSG_IMAGE {
            if path.isFileURL {
                do {
                    let data = try Data(contentsOf: path)
                    let image = UIImage(data: data)
                    return image
                } catch {
                    log.warning("failed to load image: \(path), \(error)")
                    return nil
                }
            }
            return nil
        } else {
            return nil
        }
        }()

    var file: String {
        if let cString = dc_msg_get_file(messagePointer) {
            let str = String(cString: cString)
            free(cString)
            return str
        }

        return ""
    }

    var filemime: String {
        if let cString = dc_msg_get_filemime(messagePointer) {
            let str = String(cString: cString)
            free(cString)
            return str
        }

        return ""
    }

    var filename: String {
        if let cString = dc_msg_get_filename(messagePointer) {
            let str = String(cString: cString)
            free(cString)
            return str
        }

        return ""
    }

    var filesize: UInt64 {
        return dc_msg_get_filebytes(messagePointer)
    }

    // DC_MSG_*
    var type: Int32 {
        return dc_msg_get_viewtype(messagePointer)
    }

    // DC_STATE_*
    var state: Int32 {
        return dc_msg_get_state(messagePointer)
    }

    func stateDescription() -> String {
        switch Int32(state) {
        case DC_STATE_IN_FRESH:
            return "Fresh"
        case DC_STATE_IN_NOTICED:
            return "Noticed"
        case DC_STATE_IN_SEEN:
            return "Seen"
        case DC_STATE_OUT_DRAFT:
            return "Draft"
        case DC_STATE_OUT_PENDING:
            return "Pending"
        case DC_STATE_OUT_DELIVERED:
            return "Sent"
        case DC_STATE_OUT_MDN_RCVD:
            return "Read"
        case DC_STATE_OUT_FAILED:
            return "Failed"
        default:
            return "Unknown"
        }
    }

    var timestamp: Int64 {
        return Int64(dc_msg_get_timestamp(messagePointer))
    }

    func summary(chars: Int32) -> String {
        guard let cString = dc_msg_get_summarytext(messagePointer, chars) else { return "" }
        let swiftString = String(cString: cString)
        free(cString)
        return swiftString
    }

    func createChat() -> DcChat {
        let chatId = dc_create_chat_by_msg_id(DcContext.contextPointer, UInt32(id))
        return DcChat(id: chatId)
    }
    
    var isSetupMessage: Bool {
        return dc_msg_is_setupmessage(messagePointer) == 1
    }
    
    var isInfoMessage: Bool {
        return dc_msg_is_info(messagePointer) == 1
    }
    
    var isOutgoing: Bool {
        return fromContactId == DC_CONTACT_ID_SELF
    }
    
    var hasFile: Bool {
        return !self.file.isEmpty
    }
    
    var showPadLock: Int32 {
        return dc_msg_get_showpadlock(messagePointer)
    }
    
    var isStarred: Bool {
        return dc_msg_is_starred(messagePointer) == 1
    }
    
    var setupCodeBegin: String {
        if let cString = dc_msg_get_setupcodebegin(messagePointer) {
            let str = String(cString: cString)
            free(cString)
            return str
        }
        return ""
    }

}

enum MessageViewType: Int {
    case text  = 10
    case image = 20
    case gif   = 21
    case audio = 40
    case voice = 41
    case video = 50
    case file  = 60
    
    var description: String {
        switch self {
        // Use Internationalization, as appropriate.
        case .text:     return "Text"
        case .image:    return "Image"
        case .gif:      return "GIF"
        case .audio:    return "Audio"
        case .voice:    return "Voice"
        case .video:    return "Video"
        case .file:     return "File"
        }
    }
}

// MARK: - Attachment Type

extension Int {
    
    var isValidAttachmentType: Bool {
        return DC_MSG_IMAGE == self
            || DC_MSG_GIF   == self
            || DC_MSG_AUDIO == self
            || DC_MSG_VOICE == self
            || DC_MSG_VIDEO == self
            || DC_MSG_FILE  == self
    }
    
}
