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

class Contact extends Base {
  static const String _identifier = "contact";

  static const String methodContactGetId = "contact_getId";
  static const String methodContactGetName = "contact_getName";
  static const String methodContactGetDisplayName = "contact_getDisplayName";
  static const String methodContactGetFirstName = "contact_getFirstName";
  static const String methodContactGetAddress = "contact_getAddress";
  static const String methodContactGetNameAndAddress = "contact_getNameAndAddress";
  static const String methodContactGetProfileImage = "contact_getProfileImage";
  static const String methodContactGetColor = "contact_getColor";
  static const String methodContactIsBlocked = "contact_isBlocked";
  static const String methodContactIsVerified = "contact_isVerified";

  static const int idSelf = 1;
  static const int idDevice = 2;
  static const int idLastSpecial = 9;

  final int _id;

  Contact._internal(this._id) : super();

  @override
  int get id => _id;

  @override
  String get identifier => _identifier;

  Future<String> getName() async {
    return await loadAndGetValue(methodContactGetName);
  }

  Future<String> getDisplayName() async {
    return await loadAndGetValue(methodContactGetDisplayName);
  }

  Future<String> getFirstName() async {
    return await loadAndGetValue(methodContactGetFirstName);
  }

  Future<String> getAddress() async {
    return await loadAndGetValue(methodContactGetAddress);
  }

  Future<String> getNameAndAddress() async {
    return await loadAndGetValue(methodContactGetNameAndAddress);
  }

  Future<String> getProfileImage() async {
    return await loadAndGetValue(methodContactGetProfileImage);
  }

  Future<int> getColor() async {
    return await loadAndGetValue(methodContactGetColor);
  }

  Future<bool> isVerified() async {
    return await loadAndGetValue(methodContactIsVerified);
  }

  Future<bool> isBlocked() async {
    return await loadAndGetValue(methodContactIsBlocked);
  }

  Map<String, dynamic> getDefaultArguments() => <String, dynamic>{Base.argumentId: _id};

  static Function getCreator() {
    return (id) => new Contact._internal(id);
  }
}
