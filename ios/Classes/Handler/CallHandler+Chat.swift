//
//  ChatCallHandler.swift
//  delta_chat_core
//
//  Created by Cihan Oezkan on 01.09.19.
//

import Foundation

extension CallHandler {
    
    public func handleChatCalls(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch (methodCall.method) {
        case Method.Chat.GET_ID:
            getChatId(methodCall: methodCall, result: result);
            break;
        case Method.Chat.IS_GROUP:
            isGroup(methodCall: methodCall, result: result);
            break;
        case Method.Chat.GET_ARCHIVED:
            getArchived(methodCall: methodCall, result: result);
            break;
        case Method.Chat.GET_COLOR:
            getColor(methodCall: methodCall, result: result);
            break;
        case Method.Chat.GET_NAME:
            getName(methodCall: methodCall, result: result);
            break;
        case Method.Chat.GET_SUBTITLE:
            getSubtitle(methodCall: methodCall, result: result);
            break;
        case Method.Chat.GET_PROFILE_IMAGE:
            getProfileImage(methodCall: methodCall, result: result);
            break;
        case Method.Chat.IS_UNPROMOTED:
            isUnpromoted(methodCall: methodCall, result: result);
            break;
        case Method.Chat.IS_SELF_TALK:
            isSelfTalk(methodCall: methodCall, result: result);
            break;
        case Method.Chat.IS_VERIFIED:
            isVerified(methodCall: methodCall, result: result);
            break;
        default:
            print("Context: Failing for \(methodCall.method)")
            _ = FlutterMethodNotImplemented
        }
    }
    
    private func isSelfTalk(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_is_self_talk(getChat(methodCall: methodCall, result: result)))
    }
    
    private func isUnpromoted(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_is_unpromoted(getChat(methodCall: methodCall, result: result)))
    }
    
    private func getProfileImage(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_profile_image(getChat(methodCall: methodCall, result: result)))
//    DcChat chat = getChat(methodCall, result);
//    if (chat == null) {
//    resultErrorGeneric(methodCall, result);
//    return;
//    }
//    result.success(chat.getProfileImage());
    }
    
    private func getSubtitle(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_subtitle(getChat(methodCall: methodCall, result: result)))

    }
    
    private func getName(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_name(getChat(methodCall: methodCall, result: result)))
    }
    
    private func getArchived(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_archived(getChat(methodCall: methodCall, result: result)))
    }
    
    private func getColor(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_color(getChat(methodCall: methodCall, result: result)))
    }
    
    private func isGroup(methodCall: FlutterMethodCall, result: FlutterResult) {
        // TODO : ???
        result(nil)
//    DcChat chat = getChat(methodCall, result);
//    if (chat == null) {
//    resultErrorGeneric(methodCall, result);
//    return;
//    }
//    result.success(chat.isGroup());
    }
    
    private func getChatId(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_chat_get_id(getChat(methodCall: methodCall, result: result)))
    }
    
    private func isVerified(methodCall: FlutterMethodCall, result: FlutterResult) {
        // TODO : ???
        result(dc_chat_is_verified(getChat(methodCall: methodCall, result: result)))
    }
    
    private func getChat(methodCall: FlutterMethodCall, result: FlutterResult) -> OpaquePointer {
        let id = getArgumentValueAsInt(methodCall: methodCall, result: result, argument: Argument.ID);
        let chat: OpaquePointer = dc_get_chat(mailboxPointer, UInt32(id))
        return chat;
    }
    
}
