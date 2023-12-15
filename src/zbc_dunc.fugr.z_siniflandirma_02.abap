FUNCTION Z_SINIFLANDIRMA_02.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_OBJEK) TYPE  AUSP-OBJEK OPTIONAL
*"     VALUE(IP_ATINN) TYPE  AUSP-ATINN OPTIONAL
*"  EXPORTING
*"     VALUE(EP_ATWRT) TYPE  AUSP-ATWRT
*"     VALUE(EP_ATFLV) TYPE  AUSP-ATFLV
*"  EXCEPTIONS
*"      NOT_FOUND
*"--------------------------------------------------------------------
*  TYPES: BEGIN OF t_ausp,
*          objek TYPE objnum,
*          atinn TYPE atinn,
*          atwrt TYPE atwrt,
*          atflv TYPE atflv,
*         END OF t_ausp.
*
*  TYPES: BEGIN OF t_atinn,
*          atnam LIKE cabn-atnam,
*          atinn LIKE cabn-atinn,
*         END OF t_atinn.
*
*  TYPES: BEGIN OF t_inob,
*          objek TYPE cuobn,
*          cuobj TYPE cuobj,
*         END OF t_inob.
*
*  DATA lv_atinn LIKE ausp-atinn.
*  DATA lv_objek TYPE cuobn.
*
*  STATICS st_ausp TYPE SORTED TABLE OF t_ausp
*                       WITH UNIQUE KEY objek atinn
*                       WITH HEADER LINE.
*
*  STATICS st_atinn TYPE SORTED TABLE OF t_atinn
*                        WITH UNIQUE KEY atnam
*                        WITH HEADER LINE.
*
*  STATICS st_inob TYPE SORTED TABLE OF t_inob
*                       WITH NON-UNIQUE KEY objek
*                       WITH HEADER LINE.
*
*
** CONVERSION_EXIT_ATINN_INPUT
*  CLEAR st_atinn.
*  READ TABLE st_atinn WITH TABLE KEY atnam = ip_atinn.
*  IF sy-subrc EQ 0.
*
*    lv_atinn = st_atinn-atinn.
*
*  ELSE.
*
*    lv_atinn = ip_atinn.
*
*    CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
*         EXPORTING
*              input  = ip_atinn
*         IMPORTING
*              output = lv_atinn.
*
*    st_atinn-atnam = ip_atinn.
*    st_atinn-atinn = lv_atinn.
*    INSERT st_atinn INTO TABLE st_atinn.
*
*  ENDIF.
*
** READ AUSP
*  CLEAR st_ausp.
*  READ TABLE st_ausp WITH TABLE KEY objek = ip_objek
*                                    atinn = lv_atinn.
*
*  IF sy-subrc EQ 0.
*
*    ep_atwrt = st_ausp-atwrt.
*    ep_atflv = st_ausp-atflv.
*
*  ELSE.
*
*    SELECT SINGLE objek atinn atwrt atflv
*             INTO st_ausp
*             FROM ausp
*            WHERE objek EQ ip_objek
*              AND atinn EQ lv_atinn.
*
*    IF sy-subrc EQ 0.
*
*      INSERT st_ausp INTO TABLE st_ausp.
*      ep_atwrt = st_ausp-atwrt.
*      ep_atflv = st_ausp-atflv.
*
*    ELSE.
*
** READ INOB
*      CLEAR st_inob.
*      READ TABLE st_inob WITH KEY objek = ip_objek.
*
*      IF sy-subrc EQ 0.
*
*        ip_objek = st_inob-cuobj.
*
*      ELSE.
*
*        CLEAR lv_objek.
*        SELECT SINGLE cuobj
*          INTO lv_objek
*          FROM inob
*          WHERE objek EQ ip_objek.
*
*        IF sy-subrc EQ 0.
*          st_inob-objek = ip_objek.
*          st_inob-cuobj = lv_objek.
*        ELSE.
*          st_inob-objek = ip_objek.
*          st_inob-cuobj = ip_objek.
*        ENDIF.
*
*        INSERT st_inob INTO TABLE st_inob.
*        ip_objek = st_inob-cuobj.
*
*      ENDIF.
*
** READ AUSP
*      SELECT SINGLE atwrt atflv
*        INTO (ep_atwrt, ep_atflv)
*        FROM ausp
*        WHERE objek EQ ip_objek
*          AND atinn EQ lv_atinn.
*
*    ENDIF.
*
*  ENDIF.

ENDFUNCTION.
