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

class MessageCallHandler: MethodCallHandler {

    // MARK: - Protocol MethodCallHandling

    override func handle(_ call: FlutterMethodCall, result: FlutterResult) {
        switch (call.method) {
        case Method.Message.GET_ID:
            getId(methodCall: call, result: result);
            break
        case Method.Message.GET_TEXT:
            getText(methodCall: call, result: result);
            break
        case Method.Message.GET_TIMESTAMP:
            getTimestamp(methodCall: call, result: result);
            break
        case Method.Message.GET_CHAT_ID:
            getChatId(methodCall: call, result: result);
            break
        case Method.Message.GET_FROM_ID:
            getFromId(methodCall: call, result: result);
            break
        case Method.Message.IS_OUTGOING:
            isOutgoing(methodCall: call, result: result);
            break
        case Method.Message.HAS_FILE:
            hasFile(methodCall: call, result: result);
            break
        case Method.Message.GET_TYPE:
            getType(methodCall: call, result: result);
            break
        case Method.Message.GET_FILE:
            getFile(methodCall: call, result: result);
            break
        case Method.Message.GET_FILE_BYTES:
            getFileBytes(methodCall: call, result: result);
            break
        case Method.Message.GET_FILENAME:
            getFileName(methodCall: call, result: result);
            break
        case Method.Message.GET_FILE_MIME:
            getFileMime(methodCall: call, result: result);
            break
        case Method.Message.GET_SUMMARY_TEXT:
            getSummaryText(methodCall: call, result: result);
            break
        case Method.Message.GET_STATE:
            getState(methodCall: call, result: result);
            break
        case Method.Message.IS_SETUP_MESSAGE:
            isSetupMessage(methodCall: call, result: result);
            break
        case Method.Message.IS_INFO:
            isInfo(methodCall: call, result: result);
            break
        case Method.Message.GET_SETUP_CODE_BEGIN:
            getSetupCodeBegin(methodCall: call, result: result);
        case Method.Message.SHOW_PADLOCK:
            showPadlock(methodCall: call, result: result);
            break
        case Method.Message.IS_STARRED:
            isStarred(methodCall: call, result: result);
            break
        default:
            log.error("Context: Failing for \(call.method)")
            _ = FlutterMethodNotImplemented
        }
    }
    
    
    private func isOutgoing(methodCall: FlutterMethodCall, result: FlutterResult) {
        //    DcMsg message = getMessage(methodCall, result);
        //    if (message == null) {
        //    resultErrorGeneric(methodCall, result);
        //    return;
        //    }
        //    result.success(message.isOutgoing());
    }
    
    private func hasFile(methodCall: FlutterMethodCall, result: FlutterResult) {
        //    DcMsg message = getMessage(methodCall, result);
        //    if (message == null) {
        //    resultErrorGeneric(methodCall, result);
        //    return;
        //    }
        //    result.success(message.hasFile());
    }
    
    private func getType(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_viewtype(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getFile(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_file(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getFileBytes(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_filebytes(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getFileName(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_filename(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getFileMime(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_filemime(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getFromId(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_from_id(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getChatId(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_chat_id(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getTimestamp(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_timestamp(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getText(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_text(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getId(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_id(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getSummaryText(methodCall: FlutterMethodCall, result: FlutterResult) {
        //    DcMsg message = getMessage(methodCall, result);
        //    if (message == null) {
        //    resultErrorGeneric(methodCall, result);
        //    return;
        //    }
        //    if (!hasArgumentKeys(methodCall, ARGUMENT_COUNT)) {
        //    resultErrorArgumentMissing(result);
        //    return;
        //    }
        //    Integer characterCount = methodCall.argument(ARGUMENT_COUNT);
        //    if (characterCount == null) {
        //    resultErrorArgumentMissingValue(result);
        //    return;
        //    }
        //    result.success(message.getSummarytext(characterCount));
    }
    
    private func isSetupMessage(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_is_setupmessage(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func isInfo(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_is_info(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getSetupCodeBegin(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_setupcodebegin(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getState(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_state(getMessage(methodCall: methodCall, result: result)))
    }
    
    
    private func showPadlock(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_get_showpadlock(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func isStarred(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_msg_is_starred(getMessage(methodCall: methodCall, result: result)))
    }
    
    private func getMessage(methodCall: FlutterMethodCall, result: FlutterResult) -> OpaquePointer? {
        let id = methodCall.intValue(for: Argument.ID, result: result)
        guard let message = dc_get_contact(DcContext.contextPointer, UInt32(id)) else { return nil }
        return message;
    }

}

