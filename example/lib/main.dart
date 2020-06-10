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
import 'dart:io';

import 'package:delta_chat_core/delta_chat_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var items = List();

  @override
  void initState() {
    super.initState();
    initList();
  }

  Future<void> initList() async {
    _addListItem(information: true, text: "Information\n[Test succeeded] Informational text [assertion == result]");
    try {
      DeltaChatCore core = DeltaChatCore();
      bool init = await core.setupAsync(dbName: "messenger.db", minimalSetup: false);
      if (init) {
        _addListItem(text: "Init done");
        Context context = Context();
        _addListItem(text: "Context created");
        bool isConfigured = await context.isConfiguredAsync();
        _addListItem(text: "isConfigured", assertion: false, result: isConfigured);
        await context.setConfigValueAsync("addr", "alice@ox.io", ObjectType.String);
        _addListItem(text: "setConfigValue addr alice@ox.io");
        String getConfigAddrValue = await context.getConfigValueAsync("addr");
        _addListItem(text: "getConfigValue addr", assertion: "alice@ox.io", result: getConfigAddrValue);
        await context.setConfigValueAsync(Context.configDisplayName, "Alice", ObjectType.String);
        _addListItem(text: "setConfigValue displayname Alice");
        String getConfigDisplayNameValue = await context.getConfigValueAsync(Context.configDisplayName);
        _addListItem(text: "getConfigValue displayname", assertion: "Alice", result: getConfigDisplayNameValue);
        await context.setConfigValueAsync(Context.configSelfStatus, "My status", ObjectType.String);
        _addListItem(text: "setConfigValue selfstatus My status");
        String getConfigSelfStatusValue = await context.getConfigValueAsync(Context.configSelfStatus);
        _addListItem(text: "getConfigValue selfstatus", assertion: "My status", result: getConfigSelfStatusValue);
        await context.setConfigValueAsync(Context.configMailServer, "imap.ox.io", ObjectType.String);
        _addListItem(text: "setConfigValue mail_server imap.ox.io");
        String getConfigMailServerValue = await context.getConfigValueAsync(Context.configMailServer);
        _addListItem(text: "getConfigValue mail_server", assertion: "imap.ox.io", result: getConfigMailServerValue);
        await context.setConfigValueAsync(Context.configMailUser, "alice@ox.io", ObjectType.String);
        _addListItem(text: "setConfigValue mail_user alice@ox.io");
        String getConfigMailUserValue = await context.getConfigValueAsync(Context.configMailUser);
        _addListItem(text: "getConfigValue mail_user", assertion: "alice@ox.io", result: getConfigMailUserValue);
        await context.setConfigValueAsync(Context.configMailPassword, "password", ObjectType.String);
        _addListItem(text: "setConfigValue mail_password password");
        String getConfigMailPasswordValue = await context.getConfigValueAsync(Context.configMailPassword);
        _addListItem(text: "getConfigValue mail_password", assertion: "password", result: getConfigMailPasswordValue);
        await context.setConfigValueAsync(Context.configMailPort, "148", ObjectType.String);
        _addListItem(text: "setConfigValue mail_port 148");
        String getConfigMailPortValue = await context.getConfigValueAsync(Context.configMailPort);
        _addListItem(text: "getConfigValue mail_port", assertion: "148", result: getConfigMailPortValue);
        await context.setConfigValueAsync(Context.configSendServer, "smtp.ox.io", ObjectType.String);
        _addListItem(text: "setConfigValue send_server smtp.ox.io");
        String getConfigSendServerValue = await context.getConfigValueAsync(Context.configSendServer);
        _addListItem(text: "getConfigValue send_server", assertion: "smtp.ox.io", result: getConfigSendServerValue);
        await context.setConfigValueAsync(Context.configSendUser, "alice@ox.io", ObjectType.String);
        _addListItem(text: "setConfigValue send_user alice@ox.io");
        String getConfigSendUserValue = await context.getConfigValueAsync(Context.configSendUser);
        _addListItem(text: "getConfigValue send_user", assertion: "alice@ox.io", result: getConfigSendUserValue);
        await context.setConfigValueAsync(Context.configSendPassword, "password", ObjectType.String);
        _addListItem(text: "setConfigValue send_password password");
        String getConfigSendPasswordValue = await context.getConfigValueAsync(Context.configSendPassword);
        _addListItem(text: "getConfigValue send_password", assertion: "password", result: getConfigSendPasswordValue);
        await context.setConfigValueAsync(Context.configSendPort, "931", ObjectType.String);
        _addListItem(text: "setConfigValue send_port 931");
        String getConfigSendPortValue = await context.getConfigValueAsync(Context.configSendPort);
        _addListItem(text: "getConfigValue send_port", assertion: "931", result: getConfigSendPortValue);
        int contactId = await context.createContactAsync("Bob", "bob@ox.io");
        _addListItem(text: "createContact bob@ox.io", assertion: 10, result: contactId);
        int contactId2 = await context.createContactAsync(null, "charlie@ox.io");
        _addListItem(text: "createContact charlie@ox.io", assertion: 11, result: contactId2);
        int chatId = await context.createChatByContactIdAsync(contactId);
        _addListItem(text: "createChatByContactId", assertion: 10, result: chatId);
        ChatList chatList = ChatList();
        await chatList.setupAsync();
        int index = 0;
        int id = await chatList.getChatIdAsync(index);
        _addListItem(text: "getChatId", assertion: 10, result: id);
        var chatCnt = await chatList.getChatCntAsync();
        _addListItem(text: "getChatCnt", assertion: 1, result: chatCnt);
        int chatIdFromChatList = await chatList.getChatAsync(index);
        _addListItem(text: "getChat", assertion: 10, result: chatIdFromChatList);
        await chatList.tearDownAsync();
        var groupChatId = await context.createGroupChatAsync(false, "The group");
        _addListItem(text: "createGroupChat", assertion: 11, result: groupChatId);
        var groupAddResult = await context.addContactToChatAsync(groupChatId, contactId);
        _addListItem(text: "addContactToChat", assertion: 1, result: groupAddResult);
        StreamController controller = StreamController();
        core.addListener(eventId: Event.configureProgress, streamController: controller);
        core.removeListener(controller);
        var contactIds = await context.getContactsAsync(2, null);
        _addListItem(text: "getContacts (context)", assertion: 3, result: contactIds.length);
        var chatContactIds = await context.getChatContactsAsync(chatId);
        _addListItem(text: "getChatContacts", assertion: 1, result: chatContactIds.length);
        var freshMessageCount = await context.getFreshMessageCountAsync(chatId);
        _addListItem(text: "getFreshMessageCount", assertion: 0, result: freshMessageCount);
        await context.markNoticedChatAsync(chatId);
        _addListItem(text: "markNoticedChat");
        await context.deleteChatAsync(chatId);
        await context.deleteChatAsync(groupChatId);
        chatList = ChatList();
        await chatList.setupAsync();
        var chatCntAfterDeletingChat = await chatList.getChatCntAsync();
        await chatList.tearDownAsync();
        _addListItem(text: "deleteChat", assertion: 0, result: chatCntAfterDeletingChat);
        await Future.delayed(const Duration(seconds: 1));
        core.tearDownAsync();
        var dbFile = File(core.dbPath);
        dbFile.deleteSync();
        _addListItem(text: "Teardown and cleanup down");
      }
    } on PlatformException {
      throw StateError("Test suite failed, forbidden state entered");
    }

    if (!mounted) return;
    setState(() {});
  }

  _addListItem({bool information, String text, var assertion, var result}) {
    Widget content;
    if (information != null && information) {
      content = Text(text);
    } else {
      var now = DateTime.now().toIso8601String();
      if (assertion == null || result == null) {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(now),
            Text("[true] $text"),
          ],
        );
      } else {
        bool success = assertion == result;
        content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text(now),
          Text(
            "[$success] $text [$assertion == $result]",
            style: TextStyle(color: success ? Colors.black : Colors.red),
          )
        ]);
      }
    }
    Widget base = Padding(
      padding: EdgeInsets.all(8.0),
      child: content,
    );
    items.add(base);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('delta_chat_core test suite'),
          ),
          body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return items[index];
              })),
    );
  }

}
