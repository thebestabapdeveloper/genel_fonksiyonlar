FUNCTION Z_UNPACK.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_VALUE) OPTIONAL
*"  EXPORTING
*"     REFERENCE(EP_VALUE)
*"--------------------------------------------------------------------
*  ep_value = ip_value.
*  CHECK NOT ip_value IS INITIAL.
*  CHECK ip_value CO ' 0123456789'.
*  UNPACK  ip_value TO ep_value.
ENDFUNCTION.
