*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_ALVF01.
*----------------------------------------------------------------------*
FORM grid_init.

  IF gr_container IS INITIAL.
    CREATE OBJECT gr_container
      EXPORTING
        container_name = 'CC_GRID'.
  ENDIF.

  PERFORM grid_set_table.

  IF gr_grid IS BOUND.
    IF gs_settings_grid-fcat IS NOT INITIAL.
      gr_grid->set_frontend_fieldcatalog( it_fieldcatalog = gs_settings_grid-fcat ).
    ENDIF.
    IF gs_settings_grid-fcat IS NOT INITIAL.
      gr_grid->set_sort_criteria( EXPORTING it_sort = gs_settings_grid-sort ).
    ENDIF.
  ENDIF.

ENDFORM.

FORM docu_init.

  CHECK gr_docu IS INITIAL.

  CREATE OBJECT gr_docu EXPORTING parent = NEW cl_gui_custom_container( container_name = 'DOCU' ).
  gr_docu->set_textstream( gs_settings_grid-docu ).


ENDFORM.

FORM grid_set_table.

  FIELD-SYMBOLS <data> TYPE STANDARD TABLE.

  CREATE DATA gd_data TYPE STANDARD TABLE OF (zguidrasil_setting_gridp-structure_name).
  ASSIGN gd_data->* TO <data>.

  IF gr_grid IS INITIAL.
    CREATE OBJECT gr_grid
      EXPORTING
        i_parent      = gr_container
        i_appl_events = space.

    TRY .
        SELECT * FROM (zguidrasil_setting_gridp-structure_name)
          INTO TABLE <data> UP TO 40 ROWS.
      CATCH cx_root INTO DATA(lx_root).
        MESSAGE lx_root TYPE 'I'.
        RETURN.
    ENDTRY.

    CALL METHOD gr_grid->set_table_for_first_display
      EXPORTING
        i_structure_name = zguidrasil_setting_gridp-structure_name
      CHANGING
        it_outtab        = <data>
      EXCEPTIONS
        OTHERS           = 4.


  ENDIF.

ENDFORM.

FORM grid_layout.

  DATA lr_vari           TYPE REF TO cl_alv_variant.
  DATA lt_fieldcat       TYPE lvc_t_fcat.
  DATA lt_sort           TYPE lvc_t_sort.
  DATA lt_filter         TYPE lvc_t_filt.


  CREATE OBJECT lr_vari
    EXPORTING
      it_outtab     = gd_data
      i_cl_alv_grid = gr_grid.


  gr_grid->get_frontend_fieldcatalog( IMPORTING et_fieldcatalog = lt_fieldcat ).
  gr_grid->get_sort_criteria( IMPORTING et_sort = lt_sort ).
  gr_grid->get_filter_criteria( IMPORTING et_filter = lt_filter ).

  CALL FUNCTION 'LVC_VARIANT'
    CHANGING
      ct_fieldcat = lt_fieldcat
      ct_sort     = lt_sort
      ct_filter   = lt_filter
    EXCEPTIONS
      no_change   = 1
      OTHERS      = 2.
  IF sy-subrc <> 0.
    MESSAGE 'operation cancelled' TYPE 'S'.
    RETURN.
  ENDIF.




*DATA IS_DTC_LAYOUT           TYPE DTC_S_LAYO.
**DATA I_BYPASSING_BUFFER      TYPE CHAR01.
**DATA I_BUFFER_ACTIVE         TYPE CHAR01.
**DATA IT_EXCEPT_QINFO         TYPE LVC_T_QINF.
**DATA E_SAVED                 TYPE CHAR1.
**DATA C_REF_TO_CL_ALV_VARIANT TYPE REF TO CL_ALV_VARIANT.
**DATA IT_SPECIAL_GROUPS       TYPE LVC_T_SGRP.
**DATA IT_SELECTED_COLS        TYPE LVC_T_COL.
**DATA I_TREE_OR_GRID          TYPE C.
**DATA I_FLG_TYPE              TYPE C.
**DATA C_REF_TO_CL_ALV_VARIANT TYPE REF TO CL_ALV_VARIANT.
*
*CALL FUNCTION 'LVC_VARIANT_NEU'
** EXPORTING
**   IT_SPECIAL_GROUPS             = IT_SPECIAL_GROUPS
**   IT_SELECTED_COLS              = IT_SELECTED_COLS
**   I_TREE_OR_GRID                = I_TREE_OR_GRID
**   I_FLG_TYPE                    = I_FLG_TYPE
*  CHANGING
*    c_ref_to_cl_alv_variant       = gr_vari
** EXCEPTIONS
**   NO_CHANGE                     = 1
**   OTHERS                        = 2
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.

*CALL FUNCTION 'ALV_GENERIC_DIALOG'
*  EXPORTING
*    is_dtc_layout                 = is_dtc_layout
**   I_BYPASSING_BUFFER            = I_BYPASSING_BUFFER
**   I_BUFFER_ACTIVE               = I_BUFFER_ACTIVE
**   IT_EXCEPT_QINFO               = IT_EXCEPT_QINFO
** IMPORTING
**   E_SAVED                       = E_SAVED
*  CHANGING
*    c_ref_to_cl_alv_variant       = gr_vari
* EXCEPTIONS
*   NO_CHANGE                     = 1
*   RESTORE_OLD_VIEW              = 2
*   NO_FILT_CHANGE                = 3
*   OTHERS                        = 4
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.
*
ENDFORM.
