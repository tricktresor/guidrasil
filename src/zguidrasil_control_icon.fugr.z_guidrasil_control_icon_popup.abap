FUNCTION z_guidrasil_control_icon_popup .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IR_CONTROL) TYPE REF TO  OBJECT
*"  CHANGING
*"     REFERENCE(CS_SETTINGS) TYPE  ZGUIDRASIL_SETTING_ICON
*"  EXCEPTIONS
*"      CANCELLED
*"----------------------------------------------------------------------

  gv_set_data = abap_false.

  zguidrasil_setting_icon_p = cs_settings-dynpro.
  gs_settings = cs_settings.

  IF gr_picture IS BOUND.
    gr_picture->free( ).
  ENDIF.
  IF gr_container IS BOUND.
    gr_container->free( ).
  ENDIF.

  FREE gr_picture.
  FREE gr_container.


  CALL SCREEN 50 STARTING AT 10 5.

  cs_settings-dynpro = zguidrasil_setting_icon_p.
  IF gr_docu IS BOUND.
    gr_docu->get_textstream( IMPORTING text = cs_settings-docu ).
    cl_gui_cfw=>flush( ).
  ENDIF.

ENDFUNCTION.
