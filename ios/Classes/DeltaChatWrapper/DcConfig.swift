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

enum DcConfigKey: String {
    case addr            = "addr"
    case mailServer      = "mail_server"
    case mailUser        = "mail_user"
    case mailPw          = "mail_pw"
    case mailPort        = "mail_port"
    case sendServer      = "send_server"
    case sendUser        = "send_user"
    case sendPw          = "send_pw"
    case sendPort        = "send_port"
    case serverFlags     = "server_flags"
    case displayname     = "displayname"
    case selfstatus      = "selfstatus"
    case selfavatar      = "selfavatar"
    case e2eeEnabled     = "e2ee_enabled"
    case mdnsEnabled     = "mdns_enabled"
    case inboxWatch      = "inbox_watch"
    case sentboxWatch    = "sentbox_watch"
    case mvboxWatch      = "mvbox_watch"
    case mvboxMove       = "mvbox_move"
    case showEmails      = "show_emails"
    case saveMimeHeaders = "save_mime_headers"
}

class DcConfig {

    private class func getConfig(_ key: String) -> String? {
        guard let cString = dc_get_config(DcContext.contextPointer, key) else { return nil }
        let value = String(cString: cString)
        free(cString)
        if value.isEmpty {
            return nil
        }
        return value
    }
    
    private class func setConfig(_ key: String, _ value: String?) {
        if let value = value {
            dc_set_config(DcContext.contextPointer, key, value)
        } else {
            dc_set_config(DcContext.contextPointer, key, nil)
        }
    }
    
    private class func getConfigBool(_ key: String) -> Bool {
        return Utils.strToBool(getConfig(key))
    }
    
    private class func setConfigBool(_ key: String, _ value: Bool) {
        let vStr = value ? "1" : "0"
        setConfig(key, vStr)
    }
    
    private class func getConfigInt(_ key: String) -> Int {
        let vStr = getConfig(key)
        if vStr == nil {
            return 0
        }
        let vInt = Int(vStr!)
        if vInt == nil {
            return 0
        }
        return vInt!
    }
    
    private class func setConfigInt(_ key: String, _ value: Int) {
        setConfig(key, String(value))
    }
    
    class func set(key: DcConfigKey, value: String?) -> Int {
        switch key {
        case .addr:         addr       = value
        case .mailPw:       mailPw     = value
        case .mailUser:     mailUser   = value
        case .mailServer:   mailServer = value
        case .mailPort:     mailPort   = value
        case .sendServer:   sendServer = value
        case .sendUser:     sendUser   = value
        case .sendPort:     sendPort   = value
        case .sendPw:       sendPw     = value
        case .serverFlags:
            if let value = value, let flags = Int(value) {
                serverFlags = flags
            } else {
                serverFlags = 0     // TODO: Check if this is correct!
            }

        case .displayname: displayname = value
        case .selfstatus: selfstatus = value
        case .showEmails:
            if let value = value, let intVal = Int(value) {
                showEmails = intVal
            } else {
                showEmails = 0     // according to deltachat.h: show direct replies to chats only (default)
            }
            
        case .selfavatar: selfavatar = value
            
        case .e2eeEnabled:
            if let value = value, let boolVal = Bool(value) {
                e2eeEnabled = boolVal
            } else {
                e2eeEnabled = true
            }
            
        case .mdnsEnabled:
            if let value = value, let boolVal = Bool(value) {
                mdnsEnabled = boolVal
            } else {
                mdnsEnabled = true
            }

        case .inboxWatch:
            if let value = value, let boolVal = Bool(value) {
                inboxWatch = boolVal
            } else {
                inboxWatch = true
            }
            
        case .sentboxWatch:
            if let value = value, let boolVal = Bool(value) {
                sentboxWatch = boolVal
            } else {
                sentboxWatch = true
            }
            
        case .mvboxWatch:
            if let value = value, let boolVal = Bool(value) {
                mvboxWatch = boolVal
            } else {
                mvboxWatch = true
            }
            
        case .mvboxMove:
            if let value = value, let boolVal = Bool(value) {
                mvboxMove = boolVal
            } else {
                mvboxMove = true
            }

        default:
            log.error("key not found: \(key)")
            return 0
        }
        
        log.debug("setConfig for key: \(key), value: \(String(describing: value))")
        
        return 1
    }
    
    class var isConfigured: Bool {
        return 0 != dc_is_configured(DcContext.contextPointer)
    }
    
    class var displayname: String? {
        set { setConfig(DcConfigKey.displayname.rawValue, newValue) }
        get { return getConfig(DcConfigKey.displayname.rawValue) }
    }
    
    class var selfstatus: String? {
        set { setConfig(DcConfigKey.selfstatus.rawValue, newValue) }
        get { return getConfig(DcConfigKey.selfstatus.rawValue) }
    }
    
    class var selfavatar: String? {
        set { setConfig(DcConfigKey.selfavatar.rawValue, newValue) }
        get { return getConfig(DcConfigKey.selfavatar.rawValue) }
    }
    
    class var addr: String? {
        set { setConfig(DcConfigKey.addr.rawValue, newValue) }
        get { return getConfig(DcConfigKey.addr.rawValue) }
    }
    
    class var mailServer: String? {
        set { setConfig(DcConfigKey.mailServer.rawValue, newValue) }
        get { return getConfig(DcConfigKey.mailServer.rawValue) }
    }
    
    class var mailUser: String? {
        set { setConfig(DcConfigKey.mailUser.rawValue, newValue) }
        get { return getConfig(DcConfigKey.mailUser.rawValue) }
    }
    
    class var mailPw: String? {
        set { setConfig(DcConfigKey.mailPw.rawValue, newValue) }
        get { return getConfig(DcConfigKey.mailPw.rawValue) }
    }
    
    class var mailPort: String? {
        set { setConfig(DcConfigKey.mailPort.rawValue, newValue) }
        get { return getConfig(DcConfigKey.mailPort.rawValue) }
    }
    
    class var sendServer: String? {
        set { setConfig(DcConfigKey.sendServer.rawValue, newValue) }
        get { return getConfig(DcConfigKey.sendServer.rawValue) }
    }
    
    class var sendUser: String? {
        set { setConfig(DcConfigKey.sendUser.rawValue, newValue) }
        get { return getConfig(DcConfigKey.sendUser.rawValue) }
    }
    
    class var sendPw: String? {
        set { setConfig(DcConfigKey.sendPw.rawValue, newValue) }
        get { return getConfig(DcConfigKey.sendPw.rawValue) }
    }
    
    class var sendPort: String? {
        set { setConfig(DcConfigKey.sendPort.rawValue, newValue) }
        get { return getConfig(DcConfigKey.sendPort.rawValue) }
    }
    
    private class var serverFlags: Int {
        // IMAP-/SMTP-flags as a combination of DC_LP flags
        set {
            setConfig(DcConfigKey.serverFlags.rawValue, "\(newValue)")
        }
        get {
            if let str = getConfig(DcConfigKey.serverFlags.rawValue) {
                return Int(str) ?? 0
            } else {
                return 0
            }
        }
    }
    
    class func setImapSecurity(imapFlags flags: Int) {
        var sf = serverFlags
        sf = sf & ~0x700 // DC_LP_IMAP_SOCKET_FLAGS
        sf = sf | flags
        serverFlags = sf
    }
    
    class func setSmtpSecurity(smptpFlags flags: Int) {
        var sf = serverFlags
        sf = sf & ~0x70000 // DC_LP_SMTP_SOCKET_FLAGS
        sf = sf | flags
        serverFlags = sf
    }
    
    class func setAuthFlags(flags: Int) {
        var sf = serverFlags
        sf = sf & ~0x6 // DC_LP_AUTH_FLAGS
        sf = sf | flags
        serverFlags = sf
    }
    
    class func getImapSecurity() -> Int {
        var sf = serverFlags
        sf = sf & 0x700 // DC_LP_IMAP_SOCKET_FLAGS
        return sf
    }
    
    class func getSmtpSecurity() -> Int {
        var sf = serverFlags
        sf = sf & 0x70000  // DC_LP_SMTP_SOCKET_FLAGS
        return sf
    }
    
    class func getAuthFlags() -> Int {
        var sf = serverFlags
        sf = sf & 0x6 // DC_LP_AUTH_FLAGS
        serverFlags = sf
        return sf
    }
    
    class var e2eeEnabled: Bool {
        set { setConfigBool(DcConfigKey.e2eeEnabled.rawValue, newValue) }
        get { return getConfigBool(DcConfigKey.e2eeEnabled.rawValue) }
    }
    
    class var mdnsEnabled: Bool {
        set { setConfigBool(DcConfigKey.mdnsEnabled.rawValue, newValue) }
        get { return getConfigBool(DcConfigKey.mdnsEnabled.rawValue) }
    }
    
    class var inboxWatch: Bool {
        set { setConfigBool(DcConfigKey.inboxWatch.rawValue, newValue) }
        get { return getConfigBool(DcConfigKey.inboxWatch.rawValue) }
    }
    
    class var sentboxWatch: Bool {
        set { setConfigBool(DcConfigKey.sentboxWatch.rawValue, newValue) }
        get { return getConfigBool(DcConfigKey.sentboxWatch.rawValue) }
    }
    
    class var mvboxWatch: Bool {
        set { setConfigBool(DcConfigKey.mvboxWatch.rawValue, newValue) }
        get { return getConfigBool(DcConfigKey.mvboxWatch.rawValue) }
    }
    
    class var mvboxMove: Bool {
        set { setConfigBool(DcConfigKey.mvboxMove.rawValue, newValue) }
        get { return getConfigBool(DcConfigKey.mvboxMove.rawValue) }
    }
    
    class var showEmails: Int {
        // one of DC_SHOW_EMAILS_*
        set { setConfigInt(DcConfigKey.showEmails.rawValue, newValue) }
        get { return getConfigInt(DcConfigKey.showEmails.rawValue) }
    }
    
    
    class var configuredEmail: String {
        return getConfig("configured_addr") ?? ""
    }
    
    class var configuredMailServer: String {
        return getConfig("configured_mail_server") ?? ""
    }
    
    class var configuredMailUser: String {
        return getConfig("configured_mail_user") ?? ""
    }
    
    class var configuredMailPw: String {
        return getConfig("configured_mail_pw") ?? ""
    }
    
    class var configuredMailPort: String {
        return getConfig("configured_mail_port") ?? ""
    }
    
    class var configuredSendServer: String {
        return getConfig("configured_send_server") ?? ""
    }
    
    class var configuredSendUser: String {
        return getConfig("configured_send_user") ?? ""
    }
    
    class var configuredSendPw: String {
        return getConfig("configured_send_pw") ?? ""
    }
    
    class var configuredSendPort: String {
        return getConfig("configured_send_port") ?? ""
    }
    
    class var configuredServerFlags: String {
        return getConfig("configured_server_flags") ?? ""
    }
    
    class var configured: Bool {
        return getConfigBool("configured")
    }

}
