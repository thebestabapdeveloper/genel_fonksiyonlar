FUNCTION ZC_UPPER_CASE.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_STRING) OPTIONAL
*"  EXPORTING
*"     VALUE(EP_STRING)
*"--------------------------------------------------------------------
*  DATA : BEGIN OF lt_char OCCURS 1,
*               xchar(1),
*               high_char(1),
*         END OF lt_char.
*
*  lt_char-xchar = 'ı'.
*  lt_char-high_char = 'I'.
*  APPEND lt_char.
*  lt_char-xchar = 'i'.
*  lt_char-high_char = 'İ'.
*  APPEND lt_char.
*
*  LOOP AT lt_char.
*    WHILE sy-subrc EQ 0.
*      SEARCH ip_string FOR lt_char-xchar.
*      IF sy-subrc NE 0. EXIT . ENDIF.
*      REPLACE lt_char-xchar WITH lt_char-high_char
*              INTO ip_string.
*    ENDWHILE.
*    CLEAR sy-subrc.
*  ENDLOOP.
*
*  TRANSLATE ip_string TO UPPER CASE.
*  ep_string = ip_string.

ENDFUNCTION.
