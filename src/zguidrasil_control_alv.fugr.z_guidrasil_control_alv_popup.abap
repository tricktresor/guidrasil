FUNCTION z_guidrasil_control_alv_popup .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     REFERENCE(CS_SETTINGS) TYPE  ZGUIDRASIL_SETTING_GRID
*"  EXCEPTIONS
*"      OPERATION_CANCELLED
*"----------------------------------------------------------------------

  gs_settings_grid = cs_settings.
  zguidrasil_setting_gridp = gs_settings_grid-dynpro.

  IF gr_grid IS BOUND.
    gr_grid->free( ).
  ENDIF.
  IF gr_container IS BOUND.
    gr_container->free( ).
  ENDIF.

  FREE gr_grid.
  FREE gr_docu.
  FREE gr_container.
  CLEAR gd_data.

  CALL SCREEN 40 STARTING AT 10 5.

  cs_settings-dynpro = zguidrasil_setting_gridp.
  gr_grid->get_frontend_fieldcatalog( IMPORTING et_fieldcatalog = cs_settings-fcat ).

  gr_grid->get_sort_criteria( IMPORTING et_sort = cs_settings-sort ).

  IF gr_docu IS BOUND.
    gr_docu->get_textstream( IMPORTING text = cs_settings-docu ).
  ENDIF.

  cl_gui_cfw=>flush( ).

ENDFUNCTION.
