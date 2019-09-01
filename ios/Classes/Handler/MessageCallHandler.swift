//
//  MessageCallHandler.swift
//  delta_chat_core
//
//  Created by Cihan Oezkan on 01.09.19.
//

import Foundation

extension CallHandler {
    
    public func handleMessageCalls(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch (methodCall.method) {
        case Method.Message.GET_ID:
            getId(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_TEXT:
            getText(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_TIMESTAMP:
            getTimestamp(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_CHAT_ID:
            getChatId(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_FROM_ID:
            getFromId(methodCall: methodCall, result: result);
            break;
        case Method.Message.IS_OUTGOING:
            isOutgoing(methodCall: methodCall, result: result);
            break;
        case Method.Message.HAS_FILE:
            hasFile(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_TYPE:
            getType(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_FILE:
            getFile(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_FILE_BYTES:
            getFileBytes(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_FILENAME:
            getFileName(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_FILE_MIME:
            getFileMime(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_SUMMARY_TEXT:
            getSummaryText(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_STATE:
            getState(methodCall: methodCall, result: result);
            break;
        case Method.Message.IS_SETUP_MESSAGE:
            isSetupMessage(methodCall: methodCall, result: result);
            break;
        case Method.Message.IS_INFO:
            isInfo(methodCall: methodCall, result: result);
            break;
        case Method.Message.GET_SETUP_CODE_BEGIN:
            getSetupCodeBegin(methodCall: methodCall, result: result);
        case Method.Message.SHOW_PADLOCK:
            showPadlock(methodCall: methodCall, result: result);
            break;
        case Method.Message.IS_STARRED:
            isStarred(methodCall: methodCall, result: result);
            break;
        default:
            print("Context: Failing for \(methodCall.method)")
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
        let id = getArgumentValueAsInt(methodCall: methodCall, result: result, argument: Argument.ID);
        guard let message = dc_get_contact(mailboxPointer, UInt32(id)) else { return nil }
        return message;
    }
    
}
