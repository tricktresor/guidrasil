*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_TEXTI01.
*----------------------------------------------------------------------*
MODULE user_command INPUT.


  CASE gv_okcode.
    WHEN 'OKAY'.
      PERFORM apply_text_attributes.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN 'CANCEL'.
      RAISE operation_cancelled.
    WHEN OTHERS.
      PERFORM apply_text_attributes.
  ENDCASE.

ENDMODULE.
