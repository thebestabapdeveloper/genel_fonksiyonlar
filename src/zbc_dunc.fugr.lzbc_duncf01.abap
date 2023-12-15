*----------------------------------------------------------------------*
***INCLUDE /TUAF/LBC_FUNCF01 .
*----------------------------------------------------------------------*
INCLUDE lprgn_up_and_downloadf01.
*&---------------------------------------------------------------------*
*&      Form  INIT_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_IS_THEAD  text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  DELETE_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IS_THEAD  text
*      -->P_IP_NO_COMMIT  text
*----------------------------------------------------------------------*
form delete_text using   p_is_thead structure THEAD p_commit.

* p_is_thead-tdid
*            language = sy-langu
*            name     = p_is_thead-tdname
*            object   = p_is_thead-tdobject

DATA : lt_tline like TLINE OCCURS 0 WITH HEADER LINE .

FREE :  lt_tline .

CALL FUNCTION 'READ_TEXT'
  EXPORTING
    id                            = p_is_thead-tdid
    language                      = sy-langu
    name                          = p_is_thead-tdname
    object                        = p_is_thead-tdobject
  tables
    lines                         = lt_tline
 EXCEPTIONS
   ID                            = 1
   LANGUAGE                      = 2
   NAME                          = 3
   NOT_FOUND                     = 4
   OBJECT                        = 5
   REFERENCE_CHECK               = 6
   WRONG_ACCESS_TO_ARCHIVE       = 7
   OTHERS                        = 8
          .
IF sy-subrc eq 0.
  CALL FUNCTION 'DELETE_TEXT'
    EXPORTING
      id                    = p_is_thead-tdid
      language              = sy-langu
      name                  = p_is_thead-tdname
      object                = p_is_thead-tdobject
      SAVEMODE_DIRECT       = 'X'
   EXCEPTIONS
     NOT_FOUND             = 1
     OTHERS                = 2
            .
if p_commit eq space.
   CALL FUNCTION 'COMMIT_TEXT'
     EXPORTING
       OBJECT                = '*'
       NAME                  = '*'
       ID                    = '*'
       LANGUAGE              = '*'
       SAVEMODE_DIRECT       = 'X'        .

  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
endif.
ENDIF.


endform.                    " DELETE_TEXT


*&---------------------------------------------------------------------*
*&      Form  save_text
*&---------------------------------------------------------------------*
FORM save_text TABLES  p_et_notes
               USING  p_is_thead
                      p_drag.

  DATA lt_notes LIKE tline OCCURS 0  WITH HEADER LINE.

  INSERT  lt_notes     INDEX 1.
  lt_notes[] = p_et_notes[].
*--- eðer ilk satýrý kaydýrmak gerekirse
  IF p_drag NE space.
    INSERT  lt_notes     INDEX 1.
  ENDIF.
  CALL FUNCTION 'SAVE_TEXT'
       EXPORTING
            header          = p_is_thead
            insert          = 'X'
            savemode_direct = 'X'
       TABLES
            lines           = lt_notes
       EXCEPTIONS
            id              = 1
            language        = 2
            name            = 3
            object          = 4
            OTHERS          = 5.
ENDFORM.                    " save_text
*&---------------------------------------------------------------------*

FORM commit_text.
CALL FUNCTION 'COMMIT_TEXT'
 EXPORTING
   OBJECT                = '*'
   NAME                  = '*'
   ID                    = '*'
   LANGUAGE              = '*'
  SAVEMODE_DIRECT       = 'X'.

ENDFORM.                    " commit_text

FORM init_text CHANGING    p_is_thead LIKE thead.
  DATA lt_notes LIKE tline OCCURS 0  WITH HEADER LINE.
*-- initial long text
  CALL FUNCTION 'INIT_TEXT'
       EXPORTING
            id       = p_is_thead-tdid
            language = sy-langu
            name     = p_is_thead-tdname
            object   = p_is_thead-tdobject
       IMPORTING
            header   = p_is_thead
       TABLES
            lines    = lt_notes
       EXCEPTIONS
            id       = 1
            language = 2
            name     = 3
            object   = 4
            OTHERS   = 5.
ENDFORM.                    " init_text
