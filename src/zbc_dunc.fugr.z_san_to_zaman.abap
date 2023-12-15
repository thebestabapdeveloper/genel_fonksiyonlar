FUNCTION Z_SAN_TO_ZAMAN .
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_DAKIKA) TYPE  ZHVL_IYBS_VARZM OPTIONAL
*"  EXPORTING
*"     REFERENCE(EP_SAAT) TYPE  UZEIT
*"--------------------------------------------------------------------

    CONSTANTS : lc_dak TYPE i VALUE '1440'.



  ip_dakika = ip_dakika mod   lc_dak.

  ep_saat+0(2) = floor( ip_dakika / 60 ).
  ep_saat+2(2) = ip_dakika - ep_saat+0(2) * 60.


ENDFUNCTION.
