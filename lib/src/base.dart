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
 * Copyright (C) 2016-2020 OX Software GmbH
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

import 'dart:async';

import 'package:delta_chat_core/delta_chat_core.dart';

abstract class Base {
  static const String argumentKey = "key";
  static const String argumentType = "type";
  static const String argumentValue = "value";
  static const String argumentAddress = "address";
  static const String argumentId = "id";
  static const String argumentVerified = "verified";
  static const String argumentName = "name";
  static const String argumentIndex = "index";
  static const String argumentFlags = "flags";
  static const String argumentQuery = "query";
  static const String argumentAddressBook = "addressBook";
  static const String argumentContactId = "contactId";
  static const String argumentChatId = "chatId";
  static const String argumentPath = "path";
  static const String argumentText = "text";

  final DeltaChatCore core = DeltaChatCore();

  Map<String, dynamic> _storedValues = Map();

  Map<String, bool> _loadedValues = Map();

  int _lastUpdate;

  Base() {
    setLastUpdate();
  }

  Future<void> loadValue(String key, var parameters) async {
    if (!isValueLoaded(key)) {
      _storedValues[key] = await core.invokeMethod(key, parameters);
      _loadedValues[key] = true;
    }
  }

  Future<dynamic> loadAndGetValue(String key, var parameters) async  {
    await loadValue(key, parameters);
    return _storedValues[key];
  }

  void loadValues({List<String> keys, Map<String, Map<String, dynamic>> keysAndParameters}) async {
    if (keys != null && keys.isNotEmpty) {
      Future.forEach(keys, (key) async {
        await loadValue(key, getDefaultParameters());
      });
    } else if (keysAndParameters != null && keysAndParameters.isNotEmpty) {
      for (int index = 0; index < keysAndParameters.length; index++) {
        await loadValue(keysAndParameters.keys.elementAt(index), keysAndParameters.values.elementAt(index));
      }
    }
  }

  set(String key, value) {
    _storedValues[key] = value;
    _loadedValues[key] = true;
    setLastUpdate();
  }

  prepareReloadValue(String key) {
    unloadValue(key);
    setLastUpdate();
  }

  unloadValue(String key) {
    _storedValues[key] = null;
    _loadedValues[key] = null;
  }

  bool isValueLoaded(String key) {
    return _loadedValues[key] != null && _loadedValues[key] != false;
  }

  resetValues() {
    _storedValues.clear();
    _loadedValues.clear();
  }

  int get lastUpdate => _lastUpdate;

  void setLastUpdate() {
    _lastUpdate = DateTime.now().millisecondsSinceEpoch;
  }

  getDefaultParameters();

}
