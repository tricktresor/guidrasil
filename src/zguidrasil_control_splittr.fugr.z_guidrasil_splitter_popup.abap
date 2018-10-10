FUNCTION Z_GUIDRASIL_SPLITTER_POPUP.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(ROWS) TYPE  I
*"  CHANGING
*"     REFERENCE(CS_SETTINGS) TYPE  ZGUIDRASIL_SETTING_SPLITTER
*"----------------------------------------------------------------------

  gv_set_data = abap_false.

  zguidrasil_setting_splitter = cs_settings.

  CALL SCREEN 10 STARTING AT 10 5.

  IF gv_set_data = abap_true.
    cs_settings = zguidrasil_setting_splitter.
  ENDIF.

ENDFUNCTION.
