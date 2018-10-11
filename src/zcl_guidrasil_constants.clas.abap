class ZCL_GUIDRASIL_CONSTANTS definition
  public
  final
  create public .

public section.

  class-data DESIGN_CONTAINER_HEIGHT type I value 50 ##NO_TEXT.
    CLASS-DATA icon_container TYPE zguidrasil_icon_name READ-ONLY VALUE icon_wd_view_container ##NO_TEXT.
    CLASS-DATA icon_control TYPE zguidrasil_icon_name READ-ONLY VALUE cntb_btype_dropdown ##NO_TEXT.
  class-data DESIGN_CONTAINER_HEIGHT_LOW type I read-only value 25 ##NO_TEXT.
  class-data DESIGN_CONTAINER_HEIGHT_HIGH type I read-only value 50 ##NO_TEXT.

  class-methods SET_DESIGN_CONTAINER_HEIGHT
    importing
      !HEIGHT type I .
  class-methods SET_DESIGN_CONTAINER_LOW_RES .
  class-methods SET_DESIGN_CONTAINER_HIGH_RES .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONSTANTS IMPLEMENTATION.


  METHOD SET_DESIGN_CONTAINER_HEIGHT.

    design_container_height = height.

  ENDMETHOD.


  METHOD SET_DESIGN_CONTAINER_HIGH_RES.

    set_design_container_height( design_container_height_high ).

  ENDMETHOD.


  METHOD SET_DESIGN_CONTAINER_LOW_RES.

    set_design_container_height( design_container_height_low ).

  ENDMETHOD.
ENDCLASS.
