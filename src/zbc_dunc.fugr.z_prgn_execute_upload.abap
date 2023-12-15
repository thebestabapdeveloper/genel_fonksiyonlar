FUNCTION Z_PRGN_EXECUTE_UPLOAD.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(UPLOAD_USER_ASSIGNMENT) LIKE  SMENSAPNEW-CUSTOMIZED
*"         DEFAULT SPACE
*"     VALUE(UPLOAD_DESCRIPTION) LIKE  SMENSAPNEW-CUSTOMIZED
*"         DEFAULT 'X'
*"     VALUE(UPLOAD_AUTH_DATA) LIKE  SMENSAPNEW-CUSTOMIZED
*"         DEFAULT 'X'
*"     VALUE(UPLOAD_MENU_DATA) LIKE  SMENSAPNEW-CUSTOMIZED
*"         DEFAULT 'X'
*"     VALUE(UPLOAD_CHILD_AGRS) LIKE  SMENSAPNEW-CUSTOMIZED
*"         DEFAULT 'X'
*"     VALUE(UPLOAD_MINI_APPS) LIKE  SMENSAPNEW-CUSTOMIZED
*"         DEFAULT 'X'
*"     VALUE(SET_TARGET_SYSTEM) LIKE  SMENSAPNEW-CUSTOMIZED
*"         DEFAULT SPACE
*"     VALUE(TARGET_SYSTEM) LIKE  AGR_HIER-TARGET_SYS DEFAULT SPACE
*"     VALUE(SHOW_WARNING_POPUP) LIKE  SMENSAPNEW-CUSTOMIZED
*"         DEFAULT 'X'
*"     VALUE(NO_PROGRESS_INDICATOR) LIKE  SMENSAPNEW-CUSTOMIZED
*"         DEFAULT SPACE
*"     VALUE(NO_CHANGEDOCUMENT) LIKE  SMENSAPNEW-CUSTOMIZED
*"         DEFAULT ' '
*"  EXPORTING
*"     VALUE(NUMBER_OF_AGRS) LIKE  SY-TABIX
*"     VALUE(SINGLE_SELECTED_AGR) LIKE  AGR_DEFINE-AGR_NAME
*"  TABLES
*"      TRANSFER_TAB STRUCTURE  TRTAB
*"  EXCEPTIONS
*"      NOT_AUTHORIZED
*"      ACTIVITY_GROUP_ENQUEUED
*"      ILLEGAL_RELEASE
*"      NO_VALID_DATA
*"      ACTION_CANCELLED
*"--------------------------------------------------------------------
*  DATA: header_text LIKE agr_texts-text.
*  DATA: exit TYPE c.
*  DATA: menu_was_uploaded TYPE c.
*  DATA: tt_e071 LIKE e071 OCCURS 0 WITH HEADER LINE.
*  DATA: tt_e071k LIKE e071k OCCURS 0 WITH HEADER LINE.
*  DATA: transfer_tab_compressed LIKE trtab OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_define LIKE agr_define OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_tcodes LIKE agr_tcodes OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_1250 LIKE agr_1250 OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_1251 LIKE agr_1251 OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_1252 LIKE agr_1252 OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_1253 LIKE agr_1253 OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_texts LIKE agr_texts OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_flags LIKE agr_flags OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_usert LIKE agr_usert OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_buffi LIKE agr_buffi OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_hier LIKE agr_hier OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_hiert LIKE agr_hiert OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_agrs LIKE agr_agrs OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_custom LIKE agr_custom OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_time LIKE agr_time OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_mini LIKE agr_mini OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_minit LIKE agr_minit OCCURS 0 WITH HEADER LINE.
*  DATA: i_agr_atts LIKE agr_atts OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_define LIKE agr_define OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_tcodes LIKE agr_tcodes OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_1250 LIKE agr_1250 OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_1251 LIKE agr_1251 OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_1252 LIKE agr_1252 OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_1253 LIKE agr_1253 OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_texts LIKE agr_texts OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_flags LIKE agr_flags OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_usert LIKE agr_usert OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_buffi LIKE agr_buffi OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_hier LIKE agr_hier OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_hiert LIKE agr_hiert OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_agrs LIKE agr_agrs OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_custom LIKE agr_custom OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_time LIKE agr_time OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_mini LIKE agr_mini OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_minit LIKE agr_minit OCCURS 0 WITH HEADER LINE.
*  DATA: y_agr_atts LIKE agr_atts OCCURS 0 WITH HEADER LINE.
*  DATA: i_nodes_out LIKE agr_shier OCCURS 0 WITH HEADER LINE.
*  DATA: i_texts_out LIKE agr_shiert OCCURS 0 WITH HEADER LINE.
*  DATA: text(200) TYPE c.
*
*  DATA: o_agr_define LIKE agr_define.
*  DATA: o_agr_flags LIKE agr_flags OCCURS 0 WITH HEADER LINE.
*  DATA: o_agr_hier  LIKE agr_hier OCCURS 0 WITH HEADER LINE.
*  DATA: o_agr_buffi LIKE agr_buffi OCCURS 0 WITH HEADER LINE.
**  DATA: o_agr_mapp  LIKE agr_mapp OCCURS 0 WITH HEADER LINE.
*  DATA: o_agr_texts LIKE agr_texts OCCURS 0 WITH HEADER LINE.
*  DATA: o_agr_agrs LIKE agr_agrs OCCURS 0 WITH HEADER LINE.
**  DATA: o_agr_1251 LIKE agr_1251 OCCURS 0 WITH HEADER LINE.
**  DATA: o_agr_1252 LIKE agr_1252 OCCURS 0 WITH HEADER LINE.
**  DATA: o_agr_hpage LIKE agr_hpage OCCURS 0 WITH HEADER LINE.
*  DATA:
*        upd_agr_define TYPE c,  upd_agr_texts TYPE c,
*        upd_agr_flags  TYPE c,  upd_agr_hier  TYPE c,
**        upd_agr_mapp   TYPE c,  upd_agr_hpage TYPE c,
**        upd_agr_1251   TYPE c,  upd_agr_1252  TYPE c,
*        upd_agr_buffi  TYPE c,  upd_agr_agrs  TYPE c.
*
**  LOOP AT TRANSFER_TAB WHERE LINE(50) = 'EXTERNAL_ROLE'.
**  ENDLOOP.
**  IF SY-SUBRC = 0.
**    PERFORM UPLOAD_IN_EXTERNAL_FORMAT TABLES TRANSFER_TAB
**                   USING SET_TARGET_SYSTEM
**                         TARGET_SYSTEM
**                         UPLOAD_DESCRIPTION
**                         UPLOAD_MENU_DATA.
**    EXIT.
**  ENDIF.
*
*  IF upload_auth_data = space.
*    DELETE transfer_tab WHERE line(50) = 'AGR_1250'
*                           OR line(50) = 'AGR_1251'
*                           OR line(50) = 'AGR_1252'
*                           OR line(50) = 'AGR_1253'.
*  ENDIF.
*  IF upload_menu_data = space.
*    DELETE transfer_tab WHERE line(50) = 'AGR_HIER'
*                           OR line(50) = 'AGR_HIERT'
*                           OR line(50) = 'AGR_BUFFI'
*                           OR line(50) = 'AGR_TCODES'.
*  ENDIF.
*  IF upload_description = space.
*    DELETE transfer_tab WHERE line(50) = 'AGR_TEXTS'.
*  ENDIF.
*  IF upload_child_agrs = space.
*    DELETE transfer_tab WHERE line(50) = 'AGR_AGRS'.
*  ENDIF.
**  CALL FUNCTION 'TABLE_DECOMPRESS'
**       TABLES
**            IN                   = TRANSFER_TAB_COMPRESSED
**            OUT                  = TRANSFER_TAB
**       EXCEPTIONS
**            COMPRESS_ERROR       = 1
**            TABLE_NOT_COMPRESSED = 2
**            OTHERS               = 3.
**  IF SY-SUBRC <> 0.
**    MESSAGE I392(S#).
**    EXIT.
**  ENDIF.
************************************************************************
**
*  LOOP AT transfer_tab WHERE line(50) = 'RELEASE'.
*    IF transfer_tab-line+50 <> sy-saprl.
*      SELECT SINGLE * FROM prgn_cust WHERE id = 'UPLOAD_CHECK_RELEASE'.
*      IF sy-subrc = 0 AND prgn_cust-path = 'YES'.
*        RAISE illegal_release.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.
************************************************************************
**
*  REFRESH agrs_list.
*  LOOP AT transfer_tab WHERE line(50) = 'LOADED_AGRS'.
*    agrs_list = transfer_tab-line+50.
*    APPEND agrs_list.
*  ENDLOOP.
*  IF agrs_list[] IS INITIAL.
*    RAISE no_valid_data.
*  ENDIF.
*  SORT agrs_list BY agr_name.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_DEFINE'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_define = transfer_tab-line+50.
*    APPEND i_agr_define.
*  ENDLOOP.
*  IF i_agr_define[] IS INITIAL.
*    RAISE no_valid_data.
*  ENDIF.
** Prüfung auf S_USER_AGR, Aktivität Upload sowie Anlegen/Ändern
*  DATA: BEGIN OF missing_roles OCCURS 0,
*          line(60),
*        END OF missing_roles.
*  CLEAR missing_roles[].
*
*  LOOP AT i_agr_define.
*    CALL FUNCTION 'PRGN_CHECK_AGR_EXISTS'
*         EXPORTING
*              activity_group                = i_agr_define-agr_name
*         EXCEPTIONS
*              activity_group_does_not_exist = 1
*              OTHERS                        = 2.
*    IF sy-subrc <> 0.
*      CALL FUNCTION 'PRGN_AUTH_ACTIVITY_GROUP'
*           EXPORTING
*                activity_group = i_agr_define-agr_name
*                action_create  = 'X'
*                action_change  = 'X'
*                action_upload  = 'X'
*                message_output = ' '
*           EXCEPTIONS
*                not_authorized = 1
*                OTHERS         = 2.
*      IF sy-subrc <> 0.
*        MOVE i_agr_define-agr_name TO missing_roles.
*        APPEND missing_roles.
*      ENDIF.
*    ELSE.
*      CALL FUNCTION 'PRGN_AUTH_ACTIVITY_GROUP'
*           EXPORTING
*                activity_group = i_agr_define-agr_name
*                action_change  = 'X'
*                action_upload  = 'X'
*                message_output = ' '
*           EXCEPTIONS
*                not_authorized = 1
*                OTHERS         = 2.
*      IF sy-subrc <> 0.
*        MOVE i_agr_define-agr_name TO missing_roles.
*        APPEND missing_roles.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.
*  IF NOT missing_roles[] IS INITIAL.
*    CALL FUNCTION 'SUSR_POPUP_LIST_WITH_TEXT'
*         EXPORTING
*           text1         = 'fehlende Berechtigung fuer Rolle'
**          TEXT2         =
**          TEXT3         =
**          TEXT4         =
**        IMPORTING
**          OK_CODE       =
*         TABLES
*           list          = missing_roles
*                 .
*    MESSAGE e434(s#) WITH space "I_AGR_DEFINE-AGR_NAME
*      RAISING not_authorized.
*  ENDIF.
*
**** Popup für die Anzeige der AGRs
**************************************
*  IF show_warning_popup = 'X'.
*    CALL FUNCTION 'PRGN_SHOW_WARNING_POPUP'
*         TABLES
*              activity_groups  = i_agr_define
*         EXCEPTIONS
*              action_cancelled = 1
*              OTHERS           = 2.
*    IF sy-subrc <> 0.
*      RAISE action_cancelled.
*    ENDIF.
*  ENDIF.
************************************************************************
**
*  CALL FUNCTION 'PRGN_ACTIVITY_GROUPS_ENQUEUE'
*       TABLES
*            activity_groups         = i_agr_define
*       EXCEPTIONS
*            foreign_lock            = 1
*            transport_check_problem = 2
*            OTHERS                  = 3.
*  IF sy-subrc <> 0.
*    RAISE activity_group_enqueued.
*  ENDIF.
************************************************************************
**
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_TCODES'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_tcodes = transfer_tab-line+50.
*    APPEND i_agr_tcodes.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_1250'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_1250 = transfer_tab-line+50.
*    APPEND i_agr_1250.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_1251'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_1251 = transfer_tab-line+50.
*    APPEND i_agr_1251.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_1252'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_1252 = transfer_tab-line+50.
*    APPEND i_agr_1252.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_1253'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_1253 = transfer_tab-line+50.
*    APPEND i_agr_1253.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_TEXTS'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_texts = transfer_tab-line+50.
*    APPEND i_agr_texts.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_FLAGS'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_flags = transfer_tab-line+50.
*    APPEND i_agr_flags.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_USERT'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_usert = transfer_tab-line+50.
*    APPEND i_agr_usert.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_BUFFI'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_buffi = transfer_tab-line+50.
*    APPEND i_agr_buffi.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_HIER'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_hier = transfer_tab-line+50.
*    APPEND i_agr_hier.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_HIERT'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_hiert = transfer_tab-line+50.
*    APPEND i_agr_hiert.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_AGRS'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_agrs = transfer_tab-line+50.
*    APPEND i_agr_agrs.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_CUSTOM'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_custom = transfer_tab-line+50.
*    APPEND i_agr_custom.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_TIME'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_time = transfer_tab-line+50.
*    APPEND i_agr_time.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_MINI'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_mini = transfer_tab-line+50.
*    APPEND i_agr_mini.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_MINIT'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_minit = transfer_tab-line+50.
*    APPEND i_agr_minit.
*  ENDLOOP.
*  LOOP AT transfer_tab WHERE line(50) = 'AGR_ATTS'.
*    PERFORM check_if_agr_is_valid USING transfer_tab CHANGING exit.
*    IF exit = 'X'. CONTINUE. ENDIF.
*    i_agr_atts = transfer_tab-line+50.
*    APPEND i_agr_atts.
*  ENDLOOP.
** Konsistenzbereinigungen auf den Tabellen:
*  DELETE i_agr_hier WHERE object_id = 1.
*  DELETE i_agr_hiert WHERE object_id = 1.
*  REFRESH transfer_tab.
************************************************************************
**
** Berechtigungsprüfung für gesamte Transaktionsliste und alle
** Berechtigungsdaten in der Datei (In alten Support-Packages wurde die
** Gesamtberechtigung für S_USER_TCD und S_USER_VAL geprüft.)
*  DATA: BEGIN OF missing_authorizations OCCURS 0,
*          line(60),
*        END OF missing_authorizations.
*  CLEAR missing_authorizations[].
*  IF upload_menu_data = 'X'.
*    LOOP AT i_agr_tcodes.
*      AUTHORITY-CHECK OBJECT 'S_USER_TCD'
*               ID 'TCD' FIELD i_agr_tcodes-tcode.
*      IF sy-subrc <> 0.
*        CONCATENATE 'S_USER_TCD' i_agr_tcodes-tcode
*          INTO missing_authorizations
*          SEPARATED BY space.
*        APPEND missing_authorizations.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*  IF upload_auth_data = 'X'.
*    LOOP AT i_agr_1251.
*      AUTHORITY-CHECK OBJECT 'S_USER_VAL'
*               ID 'OBJECT'     FIELD i_agr_1251-object
*               ID 'AUTH_FIELD' FIELD i_agr_1251-field
*               ID 'AUTH_VALUE' FIELD i_agr_1251-low.
*      IF sy-subrc <> 0.
*        CONCATENATE 'S_USER_VAL'
*                    i_agr_1251-object i_agr_1251-field i_agr_1251-low
*         INTO missing_authorizations
*         SEPARATED BY space.
*        APPEND missing_authorizations.
*      ENDIF.
*      IF i_agr_1251-high <> space.
*        AUTHORITY-CHECK OBJECT 'S_USER_VAL'
*                 ID 'OBJECT'     FIELD i_agr_1251-object
*                 ID 'AUTH_FIELD' FIELD i_agr_1251-field
*                 ID 'AUTH_VALUE' FIELD '*'.
*        IF sy-subrc <> 0.
*          CONCATENATE 'S_USER_VAL'
*                      i_agr_1251-object i_agr_1251-field '*'
*           INTO missing_authorizations
*           SEPARATED BY space.
*          APPEND missing_authorizations.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*  IF NOT missing_authorizations[] IS INITIAL.
*    CALL FUNCTION 'SUSR_POPUP_LIST_WITH_TEXT'
*         EXPORTING
*           text1         = 'fehlende Berechtigung'
**          TEXT2         =
**          TEXT3         =
**          TEXT4         =
**        IMPORTING
**          OK_CODE       =
*         TABLES
*           list          = missing_authorizations
*                 .
*    MESSAGE e434(s#) WITH space "I_AGR_DEFINE-AGR_NAME
*      RAISING not_authorized.
*  ENDIF.
************************************************************************
**
*
*  LOOP AT i_agr_define.
*
*    menu_was_uploaded = ' '.
*    REFRESH: y_agr_define, y_agr_tcodes, y_agr_1250, y_agr_1251,
*             y_agr_1252, y_agr_1253, y_agr_texts, y_agr_flags,
*             y_agr_usert, y_agr_buffi, y_agr_hier, y_agr_hiert,
*             y_agr_agrs, y_agr_custom, y_agr_time, y_agr_mini,
*             y_agr_minit, y_agr_atts,
*             i_nodes_out, i_texts_out.
*    CLEAR:   y_agr_define, y_agr_tcodes, y_agr_1250, y_agr_1251,
*             y_agr_1252, y_agr_1253, y_agr_texts, y_agr_flags,
*             y_agr_usert, y_agr_buffi, y_agr_hier, y_agr_hiert,
*             y_agr_agrs, y_agr_custom, y_agr_time, y_agr_mini,
*             y_agr_minit, y_agr_atts,
*             y_agr_1251,  y_agr_1252,  y_agr_texts, y_agr_flags,
*             y_agr_usert, y_agr_buffi, y_agr_agrs,
**             y_agr_mapp,  y_agr_hpage,
*             i_nodes_out, i_texts_out.
*    CLEAR:   o_agr_define, o_agr_agrs, o_agr_flags,
*             o_agr_texts , o_agr_hier, o_agr_buffi,
**             o_agr_1251, o_agr_1252,
**             o_agr_mapp, o_agr_hpage,
*             upd_agr_define, upd_agr_texts,
*             upd_agr_flags,  upd_agr_hier,
*             upd_agr_buffi,
**             upd_agr_1251,   upd_agr_1252,
**             upd_agr_mapp,   upd_agr_hpage,
*             upd_agr_agrs.
*
*    CONCATENATE text-100 i_agr_define-agr_name INTO text
*                SEPARATED BY space.
*    IF no_progress_indicator = space.
*      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
*           EXPORTING
*                percentage = 0
*                text       = text.
*    ENDIF.
*
*    i_agr_define-create_usr = sy-uname.
*    i_agr_define-create_dat = sy-datum.
*    i_agr_define-create_tim = sy-uzeit.
*    CLEAR i_agr_define-create_tmp.
*    i_agr_define-change_usr = sy-uname.
*    i_agr_define-change_dat = sy-datum.
*    i_agr_define-change_tim = sy-uzeit.
*    CLEAR i_agr_define-change_tmp.
*    i_agr_define-attributes = space.
*    APPEND i_agr_define TO y_agr_define.
*    LOOP AT i_agr_flags WHERE agr_name = i_agr_define-agr_name.
*      APPEND i_agr_flags TO y_agr_flags.
*    ENDLOOP.
*    LOOP AT i_agr_agrs WHERE agr_name = i_agr_define-agr_name.
*      APPEND i_agr_agrs TO y_agr_agrs.
*    ENDLOOP.
*    LOOP AT i_agr_custom WHERE agr_name = i_agr_define-agr_name.
*      CLEAR i_agr_custom-change_tst.
*      APPEND i_agr_custom TO y_agr_custom.
*    ENDLOOP.
*    LOOP AT i_agr_time WHERE agr_name = i_agr_define-agr_name.
*      CLEAR i_agr_time-create_tmp.
*      CLEAR i_agr_time-change_usr.
*      CLEAR i_agr_time-change_dat.
*      CLEAR i_agr_time-change_tim.
*      CLEAR i_agr_time-change_tmp.
*      CLEAR i_agr_time-attributes.
*      APPEND i_agr_time TO y_agr_time.
*    ENDLOOP.
*    LOOP AT i_agr_usert WHERE agr_name = i_agr_define-agr_name.
*      CLEAR i_agr_usert-change_tst.
*      APPEND i_agr_usert TO y_agr_usert.
*    ENDLOOP.
*    LOOP AT i_agr_mini WHERE agr_name = i_agr_define-agr_name.
*      APPEND i_agr_mini TO y_agr_mini.
*    ENDLOOP.
*    LOOP AT i_agr_minit WHERE agr_name = i_agr_define-agr_name.
*      APPEND i_agr_minit TO y_agr_minit.
*    ENDLOOP.
*    LOOP AT i_agr_atts WHERE agr_name = i_agr_define-agr_name.
*      APPEND i_agr_atts TO y_agr_atts.
*    ENDLOOP.
*
**   Flag-Tabelle bereinigen:
*    IF upload_auth_data = space.
*      DELETE y_agr_flags WHERE flag_type = 'FORCE_MIX'.
*      DELETE y_agr_flags WHERE flag_type = 'FORCE_YEL'.
*      DELETE y_agr_flags WHERE flag_type = 'FORCE_YIN'.
*    ENDIF.
**   DELETE Y_AGR_FLAGS WHERE FLAG_TYPE = 'XPRA_FLAG'.
*    DELETE y_agr_flags WHERE flag_type = 'SAP_SOURCE'.
*    DELETE y_agr_flags WHERE flag_type = 'SAPORIGSAV'.
*    DELETE y_agr_flags WHERE flag_type = 'MAINT_VERS'.
**   SYS_FLAG should not be copied
*    DELETE y_agr_flags WHERE flag_type = 'SYS_FLAG'.
*
**   Save old state (Before Image) of AGR_DEFINE, AGR_FLAGS, AGR_HPAGE
*    SELECT SINGLE * FROM agr_define INTO o_agr_define
*                 WHERE agr_name = i_agr_define-agr_name.
*    IF sy-subrc <> 0.
*      upd_agr_define = 'I'.
*    ELSE.
*      upd_agr_define = 'U'.
*    ENDIF.
*
*    SELECT * FROM agr_flags INTO TABLE o_agr_flags
*                      WHERE  agr_name = i_agr_define-agr_name
*                        AND ( flag_type = 'COLL_AGR'
**                             SYS_FLAG should not be copied
**                           OR flag_type = 'CUSTOMIZE'
*                      ).
*    IF sy-subrc <> 0.
*      upd_agr_flags = 'I'.
*    ELSE.
*      upd_agr_flags = 'U'.
*    ENDIF.
*
**    SELECT * FROM agr_hpage INTO TABLE o_agr_hpage
**                      WHERE  agr_name = i_agr_define-agr_name.
**    IF sy-subrc <> 0.
**      upd_agr_hpage = 'I'.
**    ELSE.
**      upd_agr_hpage = 'U'.
**    ENDIF.
*
*
**   Flags kommen immer nur noch dazu .....
**   DELETE FROM AGR_FLAGS WHERE AGR_NAME = I_AGR_DEFINE-AGR_NAME.
**   DELETE FROM AGR_TIME WHERE AGR_NAME = I_AGR_DEFINE-AGR_NAME.
*    DELETE FROM agr_flags WHERE agr_name = i_agr_define-agr_name
*                          AND ( flag_type = 'COLL_AGR' OR
*                                flag_type = 'CUSTOMIZE' ).
*    DELETE FROM agr_define WHERE agr_name = i_agr_define-agr_name.
*    DELETE FROM agr_custom WHERE agr_name = i_agr_define-agr_name.
*    DELETE FROM agr_usert WHERE agr_name = i_agr_define-agr_name.
*    DELETE FROM agr_atts WHERE agr_name = i_agr_define-agr_name.
*
**   INSERT AGR_TIME FROM TABLE Y_AGR_TIME ACCEPTING DUPLICATE KEYS.
*    INSERT agr_define FROM TABLE y_agr_define ACCEPTING DUPLICATE KEYS.
*    INSERT agr_custom FROM TABLE y_agr_custom ACCEPTING DUPLICATE KEYS.
*    INSERT agr_flags FROM TABLE y_agr_flags ACCEPTING DUPLICATE KEYS.
*    INSERT agr_atts FROM TABLE y_agr_atts ACCEPTING DUPLICATE KEYS.
*
**    IF upload_new_mini_apps = 'X'.
***     Save old state of AGR_MAPP
**      SELECT * FROM agr_mapp INTO TABLE o_agr_mapp
**                       WHERE agr_name = i_agr_define-agr_name.
**      IF sy-subrc <> 0.
**        upd_agr_mapp = 'I'.
**      ELSE.
**        upd_agr_mapp = 'U'.
**      ENDIF.
***     Update AGR_MAPP
**      DELETE FROM agr_mapp WHERE agr_name = i_agr_define-agr_name.
**      INSERT agr_mapp FROM TABLE y_agr_mapp ACCEPTING DUPLICATE KEYS.
**    ENDIF.
*
*    IF upload_mini_apps = 'X'.
*      DELETE FROM agr_mini WHERE agr_name = i_agr_define-agr_name.
*      DELETE FROM agr_minit WHERE agr_name = i_agr_define-agr_name.
*      INSERT agr_mini FROM TABLE y_agr_mini ACCEPTING DUPLICATE KEYS.
*      INSERT agr_minit FROM TABLE y_agr_minit ACCEPTING DUPLICATE KEYS.
*    ENDIF.
*
*    IF upload_child_agrs = 'X'.
**     Save old state (Before Image) of AGR_AGRS
*      SELECT * FROM agr_agrs INTO TABLE o_agr_agrs
*                      WHERE agr_name = i_agr_define-agr_name.
*      IF sy-subrc <> 0.
*        upd_agr_agrs = 'I'.
*      ELSE.
*        upd_agr_agrs = 'U'.
*      ENDIF.
**     Update AGR_AGRS
*      DELETE FROM agr_agrs WHERE agr_name = i_agr_define-agr_name.
*      INSERT agr_agrs FROM TABLE y_agr_agrs ACCEPTING DUPLICATE KEYS.
*      MODIFY agr_agrs2 FROM TABLE i_agr_agrs.
*      CALL FUNCTION 'PRGN_SET_CHILD_AGRS_TIMESTAMP'
*           EXPORTING
*                activity_group = i_agr_define-agr_name.
*    ENDIF.
*
*    IF upload_description = 'X'.
**     Save old state (Before Image) of AGR_TEXTS
*      SELECT * FROM agr_texts INTO TABLE o_agr_texts
*                      WHERE agr_name = i_agr_define-agr_name.
*      IF sy-subrc <> 0.
*        upd_agr_texts = 'I'.
*      ELSE.
*        upd_agr_texts = 'U'.
*      ENDIF.
**     Update AGR_TEXTS
*      LOOP AT i_agr_texts WHERE agr_name = i_agr_define-agr_name.
*        APPEND i_agr_texts TO y_agr_texts.
*      ENDLOOP.
*      DELETE FROM agr_texts WHERE agr_name = i_agr_define-agr_name.
*      INSERT agr_texts FROM TABLE y_agr_texts ACCEPTING DUPLICATE KEYS.
*    ENDIF.
*
*    IF upload_menu_data = 'X'.
**     Save old state (Before Image) of AGR_HIER, AGR_BUFFI
*      SELECT * FROM agr_hier INTO TABLE o_agr_hier
*                       WHERE agr_name = i_agr_define-agr_name.
*      IF sy-subrc <> 0.
*        upd_agr_hier = 'I'.
*      ELSE.
*        upd_agr_hier = 'U'.
*      ENDIF.
*
*      SELECT * FROM agr_buffi INTO TABLE o_agr_buffi
*                       WHERE agr_name = i_agr_define-agr_name.
*      IF sy-subrc <> 0.
*        upd_agr_buffi = 'I'.
*      ELSE.
*        upd_agr_buffi = 'U'.
*      ENDIF.
**     Update DB tables
*      LOOP AT i_agr_tcodes WHERE agr_name = i_agr_define-agr_name.
*        APPEND i_agr_tcodes TO y_agr_tcodes.
*      ENDLOOP.
*      LOOP AT i_agr_buffi WHERE agr_name = i_agr_define-agr_name.
*        APPEND i_agr_buffi TO y_agr_buffi.
*      ENDLOOP.
*      LOOP AT i_agr_hier WHERE agr_name = i_agr_define-agr_name.
*        APPEND i_agr_hier TO y_agr_hier.
*      ENDLOOP.
*      LOOP AT i_agr_hiert WHERE agr_name = i_agr_define-agr_name.
*        APPEND i_agr_hiert TO y_agr_hiert.
*      ENDLOOP.
*      DELETE FROM agr_tcodes WHERE agr_name = i_agr_define-agr_name.
*      DELETE FROM agr_buffi WHERE agr_name = i_agr_define-agr_name.
*      DELETE FROM agr_hier WHERE agr_name = i_agr_define-agr_name.
*      DELETE FROM agr_hiert WHERE agr_name = i_agr_define-agr_name.
*      INSERT agr_tcodes FROM TABLE y_agr_tcodes
*                                              ACCEPTING DUPLICATE KEYS.
*      INSERT agr_buffi FROM TABLE y_agr_buffi ACCEPTING DUPLICATE KEYS.
*      INSERT agr_hier FROM TABLE y_agr_hier ACCEPTING DUPLICATE KEYS.
*      INSERT agr_hiert FROM TABLE y_agr_hiert ACCEPTING DUPLICATE KEYS.
*      IF ( NOT y_agr_hier[] IS INITIAL ) OR
*         ( NOT y_agr_tcodes[] IS INITIAL ).
*        CALL FUNCTION 'PRGN_SET_MENU_TIMESTAMP'
*             EXPORTING
*                  activity_group = i_agr_define-agr_name.
*        menu_was_uploaded = 'X'.
*      ENDIF.
*    ENDIF.
*
*    IF upload_auth_data = 'X'.
*      LOOP AT i_agr_1250 WHERE agr_name = i_agr_define-agr_name.
*        APPEND i_agr_1250 TO y_agr_1250.
*      ENDLOOP.
*      LOOP AT i_agr_1251 WHERE agr_name = i_agr_define-agr_name.
*        APPEND i_agr_1251 TO y_agr_1251.
*      ENDLOOP.
*      LOOP AT i_agr_1252 WHERE agr_name = i_agr_define-agr_name.
*        APPEND i_agr_1252 TO y_agr_1252.
*      ENDLOOP.
*      LOOP AT i_agr_1253 WHERE agr_name = i_agr_define-agr_name.
*        APPEND i_agr_1253 TO y_agr_1253.
*      ENDLOOP.
*
**     Log tutulup tutulmaması isteğe bağlı yapıldı
**     Compozit role yaratan program yetki Authorization name(AUTH)'i
**     yeniden belirlediği için log anlamsızlaşıyor...!!!
** --> Inserted by/on: Akan ÇEŞME/22.08.2005
*      IF no_changedocument NE space.
*        DELETE FROM agr_1251 WHERE agr_name = i_agr_define-agr_name.
*        DELETE FROM agr_1252 WHERE agr_name = i_agr_define-agr_name.
*        INSERT agr_1251 FROM TABLE y_agr_1251 ACCEPTING DUPLICATE KEYS.
*        INSERT agr_1252 FROM TABLE y_agr_1252 ACCEPTING DUPLICATE KEYS.
*      ELSE.
** <-- Inserted by/on: Akan ÇEŞME/22.08.2005
*      PERFORM prgn_update_database_1251(saplprgn_scdo_h)
*        TABLES y_agr_1251
*        USING  i_agr_define-agr_name
*      .
*      PERFORM prgn_update_database_1252(saplprgn_scdo_h)
*        TABLES y_agr_1252
*        USING  i_agr_define-agr_name
*      .
*      ENDIF.                         " Ins. by/on: Akan ÇEŞME/22.08.05
*      DELETE FROM agr_1250 WHERE agr_name = i_agr_define-agr_name.
*      DELETE FROM agr_1253 WHERE agr_name = i_agr_define-agr_name.
*      INSERT agr_1250 FROM TABLE y_agr_1250 ACCEPTING DUPLICATE KEYS.
*      INSERT agr_1253 FROM TABLE y_agr_1253 ACCEPTING DUPLICATE KEYS.
*
*      IF ( NOT y_agr_1250[] IS INITIAL ) OR
*         ( NOT y_agr_1253[] IS INITIAL ).
*        CALL FUNCTION 'PRGN_SET_PROFILE_TIMESTAMP'
*             EXPORTING
*                  activity_group = i_agr_define-agr_name.
*      ENDIF.
*    ENDIF.
*
*    IF upload_user_assignment = 'X'.
*      INSERT agr_usert FROM TABLE y_agr_usert ACCEPTING DUPLICATE KEYS.
*      REFRESH tt_e071.
*      LOOP AT y_agr_usert.
*        tt_e071-pgmid = 'R3TR'.
*        tt_e071-object = 'ACGT'.
*        tt_e071-obj_name = y_agr_usert-agr_name.
*        APPEND tt_e071.
*      ENDLOOP.
*      SORT tt_e071 BY pgmid object obj_name.
*      DELETE ADJACENT DUPLICATES FROM tt_e071
*                                        COMPARING pgmid object obj_name
*.
*      CALL FUNCTION 'PRGN_AFTER_IMP_ACTGROUP'
*           EXPORTING
*                iv_tarclient  = sy-mandt
*                iv_is_upgrade = space
*           TABLES
*                tt_e071       = tt_e071
*                tt_e071k      = tt_e071k.
*    ENDIF.
*
**   Write change documents
*    IF no_changedocument EQ space.   " Ins. by/on: Akan ÇEŞME/22.08.05
*    CALL FUNCTION 'PRGN_CHANGEDOCUMENT_WRITE_UPLO'
*         EXPORTING
*              activity_group = i_agr_define-agr_name
*              o_agr_define   = o_agr_define
*              n_agr_define   = i_agr_define
*              upd_agr_agrs   = upd_agr_agrs
*              upd_agr_define = upd_agr_define
*              upd_agr_flags  = upd_agr_flags
**              upd_agr_mapp   = upd_agr_mapp
*              upd_agr_buffi  = upd_agr_buffi
*              upd_agr_hier   = upd_agr_hier
*              upd_agr_texts  = upd_agr_texts
**              upd_agr_hpage  = upd_agr_hpage
*         TABLES
*              o_agr_hier     = o_agr_hier
*              o_agr_buffi    = o_agr_buffi
*              o_agr_texts    = o_agr_texts
**              o_agr_mapp     = o_agr_mapp
*              o_agr_agrs     = o_agr_agrs
*              o_agr_flags    = o_agr_flags
**              o_agr_hpage    = o_agr_hpage
*              n_agr_hier     = y_agr_hier
*              n_agr_buffi    = y_agr_buffi
*              n_agr_texts    = y_agr_texts
**              n_agr_mapp     = y_agr_mapp
*              n_agr_agrs     = y_agr_agrs
*              n_agr_flags    = y_agr_flags
**              n_agr_hpage    = y_agr_hpage
*    .
*    ENDIF.                           " Ins. by/on: Akan ÇEŞME/22.08.05
*    IF set_target_system = 'X'.
*      CALL FUNCTION 'PRGN_SET_SYSTEM_FLAG'
*           EXPORTING
*                activity_group = i_agr_define-agr_name
*                sys_flag       = target_system.
*    ENDIF.
*
*    CALL FUNCTION 'PRGN_SET_ACTGROUP_TIMESTAMP'
*         EXPORTING
*              activity_group                = i_agr_define-agr_name
*         EXCEPTIONS
*              activity_group_does_not_exist = 1
*              OTHERS                        = 2.
*    CALL FUNCTION 'PRGN_SET_YELLOW_FLAG_ACTIVE'
*         EXPORTING
*              activity_group = i_agr_define-agr_name.
*    COMMIT WORK.
*
*    IF menu_was_uploaded = 'X'.
*      CALL FUNCTION 'PRGN_STRU_LOAD_NODES'
*           EXPORTING
*                activity_group = i_agr_define-agr_name
*           TABLES
*                i_nodes_out    = i_nodes_out
*                i_texts_out    = i_texts_out.
*      CALL FUNCTION 'PRGN_STRU_SAVE_NODES'
*           EXPORTING
*                activity_group          = i_agr_define-agr_name
*                use_global_tables       = ' '
*                only_sy_langu           = ' '
*           TABLES
*                menu_hierarchy          = i_nodes_out
*                menu_texts              = i_texts_out
*           EXCEPTIONS
*                not_authorized          = 1
*                activity_group_enqueued = 2
*                OTHERS                  = 3.
*      .
*      CASE sy-subrc.
*        WHEN 1.
*          MESSAGE e434(s#) WITH i_agr_define-agr_name
*            RAISING not_authorized.
*        WHEN 2.
*          RAISE activity_group_enqueued.
*        WHEN 3.
*          RAISE no_valid_data.
*      ENDCASE.
*
*      COMMIT WORK.
*
*      IF upload_child_agrs = 'X' AND ( NOT y_agr_agrs[] IS INITIAL ).
*        CALL FUNCTION 'PRGN_ACTIVITY_GROUP_USERPROF'
*             EXPORTING
*                  activity_group                = i_agr_define-agr_name
*                  hr_mode                       = ' '
*                  only_distribute_users         = 'X'
*             EXCEPTIONS
*                  no_authority_for_user_compare = 1
*                  at_least_one_user_enqueued    = 2
*                  authority_incomplete          = 3
*                  no_profiles_available         = 4
*                  too_many_profiles_in_user     = 5
*                  OTHERS                        = 6.
*      ENDIF.
*    ENDIF.
*
*  ENDLOOP.
*
************************************************************************
**
*  DESCRIBE TABLE i_agr_define LINES number_of_agrs.
*  CALL FUNCTION 'PRGN_ACTIVITY_GROUPS_DEQUEUE'
*       TABLES
*            activity_groups = i_agr_define.
************************************************************************
**
*
** spa-gpa Parameter setzen, falls nur ein Objekt geladen wurde ...
*  CLEAR single_selected_agr.
*  IF number_of_agrs = 1.
*    LOOP AT i_agr_define.
*    ENDLOOP.
*    CHECK sy-subrc = 0.
*    single_selected_agr = i_agr_define-agr_name.
*  ENDIF.
*
ENDFUNCTION.
