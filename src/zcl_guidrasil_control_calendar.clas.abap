class ZCL_GUIDRASIL_CONTROL_CALENDAR definition
  public
  inheriting from ZCL_GUIDRASIL_CONTROL_BASE
  final
  create public .

*"* public components of class ZCL_GUIDRASIL_CONTROL_CALENDAR
*"* do not include other source files here!!!
public section.

  methods CREATE
    redefinition .
  methods PROVIDE_CONTROL_NAME
    redefinition .
  methods PROVIDE_TOOLBAR
    redefinition .
protected section.
*"* protected components of class ZCL_GUIDRASIL_CONTROL_CALENDAR
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_GUIDRASIL_CONTROL_CALENDAR
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_CALENDAR IMPLEMENTATION.


METHOD CREATE.

  DATA lr_calendar       TYPE REF TO cl_gui_calendar.

  CREATE OBJECT lr_calendar
    EXPORTING
      parent     = ir_parent
      view_style = cnca_style_h_navigator
*     dtpicker_format    =
*     selection_style    = cnca_sel_day
*     display_months     = 3
*     focus_date =
*     stand_alone        =
*     week_begin_day     = 1
*     lifetime   = lifetime_default
*     shellstyle =
*     year_begin = 0
*     year_end   = 0
*     week_end   = '67'
*     name       =
*     cell_text_length   = 0
*  EXCEPTIONS
*     cntl_error = 1
*     cntl_install_error = 2
*     cntl_version_error = 3
*     others     = 4
    .
  IF sy-subrc <> 0.
    RAISE control_error.
  ENDIF.

  IF iv_name IS INITIAL.
    CALL METHOD zcl_guidrasil_builder=>init_control_name
      EXPORTING
        iv_text = 'CALENDAR'
      RECEIVING
        ev_name = gv_control_name.
  ELSE.
    gv_control_name = iv_name.
  ENDIF.

  mv_parent_container_name = iv_parent.

  er_control ?= lr_calendar.
  gr_control = lr_calendar.


ENDMETHOD.


  method PROVIDE_CONTROL_NAME.


  ev_name = 'CALENDAR'.
  ev_desc = 'Calendar'.
  ev_icon = icon_date.

  endmethod.


  method PROVIDE_TOOLBAR.
  endmethod.
ENDCLASS.
