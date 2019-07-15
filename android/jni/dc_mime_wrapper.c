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
#include <string.h>
#include <jni.h>
#include <libetpan/mailmime_types.h>
#include <libetpan/mailimf_types.h>
#include "messenger-backend/src/deltachat_mime.h"
#include "messenger-backend/src/dc_tools.h"

static jclass String, ArrayList, HashMap, Date;
static jclass DcContext, DcMimeContext, Message, ParamHeader, Header, Mailbox, MailboxGroup;
static jmethodID new_String, new_ArrayList, new_HashMap, new_Date;
static jmethodID new_Message, new_ParamHeader, new_Header, new_Mailbox, new_MailboxGroup;
static jmethodID ArrayList_add, HashMap_put, DcMimeContext_receiveMail;
static jstring encoding;

#define DC_MIME "com/openxchange/deltachatcore/mime/"

JNIEXPORT void JNICALL
Java_com_openxchange_deltachatcore_mime_DcMimeContext_init(JNIEnv *env, jclass type) {
    // Classes and constructors
    static const struct {
        jclass *class_ref;
        const char *name;
        jmethodID *ctor_ref;
        const char *ctor_signature;
    } classes[] = {
            {&String,        "java/lang/String",         &new_String,       "([BLjava/lang/String;)V"},
            {&ArrayList,     "java/util/ArrayList",      &new_ArrayList,    "()V"},
            {&HashMap,       "java/util/HashMap",        &new_HashMap,      "()V"},
            {&Date,          "java/util/Date",           &new_Date,         "(J)V"},
            {&Message,       DC_MIME "Message",          &new_Message,      "(JZ)V"},
            {&ParamHeader,   DC_MIME "ParamHeader",      &new_ParamHeader,  "(Ljava/lang/String;Ljava/util/Map;)V"},
            {&Header,        DC_MIME "Header",           &new_Header,       "(Ljava/lang/String;Ljava/lang/Object;)V"},
            {&Mailbox,       DC_MIME "Mailbox",          &new_Mailbox,      "(Ljava/lang/String;Ljava/lang/String;)V"},
            {&MailboxGroup,  DC_MIME "MailboxGroup",     &new_MailboxGroup, "(Ljava/lang/String;Ljava/util/ArrayList;)V"},

            {&DcContext, "com/b44t/messenger/DcContext", NULL,              NULL},
            {&DcMimeContext, DC_MIME "DcMimeContext",           NULL, NULL}
    };

    for (int i = 0; i < sizeof(classes) / sizeof(classes[0]); i++) {
        *classes[i].class_ref = (*env)->NewGlobalRef(env, (*env)->FindClass(env, classes[i].name));
        if (classes[i].ctor_ref != NULL) {
            *classes[i].ctor_ref = (*env)->GetMethodID(env, *classes[i].class_ref, "<init>",
                                                       classes[i].ctor_signature);
        }
    }

    // Methods
    ArrayList_add = (*env)->GetMethodID(env, ArrayList, "add", "(Ljava/lang/Object;)Z");
    HashMap_put = (*env)->GetMethodID(env, HashMap, "put",
                                      "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;");
    DcMimeContext_receiveMail = (*env)->GetMethodID(env, DcMimeContext, "receiveMail",
                                                    "(L" DC_MIME "Message;)V");

    // Constants
    encoding = (*env)->NewGlobalRef(env, (*env)->NewStringUTF(env, "UTF-8"));
}


static jstring to_string(JNIEnv *env, const char *a) {
    if (a == NULL) return NULL;

    jsize a_bytes = (jsize) strlen(a);
    jbyteArray array = (*env)->NewByteArray(env, a_bytes);
    (*env)->SetByteArrayRegion(env, array, 0, a_bytes, (jbyte *) a);
    jstring ret = (jstring) (*env)->NewObject(env, String, new_String, array, encoding);
    (*env)->DeleteLocalRef(env, array);

    return ret;
}


static jobject to_date(JNIEnv *env, struct mailimf_date_time *date_time) {
    return (*env)->NewObject(env, Date, new_Date, dc_timestamp_from_date(date_time) * 1000);
}


typedef jobject (*mapper_t)(JNIEnv *env, void *value);

#define MAPPER(f) ((mapper_t)(f))

static jobject to_arraylist(JNIEnv *env, clist *list, mapper_t mapper) {
    jobject arraylist = (*env)->NewObject(env, ArrayList, new_ArrayList);
    for (clistiter *cur = clist_begin(list); cur; cur = clist_next(cur)) {
        void *value = clist_content(cur);
        if (value == NULL) continue;

        jobject mapped_value = mapper(env, value);
        if (mapped_value == NULL) continue;

        (*env)->CallBooleanMethod(env, arraylist, ArrayList_add, mapped_value);
        (*env)->DeleteLocalRef(env, mapped_value);
    }
    return arraylist;
}


static jobject to_message(JNIEnv *env, struct mailmime *mime) {
    struct mailmime *nested = mime;
    if (mime->mm_type == MAILMIME_MESSAGE && mime->mm_parent == NULL) {
        // top-level message: use the nested message/rfc822 part
        nested = mime->mm_data.mm_message.mm_msg_mime;
        if (nested == NULL) return NULL;
    }

    jboolean multipart = (jboolean) (nested->mm_type == MAILMIME_MULTIPLE);
    return (*env)->NewObject(env, Message, new_Message, (jlong) mime, multipart);
}


typedef struct dc_jnicontext_t {
    JavaVM *jvm; // JNIEnv cannot be shared between threads, so we share the JavaVM object
    jclass cls;
    jobject obj;
    jmethodID methodId;
} dc_jnicontext_t;


static void receive_cb(dc_context_t *context, struct mailmime *mime) {
    if (context == NULL || mime == NULL) return;

    JNIEnv *env;
    dc_jnicontext_t *jnicontext = dc_get_userdata(context);

    if (jnicontext == NULL || jnicontext->jvm == NULL || jnicontext->obj == NULL) return;

    (*jnicontext->jvm)->GetEnv(jnicontext->jvm, (void **) &env,
                               JNI_VERSION_1_6); // as this function may be called from _any_ thread, we cannot use a static pointer to JNIEnv
    if (env == NULL) return;

    jobject message = to_message(env, mime);
    if (message == NULL) return;

    (*env)->CallVoidMethod(env, jnicontext->obj, DcMimeContext_receiveMail, message);
}


JNIEXPORT void JNICALL
Java_com_openxchange_deltachatcore_mime_DcMimeContext_initInstance(JNIEnv *env, jobject instance,
                                                                   jlong contextCPtr) {
    dc_context_t *context = (dc_context_t *) contextCPtr;

    if (context) dc_set_receive_cb(context, receive_cb);
}


JNIEXPORT jbyteArray JNICALL
Java_com_openxchange_deltachatcore_mime_Message_getBody__J(JNIEnv *env, jobject instance,
                                                           jlong cPtr) {
    struct mailmime *mime = (struct mailmime *) cPtr;
    if (mime == NULL) return NULL;

    if (mime->mm_type == MAILMIME_MESSAGE && mime->mm_parent == NULL) {
        // top-level message: use the nested message/rfc822 part
        mime = mime->mm_data.mm_message.mm_msg_mime;
        if (mime == NULL) return NULL;
    }

    if (mime->mm_body == NULL || mime->mm_body->dt_type != MAILMIME_DATA_TEXT) return NULL;

    jsize len = (jsize) mime->mm_body->dt_data.dt_text.dt_length;
    jarray ret = (*env)->NewByteArray(env, len);
    (*env)->SetByteArrayRegion(env, ret, 0, len,
                               (jbyte *) mime->mm_body->dt_data.dt_text.dt_data);
    return ret;
}


static jobject to_contenttype(JNIEnv *env, struct mailmime_content *content_type) {
    struct mailmime_type *ct_type = content_type->ct_type;
    if (ct_type == NULL) return NULL;

    const char *type = NULL;
    switch (ct_type->tp_type) {
        case MAILMIME_TYPE_DISCRETE_TYPE: {
            struct mailmime_discrete_type *dt = ct_type->tp_data.tp_discrete_type;
            if (dt == NULL) break;

            static const char *DISCRETE_TYPES[] = {NULL, "text", "image", "audio", "video",
                                                   "application"};
            if (dt->dt_type > 0 && dt->dt_type < MAILMIME_DISCRETE_TYPE_EXTENSION) {
                type = DISCRETE_TYPES[dt->dt_type];
            } else if (dt->dt_type == MAILMIME_DISCRETE_TYPE_EXTENSION) {
                type = dt->dt_extension;
            }
            break;
        }
        case MAILMIME_TYPE_COMPOSITE_TYPE: {
            struct mailmime_composite_type *ct = ct_type->tp_data.tp_composite_type;
            if (ct == NULL) break;

            static const char *COMPOSITE_TYPES[] = {NULL, "message", "multipart"};
            if (ct->ct_type > 0 && ct->ct_type < MAILMIME_COMPOSITE_TYPE_EXTENSION) {
                type = COMPOSITE_TYPES[ct->ct_type];
            } else if (ct->ct_type == MAILMIME_COMPOSITE_TYPE_EXTENSION) {
                type = ct->ct_token;
            }
            break;
        }
        default:
            break;
    }

    jobject params = (*env)->NewObject(env, HashMap, new_HashMap);
    for (clistiter *cur = clist_begin(content_type->ct_parameters); cur; cur = clist_next(cur)) {
        struct mailmime_parameter *param = (struct mailmime_parameter *) clist_content(cur);
        if (param == NULL) continue;

        jstring name = to_string(env, param->pa_name);
        jstring value = to_string(env, param->pa_value);
        jobject previous = (*env)->CallObjectMethod(env, params, HashMap_put, name, value);
        if (previous) (*env)->DeleteLocalRef(env, previous);
        (*env)->DeleteLocalRef(env, name);
        (*env)->DeleteLocalRef(env, value);
    }

    char *value = dc_mprintf("%s/%s", type, content_type->ct_subtype);
    jstring jvalue = to_string(env, value);
    free(value);

    jobject ret = (*env)->NewObject(env, ParamHeader, new_ParamHeader, jvalue, params);
    (*env)->DeleteLocalRef(env, params);
    (*env)->DeleteLocalRef(env, jvalue);
    return ret;
}


JNIEXPORT jobject JNICALL
Java_com_openxchange_deltachatcore_mime_Message_getContentType__J(JNIEnv *env, jobject instance,
                                                                  jlong cPtr) {
    struct mailmime *mime = (struct mailmime *) cPtr;
    if (mime == NULL) return NULL;

    if (mime->mm_type == MAILMIME_MESSAGE && mime->mm_parent == NULL) {
        // top-level message: use the nested message/rfc822 part
        mime = mime->mm_data.mm_message.mm_msg_mime;
        if (mime == NULL) return NULL;
    }

    if (mime->mm_content_type == NULL) return NULL;
    return to_contenttype(env, mime->mm_content_type);
}

static jobject to_mailbox(JNIEnv *env, struct mailimf_mailbox *mailbox) {
    jstring name = to_string(env, mailbox->mb_display_name);
    jstring addr = to_string(env, mailbox->mb_addr_spec);
    jobject ret = (*env)->NewObject(env, Mailbox, new_Mailbox, name, addr);
    (*env)->DeleteLocalRef(env, name);
    (*env)->DeleteLocalRef(env, addr);
    return ret;
}


static jobject to_address(JNIEnv *env, struct mailimf_address *address) {
    jobject value = NULL;
    switch (address->ad_type) {
        case MAILIMF_ADDRESS_MAILBOX: {
            struct mailimf_mailbox *mailbox = address->ad_data.ad_mailbox;
            if (mailbox != NULL) value = to_mailbox(env, mailbox);
            break;
        }
        case MAILIMF_ADDRESS_GROUP: {
            struct mailimf_group *group = address->ad_data.ad_group;
            if (group == NULL) break;
            jobject list = group->grp_mb_list == NULL ?
                           (*env)->NewObject(env, ArrayList, new_ArrayList) :
                           to_arraylist(env, group->grp_mb_list->mb_list, MAPPER(to_mailbox));
            value = (*env)->NewObject(env, MailboxGroup, new_MailboxGroup,
                                      to_string(env, group->grp_display_name), list);
            (*env)->DeleteLocalRef(env, list);
            break;
        }
        default:
            break;
    }
    return value;
}


static jobject to_header(JNIEnv *env, struct mailimf_field *field) {
    jobject value = NULL;
    switch (field->fld_type) {
        case MAILIMF_FIELD_RETURN_PATH: {
            struct mailimf_return *return_path = field->fld_data.fld_return_path;
            if (return_path != NULL) value = to_string(env, return_path->ret_path->pt_addr_spec);
            break;
        }
        case MAILIMF_FIELD_RESENT_DATE: {
            struct mailimf_orig_date *resent_date = field->fld_data.fld_resent_date;
            if (resent_date != NULL) value = to_date(env, resent_date->dt_date_time);
            break;
        }
        case MAILIMF_FIELD_RESENT_FROM: {
            struct mailimf_from *resent_from = field->fld_data.fld_resent_from;
            if (resent_from == NULL) break;
            value = to_arraylist(env, resent_from->frm_mb_list->mb_list, MAPPER(to_mailbox));
            break;
        }
        case MAILIMF_FIELD_RESENT_SENDER: {
            struct mailimf_sender *resent_sender = field->fld_data.fld_resent_sender;
            if (resent_sender != NULL) value = to_mailbox(env, resent_sender->snd_mb);
            break;
        }
        case MAILIMF_FIELD_RESENT_TO: {
            struct mailimf_to *resent_to = field->fld_data.fld_resent_to;
            if (resent_to == NULL) break;
            value = to_arraylist(env, resent_to->to_addr_list->ad_list, MAPPER(to_address));
            break;
        }
        case MAILIMF_FIELD_RESENT_CC: {
            struct mailimf_cc *resent_cc = field->fld_data.fld_resent_cc;
            if (resent_cc == NULL) break;
            value = to_arraylist(env, resent_cc->cc_addr_list->ad_list, MAPPER(to_address));
            break;
        }
        case MAILIMF_FIELD_RESENT_BCC: {
            struct mailimf_bcc *resent_bcc = field->fld_data.fld_resent_bcc;
            if (resent_bcc == NULL) break;
            value = to_arraylist(env, resent_bcc->bcc_addr_list->ad_list, MAPPER(to_address));
            break;
        }
        case MAILIMF_FIELD_RESENT_MSG_ID: {
            struct mailimf_message_id *resent_msg_id = field->fld_data.fld_resent_msg_id;
            if (resent_msg_id != NULL) value = to_string(env, resent_msg_id->mid_value);
            break;
        }
        case MAILIMF_FIELD_ORIG_DATE: {
            struct mailimf_orig_date *orig_date = field->fld_data.fld_orig_date;
            if (orig_date != NULL) value = to_date(env, orig_date->dt_date_time);
            break;
        }
        case MAILIMF_FIELD_FROM: {
            struct mailimf_from *from = field->fld_data.fld_from;
            if (from == NULL) break;
            value = to_arraylist(env, from->frm_mb_list->mb_list, MAPPER(to_mailbox));
            break;
        }
        case MAILIMF_FIELD_SENDER: {
            struct mailimf_sender *sender = field->fld_data.fld_sender;
            if (sender != NULL) value = to_mailbox(env, sender->snd_mb);
            break;
        }
        case MAILIMF_FIELD_REPLY_TO: {
            struct mailimf_reply_to *reply_to = field->fld_data.fld_reply_to;
            if (reply_to == NULL) break;
            value = to_arraylist(env, reply_to->rt_addr_list->ad_list, MAPPER(to_address));
            break;
        }
        case MAILIMF_FIELD_TO: {
            struct mailimf_to *to = field->fld_data.fld_to;
            if (to == NULL) break;
            value = to_arraylist(env, to->to_addr_list->ad_list, MAPPER(to_address));
            break;
        }
        case MAILIMF_FIELD_CC: {
            struct mailimf_cc *cc = field->fld_data.fld_cc;
            if (cc == NULL) break;
            value = to_arraylist(env, cc->cc_addr_list->ad_list, MAPPER(to_address));
            break;
        }
        case MAILIMF_FIELD_BCC: {
            struct mailimf_bcc *bcc = field->fld_data.fld_bcc;
            if (bcc == NULL) break;
            value = to_arraylist(env, bcc->bcc_addr_list->ad_list, MAPPER(to_address));
            break;
        }
        case MAILIMF_FIELD_MESSAGE_ID: {
            struct mailimf_message_id *message_id = field->fld_data.fld_message_id;
            if (message_id != NULL) value = to_string(env, message_id->mid_value);
            break;
        }
        case MAILIMF_FIELD_IN_REPLY_TO: {
            struct mailimf_in_reply_to *in_reply_to = field->fld_data.fld_in_reply_to;
            if (in_reply_to == NULL) break;
            value = to_arraylist(env, in_reply_to->mid_list, MAPPER(to_string));
            break;
        }
        case MAILIMF_FIELD_REFERENCES: {
            struct mailimf_references *references = field->fld_data.fld_references;
            if (references == NULL) break;
            value = to_arraylist(env, references->mid_list, MAPPER(to_string));
            break;
        }
        case MAILIMF_FIELD_SUBJECT: {
            struct mailimf_subject *subject = field->fld_data.fld_subject;
            if (subject != NULL) value = to_string(env, subject->sbj_value);
            break;
        }
        case MAILIMF_FIELD_COMMENTS: {
            struct mailimf_comments *comments = field->fld_data.fld_comments;
            if (comments != NULL) value = to_string(env, comments->cm_value);
            break;
        }
        case MAILIMF_FIELD_KEYWORDS: {
            struct mailimf_keywords *keywords = field->fld_data.fld_keywords;
            if (keywords == NULL) break;
            value = to_arraylist(env, keywords->kw_list, MAPPER(to_string));
            break;
        }
        case MAILIMF_FIELD_OPTIONAL_FIELD: {
            struct mailimf_optional_field *optional_field = field->fld_data.fld_optional_field;
            if (optional_field == NULL) break;
            jstring jname = to_string(env, optional_field->fld_name);
            jstring jvalue = to_string(env, optional_field->fld_value);
            jobject ret =  (*env)->NewObject(env, Header, new_Header, jname, jvalue);
            (*env)->DeleteLocalRef(env, jname);
            (*env)->DeleteLocalRef(env, jvalue);
            return ret;
        }
        default:break;
    }
    if (value == NULL) return NULL;

    static const char *HEADER_NAMES[] = {
            NULL, "Return-Path", "Resent-Date", "Resent-From", "Resent-Sender", "Resent-To",
            "Resent-Cc", "Resent-Bcc", "Resent-Message-ID", "Date", "From", "Sender", "Reply-To",
            "To", "Cc", "Bcc", "Message-ID", "In-Reply-To", "References", "Subject", "Comments",
            "Keywords"
    };

    jstring name = to_string(env, HEADER_NAMES[field->fld_type]);
    jobject ret = (*env)->NewObject(env, Header, new_Header, name, value);
    (*env)->DeleteLocalRef(env, name);
    (*env)->DeleteLocalRef(env, value);
    return ret;
}


static jobject to_disposition(JNIEnv *env, struct mailmime_disposition *disposition) {
    if (disposition->dsp_type == NULL) return NULL;

    const char *type = NULL;
    switch (disposition->dsp_type->dsp_type) {
        case MAILMIME_DISPOSITION_TYPE_INLINE:
            type = "inline";
            break;
        case MAILMIME_DISPOSITION_TYPE_ATTACHMENT:
            type = "attachment";
            break;
        case MAILMIME_DISPOSITION_TYPE_EXTENSION:
            type = disposition->dsp_type->dsp_extension;
            break;
        default:break;
    }
    if (type == NULL) return NULL;

    jobject params = (*env)->NewObject(env, HashMap, new_HashMap);
    for (clistiter *cur = clist_begin(disposition->dsp_parms); cur; cur = clist_next(cur)) {
        struct mailmime_disposition_parm *param = (struct mailmime_disposition_parm *) clist_content(cur);
        if (param == NULL) continue;

        const char *name = NULL;
        char *value = NULL;
        switch (param->pa_type) {
            case MAILMIME_DISPOSITION_PARM_FILENAME:
                name = "filename";
                value = param->pa_data.pa_filename;
                break;
            case MAILMIME_DISPOSITION_PARM_CREATION_DATE:
                name = "creation-date";
                value = param->pa_data.pa_creation_date;
                break;
            case MAILMIME_DISPOSITION_PARM_MODIFICATION_DATE:
                name = "modification-date";
                value = param->pa_data.pa_modification_date;
                break;
            case MAILMIME_DISPOSITION_PARM_READ_DATE:
                name = "read-date";
                value = param->pa_data.pa_read_date;
                break;
            case MAILMIME_DISPOSITION_PARM_SIZE:
                name = "size";
                value = dc_mprintf("%zu", param->pa_data.pa_size);
                break;
            case MAILMIME_DISPOSITION_PARM_PARAMETER:
                if (param->pa_data.pa_parameter == NULL) continue;
                name = param->pa_data.pa_parameter->pa_name;
                value = param->pa_data.pa_parameter->pa_value;
                break;
            default:break;
        }

        if (name != NULL && value != NULL) {
            jstring jname = to_string(env, name);
            jstring jvalue = to_string(env, value);
            jobject previous = (*env)->CallObjectMethod(env, params, HashMap_put, jname, jvalue);
            if (previous) (*env)->DeleteLocalRef(env, previous);
            (*env)->DeleteLocalRef(env, jname);
            (*env)->DeleteLocalRef(env, jvalue);
        }

        if (param->pa_type == MAILMIME_DISPOSITION_PARM_SIZE) free(value);
    }

    jstring jtype = to_string(env, type);
    jobject ret = (*env)->NewObject(env, ParamHeader, new_ParamHeader, jtype, params);
    (*env)->DeleteLocalRef(env, jtype);
    (*env)->DeleteLocalRef(env, params);
    return ret;
}


static jobject to_mime_header(JNIEnv *env, struct mailmime_field *field) {
    jobject value = NULL;
    switch (field->fld_type) {
        case MAILMIME_FIELD_TYPE: {
            struct mailmime_content *content = field->fld_data.fld_content;
            if (content != NULL) value = to_contenttype(env, content);
            break;
        }
        case MAILMIME_FIELD_TRANSFER_ENCODING: {
            struct mailmime_mechanism *mechanism = field->fld_data.fld_encoding;
            if (mechanism == NULL) break;

            static const char *ENCODINGS[] = {NULL, "7BIT", "8BIT", "BINARY", "QUOTED-PRINTABLE",
                                              "BASE64"};

            if (mechanism->enc_type > 0 && mechanism->enc_type < MAILMIME_MECHANISM_TOKEN) {
                value = to_string(env, ENCODINGS[mechanism->enc_type]);
            } else if (mechanism->enc_type == MAILMIME_MECHANISM_TOKEN) {
                value = to_string(env, mechanism->enc_token);
            }
            break;
        }
        case MAILMIME_FIELD_ID: {
            value = to_string(env, field->fld_data.fld_id);
            break;
        }
        case MAILMIME_FIELD_DESCRIPTION: {
            value = to_string(env, field->fld_data.fld_description);
            break;
        }
        case MAILMIME_FIELD_VERSION: {
            uint32_t version = field->fld_data.fld_version;
            char *version_str = dc_mprintf("%u.%u", version >> 16, version & 0xffff);
            value = to_string(env, version_str);
            free(version_str);
            break;
        }
        case MAILMIME_FIELD_DISPOSITION: {
            struct mailmime_disposition *disposition = field->fld_data.fld_disposition;
            if (disposition != NULL) value = to_disposition(env, disposition);
            break;
        }
        case MAILMIME_FIELD_LANGUAGE: {
            struct mailmime_language *language = field->fld_data.fld_language;
            if (language == NULL) break;
            value = to_arraylist(env, language->lg_list, MAPPER(to_string));
            break;
        }
        case MAILMIME_FIELD_LOCATION: {
            value = to_string(env, field->fld_data.fld_location);
            break;
        }
        default:break;
    }
    if (value == NULL) return NULL;

    static const char *HEADER_NAMES[] = {
            NULL, "Content-Type", "Content-Transfer-Encoding", "Content-ID", "Content-Description",
            "MIME-Version", "Content-Disposition", "Content-language", "Content-location"
    };

    jstring name = to_string(env, HEADER_NAMES[field->fld_type]);
    jobject ret = (*env)->NewObject(env, Header, new_Header, name, value);
    (*env)->DeleteLocalRef(env, name);
    (*env)->DeleteLocalRef(env, value);
    return ret;
}


JNIEXPORT jobject JNICALL
Java_com_openxchange_deltachatcore_mime_Message_getHeaders(JNIEnv *env, jobject instance,
                                                           jlong cPtr) {
    struct mailmime *mime = (struct mailmime *) cPtr;
    if (mime == NULL) return NULL;

    if (mime->mm_type == MAILMIME_MESSAGE && mime->mm_parent == NULL) {
        // top-level message: use the IMF headers
        struct mailimf_fields *fields = mime->mm_data.mm_message.mm_fields;
        if (fields == NULL || fields->fld_list == NULL) return NULL;

        return to_arraylist(env, fields->fld_list, MAPPER(to_header));
    } else {
        // nested message: use MIME headers
        struct mailmime_fields *mime_fields = mime->mm_mime_fields;
        if (mime_fields == NULL || mime_fields->fld_list == NULL) return NULL;

        return to_arraylist(env, mime_fields->fld_list, MAPPER(to_mime_header));
    }

}


JNIEXPORT jobject JNICALL
Java_com_openxchange_deltachatcore_mime_Message_getParts__J(JNIEnv *env, jobject instance,
                                                               jlong cPtr) {
    struct mailmime *mime = (struct mailmime *) cPtr;
    if (mime == NULL) return NULL;

    if (mime->mm_type == MAILMIME_MESSAGE && mime->mm_parent == NULL) {
        // top-level message: use the nested message/rfc822 part
        mime = mime->mm_data.mm_message.mm_msg_mime;
        if (mime == NULL) return NULL;
    }

    if (mime->mm_type != MAILMIME_MULTIPLE) return NULL;
    if (mime->mm_data.mm_multipart.mm_mp_list == NULL) return NULL;

    return to_arraylist(env, mime->mm_data.mm_multipart.mm_mp_list, MAPPER(to_message));
}
