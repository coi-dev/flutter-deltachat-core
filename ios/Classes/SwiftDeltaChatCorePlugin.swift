import Flutter
import UIKit

public class SwiftDeltaChatCorePlugin: NSObject, FlutterPlugin {
    
    var mailboxPointer: OpaquePointer!
    
    private let METHOD_PREFIX_SEPARATOR: Character = "_";
    private let METHOD_PREFIX_BASE = "base";
    private let METHOD_PREFIX_CONTEXT = "context";
    private let METHOD_PREFIX_CHAT_LIST = "chatList";
    private let METHOD_PREFIX_CHAT = "chat";
    private let METHOD_BASE_CORE_LISTENER = "base_coreListener";
    
    private let METHOD_BASE_INIT = "base_init";
    private let METHOD_CONFIG_SET = "context_configSet";
    private let METHOD_CONFIG_GET = "context_configGet";
    private let METHOD_IS_CONFIGURED = "context_isConfigured";
    private let METHOD_CREATE_CONTACT = "context_createContact";
    private let METHOD_CREATE_CHAT_BY_CONTACT_ID = "context_createChatByContactId";
    private let METHOD_CREATE_GROUP_CHAT = "context_createGroupChat";
    private let METHOD_ADD_CONTACT_TO_CHAT = "context_addContactToChat";
    private let METHOD_GET_CONTACTS = "context_getContacts";
    private let METHOD_GET_CHAT_CONTACTS = "context_getChatContacts";
    private let METHOD_GET_FRESH_MESSAGE_COUNT = "context_getFreshMessageCount";
    private let METHOD_MARK_NOTICED_CHAT = "context_markNoticedChat";
    private let METHOD_DELETE_CHAT = "context_deleteChat";
    
    private let METHOD_CHAT_LIST_INTERNAL_SETUP = "chatList_internal_setup";
    private let METHOD_CHAT_LIST_GET_ID = "chatList_getId";
    private let METHOD_CHAT_LIST_GET_CNT = "chatList_getCnt";
    private let METHOD_CHAT_LIST_GET_CHAT = "chatList_getChat";
    private let METHOD_CHAT_LIST_INTERNAL_TEAR_DOWN = "chatList_internal_tearDown";
    
    static let ARGUMENT_TYPE = "type";
    static let ARGUMENT_KEY = "key";
    static let ARGUMENT_VALUE = "value";
    
    static let ARGUMENT_ID = "id";
    static let ARGUMENT_ADDRESS = "address";
    let ARGUMENT_NAME = "name";
    let ARGUMENT_CONTACT_ID = "contactId";
    let ARGUMENT_INDEX = "index";
    let ARGUMENT_VERIFIED = "verified";
    let ARGUMENT_CHAT_ID = "chatId";
    let ARGUMENT_FLAGS = "flags";
    let ARGUMENT_QUERY = "query";
    
    private let ERROR_ARGUMENT_MISSING = "1"
    private let ERROR_ARGUMENT_TYPE_MISMATCH = "2"
    private let ERROR_ARGUMENT_MISSING_VALUE = "3"
    private let ERROR_ARGUMENT_NO_INT = "4"
    
    var chatList: Any?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "deltaChatCore", binaryMessenger: registrar.messenger())
    let instance = SwiftDeltaChatCorePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
     delegateMethodCall(methodCall: call, result: result);
    //result("iOS " + UIDevice.current.systemVersion)
  }
    
    func dbfile() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let documentsPath = paths[0]
        
        return documentsPath + "/messenger.db"
    }
    
    func open() {
        if mailboxPointer == nil {
            mailboxPointer = dc_context_new(nil, nil, "iOS")
            guard mailboxPointer != nil else {
                fatalError("Error: dc_context_new returned nil")
            }
        }
        _ = dc_open(mailboxPointer, dbfile(), nil)
    }
    
    private func delegateMethodCall(methodCall: FlutterMethodCall, result: FlutterResult) {
        print(methodCall.method)
        let methodPrefix = extractMethodPrefix(methodCall.method)
        
        switch (methodPrefix) {
        case METHOD_PREFIX_BASE:
            handleBaseCalls(methodCall: methodCall, result: result);
            break;
        case METHOD_PREFIX_CONTEXT:
            handleContextCalls(methodCall: methodCall, result: result)
            break
        case METHOD_PREFIX_CHAT_LIST:
            handleChatListCalls(methodCall: methodCall, result: result)
            break
        
        default:
            print("Failing for \(methodCall.method)")
            let notImplemented = FlutterMethodNotImplemented
            print(notImplemented)
        }
    }
    
    private func extractMethodPrefix(_ methodCall: String) -> String {
        return String(methodCall.split(separator: METHOD_PREFIX_SEPARATOR)[0])
    }
    
    private func handleBaseCalls(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch (methodCall.method) {
        case METHOD_BASE_INIT:
            baseinit(result: result);
            break;
        case METHOD_BASE_CORE_LISTENER:
            coreListener(methodCall: methodCall, result: result);
            break;
        default:
            print("Failing for \(methodCall.method)")
            let notImplemented = FlutterMethodNotImplemented
            
        }
    }
    
    private func handleContextCalls(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch (methodCall.method) {
        case METHOD_CONFIG_SET:
            setConfig(methodCall: methodCall, result: result)
            break;
        case METHOD_CONFIG_GET:
            getConfig(methodCall: methodCall, result: result)
            break;
        case METHOD_IS_CONFIGURED:
            print(dc_is_configured(mailboxPointer))
            result(nil)
            break;
        case METHOD_CREATE_CONTACT:
            createContact(methodCall: methodCall, result: result);
            break;
        case METHOD_CREATE_CHAT_BY_CONTACT_ID:
            createChatByContactId(methodCall: methodCall, result: result);
            break;
        case METHOD_CREATE_GROUP_CHAT:
            createGroupChat(methodCall: methodCall, result: result);
            break;
        case METHOD_ADD_CONTACT_TO_CHAT:
            addContactToChat(methodCall: methodCall, result: result);
            break;
        case METHOD_GET_CONTACTS:
            getContacts(methodCall: methodCall, result: result);
            break;
        case METHOD_GET_CHAT_CONTACTS:
            getChatContacts(methodCall: methodCall, result: result);
            break;
        case METHOD_GET_FRESH_MESSAGE_COUNT:
            getFreshMessageCount(methodCall: methodCall, result: result);
            break;
        case METHOD_MARK_NOTICED_CHAT:
            markNoticedChat(methodCall: methodCall, result: result);
            break;
        case METHOD_DELETE_CHAT:
            deleteChat(methodCall: methodCall, result: result);
            break;
        default:
            print("Failing for \(methodCall.method)")
            let notImplemented = FlutterMethodNotImplemented
            print(notImplemented)
        }
    }
    
    
    
    private func handleChatListCalls(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch (methodCall.method) {
        case METHOD_CHAT_LIST_INTERNAL_SETUP:
            setup(methodCall: methodCall, result: result);
            break;
        case METHOD_CHAT_LIST_GET_ID:
            getChatId(methodCall: methodCall, result: result);
            break;
        case METHOD_CHAT_LIST_GET_CNT:
            getChatCnt(result: result);
            break;
        case METHOD_CHAT_LIST_GET_CHAT:
            getChat(methodCall: methodCall, result: result);
            break;
        case METHOD_CHAT_LIST_INTERNAL_TEAR_DOWN:
            tearDown(methodCall: methodCall, result: result);
            break;
        default:
            print("Failing for \(methodCall.method)")
            let notImplemented = FlutterMethodNotImplemented
            
        }
    }

    private func baseinit(result : FlutterResult) {
        open()
        result("Hallo WElt")
    }
    
    private func coreListener(methodCall: FlutterMethodCall, result: FlutterResult) {
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
        result(nil)
    }
    
    private func setConfig(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            return
        }
        if let myArgs = args as? [String: Any], let someInfo1 = myArgs["key"] as? String, let someInfo2 = myArgs["value"] as? String {
            dc_set_config(mailboxPointer, someInfo1, someInfo2)
            result("nil")
        } else {
            result("iOS could not extract flutter arguments in method: (sendParams)")
        }
    }
    
    private func getConfig(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            return
        }
        if let myArgs = args as? [String: Any], let someInfo1 = myArgs["key"] as? String {
            print("config: \(someInfo1)")
            let value = dc_get_config(mailboxPointer, someInfo1)
            if let pSafe = value {
                let c = String(cString: pSafe)
                print(c)
                result(c)
            }
            
        } else {
            result("iOS could not extract flutter arguments in method: (sendParams)")
        }
    }

    private func createContact(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            return
        }
        print(args);
        if let myArgs = args as? [String: Any], let address = myArgs["address"] as? String {
            let name = myArgs["name"] as? String
            let contactId = dc_create_contact(mailboxPointer, name, address)
            result(Int(contactId))
        } else {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
        }
    }
    
    private func createChatByContactId(methodCall: FlutterMethodCall, result: FlutterResult) {
        
        guard let args = methodCall.arguments else {
            return
        }
       
        print("chatbycontact: \(args)")
        if let myArgs = args as? [String: Any], let contactId = myArgs["id"] as? UInt32 {
            print(contactId)
            let chatId = dc_create_chat_by_contact_id(mailboxPointer, contactId)
            print("chatId: \(chatId)")
            result(Int(chatId))
        } else {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
        }
    
    }
    
    private func setup(methodCall: FlutterMethodCall, result: FlutterResult) {
        var chatListFlag: Int
        guard let args = methodCall.arguments else {
            return
        }
        print(args)
        if let myArgs = args as? [String: Any] {
            if let type = myArgs["type"] as? Int {
                chatListFlag = type
            } else {
                chatListFlag = 0
            }
            let query = myArgs["query"]
            chatList = dc_get_chatlist(mailboxPointer, Int32(chatListFlag), nil, 0)
            print("chatlist: \(chatList)")
            result(1)
        } else {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
        }
        
        
    }
    
    private func getChatId(methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = getArgumentValueAsInt(methodCall: methodCall, result: result, argument: ARGUMENT_INDEX);
        
        if (!isArgumentIntValueValid(value: index)) {
            result(FlutterError(code: ERROR_ARGUMENT_NO_INT, message: "", details: nil))
            return;
        }
        var id = dc_chatlist_get_chat_id(chatList as! OpaquePointer, index)
        result(id)
        print("id: \(id)")
    }
    
    private func getChatCnt(result: FlutterResult) {
        print("get count: \(dc_chatlist_get_cnt(chatList as! OpaquePointer))")
        result(dc_chatlist_get_cnt(chatList as! OpaquePointer))
    }
    
    private func getChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        let index = getArgumentValueAsInt(methodCall: methodCall, result: result, argument: ARGUMENT_INDEX);
        if (!isArgumentIntValueValid(value: index)) {
            result(FlutterError(code: ERROR_ARGUMENT_NO_INT, message: "", details: nil))
            return;
        }
        let chatId = dc_chatlist_get_chat_id(chatList as! OpaquePointer, index)
        print("chatId: \(chatId)")
        result(chatId)
    }
    
    private func tearDown(methodCall: FlutterMethodCall, result: FlutterResult) {
        result(nil);
    }
    
    private func createGroupChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        if (!hasArgumentKeys(methodCall: methodCall, arguments: [ARGUMENT_VERIFIED, ARGUMENT_NAME])) {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
            return;
        }
        if let myArgs = args as? [String: Any] {
            let verified = myArgs[ARGUMENT_VERIFIED] as? Bool
            print(verified)
            if (verified == nil) {
                result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
                return;
            }
            let name = myArgs[ARGUMENT_NAME] as? String
            let chatId = dc_create_group_chat(mailboxPointer, Int32(truncating: verified! as NSNumber), name)
            print("chatId: \(chatId)")
            result(chatId)
        }
    }
    
    private func addContactToChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        if (!hasArgumentKeys(methodCall: methodCall, arguments: [ARGUMENT_CHAT_ID, ARGUMENT_CONTACT_ID])) {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
            return;
        }
        if let myArgs = args as? [String: Any] {
            let chatId = myArgs[ARGUMENT_CHAT_ID] as? UInt32
            let contactId = myArgs[ARGUMENT_CONTACT_ID] as? UInt32
            if (chatId == nil || contactId == nil) {
                result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
                return;
            }
            let successfullyAdded = dc_add_contact_to_chat(mailboxPointer, chatId!, contactId!)
            result(successfullyAdded)
            print(successfullyAdded)
        }
    
    }
    
    private func getContacts(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        if (!hasArgumentKeys(methodCall: methodCall, arguments: [ARGUMENT_FLAGS, ARGUMENT_QUERY])) {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
            return;
        }
        if let myArgs = args as? [String: Any] {
            let flags = myArgs[ARGUMENT_FLAGS] as? UInt32
            let query = myArgs[ARGUMENT_QUERY]  as? String
            if (flags == nil) {
                result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
                return;
            }
            
            var contactIds = dc_get_contacts(mailboxPointer, flags!, query)
            print("contactIds: \(dc_get_contacts(mailboxPointer, flags!, query))")
            
            result(FlutterStandardTypedData(int32: Data(bytes: &contactIds, count: MemoryLayout.size(ofValue: contactIds))))
        }
    
    }
    
    private func getChatContacts(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        if (!hasArgumentKeys(methodCall: methodCall, arguments: [ARGUMENT_CHAT_ID])) {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
            return;
        }
        if let myArgs = args as? [String: Any] {
            let id = myArgs[ARGUMENT_CHAT_ID] as? UInt32
            if id == nil {
                result(FlutterError(code: ERROR_ARGUMENT_MISSING_VALUE, message: "", details: nil))
                return
            }
            var contactIds = dc_get_chat_contacts(mailboxPointer, id!)
            result(FlutterStandardTypedData(int32: Data(bytes: &contactIds, count: MemoryLayout.size(ofValue: contactIds))))
        }
    
    }
    
    private func getFreshMessageCount(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        if (!hasArgumentKeys(methodCall: methodCall, arguments: [ARGUMENT_CHAT_ID])) {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING_VALUE, message: "", details: nil))
            return;
        }
        if let myArgs = args as? [String: Any] {
            let chatId = myArgs[ARGUMENT_CHAT_ID] as? UInt32
            if chatId == nil {
                result(FlutterError(code: ERROR_ARGUMENT_MISSING_VALUE, message: "", details: nil))
                return
            }
            let freshMessageCount = dc_get_fresh_msg_cnt(mailboxPointer, chatId!)
            result(freshMessageCount)
        }
    
    }
    
    private func markNoticedChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        if (!hasArgumentKeys(methodCall: methodCall, arguments: [ARGUMENT_CHAT_ID])) {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING_VALUE, message: "", details: nil))
            return;
        }
        if let myArgs = args as? [String: Any] {
            let chatId = myArgs[ARGUMENT_CHAT_ID] as? UInt32
            if chatId == nil {
                result(FlutterError(code: ERROR_ARGUMENT_MISSING_VALUE, message: "", details: nil))
                return
            }
            dc_marknoticed_chat(mailboxPointer, chatId!)
            result(nil)
        }
        
    }
    
    private func deleteChat(methodCall: FlutterMethodCall, result: FlutterResult) {
        guard let args = methodCall.arguments else {
            fatalError()
        }
        if (!hasArgumentKeys(methodCall: methodCall, arguments: [ARGUMENT_CHAT_ID])) {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING_VALUE, message: "", details: nil))
            return;
        }
        if let myArgs = args as? [String: Any] {
            let chatId = myArgs[ARGUMENT_CHAT_ID] as? UInt32
            if chatId == nil {
                result(FlutterError(code: ERROR_ARGUMENT_MISSING_VALUE, message: "", details: nil))
                return
            }
            dc_delete_chat(mailboxPointer, chatId!)
            result(nil)
        }
    
    }
    
    private func getFreshMessages(result: FlutterResult) {
        let freshMessages = dc_get_fresh_msgs(chatList as! OpaquePointer)
        result(freshMessages)
    }
    
//    private func copyAndFreeArray(inputArray: OpaquePointer?) -> FlutterStandardTypedData {
//        var acc = [FlutterStandardTypedData]()
//        let len = dc_array_get_cnt(inputArray)
//        for i in 0 ..< len {
//            var e = dc_array_get_id(inputArray, i)
//            acc.append(FlutterStandardTypedData(int32: Data(bytes: &e, count: MemoryLayout.size(ofValue: e))))
//        }
//        dc_array_unref(inputArray)
//
//        return acc
//    }
    
    private func getArgumentValueAsInt(methodCall: FlutterMethodCall, result: FlutterResult, argument: String) -> Int {
        var id: Int?
        guard let args = methodCall.arguments else {
            fatalError()
        }
        print(args)
        
        if (!hasArgumentKeys(methodCall: methodCall, arguments: [argument])) {
            result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
             print(id)
        }
        
        
        if let myArgs = args as? [String: Any], let argID = myArgs[argument] {
            id = argID as? Int
             print(id)
        }
        
        if (!isArgumentIntValueValid(value: id)) {
             print(id)
            result(FlutterError(code: ERROR_ARGUMENT_MISSING, message: "", details: nil))
            
        }
        print(id)
        return id!
        
    }
    
    private func isArgumentIntValueValid(value: Int?) -> Bool {
        return value != nil;
    }
    
    private func hasArgumentKeys(methodCall: FlutterMethodCall, arguments: [String]) -> Bool {
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
    
}



