*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_ICONF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F4_ICON
*&---------------------------------------------------------------------*
FORM f4_icon .

  DATA: lx_shlp          TYPE shlp_descr,
        lv_return_code   TYPE i,
        lt_return_values TYPE STANDARD TABLE OF ddshretval,
        ls_return_value  TYPE ddshretval.

  FIELD-SYMBOLS:
        <interface> TYPE ddshiface.


**** Suchhilfe lesen
  CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
    EXPORTING
      shlpname = 'H_ICON'
      shlptype = 'SH'
    IMPORTING
      shlp     = lx_shlp.

  READ TABLE lx_shlp-interface WITH KEY shlpfield = 'NAME' ASSIGNING <interface>.
  IF sy-subrc = 0.
    <interface>-valfield = 'X'.
  ENDIF.

*** Start der Suchhilfe
  CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
    EXPORTING
      shlp          = lx_shlp
    IMPORTING
      rc            = lv_return_code
    TABLES
      return_values = lt_return_values.
  IF lv_return_code = 0.
    READ TABLE lt_return_values INTO ls_return_value INDEX 1.
    IF sy-subrc = 0.
      zguidrasil_setting_icon_p-icon_name = ls_return_value-fieldval.
      PERFORM display_icon.
    ENDIF.
  ENDIF.

ENDFORM.

FORM display_icon.

  gr_picture->load_picture_from_sap_icons( zcl_guidrasil_control_icon=>get_icon_id( zguidrasil_setting_icon_p-icon_name ) ).
  gr_picture->set_display_mode( zguidrasil_setting_icon_p-display_mode ).

ENDFORM.

FORM init_docu_control.

  IF gr_docu IS INITIAL.
    CREATE OBJECT gr_docu EXPORTING parent = NEW cl_gui_custom_container( container_name = 'CC_DOCU' ).
  ENDIF.
  gr_docu->set_textstream( gs_settings-docu ).


ENDFORM.
