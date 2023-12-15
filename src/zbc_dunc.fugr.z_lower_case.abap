FUNCTION Z_LOWER_CASE.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_STRING) OPTIONAL
*"  EXPORTING
*"     VALUE(EP_STRING)
*"--------------------------------------------------------------------
*  DATA : BEGIN OF lt_char OCCURS 1,
*               xchar(1),
*               low_char(1),
*         END OF lt_char.
*
*  lt_char-xchar = 'I'.
*  lt_char-low_char = 'ı'.
*  APPEND lt_char.
*  lt_char-xchar = 'İ'.
*  lt_char-low_char = 'i'.
*  APPEND lt_char.
*
*  LOOP AT lt_char.
*    WHILE sy-subrc EQ 0.
*      SEARCH ip_string FOR lt_char-xchar.
*      IF sy-subrc NE 0. EXIT . ENDIF.
*      REPLACE lt_char-xchar WITH lt_char-low_char
*              INTO ip_string.
*    ENDWHILE.
*    CLEAR sy-subrc.
*  ENDLOOP.
*
*  TRANSLATE ip_string TO LOWER CASE.
*  ep_string = ip_string.
ENDFUNCTION.
