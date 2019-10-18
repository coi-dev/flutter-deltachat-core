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

fileprivate enum MimeType: String {
    // MARK: - Images
    case jpg       = "image/jpeg"
    case png       = "image/png"
    case gif       = "image/gif"
    case svg, svgz = "image/svg+xml"
    case webp      = "image/webp"
    case tif, tiff = "image/tiff"
    case wbmp      = "image/vnd.wap.wbmp"
    case ico       = "image/x-icon"
    case jng       = "image/x-jng"
    case bmp       = "image/x-ms-bmp"
    
    // MARK: - Audio
    case mp3       = "audio/mpeg"
    case ogg       = "audio/ogg"
    case m4a       = "audio/x-m4a"

    
    // MARK: - Video
    case mpeg, mpg = "video/mpeg"
    case mp4       = "video/mp4"
    case mov       = "video/quicktime"
    case webm      = "video/webm"
    case m4v       = "video/x-m4v"

    // MARK: - Other
    case bin, exe, dll, deb, dmg,
        iso, img, msi, msp, msm,
        numbers, pages, keynote = "application/octet-stream"
    case doc       = "application/msword"
    case pdf       = "application/pdf"
    case rtf       = "application/rtf"
    case m3u8      = "application/vnd.apple.mpegurl"
    case xls       = "application/vnd.ms-excel"
    case ppt       = "application/vnd.ms-powerpoint"
    case zip       = "application/zip"
    case docx      = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case xlsx      = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    case pptx      = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
}

fileprivate extension MimeType {
    
    init?(ext: String) {
        switch ext.lowercased() {
            case "jpg", "jpeg": self = .jpg
            case "png":         self = .png
            case "gif":         self = .gif
            case "svg", "svgz": self = .svg
            case "webp":        self = .webp
            case "tif", "tiff": self = .tif
            case "wbmp":        self = .wbmp
            case "ico":         self = .ico
            case "bmp":         self = .bmp
            case "mp3":         self = .mp3
            case "ogg":         self = .ogg
            case "m4a":         self = .m4a
            case "mpg", "mpeg": self = .mpg
            case "mp4":         self = .mp4
            case "mov":         self = .mov
            case "webm":        self = .webm
            case "m4v":         self = .m4v
            case "bin", "exe",
                 "dll", "deb",
                 "dmg", "iso",
                 "img", "msi",
                 "msp", "msm":  self = .bin
            case "doc":         self = .doc
            case "pdf":         self = .pdf
            case "rtf":         self = .rtf
            case "m3u8":        self = .m3u8
            case "xls":         self = .xls
            case "ppt":         self = .ppt
            case "zip":         self = .zip
            case "docx":        self = .docx
            case "xlsx":        self = .xlsx
            case "pptx":        self = .pptx
            case "pages":       self = .pages
            case "numbers":     self = .numbers
            case "keynote":     self = .keynote
            
            default:
                return nil
        }
    }

}

extension URL {

    var mimeType: String? {
        return MimeType(ext: self.pathExtension)?.rawValue
    }

}

extension String {

    var mimeType: String? {
        return URL(fileURLWithPath: self).mimeType
    }

}
