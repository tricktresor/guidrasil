*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_ICONO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0050  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0050 OUTPUT.

  SET PF-STATUS '0050'.
  SET TITLEBAR '0050'.
  CLEAR gv_okcode.

  perform init_controls.
  PERFORM init_docu_control.

  PERFORM display_icon.



ENDMODULE.
