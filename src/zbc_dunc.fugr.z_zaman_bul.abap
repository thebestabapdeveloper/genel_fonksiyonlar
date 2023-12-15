FUNCTION Z_ZAMAN_BUL .
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IP_TARIH_ILK) TYPE  DATUM
*"     REFERENCE(IP_TARIH_SON) TYPE  DATUM
*"     REFERENCE(IP_SAAT_ILK) TYPE  UZEIT
*"     REFERENCE(IP_SAAT_SON) TYPE  UZEIT
*"     REFERENCE(IP_SN_HARIC) TYPE  CHAR1 OPTIONAL
*"  EXPORTING
*"     REFERENCE(EP_SAAT) TYPE  UZEIT
*"     REFERENCE(EP_GUN) TYPE  I
*"     REFERENCE(EP_SANIYE) TYPE  HSLVT
*"--------------------------------------------------------------------

  CONSTANTS : lc_gun TYPE i VALUE '86400'.
  CONSTANTS : lc_saat TYPE i VALUE '3600'.
  CONSTANTS : lc_dak TYPE i VALUE '60'.

*  DATA : lv_kalan TYPE i.
  DATA : lv_kalan TYPE hslvt.

  ep_saniye = ( ip_tarih_son - ip_tarih_ilk ) * lc_gun.

  IF ip_sn_haric EQ space.

    ep_saniye = ep_saniye + ( ip_saat_son+0(2) * lc_saat +
                              ip_saat_son+2(2) * lc_dak +
                              ip_saat_son+4(2) ) -
                            ( ip_saat_ilk+0(2) * lc_saat +
                              ip_saat_ilk+2(2) * lc_dak +
                              ip_saat_ilk+4(2) ) .
  ELSE.

    ep_saniye = ep_saniye + ( ip_saat_son+0(2) * lc_saat +
                              ip_saat_son+2(2) * lc_dak  ) -
                            ( ip_saat_ilk+0(2) * lc_saat +
                              ip_saat_ilk+2(2) * lc_dak  ) .
  ENDIF.

*---
  ep_gun = TRUNC( ep_saniye / lc_gun ).

*-*  lv_kalan = ep_saniye - ( ep_gun * lc_gun ).
  lv_kalan = ep_saniye.

  ep_saat+0(2) = TRUNC( ep_saniye / lc_saat ).

  lv_kalan = lv_kalan - ( ep_saat+0(2) * lc_saat ).

  ep_saat+2(2) = TRUNC( lv_kalan / lc_dak ).

  lv_kalan = lv_kalan - ( ep_saat+2(2) * lc_dak ).

  ep_saat+4(2) = lv_kalan.


ENDFUNCTION.
