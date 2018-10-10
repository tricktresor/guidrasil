CLASS zcl_guidrasil_control_custom DEFINITION
  PUBLIC
  INHERITING FROM zcl_guidrasil_control_base
  FINAL
  CREATE PUBLIC .

*"* public components of class ZCL_GUIDRASIL_CONTROL_CUSTOM
*"* do not include other source files here!!!
  PUBLIC SECTION.

    METHODS create
        REDEFINITION .
    METHODS get_container_first
        REDEFINITION .
    METHODS get_container_list
        REDEFINITION .
    METHODS get_container_name
        REDEFINITION .
    METHODS get_settings_value
        REDEFINITION .
    METHODS get_settings_var
        REDEFINITION .
    METHODS load_settings
        REDEFINITION .
    METHODS provide_control_name
        REDEFINITION .
    METHODS provide_toolbar
        REDEFINITION .
    METHODS save_settings
        REDEFINITION .
  PROTECTED SECTION.
*"* protected components of class ZCL_GUIDRASIL_CONTROL_CUSTOM
*"* do not include other source files here!!!

    DATA ms_settings TYPE zguidrasil_setting_custom .
  PRIVATE SECTION.
*"* private components of class ZCL_GUIDRASIL_CONTROL_CUSTOM
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_CUSTOM IMPLEMENTATION.


  METHOD create.

    DATA lr_cc           TYPE REF TO cl_gui_custom_container.
    DATA lv_name         TYPE c LENGTH 30.

    IF ms_settings-cc_name IS INITIAL.
      ms_settings-cc_name = iv_name.
    ENDIF.

    CREATE OBJECT lr_cc
      EXPORTING
        container_name = ms_settings-cc_name.

    IF iv_name IS INITIAL.
      CALL METHOD zcl_guidrasil_builder=>init_control_name
        EXPORTING
          iv_text = 'CUSTOM'
        RECEIVING
          ev_name = gv_control_name.
    ELSE.
      gv_control_name = iv_name.
    ENDIF.
    mv_parent_container_name = iv_parent.
    gr_control = lr_cc.

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

  ENDMETHOD.


  METHOD get_settings_value.

    ASSIGN COMPONENT attr OF STRUCTURE ms_settings TO FIELD-SYMBOL(<value>).
    IF sy-subrc = 0.
      value = <value>.
    ENDIF.

  ENDMETHOD.


  METHOD get_settings_var.

    es_settings    = ms_settings.

  ENDMETHOD.


  METHOD load_settings.

    CALL METHOD load
      CHANGING
        cs_settings = ms_settings.

  ENDMETHOD.


  METHOD provide_control_name.
  ENDMETHOD.


  METHOD provide_toolbar.
  ENDMETHOD.


  METHOD save_settings.

* Einstellungen speichern
    save( is_settings = ms_settings ).

  ENDMETHOD.
ENDCLASS.
