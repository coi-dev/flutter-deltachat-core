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
      bool init = await core.init();
      if (init) {
        _addListItem(text: "Init done");
        Context context = Context();
        _addListItem(text: "Context created");
        bool isConfigured = await context.isConfigured();
        _addListItem(text: "isConfigured", assertion: false, result: isConfigured);
        await context.setConfigValue("addr", "alice@ox.io", ObjectType.String);
        _addListItem(text: "setConfigValue addr alice@ox.io");
        String getConfigAddrValue = await context.getConfigValue("addr");
        _addListItem(text: "getConfigValue addr", assertion: "alice@ox.io", result: getConfigAddrValue);
        await context.setConfigValue(Context.configDisplayName, "Alice", ObjectType.String);
        _addListItem(text: "setConfigValue displayname Alice");
        String getConfigDisplayNameValue = await context.getConfigValue(Context.configDisplayName);
        _addListItem(text: "getConfigValue displayname", assertion: "Alice", result: getConfigDisplayNameValue);
        await context.setConfigValue(Context.configSelfStatus, "My status", ObjectType.String);
        _addListItem(text: "setConfigValue selfstatus My status");
        String getConfigSelfStatusValue = await context.getConfigValue(Context.configSelfStatus);
        _addListItem(text: "getConfigValue selfstatus", assertion: "My status", result: getConfigSelfStatusValue);
        await context.setConfigValue(Context.configMailServer, "imap.ox.io", ObjectType.String);
        _addListItem(text: "setConfigValue mail_server imap.ox.io");
        String getConfigMailServerValue = await context.getConfigValue(Context.configMailServer);
        _addListItem(text: "getConfigValue mail_server", assertion: "imap.ox.io", result: getConfigMailServerValue);
        await context.setConfigValue(Context.configMailUser, "alice@ox.io", ObjectType.String);
        _addListItem(text: "setConfigValue mail_user alice@ox.io");
        String getConfigMailUserValue = await context.getConfigValue(Context.configMailUser);
        _addListItem(text: "getConfigValue mail_user", assertion: "alice@ox.io", result: getConfigMailUserValue);
        await context.setConfigValue(Context.configMailPassword, "password", ObjectType.String);
        _addListItem(text: "setConfigValue mail_password password");
        String getConfigMailPasswordValue = await context.getConfigValue(Context.configMailPassword);
        _addListItem(text: "getConfigValue mail_password", assertion: "password", result: getConfigMailPasswordValue);
        await context.setConfigValue(Context.configMailPort, "148", ObjectType.String);
        _addListItem(text: "setConfigValue mail_port 148");
        String getConfigMailPortValue = await context.getConfigValue(Context.configMailPort);
        _addListItem(text: "getConfigValue mail_port", assertion: "148", result: getConfigMailPortValue);
        await context.setConfigValue(Context.configSendServer, "smtp.ox.io", ObjectType.String);
        _addListItem(text: "setConfigValue send_server smtp.ox.io");
        String getConfigSendServerValue = await context.getConfigValue(Context.configSendServer);
        _addListItem(text: "getConfigValue send_server", assertion: "smtp.ox.io", result: getConfigSendServerValue);
        await context.setConfigValue(Context.configSendUser, "alice@ox.io", ObjectType.String);
        _addListItem(text: "setConfigValue send_user alice@ox.io");
        String getConfigSendUserValue = await context.getConfigValue(Context.configSendUser);
        _addListItem(text: "getConfigValue send_user", assertion: "alice@ox.io", result: getConfigSendUserValue);
        await context.setConfigValue(Context.configSendPassword, "password", ObjectType.String);
        _addListItem(text: "setConfigValue send_password password");
        String getConfigSendPasswordValue = await context.getConfigValue(Context.configSendPassword);
        _addListItem(text: "getConfigValue send_password", assertion: "password", result: getConfigSendPasswordValue);
        await context.setConfigValue(Context.configSendPort, "931", ObjectType.String);
        _addListItem(text: "setConfigValue send_port 931");
        String getConfigSendPortValue = await context.getConfigValue(Context.configSendPort);
        _addListItem(text: "getConfigValue send_port", assertion: "931", result: getConfigSendPortValue);
        int contactId = await context.createContact("Bob", "bob@ox.io");
        _addListItem(text: "createContact bob@ox.io", assertion: 10, result: contactId);
        int contactId2 = await context.createContact(null, "charlie@ox.io");
        _addListItem(text: "createContact charlie@ox.io", assertion: 11, result: contactId2);
        int chatId = await context.createChatByContactId(contactId);
        _addListItem(text: "createChatByContactId", assertion: 10, result: chatId);
        ChatList chatList = ChatList();
        int index = 0;
        int id = await chatList.getChatId(index, ChatList.typeNoSpecials);
        _addListItem(text: "getChatId", assertion: 10, result: id);
        var chatCnt = await chatList.getChatCnt(ChatList.typeNoSpecials);
        _addListItem(text: "getChatCnt", assertion: 1, result: chatCnt);
        int chatIdFromChatList = await chatList.getChat(index, ChatList.typeNoSpecials);
        _addListItem(text: "getChat", assertion: 10, result: chatIdFromChatList);
        var groupChatId = await context.createGroupChat(false, "The group");
        _addListItem(text: "createGroupChat", assertion: 11, result: groupChatId);
        var groupAddResult = await context.addContactToChat(groupChatId, contactId);
        _addListItem(text: "addContactToChat", assertion: 1, result: groupAddResult);
        StreamController controller = StreamController();
        var listenerId = await core.listen(Event.configureProgress, controller);
        _addListItem(text: "listen (core)", assertion: 1, result: listenerId);
        await core.removeListener(Event.configureProgress, listenerId);
        var contactIds = await context.getContacts(2, null);
        _addListItem(text: "getContacts (context)", assertion: 3, result: contactIds.length);
        var chatContactIds = await context.getChatContacts(chatId);
        _addListItem(text: "getChatContacts", assertion: 1, result: chatContactIds.length);
        var freshMessageCount = await context.getFreshMessageCount(chatId);
        _addListItem(text: "getFreshMessageCount", assertion: 0, result: freshMessageCount);
        await context.markNoticedChat(chatId);
        _addListItem(text: "markNoticedChat");
        await context.deleteChat(chatId);
        var chatCntAfterDeletingChat = await chatList.getChatCnt(ChatList.typeNoSpecials);
        _addListItem(text: "deleteChat", assertion: 0, result: chatCntAfterDeletingChat);
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
      var now = new DateTime.now().toIso8601String();
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
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('delta_chat_core test suite'),
          ),
          body: new ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return items[index];
              })),
    );
  }

}
