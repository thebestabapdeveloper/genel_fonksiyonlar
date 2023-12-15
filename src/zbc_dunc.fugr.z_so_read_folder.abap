FUNCTION Z_SO_READ_FOLDER.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(FOLNM) TYPE  SO_OBJ_DES OPTIONAL
*"  TABLES
*"      FOLDER_CONT STRUCTURE  SOMT
*"  EXCEPTIONS
*"      FOLDER_NOT_FOUND
*"      MORE_FOLDER_FOUND
*"--------------------------------------------------------------------
 data: l_object_id like  soodk,
        l_forwarder like  soud-usrnam,
        l_owner     like  soud-usrnam.

  data: l_folder_list         like   soxli.

  data: l_folder_cont like somt   occurs 16 with header line.


  call function 'ZHVL_BC_SO_GET_FOLDER'
       exporting
            foldrnm           = folnm
       importing
            folder_list       = l_folder_list
       exceptions
            folder_not_found  = 1
            more_folder_found = 2
            others            = 3.

  case sy-subrc.
    when 0.

    when 1.
      raise folder_not_found.
    when others.
      raise more_folder_found.
  endcase.

  l_object_id-objtp = l_folder_list-foltp.
  l_object_id-objyr = l_folder_list-folyr.
  l_object_id-objno = l_folder_list-folno.


  call function 'SO_FOLDER_READ'
       exporting
            object_id                  = l_object_id
            owner                      = l_owner
       tables
            folder_cont                = folder_cont
       exceptions
            active_user_not_exist      = 1
            communication_failure      = 2
            component_not_available    = 3
            folder_not_exist           = 4
            operation_no_authorization = 5
            owner_not_exist            = 6
            substitute_not_active      = 7
            substitute_not_defined     = 8
            system_failure             = 9
            x_error                    = 10
            others                     = 11.
  if sy-subrc ne 0.
    raise other_error.
  endif.


ENDFUNCTION.
