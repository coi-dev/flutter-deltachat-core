/*
 * OPEN-XCHANGE legal information
 *
 * All intellectual property rights in the Software are protected by
 * international copyright laws.
 *
 *
 * In some countries OX, OX Open-Xchange and open xchange
 * as well as the corresponding Logos OX Open-Xchange and OX are registered
 * trademarks of the OX Software GmbH group of companies.
 * The use of the Logos is not covered by the Mozilla Public License 2.0 (MPL 2.0).
 * Instead, you are allowed to use these Logos according to the terms and
 * conditions of the Creative Commons License, Version 2.5, Attribution,
 * Non-commercial, ShareAlike, and the interpretation of the term
 * Non-commercial applicable to the aforementioned license is published
 * on the web site https://www.open-xchange.com/terms-and-conditions/.
 *
 * Please make sure that third-party modules and libraries are used
 * according to their respective licenses.
 *
 * Any modifications to this package must retain all copyright notices
 * of the original copyright holder(s) for the original code used.
 *
 * After any such modifications, the original and derivative code shall remain
 * under the copyright of the copyright holder(s) and/or original author(s) as stated here:
 * https://www.open-xchange.com/legal/. The contributing author shall be
 * given Attribution for the derivative code and a license granting use.
 *
 * Copyright (C) 2016-2019 OX Software GmbH
 * Mail: info@open-xchange.com
 *
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the Mozilla Public License 2.0
 * for more details.
 */

import Foundation
import Flutter

typealias MethodCallParameters = [String: Any?]

extension MethodCallParameters {}

extension FlutterMethodCall {

    // MARK: - Computed Properties
    
    var parameters: MethodCallParameters? {
        guard let arguments: MethodCallParameters = arguments as? MethodCallParameters else {
            return nil
        }
        return arguments
    }

    var methodPrefix: String {
        return String(method.split(separator: Method.Prefix.SEPERATOR)[0])
    }

    // MARK: - Helper
    
    func contains(key: String) -> Bool {
        return contains(keys: [key])
    }
    
    func contains(keys: [String]) -> Bool {
        guard let parameters = parameters else {
            return false
        }
        
        for key in keys {
            if (!parameters.keys.contains(key)) {
                return false
            }
        }
        return true
    }

    // MARK: - Parameter Values

    func intValue(for key: String, defaultValue: Int32 = 0, result: FlutterResult) -> Int32 {
        guard let parameters = parameters else {
            return defaultValue
        }

        if !contains(keys: [key]) {
            Method.Error.missingArgument(result: result)
            return defaultValue
        }

        guard let value: Int32 = parameters[key] as? Int32 else {
            Method.Error.noInt(for: key, result: result)
            return defaultValue
        }

        return value
    }

    func boolValue(for key: String, defaultValue: Bool = false, result: FlutterResult) -> Bool {
        guard let parameters = parameters else {
            return defaultValue
        }

        if !contains(keys: [key]) {
            Method.Error.missingArgument(result: result)
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
            Method.Error.missingArgument(result: result)
            return nil
        }
        
        guard let parameters = parameters,
            let value: String = parameters[key] as? String else {
            return nil
        }

        return value
    }

    func intArrayValue(for key: String, result: FlutterResult) -> [UInt32]? {
        guard let parameters = parameters else {
            return nil
        }

        if !contains(keys: [key]) {
            Method.Error.missingArgument(result: result)
            return nil
        }

        guard let value: [UInt32] = parameters[key] as? [UInt32] else {
            Method.Error.noInt(for: key, result: result)
            return nil
        }

        return value
    }

    func value(for key: String, result: FlutterResult) -> Any? {
        guard let parameters = parameters else {
            return nil
        }

        if contains(keys: [key]) {
            return parameters[key] as Any?
        }

        Method.Error.missingArgument(result: result)
        return nil
    }

}
