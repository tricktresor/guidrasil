CLASS zcl_guidrasil_control_diabox DEFINITION
  PUBLIC
  INHERITING FROM zcl_guidrasil_control_base
  FINAL
  CREATE PUBLIC .

*"* public components of class ZCL_GUIDRASIL_CONTROL_DIABOX
*"* do not include other source files here!!!
  PUBLIC SECTION.

    METHODS apply_settings
        REDEFINITION .
    METHODS create
        REDEFINITION .
    METHODS get_container_first
        REDEFINITION .
    METHODS get_container_list
        REDEFINITION .
    METHODS get_container_name
        REDEFINITION .
    METHODS load_settings
        REDEFINITION .
    METHODS provide_control_name
        REDEFINITION .
    METHODS provide_toolbar
        REDEFINITION .
    METHODS return_creation_code
        REDEFINITION .
    METHODS save_settings
        REDEFINITION .
  PROTECTED SECTION.
*"* protected components of class ZCL_GUIDRASIL_CONTROL_DIABOX
*"* do not include other source files here!!!

    METHODS dialogbox_close
        FOR EVENT close OF cl_gui_dialogbox_container .
  PRIVATE SECTION.
*"* private components of class ZCL_GUIDRASIL_CONTROL_DIABOX
*"* do not include other source files here!!!

    DATA gs_settings TYPE zguidrasil_setting_diabox .
    DATA mr_dialogbox TYPE REF TO cl_gui_dialogbox_container .
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_DIABOX IMPLEMENTATION.


  METHOD apply_settings.

    super->apply_settings( ).

    mr_dialogbox->set_height( gs_settings-height ).
    mr_dialogbox->set_width( gs_settings-width ).
    mr_dialogbox->set_left( gs_settings-pos_x ).
    mr_dialogbox->set_top( gs_settings-pos_y ).
*
*  mr_docking_container->set_extension( extension = gs_settings-extension ).

  ENDMETHOD.


  METHOD create.


    IF iv_name IS INITIAL.
      gv_control_name = zcl_guidrasil_builder=>init_control_name( 'DIALOGBOX' ).
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


  METHOD dialogbox_close.

    IF mr_dialogbox IS BOUND.
      mr_dialogbox->set_visible( space ).
    ENDIF.

  ENDMETHOD.


  METHOD get_container_first.

    er_first_container ?= gr_control.

  ENDMETHOD.


  METHOD get_container_list.

    DATA lr_container TYPE REF TO cl_gui_container.
    lr_container ?= gr_control.
    APPEND lr_container TO ert_container.

  ENDMETHOD.


  METHOD get_container_name.

    ev_container_name = gr_control->get_name( ).

  ENDMETHOD.


  METHOD load_settings.

    CALL METHOD load
      CHANGING
        cs_settings = gs_settings.

  ENDMETHOD.


  METHOD provide_control_name.
  ENDMETHOD.


  METHOD provide_toolbar.
  ENDMETHOD.


  METHOD return_creation_code.


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


  METHOD save_settings.

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
