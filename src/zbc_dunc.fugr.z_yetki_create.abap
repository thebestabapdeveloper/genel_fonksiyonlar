FUNCTION Z_YETKI_CREATE.
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
*"  EXPORTING
*"     VALUE(NUMBER_OF_AGRS) LIKE  SY-TABIX
*"     VALUE(SINGLE_SELECTED_AGR) LIKE  AGR_DEFINE-AGR_NAME
*"  TABLES
*"      IT_AGR_DEFINE STRUCTURE  AGR_DEFINE OPTIONAL
*"      IT_AGR_TCODES STRUCTURE  AGR_TCODES OPTIONAL
*"      IT_AGR_1250 STRUCTURE  AGR_1250 OPTIONAL
*"      IT_AGR_1251 STRUCTURE  AGR_1251 OPTIONAL
*"      IT_AGR_1252 STRUCTURE  AGR_1252 OPTIONAL
*"      IT_AGR_1253 STRUCTURE  AGR_1253 OPTIONAL
*"      IT_AGR_TEXTS STRUCTURE  AGR_TEXTS OPTIONAL
*"      IT_AGR_FLAGS STRUCTURE  AGR_FLAGS OPTIONAL
*"      IT_AGR_USERT STRUCTURE  AGR_USERT OPTIONAL
*"      IT_AGR_BUFFI STRUCTURE  AGR_BUFFI OPTIONAL
*"      IT_AGR_HIER STRUCTURE  AGR_HIER OPTIONAL
*"      IT_AGR_HIERT STRUCTURE  AGR_HIERT OPTIONAL
*"      IT_AGR_AGRS STRUCTURE  AGR_AGRS OPTIONAL
*"      IT_AGR_CUSTOM STRUCTURE  AGR_CUSTOM OPTIONAL
*"      IT_AGR_TIME STRUCTURE  AGR_TIME OPTIONAL
*"      IT_AGR_MINI STRUCTURE  AGR_MINI OPTIONAL
*"      IT_AGR_MINIT STRUCTURE  AGR_MINIT OPTIONAL
*"      IT_AGR_ATTS STRUCTURE  AGR_ATTS OPTIONAL
*"  EXCEPTIONS
*"      NOT_AUTHORIZED
*"      ACTIVITY_GROUP_ENQUEUED
*"      ILLEGAL_RELEASE
*"      NO_VALID_DATA
*"      ACTION_CANCELLED
*"--------------------------------------------------------------------
  DATA: header_text LIKE agr_texts-text.
  DATA: exit TYPE c.
  DATA: menu_was_uploaded TYPE c.
  DATA: tt_e071 LIKE e071 OCCURS 0 WITH HEADER LINE.
  DATA: tt_e071k LIKE e071k OCCURS 0 WITH HEADER LINE.
  DATA: transfer_tab_compressed LIKE trtab OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_define LIKE agr_define OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_tcodes LIKE agr_tcodes OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_1250 LIKE agr_1250 OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_1251 LIKE agr_1251 OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_1252 LIKE agr_1252 OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_1253 LIKE agr_1253 OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_texts LIKE agr_texts OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_flags LIKE agr_flags OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_usert LIKE agr_usert OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_buffi LIKE agr_buffi OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_hier LIKE agr_hier OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_hiert LIKE agr_hiert OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_agrs LIKE agr_agrs OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_custom LIKE agr_custom OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_time LIKE agr_time OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_mini LIKE agr_mini OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_minit LIKE agr_minit OCCURS 0 WITH HEADER LINE.
  DATA: i_agr_atts LIKE agr_atts OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_define LIKE agr_define OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_tcodes LIKE agr_tcodes OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_1250 LIKE agr_1250 OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_1251 LIKE agr_1251 OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_1252 LIKE agr_1252 OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_1253 LIKE agr_1253 OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_texts LIKE agr_texts OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_flags LIKE agr_flags OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_usert LIKE agr_usert OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_buffi LIKE agr_buffi OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_hier LIKE agr_hier OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_hiert LIKE agr_hiert OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_agrs LIKE agr_agrs OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_custom LIKE agr_custom OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_time LIKE agr_time OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_mini LIKE agr_mini OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_minit LIKE agr_minit OCCURS 0 WITH HEADER LINE.
  DATA: y_agr_atts LIKE agr_atts OCCURS 0 WITH HEADER LINE.
  DATA: i_nodes_out LIKE agr_shier OCCURS 0 WITH HEADER LINE.
  DATA: i_texts_out LIKE agr_shiert OCCURS 0 WITH HEADER LINE.
  DATA: text(200) TYPE c.
  DATA: lv_text TYPE  agr_define.
  IF upload_auth_data = space.
    CLEAR : it_agr_1250[] , it_agr_1251[] , it_agr_1252[]
                            , it_agr_1253[].
  ENDIF.
  IF upload_menu_data = space.
    CLEAR : it_agr_hier[] , it_agr_hiert[] ,
             it_agr_buffi[] , it_agr_tcodes[].
  ENDIF.
  IF upload_description = space.
    CLEAR : it_agr_texts[].
  ENDIF.
  IF upload_child_agrs = space.
    CLEAR : it_agr_agrs[].
  ENDIF.

  REFRESH agrs_list.
  LOOP AT it_agr_define.
    agrs_list-agr_name = it_agr_define-agr_name.
    APPEND agrs_list.
  ENDLOOP.
  IF agrs_list[] IS INITIAL.
    RAISE no_valid_data.
  ENDIF.
*-------------------------------------------------------
  SORT agrs_list BY agr_name.
  LOOP AT it_agr_define.
    "    lv_text = it_agr_define .
    "    shift lv_text right by 50 places .
    "    lv_text(1) = 'X' .
*    PERFORM CHECK_IF_AGR_IS_VALID USING IT_AGR_DEFINE
*                                                      CHANGING EXIT.
    "    PERFORM CHECK_IF_AGR_IS_VALID USING lv_text
   "                                                      CHANGING EXIT.
    "   IF EXIT = 'X'. CONTINUE. ENDIF.
    i_agr_define = it_agr_define.
    APPEND i_agr_define.
  ENDLOOP.
  IF i_agr_define[] IS INITIAL.
    RAISE no_valid_data.
  ENDIF.
* Prüfung auf S_USER_AGR, Aktivität Upload sowie Anlegen/Ändern
  DATA: BEGIN OF missing_roles OCCURS 0,
          line(60),
        END OF missing_roles.
  CLEAR missing_roles[].

  LOOP AT i_agr_define.
    CALL FUNCTION 'PRGN_CHECK_AGR_EXISTS'
      EXPORTING
        activity_group                = i_agr_define-agr_name
      EXCEPTIONS
        activity_group_does_not_exist = 1
        OTHERS                        = 2.
    IF sy-subrc <> 0.
      CALL FUNCTION 'PRGN_AUTH_ACTIVITY_GROUP'
        EXPORTING
          activity_group = i_agr_define-agr_name
          action_create  = 'X'
          action_change  = 'X'
          action_upload  = 'X'
          message_output = ' '
        EXCEPTIONS
          not_authorized = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
        MOVE i_agr_define-agr_name TO missing_roles.
        APPEND missing_roles.
      ENDIF.
    ELSE.
      CALL FUNCTION 'PRGN_AUTH_ACTIVITY_GROUP'
        EXPORTING
          activity_group = i_agr_define-agr_name
          action_change  = 'X'
          action_upload  = 'X'
          message_output = ' '
        EXCEPTIONS
          not_authorized = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
        MOVE i_agr_define-agr_name TO missing_roles.
        APPEND missing_roles.
      ENDIF.
    ENDIF.
  ENDLOOP.
  IF NOT missing_roles[] IS INITIAL.
    CALL FUNCTION 'SUSR_POPUP_LIST_WITH_TEXT'
         EXPORTING
           text1         = 'fehlende Berechtigung für Rolle'
*          TEXT2         =
*          TEXT3         =
*          TEXT4         =
*        IMPORTING
*          OK_CODE       =
         TABLES
           list          = missing_roles
                 .
    MESSAGE e434(s#) WITH space "I_AGR_DEFINE-AGR_NAME
      RAISING not_authorized.
  ENDIF.

*** Popup für die Anzeige der AGRs
*************************************
**  IF SHOW_WARNING_POPUP = 'X'.
**    CALL FUNCTION 'PRGN_SHOW_WARNING_POPUP'
**         TABLES
**              ACTIVITY_GROUPS  = I_AGR_DEFINE
**         EXCEPTIONS
**              ACTION_CANCELLED = 1
**              OTHERS           = 2.
**    IF SY-SUBRC <> 0.
**      RAISE ACTION_CANCELLED.
**    ENDIF.
**  ENDIF.
***********************************************************************
*
  CALL FUNCTION 'PRGN_ACTIVITY_GROUPS_ENQUEUE'
    TABLES
      activity_groups         = i_agr_define
    EXCEPTIONS
      foreign_lock            = 1
      transport_check_problem = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    RAISE activity_group_enqueued.
  ENDIF.
***********************************************************************
*
  LOOP AT it_agr_tcodes .
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_tcodes = it_agr_tcodes.
    APPEND i_agr_tcodes.
  ENDLOOP.
  LOOP AT it_agr_1250.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_1250 = it_agr_1250.
    APPEND i_agr_1250.
  ENDLOOP.
  LOOP AT it_agr_1251.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_1251 = it_agr_1251.
    APPEND i_agr_1251.
  ENDLOOP.
  LOOP AT it_agr_1252.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_1252 = it_agr_1252.
    APPEND i_agr_1252.
  ENDLOOP.
  LOOP AT it_agr_1253.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_1253 = it_agr_1253.
    APPEND i_agr_1253.
  ENDLOOP.

  LOOP AT it_agr_texts.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_texts = it_agr_texts.
    APPEND i_agr_texts.
  ENDLOOP.
  LOOP AT it_agr_flags.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_flags = it_agr_flags.
    APPEND i_agr_flags.
  ENDLOOP.
  LOOP AT it_agr_usert.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_usert = it_agr_usert.
    APPEND i_agr_usert.
  ENDLOOP.
  LOOP AT it_agr_buffi.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_buffi = it_agr_buffi.
    APPEND i_agr_buffi.
  ENDLOOP.
  LOOP AT it_agr_hier.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_hier = it_agr_hier.
    APPEND i_agr_hier.
  ENDLOOP.
  LOOP AT it_agr_hiert.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_hiert = it_agr_hiert.
    APPEND i_agr_hiert.
  ENDLOOP.
  LOOP AT it_agr_agrs.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_agrs = it_agr_agrs.
    APPEND i_agr_agrs.
  ENDLOOP.
  LOOP AT it_agr_custom.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_custom = it_agr_custom.
    APPEND i_agr_custom.
  ENDLOOP.
  LOOP AT it_agr_time.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_time = it_agr_time.
    APPEND i_agr_time.
  ENDLOOP.
  LOOP AT it_agr_mini.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_mini = it_agr_mini.
    APPEND i_agr_mini.
  ENDLOOP.
  LOOP AT it_agr_minit.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_minit = it_agr_minit.
    APPEND i_agr_minit.
  ENDLOOP.
  LOOP AT it_agr_atts.
**    PERFORM CHECK_IF_AGR_IS_VALID USING TRANSFER_TAB CHANGING EXIT.
    IF exit = 'X'. CONTINUE. ENDIF.
    i_agr_atts = it_agr_atts.
    APPEND i_agr_atts.
  ENDLOOP.

* Konsistenzbereinigungen auf den Tabellen:
  DELETE i_agr_hier WHERE object_id = 1.
  DELETE i_agr_hiert WHERE object_id = 1.
**  REFRESH TRANSFER_TAB.
***********************************************************************
*
* Berechtigungsprüfung für gesamte Transaktionsliste und alle
* Berechtigungsdaten in der Datei (In alten Support-Packages wurde die
* Gesamtberechtigung für S_USER_TCD und S_USER_VAL geprüft.)
  DATA: BEGIN OF missing_authorizations OCCURS 0,
          line(60),
        END OF missing_authorizations.
  CLEAR missing_authorizations[].
  IF upload_menu_data = 'X'.
    LOOP AT i_agr_tcodes.
      AUTHORITY-CHECK OBJECT 'S_USER_TCD'
               ID 'TCD' FIELD i_agr_tcodes-tcode.
      IF sy-subrc <> 0.
        CONCATENATE 'S_USER_TCD' i_agr_tcodes-tcode
          INTO missing_authorizations
          SEPARATED BY space.
        APPEND missing_authorizations.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF upload_auth_data = 'X'.
    LOOP AT i_agr_1251.
      AUTHORITY-CHECK OBJECT 'S_USER_VAL'
               ID 'OBJECT'     FIELD i_agr_1251-object
               ID 'AUTH_FIELD' FIELD i_agr_1251-field
               ID 'AUTH_VALUE' FIELD i_agr_1251-low.
      IF sy-subrc <> 0.
        CONCATENATE 'S_USER_VAL'
                    i_agr_1251-object i_agr_1251-field i_agr_1251-low
         INTO missing_authorizations
         SEPARATED BY space.
        APPEND missing_authorizations.
      ENDIF.
      IF i_agr_1251-high <> space.
        AUTHORITY-CHECK OBJECT 'S_USER_VAL'
                 ID 'OBJECT'     FIELD i_agr_1251-object
                 ID 'AUTH_FIELD' FIELD i_agr_1251-field
                 ID 'AUTH_VALUE' FIELD '*'.
        IF sy-subrc <> 0.
          CONCATENATE 'S_USER_VAL'
                      i_agr_1251-object i_agr_1251-field '*'
           INTO missing_authorizations
           SEPARATED BY space.
          APPEND missing_authorizations.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF NOT missing_authorizations[] IS INITIAL.
    CALL FUNCTION 'SUSR_POPUP_LIST_WITH_TEXT'
         EXPORTING
           text1         = 'fehlende Berechtigung'
*          TEXT2         =
*          TEXT3         =
*          TEXT4         =
*        IMPORTING
*          OK_CODE       =
         TABLES
           list          = missing_authorizations
                 .
    MESSAGE e434(s#) WITH space "I_AGR_DEFINE-AGR_NAME
      RAISING not_authorized.
  ENDIF.
***********************************************************************
*

  LOOP AT i_agr_define.

    menu_was_uploaded = ' '.
    REFRESH: y_agr_define, y_agr_tcodes, y_agr_1250, y_agr_1251,
             y_agr_1252, y_agr_1253, y_agr_texts, y_agr_flags,
             y_agr_usert, y_agr_buffi, y_agr_hier, y_agr_hiert,
             y_agr_agrs, y_agr_custom, y_agr_time, y_agr_mini,
             y_agr_minit, y_agr_atts,
             i_nodes_out, i_texts_out.
    CLEAR:   y_agr_define, y_agr_tcodes, y_agr_1250, y_agr_1251,
             y_agr_1252, y_agr_1253, y_agr_texts, y_agr_flags,
             y_agr_usert, y_agr_buffi, y_agr_hier, y_agr_hiert,
             y_agr_agrs, y_agr_custom, y_agr_time, y_agr_mini,
             y_agr_minit, y_agr_atts,
             i_nodes_out, i_texts_out.

    CONCATENATE text-100 i_agr_define-agr_name INTO text
                SEPARATED BY space.
    IF no_progress_indicator = space.
      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          percentage = 0
          text       = text.
    ENDIF.

    i_agr_define-create_usr = sy-uname.
    i_agr_define-create_dat = sy-datum.
    i_agr_define-create_tim = sy-uzeit.
    CLEAR i_agr_define-create_tmp.
    i_agr_define-change_usr = sy-uname.
    i_agr_define-change_dat = sy-datum.
    i_agr_define-change_tim = sy-uzeit.
    CLEAR i_agr_define-change_tmp.
    i_agr_define-attributes = space.
    APPEND i_agr_define TO y_agr_define.
    LOOP AT i_agr_flags WHERE agr_name = i_agr_define-agr_name.
      APPEND i_agr_flags TO y_agr_flags.
    ENDLOOP.
    LOOP AT i_agr_agrs WHERE agr_name = i_agr_define-agr_name.
      APPEND i_agr_agrs TO y_agr_agrs.
    ENDLOOP.
    LOOP AT i_agr_custom WHERE agr_name = i_agr_define-agr_name.
      CLEAR i_agr_custom-change_tst.
      APPEND i_agr_custom TO y_agr_custom.
    ENDLOOP.
    LOOP AT i_agr_time WHERE agr_name = i_agr_define-agr_name.
      CLEAR i_agr_time-create_tmp.
      CLEAR i_agr_time-change_usr.
      CLEAR i_agr_time-change_dat.
      CLEAR i_agr_time-change_tim.
      CLEAR i_agr_time-change_tmp.
      CLEAR i_agr_time-attributes.
      APPEND i_agr_time TO y_agr_time.
    ENDLOOP.
    LOOP AT i_agr_usert WHERE agr_name = i_agr_define-agr_name.
      CLEAR i_agr_usert-change_tst.
      APPEND i_agr_usert TO y_agr_usert.
    ENDLOOP.
    LOOP AT i_agr_mini WHERE agr_name = i_agr_define-agr_name.
      APPEND i_agr_mini TO y_agr_mini.
    ENDLOOP.
    LOOP AT i_agr_minit WHERE agr_name = i_agr_define-agr_name.
      APPEND i_agr_minit TO y_agr_minit.
    ENDLOOP.
    LOOP AT i_agr_atts WHERE agr_name = i_agr_define-agr_name.
      APPEND i_agr_atts TO y_agr_atts.
    ENDLOOP.

* Flag-Tabelle bereinigen:
    IF upload_auth_data = space.
      DELETE y_agr_flags WHERE flag_type = 'FORCE_MIX'.
      DELETE y_agr_flags WHERE flag_type = 'FORCE_YEL'.
      DELETE y_agr_flags WHERE flag_type = 'FORCE_YIN'.
    ENDIF.
*   DELETE Y_AGR_FLAGS WHERE FLAG_TYPE = 'XPRA_FLAG'.
    DELETE y_agr_flags WHERE flag_type = 'SAP_SOURCE'.
    DELETE y_agr_flags WHERE flag_type = 'SAPORIGSAV'.
    DELETE y_agr_flags WHERE flag_type = 'MAINT_VERS'.
    DELETE y_agr_flags WHERE flag_type = 'SYS_FLAG'.

*   Flags kommen immer nur noch dazu .....
*   DELETE FROM AGR_FLAGS WHERE AGR_NAME = I_AGR_DEFINE-AGR_NAME.
*   DELETE FROM AGR_TIME WHERE AGR_NAME = I_AGR_DEFINE-AGR_NAME.
    DELETE FROM agr_flags WHERE agr_name = i_agr_define-agr_name
                          AND ( flag_type = 'COLL_AGR' OR
                                flag_type = 'CUSTOMIZE' ).
    DELETE FROM agr_define WHERE agr_name = i_agr_define-agr_name.
    DELETE FROM agr_custom WHERE agr_name = i_agr_define-agr_name.
    DELETE FROM agr_usert WHERE agr_name = i_agr_define-agr_name.
    DELETE FROM agr_atts WHERE agr_name = i_agr_define-agr_name.

*   INSERT AGR_TIME FROM TABLE Y_AGR_TIME ACCEPTING DUPLICATE KEYS.
    INSERT agr_define FROM TABLE y_agr_define ACCEPTING DUPLICATE KEYS.
    INSERT agr_custom FROM TABLE y_agr_custom ACCEPTING DUPLICATE KEYS.
    INSERT agr_flags FROM TABLE y_agr_flags ACCEPTING DUPLICATE KEYS.
    INSERT agr_atts FROM TABLE y_agr_atts ACCEPTING DUPLICATE KEYS.

    IF upload_mini_apps = 'X'.
      DELETE FROM agr_mini WHERE agr_name = i_agr_define-agr_name.
      DELETE FROM agr_minit WHERE agr_name = i_agr_define-agr_name.
      INSERT agr_mini FROM TABLE y_agr_mini ACCEPTING DUPLICATE KEYS.
      INSERT agr_minit FROM TABLE y_agr_minit ACCEPTING DUPLICATE KEYS.
    ENDIF.

    IF upload_child_agrs = 'X'.
      DELETE FROM agr_agrs WHERE agr_name = i_agr_define-agr_name.
      INSERT agr_agrs FROM TABLE y_agr_agrs ACCEPTING DUPLICATE KEYS.
      MODIFY agr_agrs2 FROM TABLE i_agr_agrs.
      CALL FUNCTION 'PRGN_SET_CHILD_AGRS_TIMESTAMP'
        EXPORTING
          activity_group = i_agr_define-agr_name.
    ENDIF.

    IF upload_description = 'X'.
      LOOP AT i_agr_texts WHERE agr_name = i_agr_define-agr_name.
        APPEND i_agr_texts TO y_agr_texts.
      ENDLOOP.
      DELETE FROM agr_texts WHERE agr_name = i_agr_define-agr_name.
      INSERT agr_texts FROM TABLE y_agr_texts ACCEPTING DUPLICATE KEYS.
    ENDIF.

    IF upload_menu_data = 'X'.
      LOOP AT i_agr_tcodes WHERE agr_name = i_agr_define-agr_name.
        APPEND i_agr_tcodes TO y_agr_tcodes.
      ENDLOOP.
      LOOP AT i_agr_buffi WHERE agr_name = i_agr_define-agr_name.
        APPEND i_agr_buffi TO y_agr_buffi.
      ENDLOOP.
      LOOP AT i_agr_hier WHERE agr_name = i_agr_define-agr_name.
        APPEND i_agr_hier TO y_agr_hier.
      ENDLOOP.
      LOOP AT i_agr_hiert WHERE agr_name = i_agr_define-agr_name.
        APPEND i_agr_hiert TO y_agr_hiert.
      ENDLOOP.
      DELETE FROM agr_tcodes WHERE agr_name = i_agr_define-agr_name.
      DELETE FROM agr_buffi WHERE agr_name = i_agr_define-agr_name.
      DELETE FROM agr_hier WHERE agr_name = i_agr_define-agr_name.
      DELETE FROM agr_hiert WHERE agr_name = i_agr_define-agr_name.
      INSERT agr_tcodes FROM TABLE y_agr_tcodes
                                              ACCEPTING DUPLICATE KEYS.
      INSERT agr_buffi FROM TABLE y_agr_buffi ACCEPTING DUPLICATE KEYS.
      INSERT agr_hier FROM TABLE y_agr_hier ACCEPTING DUPLICATE KEYS.
      INSERT agr_hiert FROM TABLE y_agr_hiert ACCEPTING DUPLICATE KEYS.
      IF ( NOT y_agr_hier[] IS INITIAL ) OR
         ( NOT y_agr_tcodes[] IS INITIAL ).
        CALL FUNCTION 'PRGN_SET_MENU_TIMESTAMP'
          EXPORTING
            activity_group = i_agr_define-agr_name.
        menu_was_uploaded = 'X'.
      ENDIF.
    ENDIF.

    IF upload_auth_data = 'X'.
      LOOP AT i_agr_1250 WHERE agr_name = i_agr_define-agr_name.
        APPEND i_agr_1250 TO y_agr_1250.
      ENDLOOP.
      LOOP AT i_agr_1251 WHERE agr_name = i_agr_define-agr_name.
        APPEND i_agr_1251 TO y_agr_1251.
      ENDLOOP.
      LOOP AT i_agr_1252 WHERE agr_name = i_agr_define-agr_name.
        APPEND i_agr_1252 TO y_agr_1252.
      ENDLOOP.
      LOOP AT i_agr_1253 WHERE agr_name = i_agr_define-agr_name.
        APPEND i_agr_1253 TO y_agr_1253.
      ENDLOOP.
      DELETE FROM agr_1250 WHERE agr_name = i_agr_define-agr_name.
      DELETE FROM agr_1251 WHERE agr_name = i_agr_define-agr_name.
      DELETE FROM agr_1252 WHERE agr_name = i_agr_define-agr_name.
      DELETE FROM agr_1253 WHERE agr_name = i_agr_define-agr_name.
      INSERT agr_1250 FROM TABLE y_agr_1250 ACCEPTING DUPLICATE KEYS.
      INSERT agr_1251 FROM TABLE y_agr_1251 ACCEPTING DUPLICATE KEYS.
      INSERT agr_1252 FROM TABLE y_agr_1252 ACCEPTING DUPLICATE KEYS.
      INSERT agr_1253 FROM TABLE y_agr_1253 ACCEPTING DUPLICATE KEYS.
      IF ( NOT y_agr_1250[] IS INITIAL ) OR
         ( NOT y_agr_1253[] IS INITIAL ).
        CALL FUNCTION 'PRGN_SET_PROFILE_TIMESTAMP'
          EXPORTING
            activity_group = i_agr_define-agr_name.
      ENDIF.
    ENDIF.

    IF upload_user_assignment = 'X'.
      INSERT agr_usert FROM TABLE y_agr_usert ACCEPTING DUPLICATE KEYS.
      REFRESH tt_e071.
      LOOP AT y_agr_usert.
        tt_e071-pgmid = 'R3TR'.
        tt_e071-object = 'ACGT'.
        tt_e071-obj_name = y_agr_usert-agr_name.
        APPEND tt_e071.
      ENDLOOP.
      SORT tt_e071 BY pgmid object obj_name.
      DELETE ADJACENT DUPLICATES FROM tt_e071
                                        COMPARING pgmid object obj_name
.
      CALL FUNCTION 'PRGN_AFTER_IMP_ACTGROUP'
        EXPORTING
          iv_tarclient  = sy-mandt
          iv_is_upgrade = space
        TABLES
          tt_e071       = tt_e071
          tt_e071k      = tt_e071k.
    ENDIF.

    IF set_target_system = 'X'.
      CALL FUNCTION 'PRGN_SET_SYSTEM_FLAG'
        EXPORTING
          activity_group = i_agr_define-agr_name
          sys_flag       = target_system.
    ENDIF.

    CALL FUNCTION 'PRGN_SET_ACTGROUP_TIMESTAMP'
      EXPORTING
        activity_group                = i_agr_define-agr_name
      EXCEPTIONS
        activity_group_does_not_exist = 1
        OTHERS                        = 2.
    CALL FUNCTION 'PRGN_SET_YELLOW_FLAG_ACTIVE'
      EXPORTING
        activity_group = i_agr_define-agr_name.
    COMMIT WORK.

    IF menu_was_uploaded = 'X'.
      CALL FUNCTION 'PRGN_STRU_LOAD_NODES'
        EXPORTING
          activity_group = i_agr_define-agr_name
        TABLES
          i_nodes_out    = i_nodes_out
          i_texts_out    = i_texts_out.
      CALL FUNCTION 'PRGN_STRU_SAVE_NODES'
        EXPORTING
          activity_group          = i_agr_define-agr_name
          use_global_tables       = ' '
          only_sy_langu           = ' '
        TABLES
          menu_hierarchy          = i_nodes_out
          menu_texts              = i_texts_out
        EXCEPTIONS
          not_authorized          = 1
          activity_group_enqueued = 2
          OTHERS                  = 3.
      .
      CASE sy-subrc.
        WHEN 1.
          MESSAGE e434(s#) WITH i_agr_define-agr_name
            RAISING not_authorized.
        WHEN 2.
          RAISE activity_group_enqueued.
        WHEN 3.
          RAISE no_valid_data.
      ENDCASE.

      COMMIT WORK.

      IF upload_child_agrs = 'X' AND ( NOT y_agr_agrs[] IS INITIAL ).
        CALL FUNCTION 'PRGN_ACTIVITY_GROUP_USERPROF'
          EXPORTING
            activity_group                = i_agr_define-agr_name
            hr_mode                       = ' '
            only_distribute_users         = 'X'
          EXCEPTIONS
            no_authority_for_user_compare = 1
            at_least_one_user_enqueued    = 2
            authority_incomplete          = 3
            no_profiles_available         = 4
            too_many_profiles_in_user     = 5
            OTHERS                        = 6.
      ENDIF.
    ENDIF.

  ENDLOOP.

***********************************************************************
*
  DESCRIBE TABLE i_agr_define LINES number_of_agrs.
  CALL FUNCTION 'PRGN_ACTIVITY_GROUPS_DEQUEUE'
    TABLES
      activity_groups = i_agr_define.
***********************************************************************
*

* spa-gpa Parameter setzen, falls nur ein Objekt geladen wurde ...
  CLEAR single_selected_agr.
  IF number_of_agrs = 1.
    LOOP AT i_agr_define.
    ENDLOOP.
    CHECK sy-subrc = 0.
    single_selected_agr = i_agr_define-agr_name.
  ENDIF.




ENDFUNCTION.
