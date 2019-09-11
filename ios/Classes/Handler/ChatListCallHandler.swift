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

class ChatListCallHandler: MethodCallHandler, MethodCallHandling {

    fileprivate var chatList: OpaquePointer!

    // MARK: - Protocol MethodCallHandling
    
    func handle(_ call: FlutterMethodCall, result: (Any?) -> Void) {
        switch (call.method) {
        case Method.ChatList.INTERNAL_SETUP:
            setup(methodCall: call, result: result)
            break
        case Method.ChatList.GET_ID:
            getChatId(methodCall: call, result: result)
            break
        case Method.ChatList.GET_CNT:
            getChatCnt(result: result)
            break
        case Method.ChatList.GET_CHAT:
            getChat(methodCall: call, result: result)
            break
        case Method.ChatList.GET_MSG_ID:
            getChatMsgId(dcChatlist: chatList, methodCall: call, result: result)
            break
        case Method.ChatList.GET_MSG:
            getChatMsg(dcChatlist: chatList, methodCall: call, result: result)
            break
        case Method.ChatList.GET_SUMMARY:
            getChatSummary(dcChatlist: chatList, methodCall: call, result: result)
            break
        case Method.ChatList.INTERNAL_TEAR_DOWN:
            tearDown(methodCall: call, result: result)
            break
        default:
            log.error("ChatList: Failing for \(call.method)")
            result(FlutterMethodNotImplemented)
            
        }
    }

    
    fileprivate func setup(methodCall: FlutterMethodCall, result: FlutterResult) {
        var chatListFlag: Int
        guard let args = methodCall.arguments else {
            return
        }
        if let myArgs = args as? [String: Any] {
            if let type = myArgs["type"] as? Int {
                chatListFlag = type
            } else {
                chatListFlag = 0
            }
            chatList = dc_get_chatlist(dcContext.contextPointer, Int32(chatListFlag), nil, 0)
            result(1)
        } else {
            Method.errorMissingArgument(result: result)
        }
        
        
    }
    
    private func getChatId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = methodCall.intValue(for: Argument.INDEX, result: result)
        let id = dc_chatlist_get_chat_id(chatList, index)
        
        result(id)
    }
    
    private func getChatCnt(result: FlutterResult) {
        result(dc_chatlist_get_cnt(chatList))
    }
    
    private func getChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = methodCall.intValue(for: Argument.INDEX, result: result)
        let chatId = dc_chatlist_get_chat_id(chatList, index)
        
        result(chatId)
    }
    
    private func getChatMsgId(dcChatlist: OpaquePointer, methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = methodCall.intValue(for: Argument.INDEX, result: result)
        
        result(dc_chatlist_get_msg_id(dcChatlist, index))
    }
    
    private func getChatMsg(dcChatlist: OpaquePointer, methodCall: FlutterMethodCall, result: FlutterResult) {
        // Not needed getChatMsg in Chatlist is not in use
        //        let index = getArgumentValueAsInt(methodCall: methodCall, result: result, argument: Argument.INDEX)
        //
        //        if (!isArgumentIntValueValid(value: index)) {
        //            resultErrorArgumentNoValidInt(result: result, argument: Argument.INDEX)
        //            return
        //        }
        //        let msg = dc_get_msg(dcChatlist, UInt32(index))
        //
        //    DcMsg msg = dcChatlist.getMsg(index);
        //    List<Object> msgResult = Collections.singletonList(msg);
        //    result.success(msgResult);
    }
    
    private func getChatSummary(dcChatlist: OpaquePointer, methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = methodCall.intValue(for: Argument.INDEX, result: result)
        let chat = dc_get_chat(dcChatlist, UInt32(index))
        let summary = dc_chatlist_get_summary(dcChatlist, index, chat)
        
        result(summary)
    }
    
    private func tearDown(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(nil);
    }
}
