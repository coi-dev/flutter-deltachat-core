//
//  CallHandler.swift
//  delta_chat_core
//
//  Created by Cihan Oezkan on 12.08.19.
//

import Flutter
import UIKit

class CallHandler {
    
    var mailboxPointer: OpaquePointer!
    var chatList: OpaquePointer!

    func resultErrorArgumentMissing(result: FlutterResult) {
        result(FlutterError(code: Argument.Error.MISSING, message: "Argument is missing", details: nil))
    }
    
    func resultErrorArgumentTypeMismatch(result: FlutterResult, argument: String) {
        result(FlutterError(code: Argument.Error.TYPE_MISMATCH, message: "Wrong type for argument " + argument, details: nil))
    }
    
    func resultErrorArgumentMissingValue(result: FlutterResult) {
        result(FlutterError(code: Argument.Error.MISSING_VALUE, message: "Argument value is missing or null", details: nil))
    }
    
    func resultErrorArgumentNoInt(result: FlutterResult, argument: String) {
        result(FlutterError(code: Argument.Error.NO_INT, message: "Argument is no integer: " + argument, details: nil))
    }
    
    func resultErrorArgumentNoValidInt(result: FlutterResult, argument: String) {
        result(FlutterError(code: Argument.Error.NO_INT, message: "Argument has no valid int value: " + argument, details: nil))
    }
    
    func resultErrorGeneric(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(FlutterError(code: methodCall.method, message: nil, details: nil));
    }
    
//    func hasArgumentKeys(methodCall: FlutterMethodCall, arguments: [String]) -> Bool {
//        guard let args = methodCall.arguments else {
//            return false
//        }
//        for argument in arguments {
//            if let myArgs = args as? [String: Any] {
//                if !(myArgs[argument] != nil) {
//                    return false
//                }
//            }
//        }
//        return true;
//    }
    
    func getArgumentValueAsInt(methodCall: FlutterMethodCall, result: FlutterResult, argument: String) -> Int {
        var id: Int?
        guard let args = methodCall.arguments else {
            fatalError()
        }
        
        if !methodCall.contains(keys: [argument]) {
            resultErrorArgumentMissing(result: result)
        }
        
        
        if let myArgs = args as? [String: Any], let argID = myArgs[argument] {
            id = argID as? Int
        }
        
        if (!isArgumentIntValueValid(value: id)) {
            resultErrorArgumentMissing(result: result)
            
        }
        return id!
        
    }
    
    func isArgumentIntValueValid(value: Int?) -> Bool {
        return value != nil;
    }
    
}
