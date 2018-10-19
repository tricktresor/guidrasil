*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_ALVF01.
*----------------------------------------------------------------------*
FORM grid_init.

  DATA do_refresh TYPE rm_boolean.

  IF gr_container IS INITIAL.
    CREATE OBJECT gr_container
      EXPORTING
        container_name = 'CC_GRID'.
  ENDIF.

  PERFORM grid_set_table.

  IF gr_grid IS BOUND.
    IF gs_settings_grid-fcat IS NOT INITIAL.
      gr_grid->set_frontend_fieldcatalog( it_fieldcatalog = gs_settings_grid-fcat ).
      do_refresh = abap_true.
    ENDIF.
    IF gs_settings_grid-fcat IS NOT INITIAL.
      gr_grid->set_sort_criteria( EXPORTING it_sort = gs_settings_grid-sort ).
      do_refresh = abap_true.
    ENDIF.

    IF do_refresh = abap_true.
      gr_grid->refresh_table_display( ).
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
  data variant type disvariant.

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

    "Set variant
    variant-handle   = 'GRID'.
    variant-report   = sy-repid.
    variant-username = sy-uname.

    "set display
    CALL METHOD gr_grid->set_table_for_first_display
      EXPORTING
        i_structure_name = zguidrasil_setting_gridp-structure_name
        i_save           = space
        is_variant       = variant
      CHANGING
        it_outtab        = <data>
      EXCEPTIONS
        OTHERS           = 4.


  ENDIF.

ENDFORM.
