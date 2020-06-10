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

import 'package:delta_chat_core/src/base.dart';

class ChatMsg extends Base {
  static const String _identifier = "chatMessage";
  static const String methodMessageGetId = "msg_getId";
  static const String methodMessageGetText = "msg_getText";
  static const String methodMessageGetTimestamp = "msg_getTimestamp";
  static const String methodMessageGetType = "msg_getType";
  static const String methodMessageGetState = "msg_getState";
  static const String methodMessageGetChatId = "msg_getChatId";
  static const String methodMessageGetFromId = "msg_getFromId";
  static const String methodMessageGetWidth = "msg_getWidth";
  static const String methodMessageGetHeight = "msg_getHeight";
  static const String methodMessageGetDuration = "msg_getDuration";
  static const String methodMessageLateFilingMediaSize = "msg_lateFilingMediaSize";
  static const String methodMessageGetSummary = "msg_getSummary";
  static const String methodMessageGetSummaryText = "msg_getSummaryText";
  static const String methodMessageShowPadlock = "msg_showPadlock";
  static const String methodMessageHasFile = "msg_hasFile";
  static const String methodMessageGetFile = "msg_getFile";
  static const String methodMessageGetFileMime = "msg_getFileMime";
  static const String methodMessageGetFilename = "msg_getFilename";
  static const String methodMessageGetFileBytes = "msg_getFileBytes";
  static const String methodMessageIsForwarded = "msg_isForwarded";
  static const String methodMessageIsInfo = "msg_isInfo";
  static const String methodMessageIsSetupMessage = "msg_isSetupMessage";
  static const String methodMessageGetSetupCodeBegin = "msg_getSetupCodeBegin";
  static const String methodMessageIsInCreation = "msg_isInCreation";
  static const String methodMessageSetText = "msg_setText";
  static const String methodMessageSetFile = "msg_setFile";
  static const String methodMessageSetDimension = "msg_setDimension";
  static const String methodMessageSetDuration = "msg_setDuration";
  static const String methodMessageIsOutgoing = "msg_isOutgoing";
  static const String methodMessageIsStarred = "msg_isStarred";

  static const int typeUndefined = 0;
  static const int typeMessage = 10;
  static const int typeImage = 20;
  static const int typeGif = 21;
  static const int typeAudio = 40;
  static const int typeVoice = 41;
  static const int typeVideo = 50;
  static const int typeFile = 60;

  static const int messageNone = 0;
  static const int messageStatePreparing = 18;
  static const int messageStateDraft = 19;
  static const int messageStatePending = 20;
  static const int messageStateFailed = 24;
  static const int messageStateDelivered = 26;
  static const int messageStateReceived = 28;

  static const int idMarker = 1;
  static const int idDayMarker = 9;

  final int _id;

  ChatMsg._internal(this._id) : super();

  @override
  int get id => _id;

  @override
  String get identifier => _identifier;

  Future<int> getMessageIdAsync() async {
    return await loadAndGetValueAsync(methodMessageGetId);
  }

  Future<String> getTextAsync() async {
    return await loadAndGetValueAsync(methodMessageGetText);
  }

  Future<int> getTimestampAsync() async {
    return await loadAndGetValueAsync(methodMessageGetTimestamp);
  }

  Future<int> getChatIdAsync() async {
    return await loadAndGetValueAsync(methodMessageGetChatId);
  }

  Future<int> getFromIdAsync() async {
    return await loadAndGetValueAsync(methodMessageGetFromId);
  }

  Future<bool> isOutgoingAsync() async {
    return await loadAndGetValueAsync(methodMessageIsOutgoing);
  }

  Future<bool> hasFileAsync() async {
    return await loadAndGetValueAsync(methodMessageHasFile);
  }

  Future<int> getTypeAsync() async {
    return await loadAndGetValueAsync(methodMessageGetType);
  }

  Future<String> getFileAsync() async {
    return await loadAndGetValueAsync(methodMessageGetFile);
  }

  Future<int> getFileBytesAsync() async {
    return await loadAndGetValueAsync(methodMessageGetFileBytes);
  }

  Future<String> getFileNameAsync() async {
    return await loadAndGetValueAsync(methodMessageGetFilename);
  }

  Future<String> getFileMimeAsync() async {
    return await loadAndGetValueAsync(methodMessageGetFileMime);
  }

  Future<String> getSummaryTextAsync(int characterCount) async {
    return await loadAndGetValueAsync(methodMessageGetSummaryText, arguments: getSummaryArguments(characterCount));
  }

  Future<int> getStateAsync() async {
    return await loadAndGetValueAsync(methodMessageGetState);
  }

  Future<bool> isSetupMessageAsync() async {
    return await loadAndGetValueAsync(methodMessageIsSetupMessage);
  }

  Future<bool> isInfoAsync() async {
    return await loadAndGetValueAsync(methodMessageIsInfo);
  }

  Future<String> getSetupCodeBeginAsync() async {
    return await loadAndGetValueAsync(methodMessageGetSetupCodeBegin);
  }

  Future<int> showPadlockAsync() async {
    return await loadAndGetValueAsync(methodMessageShowPadlock);
  }

  Future<bool> isStarredAsync() async {
    return await loadAndGetValueAsync(methodMessageIsStarred);
  }

  Future<int> getDurationAsync() async {
    return await loadAndGetValueAsync(methodMessageGetDuration);
  }

  Future<bool> isForwardedAsync() async {
    return await loadAndGetValueAsync(methodMessageIsForwarded);
  }
  
  @override
  getDefaultArguments() => <String, dynamic>{Base.argumentId: _id};

  getSummaryArguments(int characterCount) => <String, dynamic>{Base.argumentId: _id, Base.argumentCount: characterCount};

  static Function getCreator() {
    return (id) => ChatMsg._internal(id);
  }
}
