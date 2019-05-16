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

import 'package:delta_chat_core/src/types/event.dart';
import 'package:flutter/services.dart';

export 'src/base.dart';
export 'src/chat.dart';
export 'src/chatlist.dart';
export 'src/chatmsg.dart';
export 'src/contact.dart';
export 'src/context.dart';
export 'package:delta_chat_core/src/types/event.dart';
export 'package:delta_chat_core/src/types/chatsummary.dart';

class DeltaChatCore {
  static const String channelDeltaChatCore = 'deltaChatCore';
  static const String channelDeltaChatCoreEvents = 'deltaChatCoreEvents';

  static const String methodBaseInit = 'base_init';
  static const String methodBaseCoreListener = "base_coreListener";
  static const String methodBaseSetCoreStrings = "base_setCoreStrings";

  static const String argumentAdd = "add";
  static const String argumentEventId = "eventId";
  static const String argumentListenerId = "listenerId";

  static DeltaChatCore _instance;

  final MethodChannel _methodChannel;
  final _eventChannel = EventChannel(channelDeltaChatCoreEvents);
  final _eventChannelSubscribers = Map<int, Map<int, StreamController>>();

  StreamSubscription _eventChannelSubscription;
  bool _init = false;

  factory DeltaChatCore() {
    if (_instance == null) {
      final MethodChannel _methodChannel = MethodChannel(channelDeltaChatCore);
      _instance = new DeltaChatCore._createInstance(_methodChannel);
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

  Future<bool> init() async {
    if (!_init) {
      await _methodChannel.invokeMethod(methodBaseInit);
      _init = true;
    }
    _setupEventChannelListener();
    return _init;
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

  Future<int> listen(int eventId, StreamController streamController) async {
    int listenerId = await invokeMethod(methodBaseCoreListener, <String, dynamic>{argumentAdd: true, argumentEventId: eventId});
    var eventIdSubscribers = _eventChannelSubscribers[eventId];
    if (eventIdSubscribers == null) {
      eventIdSubscribers = Map();
      _eventChannelSubscribers[eventId] = eventIdSubscribers;
    }
    eventIdSubscribers[listenerId] = streamController;
    return listenerId;
  }

  delegateEventToSubscribers(Event event) {
    _eventChannelSubscribers[event.eventId].forEach((_, streamController) {
      streamController.add(event);
    });
  }

  delegateErrorToSubscribers(error) {}

  removeListener(int eventId, int listenerId) async {
    var eventIdSubscribers = _eventChannelSubscribers[eventId];
    eventIdSubscribers[listenerId].close();
    eventIdSubscribers.remove(listenerId);
    await invokeMethod(methodBaseCoreListener, <String, dynamic>{argumentAdd: false, argumentEventId: eventId, argumentListenerId: listenerId});
  }
}
