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

package com.openxchange.deltachatcore.handlers;

import android.annotation.SuppressLint;
import android.util.SparseIntArray;

import com.b44t.messenger.DcEventCenter;
import com.openxchange.deltachatcore.NativeInteractionManager;

import java.util.Arrays;
import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

public class EventChannelHandler implements EventChannel.StreamHandler {

    private static final String CHANNEL_DELTA_CHAT_CORE_EVENTS = "deltaChatCoreEvents";
    private final NativeInteractionManager nativeInteractionManager;
    private EventChannel.EventSink eventSink;
    private DcEventCenter.DcEventDelegate dcEventDelegate;
    private int listenerId = 0;
    @SuppressLint("UseSparseArrays")
    private SparseIntArray listeners = new SparseIntArray();

    public EventChannelHandler(NativeInteractionManager nativeInteractionManager, BinaryMessenger messenger) {
        this.nativeInteractionManager = nativeInteractionManager;
        EventChannel eventChannel = new EventChannel(messenger, CHANNEL_DELTA_CHAT_CORE_EVENTS);
        eventChannel.setStreamHandler(this);
        dcEventDelegate = new DcEventCenter.DcEventDelegate() {
            @Override
            public void handleEvent(int eventId, Object data1, Object data2) {
                List<Object> result = Arrays.asList(eventId, data1, data2);
                if (!hasListenersForId(eventId)) {
                    return;
                }
                eventSink.success(result);
            }

            @Override
            public boolean runOnMain() {
                return false;
            }
        };
    }

    public int addListener(Integer eventId) {
        if (eventId == null) {
            return -1;
        }
        if (!hasListenersForId(eventId)) {
            nativeInteractionManager.eventCenter.addObserver(eventId, dcEventDelegate);
        }
        listenerId++;
        listeners.put(listenerId, eventId);
        return listenerId;
    }

    public void removeListener(Integer listenerId) {
        if (listenerId == null) {
            return;
        }
        int eventId = listeners.get(listenerId);
        listeners.delete(listenerId);
        if (!hasListenersForId(eventId)) {
            nativeInteractionManager.eventCenter.removeObserver(eventId, dcEventDelegate);
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        if (this.eventSink != null) {
            return;
        }
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        if (eventSink == null) {
            return;
        }
        eventSink.endOfStream();
        eventSink = null;
    }

    @SuppressWarnings("BooleanMethodIsAlwaysInverted")
    private boolean hasListenersForId(int eventId) {
        return eventId != 0 && listeners.indexOfValue(eventId) >= 0;
    }
}
