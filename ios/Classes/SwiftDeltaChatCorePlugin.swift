import Flutter
import UIKit

public class SwiftDeltaChatCorePlugin: NSObject, FlutterPlugin {
    
    let callHandler = CallHandler()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "deltaChatCore", binaryMessenger: registrar.messenger())
        let instance = SwiftDeltaChatCorePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        delegateMethodCall(methodCall: call, result: result)
    }
    
    private func delegateMethodCall(methodCall: FlutterMethodCall, result: FlutterResult) {
        print("MethodCall: \(methodCall.method)")
        let methodPrefix = extractMethodPrefix(methodCall.method)
        switch (methodPrefix) {
        case Method.Prefix.BASE:
            callHandler.handleBaseCalls(methodCall: methodCall, result: result);
            break;
        case Method.Prefix.CONTEXT:
            callHandler.handleContextCalls(methodCall: methodCall, result: result)
            break
        case Method.Prefix.CHAT_LIST:
            callHandler.handleChatListCalls(methodCall: methodCall, result: result)
            break
        case Method.Prefix.CHAT:
            callHandler.handleChatCalls(methodCall: methodCall, result: result)
            break
        case Method.Prefix.CONTACT:
            callHandler.handleContactCalls(methodCall: methodCall, result: result)
            break
        case Method.Prefix.MSG:
            callHandler.handleMessageCalls(methodCall: methodCall, result: result);
            break;
        default:
            print("Failing for \(methodCall.method)")
            _ = FlutterMethodNotImplemented
        }
    }
    
    private func extractMethodPrefix(_ methodCall: String) -> String {
        return String(methodCall.split(separator: Method.Prefix.SEPERATOR)[0])
    }
    
}



