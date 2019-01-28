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

class Dc {
  static const int eventInfo = 100;
  static const int eventWarning = 300;
  static const int eventError = 400;
  static const int eventMsgsChanged = 2000;
  static const int eventIncomingMsg = 2005;
  static const int eventMsgDelivered = 2010;
  static const int eventMsgFailed = 2012;
  static const int eventMsgRead = 2015;
  static const int eventChatModified = 2020;
  static const int eventContactsChanged = 2030;
  static const int eventConfigureProgress = 2041;
  static const int eventImexProgress = 2051;
  static const int eventImexFileWrite = 2052;
  static const int eventSecureJoinInviterProgress = 2060;
  static const int eventSecureJoinJoinerProgress = 2061;
  static const int eventIsOffline = 2081;
  static const int eventGetString = 2091;
  static const int eventGetQuantityString = 2092;
  static const int eventHttpGet = 2100;
}
