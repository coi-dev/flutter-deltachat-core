//
//  ChatListCallHandler.swift
//  delta_chat_core
//
//  Created by Cihan Oezkan on 13.08.19.
//

import Foundation


extension CallHandler {
    
    func handleChatListCalls(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch (methodCall.method) {
        case Method.ChatList.INTERNAL_SETUP:
            setup(methodCall: methodCall, result: result)
            break
        case Method.ChatList.GET_ID:
            getChatId(methodCall: methodCall, result: result);
            break
        case Method.ChatList.GET_CNT:
            getChatCnt(result: result)
            break
        case Method.ChatList.GET_CHAT:
            getChat(methodCall: methodCall, result: result)
            break
        case Method.ChatList.GET_MSG_ID:
            getChatMsgId(dcChatlist: chatList, methodCall: methodCall, result: result)
            break
        case Method.ChatList.GET_MSG:
            getChatMsg(dcChatlist: chatList, methodCall: methodCall, result: result)
            break
        case Method.ChatList.GET_SUMMARY:
            getChatSummary(dcChatlist: chatList, methodCall: methodCall, result: result);
            break;
        case Method.ChatList.INTERNAL_TEAR_DOWN:
            tearDown(methodCall: methodCall, result: result)
            break
        default:
            print("ChatList: Failing for \(methodCall.method)")
            _ = FlutterMethodNotImplemented
            
        }
    }
    
    private func setup(methodCall: FlutterMethodCall, result: FlutterResult) {
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
            chatList = dc_get_chatlist(mailboxPointer, Int32(chatListFlag), nil, 0)
            result(1)
        } else {
            resultErrorArgumentMissing(result: result)
        }
        
        
    }
    
    private func getChatId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = getArgumentValueAsInt(methodCall: methodCall, result: result, argument: Argument.INDEX);
        
        if (!isArgumentIntValueValid(value: index)) {
            resultErrorArgumentNoInt(result: result, argument: Argument.INDEX)
            return;
        }
        let id = dc_chatlist_get_chat_id(chatList, index)
        result(id)
    }
    
    private func getChatCnt(result: FlutterResult) {
        result(dc_chatlist_get_cnt(chatList))
    }
    
    private func getChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = getArgumentValueAsInt(methodCall: methodCall, result: result, argument: Argument.INDEX);
        if (!isArgumentIntValueValid(value: index)) {
            resultErrorArgumentNoInt(result: result, argument: Argument.INDEX)
            return;
        }
        let chatId = dc_chatlist_get_chat_id(chatList, index)
        result(chatId)
    }
    
    private func getChatMsgId(dcChatlist: OpaquePointer, methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = getArgumentValueAsInt(methodCall: methodCall, result: result, argument: Argument.INDEX)
        
        if (!isArgumentIntValueValid(value: index)) {
            resultErrorArgumentNoValidInt(result: result, argument: Argument.INDEX)
            return
        }
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
        let index = getArgumentValueAsInt(methodCall: methodCall, result: result, argument: Argument.INDEX)
        
        if (!isArgumentIntValueValid(value: index)) {
            resultErrorArgumentNoValidInt(result: result, argument: Argument.INDEX)
            return
        }
        let chat = dc_get_chat(dcChatlist, UInt32(index))
        let summary = dc_chatlist_get_summary(dcChatlist, index, chat)
        result(summary)
    }
    
    private func tearDown(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(nil);
    }
    
    
    
    
}
