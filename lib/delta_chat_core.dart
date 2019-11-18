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

import 'package:delta_chat_core/src/log.dart';
import 'package:delta_chat_core/src/types/event.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

export 'package:delta_chat_core/src/types/chat_summary.dart';
export 'package:delta_chat_core/src/types/event.dart';
export 'package:delta_chat_core/src/types/qrcode_result.dart';

export 'src/base.dart';
export 'src/chat.dart';
export 'src/chatlist.dart';
export 'src/chatmsg.dart';
export 'src/contact.dart';
export 'src/context.dart';

class DeltaChatCore {
  static const String channelDeltaChatCore = 'deltaChatCore';
  static const String channelDeltaChatCoreEvents = 'deltaChatCoreEvents';

  static const String methodBaseInit = 'base_init';
  static const String methodBaseSetCoreStrings = "base_setCoreStrings";
  static const String methodBaseStart = "base_start";
  static const String methodBaseStop = "base_stop";

  static const String argumentDBName = "dbName";

  static DeltaChatCore _instance;

  final _logger = Logger("delta_chat_core");
  final MethodChannel _methodChannel;
  final _eventChannel = EventChannel(channelDeltaChatCoreEvents);
  final _eventChannelSubscribers = Map<int, Map<int, StreamController>>();
  String _dbPath;

  String get dbPath => _dbPath;

  StreamSubscription _eventChannelSubscription;
  bool _init = false;

  factory DeltaChatCore() {
    if (_instance == null) {
      final MethodChannel _methodChannel = MethodChannel(channelDeltaChatCore);
      _instance = new DeltaChatCore._createInstance(_methodChannel);
      setupLogger();
    }
    return _instance;
  }

  DeltaChatCore._createInstance(this._methodChannel);

  Future<dynamic> invokeMethod(String method, [dynamic arguments]) async {
    if (!_init) {
      throw StateError("Core isn't initialized, couldn't perform invokeMethod for " + method);
    }
    return _methodChannel.invokeMethod(method, arguments);
  }

  Future<bool> init(String dbName) async {
    if (!_init) {
      _dbPath = await _methodChannel.invokeMethod(methodBaseInit, <String, dynamic>{argumentDBName: dbName});
      _init = true;
      _setupEventChannelListener();
    }
    return _init;
  }

  Future<void> start() async {
    await _methodChannel.invokeMethod(methodBaseStart);
  }

  Future<void> stop() async {
    await _methodChannel.invokeMethod(methodBaseStop);
  }

  _setupEventChannelListener() {
    _eventChannelSubscription = _eventChannel.receiveBroadcastStream().listen((dynamic data) {
      Event event = Event.fromStream(data);
      delegateEventToSubscribers(event);
    }, onError: (dynamic error) {
      delegateErrorToSubscribers(error);
    });
  }

  tearDown() {
    _eventChannelSubscription.cancel();
  }

  Future<void> setCoreStrings(Map<int, String> coreStrings) async {
    await _methodChannel.invokeMethod(methodBaseSetCoreStrings, coreStrings);
  }

  Future<void> listen(int eventId, StreamController streamController) async {
    if (eventId == null || streamController == null) {
      return;
    }
    var eventIdSubscribers = _eventChannelSubscribers[eventId];
    if (eventIdSubscribers == null) {
      eventIdSubscribers = Map();
      _eventChannelSubscribers[eventId] = eventIdSubscribers;
    }
    eventIdSubscribers[streamController.hashCode] = streamController;
  }

  delegateEventToSubscribers(Event event) {
    var logMessage = "Event - id: ${event.eventId}, data1: ${event.data1}, data2: ${event.data2}";
    _logger.fine(logMessage);
    _eventChannelSubscribers[event.eventId]?.forEach((_, streamController) {
      streamController.add(event);
    });
  }

  delegateErrorToSubscribers(error) {}

  removeListener(int eventId, StreamController streamController) async {
    if (eventId == null || streamController == null) {
      return;
    }
    int hashCode = streamController.hashCode;
    streamController.close();
    var eventIdSubscribers = _eventChannelSubscribers[eventId];
    eventIdSubscribers?.remove(hashCode);
  }

  // Manually adds events to the core stream. This shouldn't be required normally, as those events should be produced / captured by the
  // event channel listening to the DCC
  void addStreamEvent(Event event) {
    delegateEventToSubscribers(event);
  }
}
