/*******************************************************************************
 *
 *                           Delta Chat Java Adapter
 *                           (C) 2019 Viktor Pracht
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see http://www.gnu.org/licenses/ .
 *
 ******************************************************************************/


// Purpose: The C part of the Java<->C Wrapper for the MIME interface, see also DcMimeContext.java

#include <malloc.h>
#include <jni.h>
#include <libetpan/mailmime_types.h>
#include "messenger-backend/src/deltachat_mime.h"
#include "messenger-backend/src/dc_tools.h"
#include <android/log.h>

#define JSTRING_NEW(a) jstring_new__(env, (a))
jstring jstring_new__(JNIEnv* env, const char* a);

static jclass    ArrayList, HashMap, DcContext, DcMimeContext, ContentType;
static jmethodID new_ArrayList, new_HashMap, new_ContentType;
static jmethodID ArrayList_add, HashMap_put, DcMimeContext_receiveMail;
static jfieldID  DcContext_contextCPtr;

#define DC_MIME_CONTEXT "com/openxchange/deltachatcore/DcMimeContext"

JNIEXPORT void JNICALL
Java_com_openxchange_deltachatcore_DcMimeContext_init(JNIEnv *env, jclass type) {
    // Classes
    static const struct {
        jclass* class_ref;
        const char* name;
    } classes[] = {
            {&ArrayList, "java/util/ArrayList"}, {&HashMap, "java/util/HashMap"},
            {&DcContext, "com/b44t/messenger/DcContext"}, {&DcMimeContext, DC_MIME_CONTEXT},
            {&ContentType, DC_MIME_CONTEXT "$ContentType"}
    };
    for (int i = 0; i < sizeof(classes) / sizeof (classes[0]); i++) {
        *classes[i].class_ref = (*env)->NewGlobalRef(env, (*env)->FindClass(env, classes[i].name));
    }

    // Constructors
    new_ArrayList   = (*env)->GetMethodID(env, ArrayList,   "<init>", "()V");
    new_HashMap     = (*env)->GetMethodID(env, HashMap,     "<init>", "()V");
    new_ContentType = (*env)->GetMethodID(env, ContentType, "<init>", "()V");

    // Methods
    ArrayList_add = (*env)->GetMethodID(env, ArrayList, "add", "(Ljava/lang/Object;)Z");
    HashMap_put   = (*env)->GetMethodID(env, HashMap,   "put", "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;");
    DcMimeContext_receiveMail = (*env)->GetMethodID(env, DcMimeContext, "receiveMail", "(J)V");

    // Fields
    DcContext_contextCPtr = (*env)->GetFieldID(env, DcContext,  "contextCPtr", "J");
}


typedef struct dc_jnicontext_t {
    JavaVM*   jvm; // JNIEnv cannot be shared between threads, so we share the JavaVM object
    jclass    cls;
    jobject   obj;
    jmethodID methodId;
} dc_jnicontext_t;


static void receive_cb(dc_context_t* context, struct mailmime* mime)
{
    JNIEnv* env;
    dc_jnicontext_t* jnicontext = dc_get_userdata(context);

    if (jnicontext==NULL || jnicontext->jvm==NULL || jnicontext->obj==NULL)
    {
        return;
    }

    (*jnicontext->jvm)->GetEnv(jnicontext->jvm, (void**)&env, JNI_VERSION_1_6); // as this function may be called from _any_ thread, we cannot use a static pointer to JNIEnv
    if (env==NULL) {
        return;
    }

    (*env)->CallVoidMethod(env, jnicontext->obj, DcMimeContext_receiveMail, (jlong)mime);
}


JNIEXPORT void JNICALL
Java_com_openxchange_deltachatcore_DcMimeContext_initInstance(JNIEnv *env, jobject instance, jlong contextCPtr)
{
    dc_context_t* context = (dc_context_t*) contextCPtr;

    if (context) dc_set_receive_cb(context, receive_cb);
}


JNIEXPORT jbyteArray JNICALL
Java_com_openxchange_deltachatcore_DcMimeContext_00024Mail_getBody(JNIEnv *env, jobject instance, jlong cPtr)
{
    struct mailmime* mime = (struct mailmime*) cPtr;
    if (mime==NULL) {
        return NULL;
    }

    jarray ret = NULL;
    if (mime->mm_body->dt_type==MAILMIME_DATA_TEXT) {
        jsize len = mime->mm_body->dt_data.dt_text.dt_length;
        ret = (*env)->NewByteArray(env, len);
        (*env)->SetByteArrayRegion(env, ret, 0, len, (jbyte*)mime->mm_body->dt_data.dt_text.dt_data);
    }
    return ret;
}


JNIEXPORT jobject JNICALL
Java_com_openxchange_deltachatcore_DcMimeContext_00024Mail_getContentType(JNIEnv *env, jobject instance, jlong cPtr)
{
    struct mailmime* mime = (struct mailmime*) cPtr;
    if (mime==NULL) {
        return NULL;
    }

    const char* type;
    switch (mime->mm_content_type->ct_type->tp_type) {
        case MAILMIME_TYPE_DISCRETE_TYPE: {
            struct mailmime_discrete_type* dt = mime->mm_content_type->ct_type->tp_data.tp_discrete_type;
            static const char* DISCRETE_TYPES[] = {NULL, "text", "image", "audio", "video", "application"};
            if (dt->dt_type>0 && dt->dt_type<MAILMIME_DISCRETE_TYPE_EXTENSION) {
                type = DISCRETE_TYPES[dt->dt_type];
            } else if (dt->dt_type==MAILMIME_DISCRETE_TYPE_EXTENSION) {
                type = dt->dt_extension;
            }
            break;
        }
        case MAILMIME_TYPE_COMPOSITE_TYPE: {
            struct mailmime_composite_type* ct = mime->mm_content_type->ct_type->tp_data.tp_composite_type;
            static const char* COMPOSITE_TYPES[] = {NULL, "message", "multipart"};
            if (ct->ct_type>0 && ct->ct_type<MAILMIME_COMPOSITE_TYPE_EXTENSION) {
                type = COMPOSITE_TYPES[ct->ct_type];
            } else if (ct->ct_type==MAILMIME_COMPOSITE_TYPE_EXTENSION) {
                type = ct->ct_token;
            }
            break;
        }
        default:
            type = NULL;
    }
    jobject params = (*env)->NewObject(env, HashMap, new_HashMap);
    for (clistiter* cur = clist_begin(mime->mm_content_type->ct_parameters); cur; cur = clist_next(cur))
    {
        struct mailmime_parameter* param = (struct mailmime_parameter*) clist_content(cur);
        jstring name = JSTRING_NEW(param->pa_name);
        jstring value = JSTRING_NEW(param->pa_value);
        jobject previous = (*env)->CallObjectMethod(env, params, HashMap_put, name, value);
        if (previous) (*env)->DeleteLocalRef(env, previous);
        (*env)->DeleteLocalRef(env, name);
        (*env)->DeleteLocalRef(env, value);
    }

    jobject ret = (*env)->NewObject(env, ContentType, new_ContentType, JSTRING_NEW(type),
            JSTRING_NEW(mime->mm_content_type->ct_subtype), params);

    return ret;
}
