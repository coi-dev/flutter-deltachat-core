//
//  FlutterMethodCall+Extensions.swift
//  delta_chat_core
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
    
    func intValue(for key: String, result: FlutterResult) -> Int {
        guard let arguments: [String: Any] = arguments as? [String: Any] else {
            fatalError("No arguments found for method: \(method)")
        }
        
        if !contains(keys: [key]) {
            Method.errorMissingArgument(result: result)
            fatalError()
        }
        
        guard let value: Int = arguments[key] as? Int else {
            Method.errorNoInt(for: key, result: result)
            fatalError()
        }
        
        return value
    }
    
}
