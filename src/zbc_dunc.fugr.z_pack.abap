FUNCTION Z_PACK.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_VALUE) OPTIONAL
*"  EXPORTING
*"     VALUE(EP_VALUE)
*"--------------------------------------------------------------------
*  ep_value = ip_value.
*  CHECK NOT ip_value IS INITIAL.
*  CHECK ip_value CO ' 0123456789'.
*  PACK  ip_value TO ep_value.
*  CONDENSE ep_value.
ENDFUNCTION.
