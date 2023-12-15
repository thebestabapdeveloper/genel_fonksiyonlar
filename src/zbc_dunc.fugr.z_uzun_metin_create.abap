FUNCTION Z_UZUN_METIN_CREATE.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_THEAD) TYPE  THEAD OPTIONAL
*"     VALUE(IP_DRAG_FIRST_LINE) OPTIONAL
*"     VALUE(IP_NO_COMMIT) OPTIONAL
*"  TABLES
*"      ET_NOTES OPTIONAL
*"--------------------------------------------------------------------
*---- init long text
   perform init_text changing is_thead.
*---- save text
   perform delete_text using is_thead ip_no_commit.
*----
   perform save_text tables et_notes using is_thead
                                           ip_drag_first_line.

  if ip_no_commit eq space.
       perform commit_text.
  endif.

ENDFUNCTION.
