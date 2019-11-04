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

class ChatListCallHandler: MethodCallHandling {
    
    fileprivate let context: DcContext!
    
    fileprivate let chatCache: IdCache<DcChat>!
    fileprivate let chatListCache: IncrementalCache<DcChatlist> = IncrementalCache()
    
    fileprivate var chatList: DcChatlist!
    
    // MARK: - Initialization
    
    init(context: DcContext, chatCache: IdCache<DcChat>) {
        self.context = context
        self.chatCache = chatCache
    }

    // MARK: - Protocol MethodCallHandling
    
    func handle(_ call: FlutterMethodCall, result: FlutterResult) {
        if call.method != Method.ChatList.INTERNAL_SETUP {
            let cacheId = call.intValue(for: Argument.CACHE_ID, result: result)
            guard let chatList = chatListCache.value(for: UInt32(cacheId)) else {
                Method.Error.generic(methodCall: call, result: result)
                return
            }
            self.chatList = chatList
        }

        switch (call.method) {
            case Method.ChatList.INTERNAL_SETUP:
                setup(methodCall: call, result: result)
                break
            case Method.ChatList.INTERNAL_TEAR_DOWN:
                tearDown(methodCall: call, result: result)
                break
            case Method.ChatList.GET_ID:
                getChatId(chatList: chatList, methodCall: call, result: result)
                break
            case Method.ChatList.GET_CNT:
                getChatCnt(chatList: chatList, result: result)
                break
            case Method.ChatList.GET_CHAT:
                getChat(chatList: chatList, methodCall: call, result: result)
                break
            case Method.ChatList.GET_MSG_ID:
                getChatMsgId(chatList: chatList, methodCall: call, result: result)
                break
            case Method.ChatList.GET_MSG:
                getChatMsg(chatList: chatList, methodCall: call, result: result)
                break
            case Method.ChatList.GET_SUMMARY:
                getChatSummary(chatList: chatList, methodCall: call, result: result)
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
        let flags = methodCall.intValue(for: Argument.TYPE, result: result)
        let query = methodCall.stringValue(for: Argument.QUERY, result: result)
        let dcChatList = context.getChatlist(flags: flags, queryString: query, queryId: 0)
        let cacheId = chatListCache.add(object: dcChatList)

        result(NSNumber(value: cacheId))
    }
    
    fileprivate func tearDown(methodCall: FlutterMethodCall, result: FlutterResult) {
        let cacheId = methodCall.intValue(for: Argument.CACHE_ID, result: result)
        _ = chatListCache.removeValue(for: UInt32(cacheId))
        result(nil)
    }
    
    private func getChatId(chatList: DcChatlist, methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = methodCall.intValue(for: Argument.INDEX, result: result)
        let id = chatList.getChatId(index: UInt32(index))
        
        result(NSNumber(value: id))
    }
    
    private func getChatCnt(chatList: DcChatlist, result: FlutterResult) {
        result(chatList.length)
    }
    
    private func getChat(chatList: DcChatlist, methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = methodCall.intValue(for: Argument.INDEX, result: result)
        let chatId = chatList.getChatId(index: UInt32(index))
        
        if let chat = chatCache.value(for: chatId) {
            result(chat.id)
            return
        }
        
        let chat = chatList.getChat(for: chatId)
        chatCache.set(value: chat, for: chatId)
        
        result(NSNumber(value: chat.id))
    }
    
    private func getChatMsgId(chatList: DcChatlist, methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = methodCall.intValue(for: Argument.INDEX, result: result)
        let id = chatList.getMsgId(index: UInt32(index))
        
        result(NSNumber(value: id))
    }
    
    private func getChatMsg(chatList: DcChatlist, methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = methodCall.intValue(for: Argument.INDEX, result: result)
        let msg = chatList.getMsg(index: UInt32(index))
        
        result([msg])
    }
    
    private func getChatSummary(chatList: DcChatlist, methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = methodCall.intValue(for: Argument.INDEX, result: result)
        let summary = chatList.getSummary(index: Int(index))
        
        result(summary.propertyArray)
    }

}
