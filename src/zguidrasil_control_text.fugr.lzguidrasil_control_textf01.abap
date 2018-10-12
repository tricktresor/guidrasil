*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_TEXTF01.
*----------------------------------------------------------------------*
FORM init_text_control .

  IF gr_container IS INITIAL.
    CREATE OBJECT gr_container
      EXPORTING
        container_name = 'CC_TEXT'.
  ENDIF.

  IF gr_text IS INITIAL.
    CREATE OBJECT gr_text
      EXPORTING
        parent = gr_container
        name   = 'POPUP'.
    PERFORM apply_text_attributes.
    gr_text->set_textstream( |{ gs_settings_text-text }| ).

  ENDIF.

ENDFORM.

FORM init_docu_control.

  IF gr_docu IS INITIAL.
    CREATE OBJECT gr_docu EXPORTING parent = NEW cl_gui_custom_container( container_name = 'DOCU' ).
    gr_docu->set_textstream( gs_settings_text-docu ).
  ENDIF.


ENDFORM.

FORM apply_text_attributes.

  IF gr_text IS BOUND.
    gr_text->set_readonly_mode( zguidrasil_setting_textp-readonly ).
    gr_text->set_toolbar_mode( zguidrasil_setting_textp-toolbar ).
    gr_text->set_statusbar_mode( zguidrasil_setting_textp-statusbar ).
    gr_text->set_wordwrap_behavior( wordwrap_mode = zguidrasil_setting_textp-wordwrap ).
  ENDIF.

ENDFORM.
