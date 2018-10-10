class ZCL_GUIDRASIL_CONSTANTS definition
  public
  final
  create public .

public section.

  class-data DESIGN_CONTAINER_HEIGHT type I value 50 ##NO_TEXT.
  class-data ICON_CONTAINER type ICON_NAME read-only value ICON_WD_VIEW_CONTAINER ##NO_TEXT.
  class-data ICON_CONTROL type ICON_NAME read-only value CNTB_BTYPE_DROPDOWN ##NO_TEXT.
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
