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
            Method.errorMissingArgument(result: result)
            fatalError()
        }
        
        guard let value: Int = arguments[key] as? Int else {
            Method.errorNoInt(for: key, result: result)
            fatalError()
        }
        
        return value
    }
    
    func value(for key: String, result: FlutterResult) -> Any? {
        if contains(keys: [key]) {
            return parameters[key]
        }

        Method.errorMissingArgument(result: result);
        return nil
    }
    
}
