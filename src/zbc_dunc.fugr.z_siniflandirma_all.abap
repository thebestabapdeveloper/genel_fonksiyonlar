FUNCTION Z_SINIFLANDIRMA_ALL.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_OBJEK) TYPE  AUSP-OBJEK OPTIONAL
*"     VALUE(IP_ATINN) OPTIONAL
*"  EXPORTING
*"     VALUE(EP_ATWRT) TYPE  AUSP-ATWRT
*"     VALUE(EP_ATFLV) TYPE  AUSP-ATFLV
*"  TABLES
*"      GT_CHAR STRUCTURE  ZHVL_KIK_CHARACTERISTICS
*"  EXCEPTIONS
*"      YOK
*"--------------------------------------------------------------------
*  DATA : lv_atinn LIKE ausp-atinn.
*
*  lv_atinn = ip_atinn.
*
*  CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
*       EXPORTING
*            input  = ip_atinn
*       IMPORTING
*            output = lv_atinn.
*
*
*  SELECT SINGLE atwrt INTO ep_atwrt FROM ausp
*               WHERE atinn EQ lv_atinn AND
*                     objek EQ ip_objek.
*  IF sy-subrc NE 0.
*    SELECT SINGLE cuobj INTO ip_objek FROM inob
*                   WHERE objek EQ ip_objek.
*
*    SELECT SINGLE atwrt atflv
*                         INTO (ep_atwrt,  ep_atflv)
*                                       FROM ausp
*                 WHERE atinn EQ lv_atinn AND
*                       objek EQ ip_objek.
*
*
*  ENDIF.
ENDFUNCTION.
