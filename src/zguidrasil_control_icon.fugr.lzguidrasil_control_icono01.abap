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

  IF gr_dialogbox IS INITIAL.
    CREATE OBJECT gr_dialogbox EXPORTING left = 340 top = 255 height = 200 width = 1210.
  ENDIF.
  IF gr_container IS INITIAL.
    CREATE OBJECT gr_container
      EXPORTING
        container_name = 'CC_ICON'.
    zcl_guidrasil_tools_icons=>init( gr_dialogbox ).

  ENDIF.

  IF gr_picture IS INITIAL.
    CREATE OBJECT gr_picture
      EXPORTING
        parent = gr_container.
  ENDIF.

  PERFORM init_docu_control.

  PERFORM display_icon.



ENDMODULE.
