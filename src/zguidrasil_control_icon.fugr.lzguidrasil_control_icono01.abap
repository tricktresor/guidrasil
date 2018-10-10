*----------------------------------------------------------------------*
***INCLUDE LZGUIDRASIL_CONTROL_ICONO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0050  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0050 OUTPUT.

  SET PF-STATUS '0050'.
  SET TITLEBAR '0050'.
  CLEAR gv_okcode.

  IF gr_container IS INITIAL.
    CREATE OBJECT gr_container
      EXPORTING
        container_name = 'CC_ICON'.
  ENDIF.

  IF gr_picture IS INITIAL.
    CREATE OBJECT gr_picture
      EXPORTING
        parent = gr_container.
  ENDIF.

  PERFORM display_icon.

ENDMODULE.
