*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_TEXTO01.
*----------------------------------------------------------------------*
MODULE status_0030 OUTPUT.
  SET PF-STATUS '0030'.
  SET TITLEBAR '0030'.
  CLEAR gv_okcode.

  PERFORM init_text_control.
  PERFORM init_docu_control.

ENDMODULE.
