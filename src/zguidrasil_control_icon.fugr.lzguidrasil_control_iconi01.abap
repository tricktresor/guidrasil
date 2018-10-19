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
      RAISE cancelled.
    WHEN OTHERS.
      zguidrasil_setting_icon_p-icon_name = zcl_guidrasil_tools_icons=>iconname.
*      "Test: Get info about dialogbox size
*      gr_dialogbox->get_left(   IMPORTING left = DATA(left)  ).
*      gr_dialogbox->get_top(    IMPORTING top    = DATA(top) ).
*      gr_dialogbox->get_width(  IMPORTING width  = DATA(width) ).
*      gr_dialogbox->get_height( IMPORTING height = DATA(height) ).
*      cl_gui_cfw=>flush( ).
  ENDCASE.

ENDMODULE.
