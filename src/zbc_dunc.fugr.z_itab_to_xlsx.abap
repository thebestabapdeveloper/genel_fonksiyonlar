FUNCTION Z_ITAB_TO_XLSX.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_ICERIK_TABLOSU) TYPE  TABLE
*"     REFERENCE(IT_ALAN_KATALOG) TYPE  ZEXCEL_T_FIELDCATALOG
*"         OPTIONAL
*"     REFERENCE(IV_WORKSHEET_ADI) TYPE  STRING
*"  EXPORTING
*"     REFERENCE(EV_EXCEL_AS_XSTRING) TYPE  XSTRING
*"  EXCEPTIONS
*"      ZCX_EXCEL
*"--------------------------------------------------------------------

*- Sabitler
  CONSTANTS: lc_first_column TYPE char1 VALUE 'A'.

*- Nesneler
  DATA: lo_excel        TYPE REF TO zcl_excel ##NEEDED,
        lo_worksheet    TYPE REF TO zcl_excel_worksheet,
        lo_excel_writer TYPE REF TO zif_excel_writer.

*- Tablolar
  DATA: lt_alan_katalog TYPE zexcel_t_fieldcatalog.

*- Yapılar
  DATA: ls_table_settings  TYPE zexcel_s_table_settings.

*- Değişkenler
  DATA: lv_worksheet_title TYPE zexcel_sheet_title.

*- Lojik
  IF it_icerik_tablosu[] IS INITIAL.
    RETURN.
  ENDIF.

  IF it_alan_katalog[] IS INITIAL.
    lt_alan_katalog = zcl_excel_common=>get_fieldcatalog( ip_table = it_icerik_tablosu ).
  ELSE.
    lt_alan_katalog = it_alan_katalog.
  ENDIF.

  TRY.
      ls_table_settings-table_style      = zcl_excel_table=>builtinstyle_medium2.
      ls_table_settings-show_row_stripes = abap_true.
      ls_table_settings-nofilters        = abap_true.
      ls_table_settings-top_left_column  = lc_first_column.
      ls_table_settings-top_left_row     = 01.
      IF lo_excel IS NOT BOUND.
        lo_excel = NEW #( ).
        lo_worksheet = lo_excel->get_active_worksheet( ).
      ELSE.
        lo_worksheet = lo_excel->add_new_worksheet( ).
      ENDIF.
      lv_worksheet_title = iv_worksheet_adi.
      lo_worksheet->set_title( lv_worksheet_title ).
      lo_worksheet->bind_table( ip_table          = it_icerik_tablosu
                                it_field_catalog  = lt_alan_katalog
                                is_table_settings = ls_table_settings ).

      lo_excel_writer = NEW zcl_excel_writer_2007( ).
      ev_excel_as_xstring = lo_excel_writer->write_file( lo_excel ).
    CATCH cx_root.
      RAISE zcx_excel.
  ENDTRY.
ENDFUNCTION.
