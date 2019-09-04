//
//  ContactCallHandler.swift
//  delta_chat_core
//
//  Created by Cihan Oezkan on 01.09.19.
//

import Foundation

extension CallHandler {
    
    public func handleContactCalls(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch (methodCall.method) {
        case Method.Contact.GET_ID:
            getId(methodCall: methodCall, result: result);
            break
        case Method.Contact.GET_NAME:
            getName(methodCall: methodCall, result: result);
            break
        case Method.Contact.GET_DISPLAY_NAME:
            getDisplayName(methodCall: methodCall, result: result);
            break
        case Method.Contact.GET_FIRST_NAME:
            getFirstName(methodCall: methodCall, result: result);
            break
        case Method.Contact.GET_ADDRESS:
            getAddress(methodCall: methodCall, result: result);
            break
        case Method.Contact.GET_NAME_AND_ADDRESS:
            getNameAndAddress(methodCall: methodCall, result: result);
            break
        case Method.Contact.GET_PROFILE_IMAGE:
            getProfileImage(methodCall: methodCall, result: result);
            break
        case Method.Contact.GET_COLOR:
            getColor(methodCall: methodCall, result: result);
            break
        case Method.Contact.IS_BLOCKED:
            isBlocked(methodCall: methodCall, result: result);
            break
        case Method.Contact.IS_VERIFIED:
            isVerified(methodCall: methodCall, result: result);
            break
        default:
            print("Context: Failing for \(methodCall.method)")
            _ = FlutterMethodNotImplemented
        }
    }
    
    private func getId(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_contact_get_id(getContact(methodCall: methodCall, result: result)))
    }
    
    private func getName(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_contact_get_name(getContact(methodCall: methodCall, result: result)))
    }
    
    private func getDisplayName(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_contact_get_display_name(getContact(methodCall: methodCall, result: result)))
    }
    
    private func getFirstName(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_contact_get_first_name(getContact(methodCall: methodCall, result: result)))
    }
    
    
    private func getAddress(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_contact_get_addr(getContact(methodCall: methodCall, result: result)))
    }
    
    
    private func getNameAndAddress(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_contact_get_name_n_addr(getContact(methodCall: methodCall, result: result)))
    }
    
    private func getProfileImage(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_contact_get_profile_image(getContact(methodCall: methodCall, result: result)))
    }
    
    private func getColor(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_contact_get_color(getContact(methodCall: methodCall, result: result)))
    }
    
    private func isBlocked(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_contact_is_blocked(getContact(methodCall: methodCall, result: result)))
    }
    
    
    private func isVerified(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(dc_contact_is_verified(getContact(methodCall: methodCall, result: result)))
    }
    
    private func getContact(methodCall: FlutterMethodCall, result: FlutterResult) -> OpaquePointer {
        let id = methodCall.intValue(for: Argument.ID, result: result)
    
        return dc_get_contact(mailboxPointer, UInt32(id))
    }
    
}
