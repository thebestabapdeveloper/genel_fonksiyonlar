FUNCTION Z_SABLON_DOWNLOAD.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_SABLON) TYPE  TEXT50 OPTIONAL
*"     VALUE(IM_FOLDER) TYPE  SO_OBJ_DES OPTIONAL
*"  EXPORTING
*"     VALUE(FILENAME) TYPE  LOCALFILE
*"     VALUE(FILELEN) TYPE  SO_DOC_LEN
*"     VALUE(FILETYPE) TYPE  FILEFORMAT
*"  EXCEPTIONS
*"      DOCUMENT_NOT_FOUND
*"      FOLDER_NOT_FOUND
*"      PROGRAM_DOC_NOT_FOUND
*"      DOCUMENT_ERROR
*"--------------------------------------------------------------------
  DATA: l_foldername TYPE so_obj_des.
  DATA: l_localfile  TYPE localfile.

  DATA: l_folder_id  LIKE soodk.
  DATA: l_object_id  LIKE soodk.

  DATA: l_objcont LIKE soli OCCURS 1 WITH HEADER LINE.
  DATA: l_objhead LIKE soli OCCURS 1 WITH HEADER LINE.

  DATA: lv_pathname LIKE rlgrap-filename.

  DATA: l_bin_filesize     LIKE  soxwd-doc_length,
        l_default_filename LIKE  rlgrap-filename,
        l_filetype         LIKE  rlgrap-filetype,
        l_path_and_file    LIKE  rlgrap-filename,
        l_extct            LIKE  sood-extct,
        l_no_dialog        LIKE  sonv-flag,
        l_canceled         LIKE  sonv-flag.



  DATA: l_somt LIKE somt OCCURS 16 WITH HEADER LINE.

  l_foldername = im_folder.
  l_localfile  = im_sablon.

  CALL FUNCTION 'ZHVL_BC_SO_READ_FOLDER'
       EXPORTING
            folnm             = l_foldername
       TABLES
            folder_cont       = l_somt
       EXCEPTIONS
            folder_not_found  = 1
            more_folder_found = 2
            other_error       = 3
            OTHERS            = 4.

  IF sy-subrc NE 0.
    RAISE folder_not_found.
  ENDIF.

  LOOP AT l_somt WHERE docdes EQ l_localfile.
  ENDLOOP.
  IF sy-subrc NE 0.
    RAISE document_not_found.
  ENDIF.

  l_folder_id-objtp = l_somt-foltp.
  l_folder_id-objyr = l_somt-folyr.
  l_folder_id-objno = l_somt-folno.

  l_object_id-objtp = l_somt-doctp.
  l_object_id-objyr = l_somt-docyr.
  l_object_id-objno = l_somt-docno.

  CALL FUNCTION 'SO_OBJECT_READ'
       EXPORTING
            folder_id                  = l_folder_id
            object_id                  = l_object_id
       TABLES
            objcont                    = l_objcont
            objhead                    = l_objhead
       EXCEPTIONS
            active_user_not_exist      = 1
            communication_failure      = 2
            component_not_available    = 3
            folder_not_exist           = 4
            folder_no_authorization    = 5
            object_not_exist           = 6
            object_no_authorization    = 7
            operation_no_authorization = 8
            owner_not_exist            = 9
            parameter_error            = 10
            substitute_not_active      = 11
            substitute_not_defined     = 12
            system_failure             = 13
            x_error                    = 14
            OTHERS                     = 15.
  IF sy-subrc NE 0.
    RAISE document_error.
  ENDIF.


  l_bin_filesize      = l_somt-objlen.
  l_default_filename  = space.
  l_filetype          = 'BIN'.


  CALL FUNCTION 'SO_FILENAME_GET_WITH_PATH'
       IMPORTING
            pathname         = lv_pathname
       EXCEPTIONS
            no_batch         = 1
            x_error          = 2
            no_free_filename = 3
            error_ws_query   = 4
            OTHERS           = 5.

  IF sy-subrc NE 0.
    lv_pathname = 'C:\'.
  ENDIF.

  CONCATENATE lv_pathname l_localfile '.' l_somt-file_ext
                              INTO l_path_and_file.
  l_extct             = 'K'.
  l_no_dialog         = 'X'.

  CALL FUNCTION 'SO_OBJECT_DOWNLOAD'
       EXPORTING
            bin_filesize     = l_bin_filesize
            default_filename = l_default_filename
            filetype         = l_filetype
            path_and_file    = l_path_and_file
            extct            = l_extct
            no_dialog        = l_no_dialog
       IMPORTING
            filelength       = l_bin_filesize
            f_cancelled      = l_canceled
            act_filetype     = l_filetype
            act_filename     = l_path_and_file
       TABLES
            objcont          = l_objcont
       EXCEPTIONS
            file_write_error = 1
            invalid_type     = 2
            x_error          = 3
            kpro_error       = 4
            OTHERS           = 5.
  IF sy-subrc NE 0.
    RAISE document_error.
  ENDIF.
  filename  = l_path_and_file.
  filelen   = l_somt-objlen.
  filetype  = l_somt-file_ext.

ENDFUNCTION.
