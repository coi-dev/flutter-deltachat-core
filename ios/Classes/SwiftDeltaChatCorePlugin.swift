import Flutter
import SwiftyBeaver
import UIKit

let log = SwiftyBeaver.self

public class SwiftDeltaChatCorePlugin: NSObject, FlutterPlugin {
    
    fileprivate let callHandler = CallHandler()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "deltaChatCore", binaryMessenger: registrar.messenger())
        let instance = SwiftDeltaChatCorePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        log.debug("MethodCall: \(call.method)")
        let methodPrefix = prefix(for: call.method)

        switch (methodPrefix) {
        case Method.Prefix.BASE:
            callHandler.handleBaseCalls(methodCall: call, result: result);
            break
        case Method.Prefix.CONTEXT:
            callHandler.handleContextCalls(methodCall: call, result: result)
            break
        case Method.Prefix.CHAT_LIST:
            callHandler.handleChatListCalls(methodCall: call, result: result)
            break
        case Method.Prefix.CHAT:
            callHandler.handleChatCalls(methodCall: call, result: result)
            break
        case Method.Prefix.CONTACT:
            callHandler.handleContactCalls(methodCall: call, result: result)
            break
        case Method.Prefix.MSG:
            callHandler.handleMessageCalls(methodCall: call, result: result);
            break
        default:
            log.debug("Failing for \(call.method)")
            _ = FlutterMethodNotImplemented
        }

    }
    
    // MARK: - Private Helper
    
    fileprivate func prefix(for methodCall: String) -> String {
        return String(methodCall.split(separator: Method.Prefix.SEPERATOR)[0])
    }
    
}
