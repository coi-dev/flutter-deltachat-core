//
//  FlutterMethodCall+Extensions.swift
//  delta_chat_core
//
//  Created by Frank Gregor on 04.09.19.
//

import Foundation
import Flutter

typealias MethodCallParameters = [String: Any?]

extension MethodCallParameters {
}

extension FlutterMethodCall {
    
    // MARK: - Computed Properties
    
    var parameters: MethodCallParameters {
        guard let arguments: MethodCallParameters = arguments as? MethodCallParameters else {
            fatalError("No arguments found for method: \(method)")
        }
        return arguments
    }
    
    var methodPrefix: String {
        return String(method.split(separator: Method.Prefix.SEPERATOR)[0])
    }

    // MARK: - Helper

    func contains(keys: [String]) -> Bool {
        for key in keys {
            if (!parameters.keys.contains(key)) {
                return false
            }
        }
        return true
    }

    // MARK: - Parameter Values
    
    func intValue(for key: String, defaultValue: Int32 = 0, result: FlutterResult) -> Int32 {
        if !contains(keys: [key]) {
            return defaultValue
        }
        
        guard let value: Int32 = parameters[key] as? Int32 else {
            Method.Error.noInt(for: key, result: result)
            return defaultValue
        }
        
        return value
    }
    
    func boolValue(for key: String, defaultValue: Bool = false, result: FlutterResult) -> Bool {
        if !contains(keys: [key]) {
            return defaultValue
        }
        
        guard let value: Bool = parameters[key] as? Bool else {
            Method.Error.noBool(for: key, result: result)
            return defaultValue
        }
        
        return value
    }

    func stringValue(for key: String, result: FlutterResult) -> String? {
        if !contains(keys: [key]) {
            return nil
        }
        
        guard let value: String = parameters[key] as? String else {
            return nil
        }

        return value
    }
    
    func value(for key: String, result: FlutterResult) -> Any? {
        if contains(keys: [key]) {
            return parameters[key] as Any?
        }

        Method.Error.missingArgument(result: result);
        return nil
    }
    
}
