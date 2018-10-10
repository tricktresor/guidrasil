class ZCL_GUIDRASIL_CONTROL_SPLITTER definition
  public
  inheriting from ZCL_GUIDRASIL_CONTROL_BASE
  final
  create public .

*"* public components of class ZCL_GUIDRASIL_CONTROL_SPLITTER
*"* do not include other source files here!!!
public section.

  methods CREATE
    redefinition .
  methods GET_CONTAINER_LIST
    redefinition .
  methods LOAD_SETTINGS
    redefinition .
  methods PROVIDE_CONTROL_NAME
    redefinition .
  methods PROVIDE_TOOLBAR
    redefinition .
  methods SAVE_SETTINGS
    redefinition .
protected section.
*"* protected components of class ZCL_GUIDRASIL_CONTROL_SPLITTER
*"* do not include other source files here!!!
PRIVATE SECTION.
*"* private components of class /INW/ENHEMA_CONTROL_SPLITTER
*"* do not include other source files here!!!

  DATA ms_settings TYPE zguidrasil_setting_splitter .
  DATA gv_orient_set TYPE xfeld .
  DATA gv_orientation TYPE int4 .
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_SPLITTER IMPLEMENTATION.


METHOD CREATE.


  DATA lr_splitter          TYPE REF TO cl_gui_splitter_container.
  DATA lr_container_toolbar TYPE REF TO cl_gui_container.
  DATA lr_container_control TYPE REF TO cl_gui_container.
*  DATA lv_orientation       TYPE i.
  DATA lv_answer            TYPE c.

** HW
*  IF gv_no_settings = abap_false.
*    gv_orient_set = abap_true.
*    gv_orientation = gs_settings-orientation.
*  ENDIF.
* HW

  IF ms_settings IS INITIAL.
    CALL FUNCTION 'Z_GUIDRASIL_SPLITTER_POPUP'
      CHANGING
        cs_settings = ms_settings.
  ENDIF.


  CREATE OBJECT lr_splitter
    EXPORTING
      parent  = ir_parent
      rows    = ms_settings-rows
      columns = ms_settings-cols.


  IF iv_name IS INITIAL.
    gv_control_name = zcl_guidrasil_builder=>init_control_name( 'SPLITTER' ).
  ELSE.
    gv_control_name = iv_name.
  ENDIF.

  mv_parent_container_name = iv_parent.

  DATA lr_container TYPE REF TO cl_gui_container.
  DATA row TYPE i.
  DATA col TYPE i.

  DO ms_settings-rows TIMES.
    ADD 1 TO row.
    DO ms_settings-cols TIMES.
      ADD 1 TO col.
      lr_container = lr_splitter->get_container( row = row column = col ).
      lr_container->parent->set_name( |{ gv_control_name }_PARENT| ).
      lr_container->set_name( |{ gv_control_name }_{ row }_{ col }| ).
      APPEND lr_container TO ert_container.
      APPEND lr_container TO grt_container.
    ENDDO.
    col = 0.
  ENDDO.


  er_control ?= lr_splitter.
  gr_control = lr_splitter.

ENDMETHOD.


  METHOD GET_CONTAINER_LIST.
    ert_container = grt_container.
  ENDMETHOD.


METHOD LOAD_SETTINGS.

  CALL METHOD load
    CHANGING
      cs_settings = ms_settings.

ENDMETHOD.


METHOD PROVIDE_CONTROL_NAME.
ENDMETHOD.


  method PROVIDE_TOOLBAR.
  endmethod.


METHOD SAVE_SETTINGS.

  save( is_settings = ms_settings ).

ENDMETHOD.
ENDCLASS.
