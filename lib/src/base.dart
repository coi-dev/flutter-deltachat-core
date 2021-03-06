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
  static const String argumentRemoveCacheIdentifier = "removeCacheIdentifier";
  static const String argumentCacheId = "cacheId";
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
  static const String argumentCount = "count";
  static final String argumentSetupCode = "setupCode";
  static const String argumentMessageId = "messageId";
  static const String argumentMessageIds = "messageIds";
  static const String argumentQrText = "qrText";
  static const String argumentJson = "json";
  static const String argumentMessage = "message";
  static const String argumentUid = "uid";
  static const String argumentMode = "mode";
  static const String argumentEnable = "enable";
  static const String argumentContentType = "contentType";
  static const String argumentContent = "content";
  static const String argumentMimeType = "mimeType";
  static const String argumentDuration = "duration";
  static const String argumentDir = "dir";
  static const String argumentMessageTypeOne = "messageTypeOne";
  static const String argumentMessageTypeTwo = "messageTypeTwo";
  static const String argumentMessageTypeThree = "messageTypeThree";

  final DeltaChatCore core = DeltaChatCore();

  Map<String, dynamic> _storedValues = Map();

  Map<String, bool> _loadedValues = Map();

  int _lastUpdate;

  Base() {
    setLastUpdate();
  }

  Future<void> loadValueAsync(String key, {Map<String, dynamic> arguments}) async {
    if (!isValueLoaded(key)) {
      _storedValues[key] = await core.invokeMethodAsync(key, arguments ?? getDefaultArguments());
      _loadedValues[key] = true;
    }
  }

  Future<dynamic> loadAndGetValueAsync(String key, {Map<String, dynamic> arguments}) async {
    await loadValueAsync(key, arguments: arguments);
    return _storedValues[key];
  }

  Future<void> loadValuesAsync({List<String> keys, Map<String, Map<String, dynamic>> keysAndArguments}) async {
    if (keys != null && keys.isNotEmpty) {
      await Future.forEach(keys, (key) async {
        await loadValueAsync(key);
      });
    } else if (keysAndArguments != null && keysAndArguments.isNotEmpty) {
      await Future.forEach(keysAndArguments.entries, (keysAndArgument) async {
        await loadValueAsync(keysAndArgument.key, arguments: keysAndArgument.value);
      });
    }
  }

  set(String key, value) {
    _storedValues[key] = value;
    _loadedValues[key] = true;
    setLastUpdate();
  }

  get(String key) {
    return _storedValues[key];
  }

  remove(String key) {
    _storedValues.remove(key);
    _loadedValues.remove(key);
  }

  Future<void> reloadValueAsync(String key, {Map<String, dynamic> arguments, bool removeFromJavaCache = true}) async {
    var value = get(key);
    var reloadArguments = arguments ?? getDefaultArguments();
    if (removeFromJavaCache) {
      reloadArguments.addAll(_getRemoveCacheIdentifierArguments());
      if (!reloadArguments.containsKey(argumentId) || !reloadArguments.containsKey(argumentRemoveCacheIdentifier)) {
        throw ArgumentError("$argumentId or $argumentRemoveCacheIdentifier is missing. Add required parameters to the reloadValue() call");
      }
    }
    _loadedValues.remove(key);
    var newValue = await loadAndGetValueAsync(key, arguments: reloadArguments);
    if (value != newValue) {
      setLastUpdate();
    }
  }

  Future<void> reloadValuesAsync({List<String> keys, Map<String, Map<String, dynamic>> keysAndArguments}) async {
    bool removeFromJavaCache = true;
    if (keys != null && keys.isNotEmpty) {
      Future.forEach(keys, (key) async {
        await reloadValueAsync(key, removeFromJavaCache: removeFromJavaCache);
        removeFromJavaCache = false;
      });
    } else if (keysAndArguments != null && keysAndArguments.isNotEmpty) {
      for (int index = 0; index < keysAndArguments.length; index++) {
        await reloadValueAsync(keysAndArguments.keys.elementAt(index),
            arguments: keysAndArguments.values.elementAt(index), removeFromJavaCache: removeFromJavaCache);
        removeFromJavaCache = false;
      }
    }
  }

  bool isValueLoaded(String key) => _loadedValues[key] ?? false;

  int get lastUpdate => _lastUpdate;

  void setLastUpdate() {
    _lastUpdate = DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, String> _getRemoveCacheIdentifierArguments() => {argumentRemoveCacheIdentifier: identifier};

  Map<String, dynamic> getDefaultArguments();

  int get id;

  String get identifier;
}
