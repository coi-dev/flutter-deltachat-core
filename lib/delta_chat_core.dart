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
import 'package:flutter/foundation.dart';
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
  static const String _channelDeltaChatCore = 'deltaChatCore';
  static const String _channelDeltaChatCoreEvents = 'deltaChatCoreEvents';

  static const String methodBaseInit = 'base_init';
  static const String methodBaseStart = "base_start";
  static const String methodBaseStop = "base_stop";
  static const String methodBaseLogout = "base_logout";

  static const String argumentDBName = "dbName";

  static DeltaChatCore _instance;

  final _logger = Logger("delta_chat_core");
  final MethodChannel _methodChannel;
  final _eventChannel = EventChannel(_channelDeltaChatCoreEvents);
  final _eventChannelSubscribers = Map<int, Map<int, StreamController>>();

  String _dbPath;
  String get dbPath => _dbPath;

  StreamSubscription _eventChannelSubscription;
  bool _init = false;

  factory DeltaChatCore() {
    if (_instance == null) {
      final methodChannel = MethodChannel(_channelDeltaChatCore);
      _instance = new DeltaChatCore._createInstance(methodChannel);
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

  Future<void> logout() async {
    await _methodChannel.invokeMethod(methodBaseLogout);
  }

  _setupEventChannelListener() {
    _eventChannelSubscription = _eventChannel.receiveBroadcastStream().listen((dynamic data) {
      Event event = Event.fromStream(data);
      _delegateEventToSubscribers(event);
    });
  }

  _delegateEventToSubscribers(Event event) {
    var logMessage = "Event - id: ${event.eventId}, data1: ${event.data1}, data2: ${event.data2}";
    _logger.fine(logMessage);
    _eventChannelSubscribers[event.eventId]?.forEach((_, streamController) {
      streamController.add(event);
    });
  }

  tearDown() {
    _eventChannelSubscription.cancel();
  }

  void addListener({int eventId, List<int> eventIdList, @required StreamController streamController}) {
    if (streamController == null || (eventId == null && eventIdList == null)) {
      throw ArgumentError("Either eventId or eventIdList must be set and a stream controller must be not null");
    }
    if (eventId != null && eventIdList != null) {
      throw ArgumentError("Either eventId or eventIdList must be set, dont't set both");
    }
    var streamControllerId = streamController.hashCode;
    if (_isAlreadyListening(streamControllerId)) {
      throw ArgumentError("Stream controller is already listening to events (use eventIdList to listen to multiple events with one listener)");
    }
    if (eventId != null) {
      _addEventIdSubscriber(eventId, streamController, streamControllerId);
    } else {
      for (eventId in eventIdList) {
        _addEventIdSubscriber(eventId, streamController, streamControllerId);
      }
    }
  }

  bool _isAlreadyListening(int streamControllerId) {
    bool _isAlreadyListening = false;
    _eventChannelSubscribers.forEach((_, eventIdSubscribers) {
      if (_isAlreadyListening) {
        return;
      }
      if (eventIdSubscribers.containsKey(streamControllerId)) {
        _isAlreadyListening = true;
      }
    });
    return _isAlreadyListening;
  }

  void _addEventIdSubscriber(int eventId, StreamController streamController, int streamControllerId) {
    var eventIdSubscribers = _eventChannelSubscribers[eventId];
    if (eventIdSubscribers == null) {
      eventIdSubscribers = Map();
      _eventChannelSubscribers[eventId] = eventIdSubscribers;
    }
    eventIdSubscribers[streamControllerId] = streamController;
  }

  void removeListener(StreamController streamController) {
    if (streamController == null) {
      throw ArgumentError("Stream controller must be not null");
    }
    var streamControllerId = streamController.hashCode;
    streamController.close();
    _eventChannelSubscribers.forEach((_, eventIdSubscribers) {
      eventIdSubscribers.remove(streamControllerId);
    });
  }

  // Manually adds events to the core stream. This shouldn't be required normally, as those events should be produced / captured by the
  // event channel listening to the DCC
  void addStreamEvent(Event event) {
    _delegateEventToSubscribers(event);
  }
}
