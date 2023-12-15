FUNCTION Z_SO_GET_FOLDER.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(FOLDRNM) TYPE  SO_OBJ_DES OPTIONAL
*"  EXPORTING
*"     VALUE(FOLDER_LIST) TYPE  SOXLI
*"  EXCEPTIONS
*"      FOLDER_NOT_FOUND
*"      MORE_FOLDER_FOUND
*"--------------------------------------------------------------------
  data: l_exclude_regions    like soxrg,
        l_folder_access      like sofa-usracc,
        l_folder_selections  like sofds,
        l_owner              like soud-usrnam,
        l_region             like sofd-folrg,
        l_source_folder_id   like sofdk,
        l_parent_id          like sofdk,
        l_current_fol_id     like sofdk.

  data: l_table_empty        like sonv-flag,
        l_table_hier         like sonv-flag,
        l_table_100_rows     like sonv-flag.

  data: l_itfolder_list like soxli occurs 5 with header line.

  data: l_fcount type i.

  l_folder_access            = '1'.
  l_region                   = 'Q'.
  l_exclude_regions-fobjfol  = 'X'.

  l_folder_selections-folnam =   foldrnm.

  call function 'SO_FOLDER_LIST_READ'
       exporting
            exclude_regions            = l_exclude_regions
            folder_access              = l_folder_access
            folder_selections          = l_folder_selections
            owner                      = l_owner
            region                     = l_region
            source_folder_id           = l_source_folder_id
            parent_id                  = l_parent_id
            current_fol_id             = l_current_fol_id
       importing
            table_empty                = l_table_empty
            table_hier                 = l_table_hier
            table_100_rows             = l_table_100_rows
       tables
            folder_list                = l_itfolder_list
       exceptions
            component_not_available    = 1
            operation_no_authorization = 2
            owner_not_exist            = 3
            parameter_error            = 4
            x_error                    = 5
            others                     = 6.
  if sy-subrc ne 0.
    raise folder_not_found.
  else.
    l_fcount = 0.
    loop at l_itfolder_list where objnam eq foldrnm.
      l_fcount = l_fcount + 1.
    endloop.
    case l_fcount.
      when 0.
        raise folder_not_found.
      when 1.
        folder_list = l_itfolder_list.
      when others.
        raise more_folder_found.
    endcase.
  endif.


ENDFUNCTION.
