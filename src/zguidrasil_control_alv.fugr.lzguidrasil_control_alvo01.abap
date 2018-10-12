*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_ALVO01.
*----------------------------------------------------------------------*
MODULE status_0040 OUTPUT.

  SET PF-STATUS '0040'.
  SET TITLEBAR '0040'.
  CLEAR gv_okcode.

  PERFORM grid_init.
  perform docu_init.

ENDMODULE.
