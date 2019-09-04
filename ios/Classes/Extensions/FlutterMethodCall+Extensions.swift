//
//  FlutterMethodCall+Extensions.swift
//  background_fetch
//
//  Created by Frank Gregor on 04.09.19.
//

import Foundation
import Flutter

extension FlutterMethodCall {
    
    func contains(keys: [String]) -> Bool {
        guard let arguments: [String: Any] = arguments as? [String: Any] else {
            return false
        }
        
        for key in keys {
            if (nil == arguments[key]) {
                return false
            }
        }
        
        return true
    }
    
}

/*
func hasArgumentKeys(methodCall: FlutterMethodCall, arguments: [String]) -> Bool {
    guard let args = methodCall.arguments else {
        return false
    }
    for argument in arguments {
        if let myArgs = args as? [String: Any] {
            if !(myArgs[argument] != nil) {
                return false
            }
        }
    }
    return true;
}
*/
