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
import 'package:delta_chat_core/src/base.dart';

enum ObjectType { String, int }

class Context {
  static const String methodConfigGet = "context_configGet";
  static const String methodConfigGetInt = "context_configGetInt";
  static const String methodConfigSet = "context_configSet";
  static const String methodConfigure = "context_configure";
  static const String methodIsConfigured = "context_isConfigured";
  static const String methodAddAddressBook = "context_addAddressBook";
  static const String methodCreateContact = "context_createContact";
  static const String methodDeleteContact = "context_deleteContact";
  static const String methodCreateChatById = "context_createChatByContactId";
  static const String methodCreateChatByMessageId = "context_createChatByMessageId";
  static const String methodCreateGroupChat = "context_createGroupChat";
  static const String methodGetContacts = "context_getContacts";
  static const String methodGetChatMessages = "context_getChatMessages";
  static const String methodCreateChatMessage = "context_createChatMessage";
  static const String methodAddContactToChat = "context_addContactToChat";

  static const String configAddress = "addr";
  static const String configMailServer = "mail_server";
  static const String configMailUser = "mail_user";
  static const String configMailPassword = "mail_pw";
  static const String configMailPort = "mail_port";
  static const String configSendServer = "send_server";
  static const String configSendUser = "send_user";
  static const String configSendPassword = "send_pw";
  static const String configSendPort = "send_port";
  static const String configServerFlags = "server_flags";
  static const String configDisplayName = "displayname";
  static const String configSelfStatus = "selfstatus";
  static const String configSelfAvatar = "selfavatar";
  static const String configE2eeEnabled = "e2ee_enabled";
  static const String configQrOverlayLogo = "qr_overlay_logo";

  final DeltaChatCore core = DeltaChatCore();

  Future<dynamic> getConfigValue(String key, [ObjectType type]) async {
    var method;
    if (type == null || type == ObjectType.String) {
      method = methodConfigGet;
    } else if (type == ObjectType.int) {
      method = methodConfigGetInt;
    }
    var arguments = <String, dynamic>{Base.argumentKey: key};
    return await core.invokeMethod(method, arguments);
  }

  Future<dynamic> setConfigValue(String key, value) async {
    String type = value.runtimeType.toString();
    var arguments = <String, dynamic>{Base.argumentType: type, Base.argumentKey: key, Base.argumentValue: value};
    await core.invokeMethod(methodConfigSet, arguments);
  }

  Future<dynamic> configure() async {
    await core.invokeMethod(methodConfigure);
  }

  Future<bool> isConfigured() async {
    return await core.invokeMethod(methodIsConfigured);
  }

  Future<int> addAddressBook(String addressBook) async {
    var arguments = <String, dynamic>{Base.argumentAddressBook: addressBook};
    return await core.invokeMethod(methodAddAddressBook, arguments);
  }

  Future<int> createContact(String name, String address) async {
    var arguments = <String, dynamic>{Base.argumentName: name, Base.argumentAddress: address};
    return await core.invokeMethod(methodCreateContact, arguments);
  }

  Future<bool> deleteContact(int id) async {
    var arguments = <String, dynamic>{Base.argumentId: id};
    return await core.invokeMethod(methodDeleteContact, arguments);
  }

  Future<int> createChatByContactId(int id) async {
    var arguments = <String, dynamic>{Base.argumentId: id};
    return await core.invokeMethod(methodCreateChatById, arguments);
  }

  Future<int> createChatByMessageId(int id) async {
    var arguments = <String, dynamic>{Base.argumentId: id};
    return await core.invokeMethod(methodCreateChatByMessageId, arguments);
  }

  Future<int> createGroupChat(bool verified, String name) async {
    var arguments = <String, dynamic>{Base.argumentVerified: verified, Base.argumentName: name};
    return await core.invokeMethod(methodCreateGroupChat, arguments);
  }

  Future<List> getContacts(int flags, String query) async {
    var arguments = <String, dynamic>{Base.argumentFlags: flags, Base.argumentQuery: query};
    return await core.invokeMethod(methodGetContacts, arguments);
  }

  Future<List> getChatMessages(int chatId) async {
    var arguments = <String, dynamic>{Base.argumentId: chatId};
    return await core.invokeMethod(methodGetChatMessages, arguments);
  }

  Future<int> createChatMessage(int chatId, String text) async {
    var arguments = <String, dynamic>{Base.argumentId: chatId, Base.argumentValue: text};
    return await core.invokeMethod(methodCreateChatMessage, arguments);
  }

  Future<int> addContactToChat(int chatId, int contactId) async {
    var arguments = <String, dynamic>{Base.argumentChatId: chatId, Base.argumentContactId: contactId};
    return await core.invokeMethod(methodAddContactToChat, arguments);
  }

}