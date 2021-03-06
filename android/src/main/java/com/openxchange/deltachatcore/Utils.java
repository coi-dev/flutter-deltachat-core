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

package com.openxchange.deltachatcore;

import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.b44t.messenger.DcContext;
import com.openxchange.deltachatcore.handlers.EventChannelHandler;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import static android.util.Log.DEBUG;
import static android.util.Log.ERROR;
import static android.util.Log.INFO;
import static android.util.Log.VERBOSE;
import static android.util.Log.WARN;

public class Utils {

    private static final Handler handler = new Handler(Looper.getMainLooper());

    public static void runOnMain(final @NonNull Runnable runnable) {
        handler.post(runnable);
    }

    public static void runOnBackground(final @NonNull Runnable runnable) {
        AsyncTask.THREAD_POOL_EXECUTOR.execute(runnable);
    }

    public static void sleep(long millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException e) {
            throw new AssertionError(e);
        }
    }

    public static void logEventAndDelegate(@Nullable EventChannelHandler eventChannelHandler, int logLevel, String tag, String message) {
        boolean shouldDelegate = eventChannelHandler != null;

        switch (logLevel) {
            case DEBUG:
                if (shouldDelegate) {
                    eventChannelHandler.handleEvent(DcContext.DC_EVENT_INFO, message, logLevel);
                }
                Log.d(tag, message);
                break;
            case INFO:
                if (shouldDelegate) {
                    eventChannelHandler.handleEvent(DcContext.DC_EVENT_INFO, message, logLevel);
                }
                Log.i(tag, message);
                break;
            case WARN:
                if (shouldDelegate) {
                    eventChannelHandler.handleEvent(DcContext.DC_EVENT_WARNING, message, logLevel);
                }
                Log.w(tag, message);
                break;
            case ERROR:
                if (shouldDelegate) {
                    eventChannelHandler.handleEvent(DcContext.DC_EVENT_ERROR, message, logLevel);
                }
                Log.e(tag, message);
                break;
            case VERBOSE:
            default:
                if (shouldDelegate) {
                    eventChannelHandler.handleEvent(DcContext.DC_EVENT_INFO, message, logLevel);
                }
                Log.v(tag, message);
        }

    }

}
