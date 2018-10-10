CLASS zcl_guidrasil_control_docking DEFINITION
  PUBLIC
  INHERITING FROM zcl_guidrasil_control_base
  FINAL
  CREATE PUBLIC .

*"* public components of class ZCL_GUIDRASIL_CONTROL_DOCKING
*"* do not include other source files here!!!
  PUBLIC SECTION.

    METHODS apply_settings
        REDEFINITION .
    METHODS create
        REDEFINITION .
    METHODS get_container_list
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
*"* protected components of class ZCL_GUIDRASIL_CONTROL_DOCKING
*"* do not include other source files here!!!
  PRIVATE SECTION.
*"* private components of class ZCL_GUIDRASIL_CONTROL_DOCKING
*"* do not include other source files here!!!

    DATA gs_settings TYPE zguidrasil_setting_dock .
    DATA mr_docking_container TYPE REF TO cl_gui_docking_container .
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_DOCKING IMPLEMENTATION.


  METHOD apply_settings.

    super->apply_settings( ).
    mr_docking_container->dock_at( side = gs_settings-side ).
    mr_docking_container->set_extension( extension = gs_settings-extension ).

  ENDMETHOD.


  METHOD create.


    IF iv_name IS INITIAL.
      gv_control_name = zcl_guidrasil_builder=>init_control_name( 'DOCKER' ).
    ELSE.
      gv_control_name = iv_name.
    ENDIF.


    CREATE OBJECT mr_docking_container
      EXPORTING
        side      = gs_settings-side
        extension = gs_settings-extension
        name      = |{ gv_control_name }|.

    mr_docking_container->set_name( |{ gv_control_name }| ).

    gr_control = mr_docking_container.

  ENDMETHOD.


  METHOD get_container_list.
    DATA lr_container TYPE REF TO cl_gui_container.
    lr_container ?= gr_control.
    APPEND lr_container TO ert_container.
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


*  APPEND 'DATA $control TYPE REF TO cl_gui_docking_container.' TO data.

    APPEND 'CREATE OBJECT $control EXPORTING' TO code.
    APPEND |      side      = { gs_settings-side }| TO code.
    APPEND |      extension = { gs_settings-extension }.| TO code.


  ENDMETHOD.


  METHOD save_settings.

    DATA:
      lr_docking        TYPE REF TO cl_gui_docking_container.


    lr_docking ?= gr_control.

    gs_settings-side = lr_docking->get_docking_side( ).

    CALL METHOD lr_docking->get_extension
      IMPORTING
        extension = gs_settings-extension
      EXCEPTIONS
        OTHERS    = 0.

    CALL METHOD cl_gui_cfw=>flush( ).

* Einstellungen speichern
    save( is_settings = gs_settings ).

  ENDMETHOD.
ENDCLASS.
