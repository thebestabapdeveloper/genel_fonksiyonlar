FUNCTION Z_READ_AUTH.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      IT_DEFINE STRUCTURE  AGR_DEFINE OPTIONAL
*"      IT_TCODES STRUCTURE  AGR_TCODES OPTIONAL
*"      IT_1250 STRUCTURE  AGR_1250 OPTIONAL
*"      IT_1251 STRUCTURE  AGR_1251 OPTIONAL
*"      IT_1252 STRUCTURE  AGR_1252 OPTIONAL
*"      IT_1253 STRUCTURE  AGR_1253 OPTIONAL
*"      IT_SELECT STRUCTURE  RSPARAMS OPTIONAL
*"      IT_HIER STRUCTURE  AGR_HIER OPTIONAL
*"      IT_HIERT STRUCTURE  AGR_HIERT
*"--------------------------------------------------------------------
*---sap_tables
  TABLES : agr_define ,   " rol
           agr_tcodes ,   " tcodes
           agr_1250   ,   " auth
           agr_1251   ,   " activite
           agr_hier   ,   " menu hiyerarşi
           agr_hiert.


  RANGES : s_name FOR agr_define-agr_name.

** convert
  LOOP AT it_select.
    MOVE-CORRESPONDING it_select TO s_name.
    COLLECT s_name.
  ENDLOOP.

  SELECT * FROM agr_1250   INTO TABLE it_1250
                           WHERE agr_name IN s_name
                           AND   deleted = space.
  SELECT * FROM agr_1251   INTO TABLE it_1251
                           WHERE agr_name IN s_name
                           AND   deleted = space.
  SELECT * FROM agr_1252   INTO TABLE it_1252
                           WHERE agr_name IN s_name.
  SELECT * FROM agr_1253   INTO TABLE it_1253
                           WHERE agr_name IN s_name.
  SELECT * FROM agr_hier   INTO TABLE it_hier
                           WHERE agr_name IN s_name.
  SELECT * FROM agr_hiert  INTO TABLE it_hiert
                           WHERE agr_name IN s_name
                           AND   spras = sy-langu.
  SELECT * FROM agr_define INTO TABLE it_define
                           WHERE agr_name IN s_name.
  SELECT * FROM agr_tcodes INTO TABLE it_tcodes
                           WHERE agr_name IN s_name.





ENDFUNCTION.
