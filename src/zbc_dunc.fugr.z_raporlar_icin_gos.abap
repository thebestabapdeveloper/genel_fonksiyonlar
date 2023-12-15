FUNCTION Z_RAPORLAR_ICIN_GOS.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"--------------------------------------------------------------------

*- Nesneler
  DATA : lo_manager TYPE REF TO cl_gos_manager.

*- Yapılar
  DATA : ls_object TYPE borident.

*- Lojik
  CLEAR ls_object.
  ls_object-objtype = 'ZGOS'.

  SELECT SINGLE name
    FROM trdir
    INTO ls_object-objkey
   WHERE name = sy-cprog.

  IF lo_manager IS BOUND.
    RETURN.
  ENDIF.

  CREATE OBJECT lo_manager
    EXPORTING
      is_object    = ls_object
      ip_no_commit = 'R'
    EXCEPTIONS
      OTHERS       = 1.

  IF sy-subrc <> 0.
    MESSAGE TEXT-w01 TYPE 'I'.
  ENDIF.
ENDFUNCTION.
