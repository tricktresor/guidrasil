FUNCTION Z_GUIDRASIL_CONTROL_ICON_POPUP .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IR_CONTROL) TYPE REF TO  CL_GUI_CONTROL
*"  CHANGING
*"     REFERENCE(CS_SETTINGS) TYPE  ZGUIDRASIL_SETTING_ICON
*"  EXCEPTIONS
*"      NO_CHANGES
*"----------------------------------------------------------------------

  gv_set_data = abap_false.

  zguidrasil_setting_icon = cs_settings.

  IF gr_picture IS BOUND.
    gr_picture->free( ).
  ENDIF.
  IF gr_container IS BOUND.
    gr_container->free( ).
  ENDIF.
  FREE gr_picture.
  FREE gr_container.


  CALL SCREEN 50 STARTING AT 10 5.

  IF gv_set_data = abap_true.
    cs_settings = zguidrasil_setting_icon.
  ELSE.
    RAISE no_changes.
  ENDIF.

ENDFUNCTION.
