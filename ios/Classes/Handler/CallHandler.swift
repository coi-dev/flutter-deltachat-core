//
//  CallHandler.swift
//  delta_chat_core
//
//  Created by Cihan Oezkan on 12.08.19.
//

import UIKit

class CallHandler {
    
    var mailboxPointer: OpaquePointer!
    var chatList: OpaquePointer!
    var dcConfig: DCConfig = DCConfig()

    let dcContext: DCContext!

    // MARK: - Initialization

    init() {
        dcContext = DCContext("OX Coi iOS")
    }
}
