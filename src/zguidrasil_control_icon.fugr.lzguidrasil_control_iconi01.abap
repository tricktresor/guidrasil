*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_ICONI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0050  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0050 INPUT.

  CASE gv_okcode.
    WHEN 'OKAY'.
      gv_set_data = abap_true.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN 'CANCEL'.
      SET SCREEN 0. LEAVE SCREEN.
  ENDCASE.

ENDMODULE.
