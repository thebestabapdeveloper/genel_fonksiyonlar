FUNCTION Z_TCODE_AUTH_CHECK.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_TCODE) OPTIONAL
*"  EXPORTING
*"     REFERENCE(EP_SUBRC)
*"--------------------------------------------------------------------

*  AUTHORITY-CHECK OBJECT 'S_TCODE'
*           ID 'TCD' FIELD ip_tcode.
*
*  ep_subrc = sy-subrc.
ENDFUNCTION.
