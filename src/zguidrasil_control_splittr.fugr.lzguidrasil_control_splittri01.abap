*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_SPLITTRI01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  CHECK_COLS  INPUT
*&---------------------------------------------------------------------*
MODULE check_cols INPUT.

  IF zguidrasil_setting_splitter-cols > 20.
    MESSAGE e000(oo) WITH 'Maximal 20 erlaubt!'.
  ENDIF.

ENDMODULE.

MODULE check_rows INPUT.

  IF zguidrasil_setting_splitter-rows > 20.
    MESSAGE e000(oo) WITH 'Maximal 20 erlaubt!'.
  ENDIF.

ENDMODULE.

MODULE user_command_0010 INPUT.

  CASE gv_okcode.
    WHEN 'OKAY'.
      gv_set_data = abap_true.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN 'CANCEL'.
      SET SCREEN 0. LEAVE SCREEN.

  ENDCASE.

ENDMODULE.
