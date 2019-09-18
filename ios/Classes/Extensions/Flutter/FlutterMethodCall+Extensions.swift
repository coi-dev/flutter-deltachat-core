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
            return [:]
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
    
    func intValue(for key: String, result: FlutterResult) -> Int {
        guard let arguments: MethodCallParameters = arguments as? MethodCallParameters else {
            fatalError("No arguments found for method: \(method)")
        }
        
        if !contains(keys: [key]) {
            Method.Error.missingArgument(result: result)
            fatalError()
        }
        
        guard let value: Int = arguments[key] as? Int else {
            Method.Error.noInt(for: key, result: result)
            fatalError()
        }
        
        return value
    }
    
    func value(for key: String, result: FlutterResult) -> Any? {
        if contains(keys: [key]) {
            return parameters[key]
        }

        Method.Error.missingArgument(result: result);
        return nil
    }
    
}
