FUNCTION-POOL ZBC_DUNC.                "MESSAGE-ID ..

TYPE-POOLS: vrm.

TABLES: prgn_cust.
DATA: BEGIN OF agrs_list OCCURS 0,
      agr_name LIKE agr_define-agr_name,
      END OF agrs_list.
