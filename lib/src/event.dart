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

class Event {

  static const int info = 100;
  static const int warning = 300;
  static const int error = 400;
  static const int msgsChanged = 2000;
  static const int incomingMsg = 2005;
  static const int msgDelivered = 2010;
  static const int msgFailed = 2012;
  static const int msgRead = 2015;
  static const int chatModified = 2020;
  static const int contactsChanged = 2030;
  static const int configureProgress = 2041;
  static const int imexProgress = 2051;
  static const int imexFileWrite = 2052;
  static const int secureJoinInviterProgress = 2060;
  static const int secureJoinJoinerProgress = 2061;
  static const int isOffline = 2081;
  static const int getString = 2091;
  static const int getQuantityString = 2092;
  static const int httpGet = 2100;

  static const _INDEX_EVENT_ID = 0;
  static const _INDEX_DATA1 = 1;
  static const _INDEX_DATA2 = 2;

  int eventId;
  var data1;
  var data2;

  Event(this.eventId, this.data1, this.data2);

  Event.fromStream(dynamic data) {
    if (data is! List) {
      throw ArgumentError("Given data is no List, can't create Event object");
    }
    List eventMap = data as List;
    eventId = eventMap[_INDEX_EVENT_ID];
    data1 = eventMap[_INDEX_DATA1];
    data2 = eventMap[_INDEX_DATA2];
  }

  bool hasType(int type) {
    return eventId == type;
  }

}
