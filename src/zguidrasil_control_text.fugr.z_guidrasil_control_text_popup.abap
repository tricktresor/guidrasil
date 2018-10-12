FUNCTION z_guidrasil_control_text_popup .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IR_CONTROL) TYPE REF TO  CL_GUI_CONTROL
*"  CHANGING
*"     REFERENCE(CS_SETTINGS) TYPE  ZGUIDRASIL_SETTING_TEXT
*"  EXCEPTIONS
*"      OPERATION_CANCELLED
*"----------------------------------------------------------------------

  DATA ls_settings_text TYPE zguidrasil_setting_text.
  ls_settings_text = cs_settings.

  zguidrasil_setting_textp = cs_settings-dynpro.
  gs_settings_text         = cs_settings.

  IF gr_text IS BOUND.
    gr_text->free( ).
  ENDIF.
  IF gr_container IS BOUND.
    gr_container->free( ).
  ENDIF.
  FREE gr_text.
  FREE gr_docu.
  FREE gr_container.
  CLEAR gd_data.

  CALL SCREEN 30 STARTING AT 10 5.

  IF gr_text IS BOUND.
    gr_text->get_textstream( IMPORTING text = cs_settings-text ).
    cl_gui_cfw=>flush( ).
  ENDIF.

  IF gr_docu IS BOUND.
    gr_docu->get_textstream( IMPORTING text = cs_settings-docu ).
    cl_gui_cfw=>flush( ).
  ENDIF.

  cs_settings-dynpro = zguidrasil_setting_textp.

ENDFUNCTION.
