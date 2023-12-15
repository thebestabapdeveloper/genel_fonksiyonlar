FUNCTION Z_TEXT_CREATE_HISTORY_LI.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_LINE_SIZE) TYPE  TDLINESIZE DEFAULT 72
*"     REFERENCE(IV_ENVIRONMENT_TIME_FORMAT) TYPE  ABAP_BOOL OPTIONAL
*"     REFERENCE(IV_UNAME) TYPE  SYUNAME DEFAULT SY-UNAME
*"     REFERENCE(IV_DATE) TYPE  SYDATUM DEFAULT SY-DATUM
*"     REFERENCE(IV_TIME) TYPE  SYTIME DEFAULT SY-UZEIT
*"     REFERENCE(IV_TIMEZONE) TYPE  TIMEZONE OPTIONAL
*"  EXPORTING
*"     VALUE(HISTORY_LINE) TYPE  TLINE-TDLINE
*"--------------------------------------------------------------------
  CLEAR history_line.

  DATA: lv_history_line   TYPE tline-tdline.
  DATA: lv_line1          TYPE tline-tdline. "Complete line
  DATA: lv_line2          TYPE tline-tdline. "Short first name
  DATA: lv_line3          TYPE tline-tdline. "No telephone number
  DATA: lv_date           TYPE c LENGTH 16.
  DATA: lv_time           TYPE c LENGTH 16.
  DATA: lv_timezone       TYPE timezone.         " Note 2051852
  DATA: lv_name           TYPE c LENGTH 50.
  DATA: lv_temp_linesize  LIKE iv_line_size.
  DATA: lv_temp_remainder LIKE iv_line_size.

  DATA: user_address          LIKE addr3_val.
  DATA: s_length TYPE i.
  DATA: s_length1 TYPE i.
  DATA: BEGIN OF user_string,
          filler1(1) VALUE '(',
          user_name  LIKE usr01-bname,
          filler2(1) VALUE ')',
        END OF user_string.
  DATA: user_name LIKE usr01-bname.
  DATA: uname_uzunlugu TYPE i.

  user_name = iv_uname.
  uname_uzunlugu = strlen( user_name ).

  IF uname_uzunlugu EQ 11 AND user_name CO '0123456789 ' .
    user_string-user_name = '***********'.
  ELSE.
    user_string-user_name = user_name.
  ENDIF.

  CALL FUNCTION 'SUSR_USER_ADDRESS_READ'
    EXPORTING
      user_name    = user_name
    IMPORTING
      user_address = user_address
    EXCEPTIONS
      OTHERS       = 1.

  MOVE '* ' TO history_line.
*--- Datum, Uhrzeit
  WRITE iv_date TO lv_date.
  IF iv_environment_time_format NE space.
    WRITE iv_time TO lv_time ENVIRONMENT TIME FORMAT.
  ELSE.
    WRITE iv_time TO lv_time.
  ENDIF.

  IF user_address-name_first IS INITIAL AND
     user_address-name_last  IS INITIAL.
*--- keine Useradresse gepflegt -> Username nehmen
    WRITE iv_uname TO lv_name.
  ELSE.
    CONDENSE user_string NO-GAPS.
*--- Mehrere Versionen der Zeile erzeugen
    CONCATENATE user_address-name_first
                user_address-name_last
                user_string
                INTO lv_line1 SEPARATED BY space.
    IF NOT user_address-tel_number IS INITIAL.
      CONCATENATE lv_line1
                  TEXT-027
                  user_address-tel_number
                  user_address-tel_extens
                  INTO lv_line1 SEPARATED BY space.
    ENDIF.
* Kurze Zeile Vorname abgekürzt
    MOVE '.' TO user_address-name_first+1(1).
    CONCATENATE user_address-name_first(2)
                user_address-name_last
                user_string
                INTO lv_line2 SEPARATED BY space.
    IF NOT user_address-tel_number IS INITIAL.
      CONCATENATE lv_line2
                  TEXT-027
                  user_address-tel_number
                  user_address-tel_extens
                  INTO lv_line2 SEPARATED BY space.
    ENDIF.
* Note 2051852 - begin
*   CONCATENATE lv_date lv_time INTO history_line+2 SEPARATED BY space.
*   lv_date/lv_time = SY_DATUM/SY_UZEIT ->
    lv_timezone = '???'. "#EC_NOTEXT
    IF iv_timezone IS SUPPLIED.
      lv_timezone = iv_timezone.
    ELSE.
      IF iv_time IS NOT SUPPLIED.
        " SY-UZEIT - assume system timezone required
        CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
          IMPORTING
            timezone            = lv_timezone
          EXCEPTIONS
            customizing_missing = 1
            OTHERS              = 2.
        IF sy-subrc <> 0.
          lv_timezone = '???'. "#EC_NOTEXT
        ENDIF.
      ENDIF.
    ENDIF.
    CONCATENATE lv_date lv_time lv_timezone INTO history_line+2 SEPARATED BY space.
* Note 2051852 - begin
    s_length = strlen( lv_line1 ).
    s_length1 = strlen( history_line ).
* note 1918341
    IF ( s_length + s_length1 ) < ( iv_line_size + 2 ). "72+Format line
      CONCATENATE history_line lv_line1 INTO history_line
        SEPARATED BY space.
    ELSE.
      s_length = strlen( lv_line2 ).
* note 1918341
      IF ( s_length + s_length1 ) < ( iv_line_size + 2 ). "72+Format line
        CONCATENATE history_line lv_line2 INTO history_line
          SEPARATED BY space.
      ELSE.
* Immer noch zu lang. Ende mit .. kennzeichnen
        CONCATENATE history_line lv_line2 INTO history_line
          SEPARATED BY space.
* Maximum length of line reached.
        IF iv_line_size > 130.
          MOVE 130 TO lv_temp_linesize.
        ELSE.
          lv_temp_linesize  = iv_line_size.
        ENDIF.
        lv_temp_remainder = 2.
        WRITE '..' TO history_line+lv_temp_linesize(lv_temp_remainder).
        lv_temp_linesize  = lv_temp_linesize + 2.
        lv_temp_remainder = 132 - lv_temp_linesize.
        MOVE space TO history_line+lv_temp_linesize(lv_temp_remainder). "Clear the rest of the line
      ENDIF.
    ENDIF.
  ENDIF.

ENDFUNCTION.
