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
import 'package:flutter/foundation.dart';

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
  static const String methodBlockContact = "context_blockContact";
  static const String methodUnblockContact = "context_unblockContact";
  static const String methodGetBlockedContacts = "context_getBlockedContacts";
  static const String methodCreateChatById = "context_createChatByContactId";
  static const String methodCreateChatByMessageId = "context_createChatByMessageId";
  static const String methodCreateGroupChat = "context_createGroupChat";
  static const String methodGetContacts = "context_getContacts";
  static const String methodGetChatContacts = "context_getChatContacts";
  static const String methodGetChatMessages = "context_getChatMessages";
  static const String methodCreateChatMessage = "context_createChatMessage";
  static const String methodCreateChatAttachmentMessage = "context_createChatAttachmentMessage";
  static const String methodAddContactToChat = "context_addContactToChat";
  static const String methodGetChatByContactId = "context_getChatByContactId";
  static const String methodGetFreshMessageCount = "context_getFreshMessageCount";
  static const String methodMarkNoticedChat = "context_markNoticedChat";
  static const String methodDeleteChat = "context_deleteChat";
  static const String methodRemoveContactFromChat = "context_removeContactFromChat";
  static const String methodImportKeys = "context_importKeys";
  static const String methodExportKeys = "context_exportKeys";
  static const String methodGetFreshMessages = "context_getFreshMessages";
  static const String methodForwardMessages = "context_forwardMessages";
  static const String methodInitiateKeyTransfer = "context_initiateKeyTransfer";
  static const String methodContinueKeyTransfer = "context_continueKeyTransfer";
  static const String methodMarkSeenMessages = "context_markSeenMessages";
  static const String methodGetSecurejoinQr = "context_getSecurejoinQr";
  static const String methodJoinSecurejoinQr = "context_joinSecurejoin";
  static const String methodCheckQr = "context_checkQr";
  static const String methodStopOngoingProcess = "context_stopOngoingProcess";
  static const String methodDeleteMessages = "context_deleteMessages";
  static const String methodStarMessages = "context_starMessages";
  static const String methodSetChatName = "context_setChatName";
  static const String methodSetChatProfileImage = "context_setChatProfileImage";
  static const String methodInterruptIdleForIncomingMessages = "context_interruptIdleForIncomingMessages";
  static const String methodClose = "context_close";
  static const String methodIsCoiSupported = "context_isCoiSupported";
  static const String methodIsCoiEnabled = "context_isCoiEnabled";
  static const String methodIsWebPushSupported = "context_isWebPushSupported";
  static const String methodGetWebPushVapidKey = "context_getWebPushVapidKey";
  static const String methodSubscribeWebPush = "context_subscribeWebPush";
  static const String methodValidateWebPush = "context_validateWebPush";
  static const String methodGetWebPushSubscription = "context_getWebPushSubscription";
  static const String methodSetCoiEnabled = "context_setCoiEnabled";
  static const String methodSetCoiMessageFilter = "context_setCoiMessageFilter";
  static const String methodIsCoiMessageFilterEnabled = "context_isCoiMessageFilterEnabled";
  static const String methodGetMessageInfo = "context_getMessageInfo";
  static const String methodRetrySendingPendingMessages = "context_retrySendingPendingMessages";
  static const String methodGetContactIdByAddress = "context_getContactIdByAddress";
  static const String methodGetNextMedia = "context_getNextMedia";
  static const String methodDecryptInMemory = "context_decryptInMemory";

  static const String configAddress = "addr";
  static const String configMailServer = "mail_server";
  static const String configMailUser = "mail_user";
  static const String configMailPassword = "mail_pw";
  static const String configMailPort = "mail_port";
  static const String configSendServer = "send_server";
  static const String configSendUser = "send_user";
  static const String configSendPassword = "send_pw";
  static const String configSendPort = "send_port";
  static const String configAuthScheme = "auth_scheme";
  static const String configImapSecurity = "imap_security";
  static const String configSmtpSecurity = "smtp_security";
  static const String configDisplayName = "displayname";
  static const String configSelfStatus = "selfstatus";
  static const String configSelfAvatar = "selfavatar";
  static const String configE2eeEnabled = "e2ee_enabled";
  static const String configQrOverlayLogo = "qr_overlay_logo";
  static const String configShowEmails = "show_emails";
  static const String configMdnsEnabled = "mdns_enabled";
  static const String configRfc724MsgIdPrefix = "rfc724_msg_id_prefix";
  static const String configMaxAttachSize = "max_attach_size";

  static const int contactListFlagVerifiedOnly = 1;
  static const int contactListFlagAddSelf = 2;

  static const int serverFlagsImapStartTls = 0x100;
  static const int serverFlagsImapSsl = 0x200;
  static const int serverFlagsImapPlain = 0x400;
  static const int serverFlagsSmtpStartTls = 0x10000;
  static const int serverFlagsSmtpSsl = 0x20000;
  static const int serverFlagsSmtpPlain = 0x40000;

  static const int qrAskVerifyContact = 200;
  static const int qrAskVerifyGroup = 202;
  static const int qrFingerprintOk = 210;
  static const int qrFingerprintMismatch = 220;
  static const int qrFingerprintWithoutAddress = 230;
  static const int qrAddress = 320;
  static const int qrText = 330;
  static const int qrUrl = 332;
  static const int qrError = 400;

  static const int showEmailsOff = 0;
  static const int showEmailsAcceptedContacts = 1;
  static const int showEmailsAll = 2;

  static const int chatListAddDayMarker = 0x01;

  static const int starMessage = 1;
  static const int unstarMessage = 0;

  static const int enableChatPrefix = 1;
  static const int disableChatPrefix = 0;

  final DeltaChatCore core = DeltaChatCore();

  Future<dynamic> getConfigValueAsync(String key, [ObjectType type]) async {
    var method;
    if (type == null || type == ObjectType.String) {
      method = methodConfigGet;
    } else if (type == ObjectType.int) {
      method = methodConfigGetInt;
    }
    return await core.invokeMethodAsync(method, getKeyArguments(key));
  }

  Future<dynamic> setConfigValueAsync(String key, value, ObjectType enforceType) async {
    String type;
    if (enforceType != null) {
      type = describeEnum(enforceType);
    } else {
      type = value != null ? value.runtimeType.toString() : null;
    }
    await core.invokeMethodAsync(methodConfigSet, getConfigArguments(type, key, value));
  }

  Future<void> configureAsync() async {
    await core.invokeMethodAsync(methodConfigure);
  }

  Future<bool> isConfiguredAsync() async {
    return await core.invokeMethodAsync(methodIsConfigured);
  }

  Future<int> addAddressBookAsync(String addressBook) async {
    return await core.invokeMethodAsync(methodAddAddressBook, getAddressBookArguments(addressBook));
  }

  Future<int> createContactAsync(String name, String address) async {
    return await core.invokeMethodAsync(methodCreateContact, getContactArguments(name, address));
  }

  Future<bool> deleteContactAsync(int id) async {
    return await core.invokeMethodAsync(methodDeleteContact, getIdArguments(id));
  }

  Future<bool> blockContactAsync(int id) async {
    return await core.invokeMethodAsync(methodBlockContact, getIdArguments(id));
  }

  Future<bool> unblockContactAsync(int id) async {
    return await core.invokeMethodAsync(methodUnblockContact, getIdArguments(id));
  }

  Future<int> createChatByContactIdAsync(int id) async {
    return await core.invokeMethodAsync(methodCreateChatById, getIdArguments(id));
  }

  Future<int> createChatByMessageIdAsync(int id) async {
    return await core.invokeMethodAsync(methodCreateChatByMessageId, getIdArguments(id));
  }

  Future<int> createGroupChatAsync(bool verified, String name) async {
    return await core.invokeMethodAsync(methodCreateGroupChat, getCreateGroupArguments(verified, name));
  }

  Future<List<int>> getContactsAsync(int flags, String query) async {
    return await core.invokeMethodAsync(methodGetContacts, getContactsArguments(flags, query));
  }

  Future<List<int>> getChatContactsAsync(int chatId) async {
    return await core.invokeMethodAsync(methodGetChatContacts, getChatIdArguments(chatId));
  }

  Future<List<int>> getBlockedContactsAsync() async {
    return await core.invokeMethodAsync(methodGetBlockedContacts);
  }

  Future<List<int>> getChatMessagesAsync(int chatId, [int flags = 0]) async {
    return await core.invokeMethodAsync(methodGetChatMessages, getChatMessageArguments(chatId, flags));
  }

  Future<int> createChatMessageAsync(int chatId, String text) async {
    return await core.invokeMethodAsync(methodCreateChatMessage, createChatMessageArguments(chatId, text));
  }

  Future<int> createChatAttachmentMessageAsync(int chatId, String path, int msgType, String mimeType, int duration, [String text]) async {
    return await core.invokeMethodAsync(
        methodCreateChatAttachmentMessage, getCreateAttachmentMessageArguments(chatId, path, msgType, mimeType, duration, text));
  }

  Future<int> addContactToChatAsync(int chatId, int contactId) async {
    return await core.invokeMethodAsync(methodAddContactToChat, getChatAndContactIdArguments(chatId, contactId));
  }

  Future<int> getChatByContactIdAsync(int contactId) async {
    return await core.invokeMethodAsync(methodGetChatByContactId, getContactIdArguments(contactId));
  }

  Future<int> getFreshMessageCountAsync(int chatId) async {
    return await core.invokeMethodAsync(methodGetFreshMessageCount, getChatIdArguments(chatId));
  }

  Future<int> markNoticedChatAsync(int chatId) async {
    return await core.invokeMethodAsync(methodMarkNoticedChat, getChatIdArguments(chatId));
  }

  Future<int> deleteChatAsync(int chatId) async {
    return await core.invokeMethodAsync(methodDeleteChat, getChatIdArguments(chatId));
  }

  Future<int> removeContactFromChatAsync(int chatId, int contactId) async {
    return await core.invokeMethodAsync(methodRemoveContactFromChat, getChatAndContactIdArguments(chatId, contactId));
  }

  Future<void> exportKeysAsync(String path) async {
    return await core.invokeMethodAsync(methodExportKeys, getExportImportArguments(path));
  }

  Future<void> importKeysAsync(String path) async {
    return await core.invokeMethodAsync(methodImportKeys, getExportImportArguments(path));
  }

  Future<List<int>> getFreshMessagesAsync() async {
    return await core.invokeMethodAsync(methodGetFreshMessages);
  }

  Future<void> forwardMessagesAsync(int chatId, List<int> msgIds) async {
    return await core.invokeMethodAsync(methodForwardMessages, getForwardMessageArguments(chatId, msgIds));
  }

  Future<String> initiateKeyTransferAsync() async {
    return await core.invokeMethodAsync(methodInitiateKeyTransfer);
  }

  Future<bool> continueKeyTransferAsync(int messageId, String setupCode) async {
    return await core.invokeMethodAsync(methodContinueKeyTransfer, getContinueKeyTransferArguments(messageId, setupCode));
  }

  Future<void> markSeenMessagesAsync(List<int> msgIds) async {
    if (msgIds.isEmpty) {
      return null;
    }
    return await core.invokeMethodAsync(methodMarkSeenMessages, getMessageIdsArguments(msgIds));
  }

  Future<String> getSecureJoinQrAsync(int chatId) async {
    return await core.invokeMethodAsync(methodGetSecurejoinQr, getSecureJoinQrArguments(chatId));
  }

  Future<int> joinSecurejoinQrAsync(String qrText) async {
    return await core.invokeMethodAsync(methodJoinSecurejoinQr, getQrTextArguments(qrText));
  }

  Future<List<dynamic>> checkQrAsync(String qrText) async {
    return await core.invokeMethodAsync(methodCheckQr, getQrTextArguments(qrText));
  }

  Future<void> stopOngoingProcessAsync() async {
    return await core.invokeMethodAsync(methodStopOngoingProcess);
  }

  Future<void> deleteMessagesAsync(List<int> msgIds) async {
    return await core.invokeMethodAsync(methodDeleteMessages, getMessageIdsArguments(msgIds));
  }

  Future<void> starMessagesAsync(List<int> msgIds, int star) async {
    await core.invokeMethodAsync(methodStarMessages, getStarMessagesArguments(msgIds, star));
    // Manually dispatching Event.msgsChanged as the core currently not supports this.
    // As soon as this is fixed in the core the following part should get removed.
    msgIds.forEach((msgId) {
      core.addStreamEvent(Event(Event.msgsChanged, null, msgId));
    });
  }

  Future<int> setChatNameAsync(int chatId, String newName) async {
    return await core.invokeMethodAsync(methodSetChatName, getSetNameOrImageArguments(chatId, newName));
  }

  Future<int> setChatProfileImageAsync(int chatId, String newImagePath) async {
    return await core.invokeMethodAsync(methodSetChatProfileImage, getSetNameOrImageArguments(chatId, newImagePath));
  }

  Future<void> interruptIdleForIncomingMessagesAsync() async {
    return await core.invokeMethodAsync(methodInterruptIdleForIncomingMessages);
  }

  Future<void> closeAsync() async {
    return await core.invokeMethodAsync(methodClose);
  }

  Future<int> isCoiSupportedAsync() async {
    return await core.invokeMethodAsync(methodIsCoiSupported);
  }

  Future<int> isCoiEnabledAsync() async {
    return await core.invokeMethodAsync(methodIsCoiEnabled);
  }

  Future<int> isWebPushSupportedAsync() async {
    return await core.invokeMethodAsync(methodIsWebPushSupported);
  }

  Future<String> getWebPushVapidKeyAsync() async {
    return await core.invokeMethodAsync(methodGetWebPushVapidKey);
  }

  Future<void> subscribeWebPushAsync(String uid, String json, int id) async {
    return await core.invokeMethodAsync(methodSubscribeWebPush, getWebPushSubscribeArguments(uid, json, id));
  }

  Future<void> validateWebPushAsync(String uid, String message, int id) async {
    return await core.invokeMethodAsync(methodValidateWebPush, getWebPushValidateArguments(uid, message, id));
  }

  Future<void> getWebPushSubscriptionAsync(String uid, int id) async {
    return await core.invokeMethodAsync(methodGetWebPushSubscription, getWebPushGetSubscriptionArguments(uid, id));
  }

  Future<void> setCoiEnabledAsync(int enable, int id) async {
    return await core.invokeMethodAsync(methodSetCoiEnabled, getSetCoiEnabledArguments(enable, id));
  }

  Future<void> setCoiMessageFilterAsync(int mode, int id) async {
    return await core.invokeMethodAsync(methodSetCoiMessageFilter, getSetCoiMessageFilter(mode, id));
  }

  Future<int> isCoiMessageFilterEnabledAsync() async {
    return await core.invokeMethodAsync(methodIsCoiMessageFilterEnabled);
  }

  Future<String> getMessageInfoAsync(int msgId) async {
    return await core.invokeMethodAsync(methodGetMessageInfo, getMessageIdArguments(msgId));
  }

  Future<void> retrySendingPendingMessagesAsync() async {
    return await core.invokeMethodAsync(methodRetrySendingPendingMessages);
  }

  Future<int> getContactIdByAddressAsync(String address) async {
    return await core.invokeMethodAsync(methodGetContactIdByAddress, getContactIdByAddressArguments(address));
  }

  Future<int> getNextMediaAsync(int messageId, int dir, {int messageTypeOne = 0, int messageTypeTwo = 0, int messageTypeThree = 0}) async {
    return await core.invokeMethodAsync(methodGetNextMedia, getNextMediaArguments(messageId, dir, messageTypeOne, messageTypeTwo, messageTypeThree));
  }

  Future<List<dynamic>> decryptInMemoryAsync(String contentType, String content, String senderAddress) async {
    return await core.invokeMethodAsync(methodDecryptInMemory, getDecryptInMemoryArguments(contentType, content, senderAddress));
  }

  Map<String, dynamic> getKeyArguments(String key) => <String, dynamic>{Base.argumentKey: key};

  Map<String, dynamic> getConfigArguments(String type, String key, value) =>
      <String, dynamic>{Base.argumentType: type, Base.argumentKey: key, Base.argumentValue: value};

  Map<String, dynamic> getAddressBookArguments(String addressBook) => <String, dynamic>{Base.argumentAddressBook: addressBook};

  Map<String, dynamic> getContactArguments(String name, String address) => <String, dynamic>{Base.argumentName: name, Base.argumentAddress: address};

  Map<String, dynamic> getIdArguments(int id) => <String, dynamic>{Base.argumentId: id};

  Map<String, dynamic> getMessageIdArguments(int msgId) => <String, dynamic>{Base.argumentMessageId: msgId};

  Map<String, dynamic> getMessageIdsArguments(List<int> msgIds) => <String, dynamic>{Base.argumentMessageIds: msgIds};

  Map<String, dynamic> getCreateGroupArguments(bool verified, String name) =>
      <String, dynamic>{Base.argumentVerified: verified, Base.argumentName: name};

  Map<String, dynamic> getContactsArguments(int flags, String query) => <String, dynamic>{Base.argumentFlags: flags, Base.argumentQuery: query};

  Map<String, dynamic> getChatIdArguments(int chatId) => <String, dynamic>{Base.argumentChatId: chatId};

  Map<String, dynamic> getChatMessageArguments(int chatId, int flags) => <String, dynamic>{Base.argumentChatId: chatId, Base.argumentFlags: flags};

  Map<String, dynamic> createChatMessageArguments(int chatId, String text) => <String, dynamic>{Base.argumentChatId: chatId, Base.argumentText: text};

  Map<String, dynamic> getCreateAttachmentMessageArguments(int chatId, String path, int msgType, String mimeType, int duration, String text) =>
      <String, dynamic>{
        Base.argumentChatId: chatId,
        Base.argumentPath: path,
        Base.argumentType: msgType,
        Base.argumentMimeType: mimeType,
        Base.argumentDuration: duration,
        Base.argumentText: text
      };

  Map<String, dynamic> getChatAndContactIdArguments(int chatId, int contactId) =>
      <String, dynamic>{Base.argumentChatId: chatId, Base.argumentContactId: contactId};

  Map<String, dynamic> getContactIdArguments(int contactId) => <String, dynamic>{Base.argumentContactId: contactId};

  Map<String, dynamic> getExportImportArguments(String path) => <String, dynamic>{Base.argumentPath: path};

  Map<String, dynamic> getContinueKeyTransferArguments(int messageId, String setupCode) =>
      <String, dynamic>{Base.argumentId: messageId, Base.argumentSetupCode: setupCode};

  Map<String, dynamic> getForwardMessageArguments(int chatId, List<int> msgIds) =>
      <String, dynamic>{Base.argumentChatId: chatId, Base.argumentMessageIds: msgIds};

  Map<String, dynamic> getSecureJoinQrArguments(int chatId) => <String, dynamic>{Base.argumentChatId: chatId};

  Map<String, dynamic> getQrTextArguments(String qrText) => <String, dynamic>{Base.argumentQrText: qrText};

  Map<String, dynamic> getStarMessagesArguments(List<int> msgIds, int star) =>
      <String, dynamic>{Base.argumentMessageIds: msgIds, Base.argumentValue: star};

  Map<String, dynamic> getSetNameOrImageArguments(int chatId, String newValue) =>
      <String, dynamic>{Base.argumentChatId: chatId, Base.argumentValue: newValue};

  Map<String, dynamic> getWebPushSubscribeArguments(String uid, String json, int id) =>
      <String, dynamic>{Base.argumentUid: uid, Base.argumentJson: json, Base.argumentId: id};

  Map<String, dynamic> getWebPushValidateArguments(String uid, String message, int id) =>
      <String, dynamic>{Base.argumentUid: uid, Base.argumentMessage: message, Base.argumentId: id};

  Map<String, dynamic> getWebPushGetSubscriptionArguments(String uid, int id) => <String, dynamic>{Base.argumentUid: uid, Base.argumentId: id};

  Map<String, dynamic> getSetCoiEnabledArguments(int enable, int id) => <String, dynamic>{Base.argumentEnable: enable, Base.argumentId: id};

  Map<String, dynamic> getSetCoiMessageFilter(int mode, int id) => <String, dynamic>{Base.argumentMode: mode, Base.argumentId: id};

  Map<String, dynamic> getContactIdByAddressArguments(String address) => <String, dynamic>{Base.argumentAddress: address};

  Map<String, dynamic> getNextMediaArguments(int messageId, int dir, int messageTypeOne, int messageTypeTwo, int messageTypeThree) =>
      <String, dynamic>{
        Base.argumentMessageId: messageId,
        Base.argumentDir: dir,
        Base.argumentMessageTypeOne: messageTypeOne,
        Base.argumentMessageTypeTwo: messageTypeTwo,
        Base.argumentMessageTypeThree: messageTypeThree
      };

  Map<String, dynamic> getDecryptInMemoryArguments(String contentType, String content, String senderAddress) => <String, dynamic>{Base.argumentContentType: contentType, Base.argumentContent: content, Base.argumentAddress: senderAddress};
}
