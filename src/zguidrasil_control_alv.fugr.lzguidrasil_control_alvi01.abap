*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_ALVI01.
*----------------------------------------------------------------------*
MODULE user_command INPUT.

  CASE gv_okcode.
    WHEN 'OKAY'.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN 'CANCEL'.
      raise operation_cancelled.
    WHEN 'GRID_LAYOUT'.
      PERFORM grid_layout.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GRID_REFRESH  INPUT
*&---------------------------------------------------------------------*
MODULE grid_refresh INPUT.

  gr_grid->free( ).
  FREE gr_grid.
  PERFORM grid_set_table.

ENDMODULE.
