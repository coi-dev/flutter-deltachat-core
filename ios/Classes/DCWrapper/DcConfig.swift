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

class DcConfig {

    private class func getConfig(_ key: DcConfigKey) -> String? {
        guard let cString = dc_get_config(DcContext.contextPointer, key.rawValue) else { return nil }
        let value = String(cString: cString)
        free(cString)
        if value.isEmpty {
            return nil
        }
        return value
    }
    
    private class func setConfig(_ key: DcConfigKey, _ value: String?) {
        if let value = value {
            dc_set_config(DcContext.contextPointer, key.rawValue, value)
        } else {
            dc_set_config(DcContext.contextPointer, key.rawValue, nil)
        }
    }
    
    private class func getConfigBool(_ key: DcConfigKey) -> Bool {
        return Utils.bool(for: getConfig(key))
    }
    
    private class func setConfigBool(_ key: DcConfigKey, _ value: Bool) {
        let vStr = value ? "1" : "0"
        setConfig(key, vStr)
    }
    
    private class func getConfigInt(_ key: DcConfigKey) -> Int {
        return Utils.int(for: getConfig(key))
    }
    
    private class func setConfigInt(_ key: DcConfigKey, _ value: Int) {
        setConfig(key, String(value))
    }
    
    private class func int(for value: String?, defaultValue: Int? = 0) -> Int {
        if let value = value, let intVal = Int(value) {
            return intVal
        } else {
            return defaultValue!
        }
    }

    class func set(key: DcConfigKey, value: String?) -> Int {
        var val = value
        
        switch key {
        case .addr:         addr         = val
        case .mailPw:
            mailPw = val
            val = "***"   // NOTE: this is just for hiding from logs

        case .mailUser:             mailUser          = val
        case .mailServer:           mailServer        = val
        case .mailPort:             mailPort          = val
        case .sendServer:           sendServer        = val
        case .sendUser:             sendUser          = val
        case .sendPort:             sendPort          = val
        case .sendPw:               sendPw            = val
        case .serverFlags:          serverFlags       = Utils.int(for: val)
        case .displayname:          displayname       = val
        case .selfstatus:           selfstatus        = val
        case .showEmails:           showEmails        = Utils.int(for: val)
        case .selfavatar:           selfavatar        = val
        case .e2eeEnabled:          e2eeEnabled       = Utils.bool(for: val)
        case .mdnsEnabled:          mdnsEnabled       = Utils.bool(for: val)
        case .inboxWatch:           inboxWatch        = Utils.bool(for: val)
        case .sentboxWatch:         sentboxWatch      = Utils.bool(for: val)
        case .mvboxWatch:           mvboxWatch        = Utils.bool(for: val)
        case .mvboxMove:            mvboxMove         = Utils.bool(for: val)
        case .rfc724MsgIdPrefix:    rfc724MsgIdPrefix = val
        default:
            log.error("key not found: \(key)")
            return 0
        }

        log.debug("setConfig for key: \(key), value: \(String(describing: val))")
        
        return 1
    }
    
    class var isConfigured: Bool {
        return 0 != dc_is_configured(DcContext.contextPointer)
    }
    
    class var displayname: String? {
        set { setConfig(.displayname, newValue) }
        get { return getConfig(.displayname) }
    }
    
    class var selfstatus: String? {
        set { setConfig(.selfstatus, newValue) }
        get { return getConfig(.selfstatus) }
    }
    
    class var selfavatar: String? {
        set { setConfig(.selfavatar, newValue) }
        get { return getConfig(.selfavatar) }
    }
    
    class var addr: String? {
        set { setConfig(.addr, newValue) }
        get { return getConfig(.addr) }
    }
    
    class var mailServer: String? {
        set { setConfig(.mailServer, newValue) }
        get { return getConfig(.mailServer) }
    }
    
    class var mailUser: String? {
        set { setConfig(.mailUser, newValue) }
        get { return getConfig(.mailUser) }
    }
    
    class var mailPw: String? {
        set { setConfig(.mailPw, newValue) }
        get { return getConfig(.mailPw) }
    }
    
    class var mailPort: String? {
        set { setConfig(.mailPort, newValue) }
        get { return getConfig(.mailPort) }
    }
    
    class var sendServer: String? {
        set { setConfig(.sendServer, newValue) }
        get { return getConfig(.sendServer) }
    }
    
    class var sendUser: String? {
        set { setConfig(.sendUser, newValue) }
        get { return getConfig(.sendUser) }
    }
    
    class var sendPw: String? {
        set { setConfig(.sendPw, newValue) }
        get { return getConfig(.sendPw) }
    }
    
    class var sendPort: String? {
        set { setConfig(.sendPort, newValue) }
        get { return getConfig(.sendPort) }
    }
    
    private class var serverFlags: Int {
        // IMAP-/SMTP-flags as a combination of DC_LP flags
        set {
            setConfig(.serverFlags, "\(newValue)")
        }
        get {
            if let str = getConfig(.serverFlags) {
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
        set { setConfigBool(.e2eeEnabled, newValue) }
        get { return getConfigBool(.e2eeEnabled) }
    }
    
    class var mdnsEnabled: Bool {
        set { setConfigBool(.mdnsEnabled, newValue) }
        get { return getConfigBool(.mdnsEnabled) }
    }
    
    class var inboxWatch: Bool {
        set { setConfigBool(.inboxWatch, newValue) }
        get { return getConfigBool(.inboxWatch) }
    }
    
    class var sentboxWatch: Bool {
        set { setConfigBool(.sentboxWatch, newValue) }
        get { return getConfigBool(.sentboxWatch) }
    }
    
    class var mvboxWatch: Bool {
        set { setConfigBool(.mvboxWatch, newValue) }
        get { return getConfigBool(.mvboxWatch) }
    }
    
    class var mvboxMove: Bool {
        set { setConfigBool(.mvboxMove, newValue) }
        get { return getConfigBool(.mvboxMove) }
    }
    
    class var showEmails: Int {
        set { setConfigInt(.showEmails, newValue) }
        get { return getConfigInt(.showEmails) }
    }
    
    class var rfc724MsgIdPrefix: String? {
        set { setConfig(.rfc724MsgIdPrefix, newValue) }
        get { return getConfig(.rfc724MsgIdPrefix) }
    }

    
    class var configuredEmail: String {
        return getConfig(.configuredEmail) ?? ""
    }
    
    class var configuredMailServer: String {
        return getConfig(.configuredMailServer) ?? ""
    }
    
    class var configuredMailUser: String {
        return getConfig(.configuredMailUser) ?? ""
    }
    
    class var configuredMailPw: String {
        return getConfig(.configuredMailPw) ?? ""
    }
    
    class var configuredMailPort: String {
        return getConfig(.configuredMailPort) ?? ""
    }
    
    class var configuredSendServer: String {
        return getConfig(.configuredSendServer) ?? ""
    }
    
    class var configuredSendUser: String {
        return getConfig(.configuredSendUser) ?? ""
    }
    
    class var configuredSendPw: String {
        return getConfig(.configuredSendPw) ?? ""
    }
    
    class var configuredSendPort: String {
        return getConfig(.configuredSendPort) ?? ""
    }
    
    class var configuredServerFlags: String {
        return getConfig(.configuredServerFlags) ?? ""
    }
    
    class var configured: Bool {
        return getConfigBool(.configured)
    }

}

enum DcConfigKey: String {
    case addr                  = "addr"
    case mailServer            = "mail_server"
    case mailUser              = "mail_user"
    case mailPw                = "mail_pw"
    case mailPort              = "mail_port"
    case sendServer            = "send_server"
    case sendUser              = "send_user"
    case sendPw                = "send_pw"
    case sendPort              = "send_port"
    case serverFlags           = "server_flags"
    case displayname           = "displayname"
    case selfstatus            = "selfstatus"
    case selfavatar            = "selfavatar"
    case e2eeEnabled           = "e2ee_enabled"
    case mdnsEnabled           = "mdns_enabled"
    case inboxWatch            = "inbox_watch"
    case sentboxWatch          = "sentbox_watch"
    case mvboxWatch            = "mvbox_watch"
    case mvboxMove             = "mvbox_move"
    case showEmails            = "show_emails"
    case saveMimeHeaders       = "save_mime_headers"
    case configuredEmail       = "configured_addr"
    case configuredMailServer  = "configured_mail_server"
    case configuredMailUser    = "configured_mail_user"
    case configuredMailPw      = "configured_mail_pw"
    case configuredMailPort    = "configured_mail_port"
    case configuredSendServer  = "configured_send_server"
    case configuredSendUser    = "configured_send_user"
    case configuredSendPw      = "configured_send_pw"
    case configuredSendPort    = "configured_send_port"
    case configuredServerFlags = "configured_server_flags"
    case configured            = "configured"
    case rfc724MsgIdPrefix     = "rfc724_msg_id_prefix"
}
