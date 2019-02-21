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

class Chat extends Base {
  static const String methodChatGetId = "chat_getId";
  static const String methodChatIsGroup = "chat_isGroup";
  static const String methodChatGetArchived = "chat_getArchived";
  static const String methodChatGetColor = "chat_getColor";
  static const String methodChatGetName = "chat_getName";
  static const String methodChatGetSubtitle = "chat_getSubtitle";
  static const String methodChatGetProfileImage = "chat_getProfileImage";
  static const String methodChatIsUnpromoted = "chat_isUnpromoted";
  static const String methodChatIsVerified = "chat_isVerified";
  static const String methodChatIsSelfTalk = "chat_isSelfTalk";

  final int _id;

  Chat._internal(this._id) : super();

  int getId() {
    return _id;
  }

  Future<int> getChatId() async {
    return await loadAndGetValue(methodChatGetId, getDefaultParameters());
  }

  Future<bool> isGroup() async {
    return await loadAndGetValue(methodChatIsGroup, getDefaultParameters());
  }

  Future<int> getArchived() async {
    return await loadAndGetValue(methodChatGetArchived, getDefaultParameters());
  }

  Future<int> getColor() async {
    return await loadAndGetValue(methodChatGetColor, getDefaultParameters());
  }

  Future<String> getName() async {
    return await loadAndGetValue(methodChatGetName, getDefaultParameters());
  }

  Future<String> getSubtitle() async {
    return await loadAndGetValue(methodChatGetSubtitle, getDefaultParameters());
  }

  Future<String> getProfileImage() async {
    return await loadAndGetValue(methodChatGetProfileImage, getDefaultParameters());
  }

  Future<bool> isUnpromoted() async {
    return await loadAndGetValue(methodChatIsUnpromoted, getDefaultParameters());
  }

  Future<bool> isVerified() async {
    return await loadAndGetValue(methodChatIsVerified, getDefaultParameters());
  }

  Future<bool> isSelfTalk() async {
    return await loadAndGetValue(methodChatIsSelfTalk, getDefaultParameters());
  }

  @override
  Map<String, dynamic> getDefaultParameters() => <String, dynamic>{Base.argumentId: _id};

  static Function getCreator() {
    return (id) => new Chat._internal(id);
  }
}