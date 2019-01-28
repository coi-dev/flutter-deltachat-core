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

import 'package:delta_chat_core/src/base.dart';

class ChatMsg extends Base{
  static const String methodMessageGetId = "msg_getId";
  static const String methodMessageGetText = "msg_getText";
  static const String methodMessageGetTimestamp = "msg_getTimestamp";
  static const String methodMessageGetType = "msg_getType";
  static const String methodMessageGetStatte = "msg_getState";
  static const String methodMessageGetChatId = "msg_getChatId";
  static const String methodMessageGetFromId = "msg_getFromId";
  static const String methodMessageGetWidth = "msg_getWidth";
  static const String methodMessageGetHeight = "msg_getHeight";
  static const String methodMessageGetDuration = "msg_getDuration";
  static const String methodMessageLateFilingMediaSize = "msg_lateFilingMediaSize";
  static const String methodMessageGetSummary = "msg_getSummary";
  static const String methodMessageGetSumaryText = "msg_getSummaryText";
  static const String methodMessageShowPadlock = "msg_showPadlock";
  static const String methodMessageHasFile = "msg_hasFile";
  static const String methodMessageGetFile = "msg_getFile";
  static const String methodMessageGetFilemime = "msg_getFilemime";
  static const String methodMessageGetFilename = "msg_getFilename";
  static const String methodMessageGetFilebytes = "msg_getFilebytes";
  static const String methodMessageIsForwarded = "msg_isForwarded";
  static const String methodMessageIsInfo = "msg_isInfo";
  static const String methodMessageIsSetupMessage = "msg_isSetupMessage";
  static const String methodMessageGetSetupCodeBegin = "msg_getSetupCodeBegin";
  static const String methodMessageIsIncreation = "msg_isIncreation";
  static const String methodMessageSetText = "msg_setText";
  static const String methodMessageSetFile = "msg_setFile";
  static const String methodMessageSetDimension = "msg_setDimension";
  static const String methodMessageSetDuration = "msg_setDuration";
  static const String methodMessageIsOutgoing = "msg_isOutgoing";

  final int _id;

  ChatMsg._internal(this._id) : super();

  int getId() {
    return _id;
  }

  Future<int> getMessageId() async {
    return await loadValue(methodMessageGetId, <String, dynamic>{Base.argumentId: _id});
  }
  Future<String> getText() async {
    return await loadValue(methodMessageGetText, <String, dynamic>{Base.argumentId: _id});
  }

  Future<int> getTimestamp() async {
    return await loadValue(methodMessageGetTimestamp, <String, dynamic>{Base.argumentId: _id});
  }

  Future<int> getChatId() async {
    return await loadValue(methodMessageGetChatId, <String, dynamic>{Base.argumentId: _id});
  }

  Future<int> getFromId() async {
    return await loadValue(methodMessageGetFromId, <String, dynamic>{Base.argumentId: _id});
  }

  Future<bool> isOutgoing() async {
    return await loadValue(methodMessageIsOutgoing, <String, dynamic>{Base.argumentId: _id});
  }

  static Function getCreator() {
    return (id) => new ChatMsg._internal(id);
  }
}