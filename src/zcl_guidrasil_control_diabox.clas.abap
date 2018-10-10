class ZCL_GUIDRASIL_CONTROL_DIABOX definition
  public
  inheriting from ZCL_GUIDRASIL_CONTROL_BASE
  final
  create public .

*"* public components of class ZCL_GUIDRASIL_CONTROL_DIABOX
*"* do not include other source files here!!!
public section.

  methods APPLY_SETTINGS
    redefinition .
  methods CREATE
    redefinition .
  methods GET_CONTAINER_FIRST
    redefinition .
  methods GET_CONTAINER_LIST
    redefinition .
  methods GET_CONTAINER_NAME
    redefinition .
  methods LOAD_SETTINGS
    redefinition .
  methods PROVIDE_CONTROL_NAME
    redefinition .
  methods PROVIDE_TOOLBAR
    redefinition .
  methods RETURN_CREATION_CODE
    redefinition .
  methods SAVE_SETTINGS
    redefinition .
protected section.
*"* protected components of class ZCL_GUIDRASIL_CONTROL_DIABOX
*"* do not include other source files here!!!

  methods DIALOGBOX_CLOSE
    for event CLOSE of CL_GUI_DIALOGBOX_CONTAINER .
private section.
*"* private components of class ZCL_GUIDRASIL_CONTROL_DIABOX
*"* do not include other source files here!!!

  data GS_SETTINGS type /INW/S_ENHEMA_SETTING_DIABOX .
  data MR_DIALOGBOX type ref to CL_GUI_DIALOGBOX_CONTAINER .
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_DIABOX IMPLEMENTATION.


METHOD APPLY_SETTINGS.

  super->apply_settings( ).

  mr_dialogbox->set_height( gs_settings-height ).
  mr_dialogbox->set_width( gs_settings-width ).
  mr_dialogbox->set_left( gs_settings-pos_x ).
  mr_dialogbox->set_top( gs_settings-pos_y ).
*
*  mr_docking_container->set_extension( extension = gs_settings-extension ).

ENDMETHOD.


METHOD CREATE.


  IF iv_name IS INITIAL.
    gv_control_name = /inw/enhema_builder=>init_control_name( 'DIALOGBOX' ).
  ELSE.
    gv_control_name = iv_name.
  ENDIF.

*  gv_control_name = |Diabox_{ gv_control_name }|.

  mv_parent_container_name = iv_parent.

  IF gs_settings IS INITIAL.
    gs_settings-width  = 500.
    gs_settings-height = 300.
    gs_settings-pos_y  =  50.
    gs_settings-pos_x  = 150.
  ENDIF.

  CREATE OBJECT mr_dialogbox
    EXPORTING
      parent  = ir_parent
      width   = gs_settings-width
      height  = gs_settings-height
      top     = gs_settings-pos_y
      left    = gs_settings-pos_x
      caption = gv_control_name.
  mr_dialogbox->set_name( |{ gv_control_name }| ).

  SET HANDLER dialogbox_close FOR mr_dialogbox.

  gr_control = mr_dialogbox.

ENDMETHOD.


  METHOD DIALOGBOX_CLOSE.

    IF mr_dialogbox IS BOUND.
      mr_dialogbox->set_visible( space ).
    ENDIF.

  ENDMETHOD.


  METHOD GET_CONTAINER_FIRST.

    er_first_container ?= gr_control.

  ENDMETHOD.


  METHOD GET_CONTAINER_LIST.

    DATA lr_container TYPE REF TO cl_gui_container.
    lr_container ?= gr_control.
    APPEND lr_container TO ert_container.

  ENDMETHOD.


  METHOD GET_CONTAINER_NAME.

    ev_container_name = gr_control->get_name( ).

  ENDMETHOD.


METHOD LOAD_SETTINGS.

  CALL METHOD load
    CHANGING
      cs_settings = gs_settings.

ENDMETHOD.


  method PROVIDE_CONTROL_NAME.
  endmethod.


  method PROVIDE_TOOLBAR.
  endmethod.


METHOD RETURN_CREATION_CODE.


*  APPEND '$control TYPE REF TO cl_gui_dialogbox_container.' TO data.
*
*  APPEND 'CREATE OBJECT $control EXPORTING' TO code.
*  APPEND |      side      = { gs_settings-side }| TO code.
*  APPEND |      extension = { gs_settings-extension }.| TO code.
*  CREATE OBJECT mr_dialogbox
*    EXPORTING
*      parent  = ir_parent
*      width   = gs_settings-width
*      height  = gs_settings-height
*      top     = gs_settings-pos_y
*      left    = gs_settings-pos_x
*      caption = gv_control_name.

ENDMETHOD.


  METHOD SAVE_SETTINGS.

    DATA:
      lr_docking        TYPE REF TO cl_gui_docking_container.


*    lr_docking ?= gr_control.

    mr_dialogbox->get_height( IMPORTING height = gs_settings-height ).
    mr_dialogbox->get_width( IMPORTING width = gs_settings-width ).
    mr_dialogbox->get_left( IMPORTING left = gs_settings-pos_x ).
    mr_dialogbox->get_top( IMPORTING top = gs_settings-pos_y ).

    CALL METHOD cl_gui_cfw=>flush( ).

* Einstellungen speichern
    save( is_settings = gs_settings ).

  ENDMETHOD.
ENDCLASS.
