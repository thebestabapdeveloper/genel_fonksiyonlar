FUNCTION Z_ITAB_TO_GOS_AS_XLSX.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_ICERIK_TABLOSU) TYPE  TABLE
*"     REFERENCE(IT_ALAN_KATALOG) TYPE  ZEXCEL_T_FIELDCATALOG
*"         OPTIONAL
*"     REFERENCE(IV_DOSYA_ADI) TYPE  STRING
*"     REFERENCE(IV_HATA_MESAJI) TYPE  XFELD DEFAULT ABAP_FALSE
*"     REFERENCE(IV_BOS_KAYIT) TYPE  XFELD DEFAULT ABAP_TRUE
*"  EXCEPTIONS
*"      ZCX_EXCEL
*"      ZCX_GOS
*"--------------------------------------------------------------------

*- Sabitler
  CONSTANTS: lc_objtyp TYPE swo_objtyp VALUE 'ZGOS'.

*- Değişkenler
  DATA: lv_excel_as_xstring TYPE xstring,
        lv_objkey           TYPE swo_typeid.

*- Lojik
  IF it_icerik_tablosu[] IS INITIAL.
    IF iv_hata_mesaji EQ abap_true.
      MESSAGE e001(zhvl_bc).
    ENDIF.
    IF iv_bos_kayit NE abap_true.
      RETURN.
    ENDIF.
  ENDIF.

  DATA(lv_source_description) = CONV string( iv_dosya_adi && '.xlsx' ).

  CALL FUNCTION 'ZHVL_BC_ITAB_TO_XLSX'
    EXPORTING
      it_icerik_tablosu   = it_icerik_tablosu
      it_alan_katalog     = it_alan_katalog
      iv_worksheet_adi    = iv_dosya_adi
    IMPORTING
      ev_excel_as_xstring = lv_excel_as_xstring
    EXCEPTIONS
      zcx_excel           = 1
      OTHERS              = 2.
  IF sy-subrc <> 0.
    RAISE zcx_excel.
  ENDIF.

  SELECT SINGLE name
    FROM trdir
    INTO lv_objkey
   WHERE name = sy-cprog.

  CALL FUNCTION 'ZHVL_CA_SAVE_DOC_GOS'
    EXPORTING
      iv_file_name      = lv_source_description
      iv_objkey         = lv_objkey
      iv_bus            = lc_objtyp
      iv_media_value    = lv_excel_as_xstring
    EXCEPTIONS
      file_cannot_saved = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
    RAISE zcx_gos.
  ENDIF.
ENDFUNCTION.
