//
//  BaseCallHandler.swift
//  delta_chat_core
//
//  Created by Cihan Oezkan on 12.08.19.
//

import Foundation

extension CallHandler {

    // MARK: - Computed Properties
    
    fileprivate var dbFilePath: String {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        return "\(paths[0])/messenger.db"
    }

    // MARK: - Initializations
    
    fileprivate func baseInit(result : FlutterResult) {
        openDatabase()
        result(dbFilePath)
    }

    // MARK: - Method Call Handling
    
    public func handleBaseCalls(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch (methodCall.method) {
        case Method.Base.INIT:
            baseInit(result: result);
            break
        case Method.Base.SYSTEM_INFO:
            systemInfo(result: result);
            break
        case Method.Base.CORE_LISTENER:
            coreListener(methodCall: methodCall, result: result);
            break
        case Method.Base.SET_CORE_STRINGS:
            setCoreStrings(methodCall: methodCall, result: result);
            break
        default:
            log.error("Base: Failing for \(methodCall.method)")
            _ = FlutterMethodNotImplemented
        }
    }

    // MARK: - Private Helper

    // TODO : Schauen was hier passiert und methode selbsterklärend benennen
    fileprivate func openDatabase() {
        if mailboxPointer == nil {
            mailboxPointer = dc_context_new(nil, nil, "iOS")
            guard mailboxPointer != nil else {
                fatalError("Error: dc_context_new returned nil")
            }
        }
        _ = dc_open(mailboxPointer, dbFilePath, nil)
    }
    
    private func coreListener(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let add: Bool = methodCall.value(for: Argument.ADD, result: result) as? Bool,
            let eventId: Int = methodCall.value(for: Argument.EVENT_ID, result: result) as? Int else {
                result(nil)
                return
        }
        
        // Add a new Listener
        if true == add {
            let listenerId = Int(1 /* TODO: Add new Listener here */)
            result(listenerId)
        }
        
        // Remove a given Listener
        if let listenerId: Int = methodCall.value(for: Argument.LISTENER_ID, result: result) as? Int {
            // TODO: Add logic to remove the listener with listenerId
        }
        
        result(nil)

        //        Boolean add = methodCall.argument(ARGUMENT_ADD);
        //        Integer eventId = methodCall.argument(ARGUMENT_EVENT_ID);
        //        Integer listenerId = methodCall.argument(ARGUMENT_LISTENER_ID);
        //        if (eventId == null || add == null) {
        //        return;
        //        }
        //        if (add) {
        //        int newListenerId = eventChannelHandler.addListener(eventId);
        //        result.success(newListenerId);
        //        } else {
        //        if (listenerId == null) {
        //        return;
        //        }
        //        eventChannelHandler.removeListener(listenerId);
        //        result.success(null);
        //        }
    }
    
    fileprivate func systemInfo(result: FlutterResult) {
        result("success")
    }
    
    fileprivate func setCoreStrings(methodCall: FlutterMethodCall, result: FlutterResult) {
        // TODO: Ask Daniel for NativeInteractionManager
//        guard let coreStrings = methodCall.arguments else {
//            return
//        }
//
//    Map<Long, String> coreStrings = methodCall.arguments();
//    nativeInteractionManager.setCoreStrings(coreStrings);
//    result.success(null);
        result(nil)
    }
    
}
