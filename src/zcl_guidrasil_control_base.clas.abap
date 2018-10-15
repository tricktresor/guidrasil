CLASS zcl_guidrasil_control_base DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

*"* public components of class ZCL_GUIDRASIL_CONTROL_BASE
*"* do not include other source files here!!!
  PUBLIC SECTION.
    TYPE-POOLS abap .
    TYPE-POOLS icon .

    INTERFACES if_serializable_object .
    INTERFACES zif_guidrasil_func_receiver .

    DATA gv_guid TYPE guid_16 READ-ONLY .
    DATA gv_control_name TYPE text30 .
    DATA gr_control TYPE REF TO cl_gui_control .
    DATA gv_control_short_name TYPE string .
    DATA gv_control_technical TYPE seoclsname .
    DATA:
      gt_events TYPE STANDARD TABLE OF string .
    DATA mv_parent_container_name TYPE zguidrasil_container_name .

    CLASS-METHODS get_instance
      IMPORTING
        !iv_classname        TYPE seoclsname
        !iv_guid             TYPE guid_16 OPTIONAL
        !ir_parent_container TYPE REF TO cl_gui_container OPTIONAL
        !iv_dont_create      TYPE xfeld OPTIONAL
        !iv_name             TYPE text30 OPTIONAL
        !iv_control_id       TYPE i
        !iv_parent_container TYPE clike OPTIONAL
      EXPORTING
        !er_control          TYPE REF TO zcl_guidrasil_control_base
      EXCEPTIONS
        control_error .
    CLASS-METHODS set_attribute_ext
      IMPORTING
        !attr     TYPE clike
        !value    TYPE any
      CHANGING
        !settings TYPE any .
    METHODS add_child
      IMPORTING
        !ir_control TYPE REF TO zcl_guidrasil_control_base .
    METHODS return_creation_code
      EXPORTING
        VALUE(code)    TYPE string_table
        !data          TYPE string_table
      RETURNING
        VALUE(no_code) TYPE rm_boolean .
    METHODS apply_settings .
    METHODS constructor .
    METHODS create
      IMPORTING
        !ir_parent     TYPE REF TO cl_gui_container OPTIONAL
        !iv_name       TYPE string OPTIONAL
        !iv_control_id TYPE i
        !iv_parent     TYPE clike
      EXPORTING
        !er_control    TYPE REF TO cl_gui_control
        !ert_container TYPE cwb_container
      EXCEPTIONS
        control_error .
    METHODS destroy .
    METHODS function
      IMPORTING
        !iv_function TYPE c
      EXCEPTIONS
        error .
    METHODS get_children
      EXPORTING
        !et_controls      TYPE zguidrasil_control_t
        !er_first_control TYPE REF TO zcl_guidrasil_control_base .
    METHODS get_container_xxx
      EXPORTING
        !er_first_container TYPE REF TO cl_gui_container
        !ert_container      TYPE cwb_container
        !ev_container_name  TYPE clike .
    METHODS get_control
      RETURNING
        VALUE(object) TYPE REF TO cl_gui_control .
    METHODS get_control_list
      IMPORTING
        !ir_parent_control TYPE REF TO zcl_guidrasil_control_base
      CHANGING
        !ct_control_list   TYPE zguidrasil_ctl_hierarchy_t .
    METHODS get_design_functions
      EXPORTING
        VALUE(et_functions) TYPE ttb_button
        VALUE(et_funcmenus) TYPE ttb_btnmnu .
    METHODS get_pattern
      RETURNING
        VALUE(et_pattern) TYPE string_table .
    METHODS get_settings_value
      IMPORTING
        !attr        TYPE clike
      RETURNING
        VALUE(value) TYPE string .
    METHODS get_settings_var
      EXPORTING
        !es_settings    TYPE any
        !ev_no_settings TYPE xfeld .
    METHODS has_pattern
      RETURNING
        VALUE(pattern_flag) TYPE integer .
    METHODS init
      EXPORTING
        !er_control TYPE REF TO cl_gui_object .
    METHODS load_settings .
    METHODS provide_control_name
          ABSTRACT
      EXPORTING
        !ev_name  TYPE c
        !ev_text  TYPE c
        !ev_desc  TYPE c
        !ev_icon  TYPE icon_d
        !ev_short TYPE c
      EXCEPTIONS
        redefine .
    METHODS provide_enhema_object
      EXPORTING
        !ev_enhema_name TYPE c
      EXCEPTIONS
        redefine .
    METHODS provide_toolbar
          ABSTRACT
      CHANGING
        !cr_toolbar TYPE REF TO cl_gui_toolbar
      EXCEPTIONS
        error .
    METHODS save_all .
    METHODS save_settings .
    METHODS set_attribute
      IMPORTING
        !name  TYPE clike
        !value TYPE any .
    METHODS set_settings_var
      IMPORTING
        !is_settings TYPE any .
    METHODS view_attributes
      IMPORTING
        !iv_edit TYPE c .
    METHODS get_container_list
      RETURNING
        VALUE(ert_container) TYPE cwb_container .
    METHODS get_container_name
      RETURNING
        VALUE(ev_container_name) TYPE string .
    METHODS get_container_first
      RETURNING
        VALUE(er_first_container) TYPE REF TO cl_gui_container .
protected section.

*"* protected components of class ZCL_GUIDRASIL_CONTROL_BASE
*"* do not include other source files here!!!
  class-data MR_RANDOM type ref to CL_ABAP_RANDOM_INT .
  class-data MT_ALL_ICONS type TREEMICTAB .
  data GT_CHILDREN type ZGUIDRASIL_CONTROL_T .
  data GRT_CONTAINER type CWB_CONTAINER .
  data GV_NO_SETTINGS type XFELD .
  data MR_ITERATOR_OBJECTS_FUNC type ref to CL_OBJECT_COLLECTION .
  data MR_CONTROL_FUNCTIONS type ref to ZCL_GUIDRASIL_FUNCTION .
  data MT_CREATION_CODE type STRING_TABLE .
  data MD_DATA type ref to DATA .

  methods INIT_GUIDRASIL .
  methods LOAD
    changing
      !CS_SETTINGS type ANY optional .
  methods SAVE
    importing
      !IS_SETTINGS type ANY .
  PRIVATE SECTION.
*"* private components of class ZCL_GUIDRASIL_CONTROL_BASE
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_BASE IMPLEMENTATION.


  METHOD add_child.

    APPEND ir_control TO gt_children.

  ENDMETHOD.


  METHOD apply_settings.


  ENDMETHOD.


  METHOD constructor.



  ENDMETHOD.


  METHOD create.
* Implementierung in den Subklassen

  ENDMETHOD.


  METHOD destroy.

    DATA:
      lr_control_builder       TYPE REF TO zcl_guidrasil_control_base.

* Elemente rekursiv löschen
    LOOP AT gt_children INTO lr_control_builder.
      CALL METHOD lr_control_builder->destroy.
      DELETE gt_children.
    ENDLOOP.

    IF gr_control IS BOUND.
      CALL METHOD gr_control->free EXCEPTIONS OTHERS = 1.
    ENDIF.

  ENDMETHOD.


  METHOD function.
  ENDMETHOD.


  METHOD get_children.

    READ TABLE gt_children INTO er_first_control INDEX 1.
    et_controls = gt_children.

  ENDMETHOD.


  METHOD get_container_first.



  ENDMETHOD.


  METHOD get_container_list.



  ENDMETHOD.


  METHOD get_container_name.



  ENDMETHOD.


  METHOD get_container_xxx.



  ENDMETHOD.


  METHOD get_control.

    object = gr_control.

  ENDMETHOD.


  METHOD get_control_list.

    DATA:
      ls_control_list    TYPE zguidrasil_ctl_hierarchy_s,
      lr_control_builder TYPE REF TO zcl_guidrasil_control_base.

* Elemente rekursiv ermitteln
    LOOP AT gt_children INTO lr_control_builder.

      READ TABLE ct_control_list TRANSPORTING NO FIELDS
            WITH KEY parent  = ir_parent_control
                     control = lr_control_builder
                     guid    = gv_guid
                     name    = gv_control_name.             "ew20160609
      CHECK sy-subrc > 0.
      ls_control_list-parent  = ir_parent_control.
      ls_control_list-control = lr_control_builder.
      ls_control_list-guid    = gv_guid.
      ls_control_list-name    = gv_control_name.
      APPEND ls_control_list TO ct_control_list.

      CALL METHOD lr_control_builder->get_control_list
        EXPORTING
          ir_parent_control = lr_control_builder
        CHANGING
          ct_control_list   = ct_control_list.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_design_functions.
  ENDMETHOD.


  METHOD get_instance.

    DATA lr_obj         TYPE REF TO cl_abap_classdescr.
    DATA lv_cc_name     TYPE string.

* Klassennamen auf Kompatibilität prüfen
    lr_obj ?= cl_abap_typedescr=>describe_by_name( 'zcl_guidrasil_control_base' ).
    IF lr_obj->applies_to_class( iv_classname ) = abap_false.
      RAISE control_error.
    ENDIF.

    CREATE OBJECT er_control TYPE (iv_classname).
    er_control->init_guidrasil( ).

* eindeutige ID erzeugen, wenn nicht gesetzt
    IF iv_guid IS INITIAL.
*    if sy-uname = 'EWULFF'.
*      er_control->gv_guid = /INW/enhema_tools=>guid_create( ).
*    else.
      CALL FUNCTION 'GUID_CREATE'
        IMPORTING
          ev_guid_16 = er_control->gv_guid.
*    endif.
      er_control->gv_no_settings = abap_true.
* sonst GUID übernehmen
    ELSE.
      er_control->gv_guid = iv_guid.
*   ggf. Control-spezifische Einstellungen laden
      CALL METHOD er_control->load_settings.

      lv_cc_name = er_control->get_settings_value( 'CC_NAME' ).
    ENDIF.


* entsprechendes Kindcontrol erzeugen
    IF iv_dont_create = abap_false.

      IF lv_cc_name IS INITIAL.
        lv_cc_name = iv_name.
      ENDIF.

      CALL METHOD er_control->create
        EXPORTING
          ir_parent     = ir_parent_container
          iv_parent     = iv_parent_container
          iv_name       = lv_cc_name
          iv_control_id = iv_control_id
        EXCEPTIONS
          OTHERS        = 1.

      IF sy-subrc <> 0.
        RAISE control_error.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_pattern.
  ENDMETHOD.


  METHOD get_settings_value.

    "Please redefine!
*  MESSAGE i000(oo) WITH 'Please Redefine!! GET_SETTINGS_VALUE'.

  ENDMETHOD.


  METHOD get_settings_var.
    ev_no_settings = abap_true.
  ENDMETHOD.


  METHOD has_pattern.
*** Please redefine!
    pattern_flag = 0.
  ENDMETHOD.


  METHOD init.
  ENDMETHOD.


  METHOD INIT_GUIDRASIL.

    CREATE OBJECT mr_control_functions
      EXPORTING
        guidrasil_control = me.

  ENDMETHOD.


  METHOD load.

    DATA lv_xml      TYPE xstring.
    DATA lv_guid(32) TYPE c.
    DATA lx_error    TYPE REF TO cx_st_error.

    CLEAR gv_no_settings.

* aus Index-Tabelle lesen
    lv_guid = gv_guid.
    SELECT SINGLE settings
      FROM zguidrasil_set
      INTO lv_xml
     WHERE guid = gv_guid.

    IF sy-subrc <> 0.
      gv_no_settings = abap_true.
      CLEAR cs_settings.
    ELSE.

      TRY .
* Deserialisierung XML -> ABAP STRUKTUR
          CALL TRANSFORMATION id
            SOURCE XML lv_xml
            RESULT root = cs_settings.

        CATCH cx_st_error INTO lx_error.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD load_settings.

* Vorablösung (das geht noch schöner)

* Aufruf von SAVE in den Unterklassen mit der Einstellungsstruktur

  ENDMETHOD.


  METHOD provide_enhema_object.

    DATA lr_description      TYPE REF TO cl_abap_typedescr.

    CALL METHOD cl_abap_datadescr=>describe_by_object_ref
      EXPORTING
        p_object_ref         = me
      RECEIVING
        p_descr_ref          = lr_description
      EXCEPTIONS
        reference_is_initial = 1
        OTHERS               = 2.
    IF sy-subrc = 0.
      ev_enhema_name = lr_description->absolute_name.
    ENDIF.

  ENDMETHOD.


  METHOD return_creation_code.

*  DATA lv_line TYPE string.

*  APPEND lv_line TO mt_creation_code.

* $control => Name of Control
* $parent  => Name of Parent Container
    no_code = abap_true.

  ENDMETHOD.


  METHOD save.

    DATA lv_no_settings TYPE xfeld.
    DATA ls_settings TYPE zguidrasil_set.


    CLEAR ls_settings.
    ls_settings-guid = gv_guid.

*== XML-Serialisierung STRUKTUR
    CALL TRANSFORMATION id
      SOURCE root = is_settings
      RESULT XML ls_settings-settings.

    MODIFY zguidrasil_set FROM ls_settings.

  ENDMETHOD.


  METHOD save_all.

    DATA:
      lr_control_builder       TYPE REF TO zcl_guidrasil_control_base.

* Elemente rekursiv ermitteln
    LOOP AT gt_children INTO lr_control_builder.
      lr_control_builder->save_all( ).
    ENDLOOP.

* Eigene Einstellungen speichern
    save_settings( ).

    COMMIT WORK.

  ENDMETHOD.


  METHOD save_settings.

* Vorablösung (das geht noch schöner)

* Aufruf von LOAD in den Unterklassen mit der Einstellungsstruktur

  ENDMETHOD.


  METHOD set_attribute.

    "please redefine!!

  ENDMETHOD.


  METHOD set_attribute_ext.

    FIELD-SYMBOLS <value> TYPE any.

    ASSIGN COMPONENT attr OF STRUCTURE settings TO <value>.
    IF sy-subrc = 0.
      <value> = value.
    ENDIF.

  ENDMETHOD.


  METHOD set_settings_var.
    "REDEFINE!
  ENDMETHOD.


  METHOD view_attributes.

    CALL METHOD zcl_guidrasil_tools=>view_attributes
      EXPORTING
        iv_structure_name   = space
        is_structure_values = space
      CHANGING
        cv_name             = gv_control_name
      EXCEPTIONS
        OTHERS              = 2.

  ENDMETHOD.


  method ZIF_GUIDRASIL_FUNC_RECEIVER~ON_DROPDOWN_CLICKED.
  endmethod.


  method ZIF_GUIDRASIL_FUNC_RECEIVER~ON_FUNCTION_SELECTED.
  endmethod.
ENDCLASS.
