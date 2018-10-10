class ZCL_GUIDRASIL_CONTROL_BASE definition
  public
  abstract
  create public .

*"* public components of class ZCL_GUIDRASIL_CONTROL_BASE
*"* do not include other source files here!!!
public section.
  type-pools ABAP .
  type-pools ICON .

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces ZIF_GUIDRASIL_FUNC_RECEIVER .

  data GV_GUID type GUID_16 read-only .
  data GV_CONTROL_NAME type TEXT30 .
  data GR_CONTROL type ref to CL_GUI_CONTROL .
  data GV_CONTROL_SHORT_NAME type STRING .
  data GV_CONTROL_TECHNICAL type SEOCLSNAME .
  data:
    gt_events TYPE STANDARD TABLE OF string .
  data MV_PARENT_CONTAINER_NAME type ZGUIDRASIL_CONTAINER_NAME .

  class-methods GET_INSTANCE
    importing
      !IV_CLASSNAME type SEOCLSNAME
      !IV_GUID type GUID_16 optional
      !IR_PARENT_CONTAINER type ref to CL_GUI_CONTAINER optional
      !IV_DONT_CREATE type XFELD optional
      !IV_NAME type TEXT30 optional
      !IV_CONTROL_ID type I
      !IV_PARENT_CONTAINER type CLIKE optional
    exporting
      !ER_CONTROL type ref to ZCL_GUIDRASIL_CONTROL_BASE
    exceptions
      CONTROL_ERROR .
  class-methods SET_ATTRIBUTE_EXT
    importing
      !ATTR type CLIKE
      !VALUE type ANY
    changing
      !SETTINGS type ANY .
  methods ADD_CHILD
    importing
      !IR_CONTROL type ref to ZCL_GUIDRASIL_CONTROL_BASE .
  methods RETURN_CREATION_CODE
    exporting
      value(CODE) type STRING_TABLE
      !DATA type STRING_TABLE
    returning
      value(NO_CODE) type BOOLEAN .
  methods APPLY_SETTINGS .
  methods CONSTRUCTOR .
  methods CREATE
    importing
      !IR_PARENT type ref to CL_GUI_CONTAINER optional
      !IV_NAME type STRING optional
      !IV_CONTROL_ID type I
      !IV_PARENT type CLIKE
    exporting
      !ER_CONTROL type ref to CL_GUI_CONTROL
      !ERT_CONTAINER type CWB_CONTAINER
    exceptions
      CONTROL_ERROR .
  methods DESTROY .
  methods FUNCTION
    importing
      !IV_FUNCTION type C
    exceptions
      ERROR .
  methods GET_CHILDREN
    exporting
      !ET_CONTROLS type ZGUIDRASIL_CONTROL_T
      !ER_FIRST_CONTROL type ref to ZCL_GUIDRASIL_CONTROL_BASE .
  methods GET_CONTAINER_XXX
    exporting
      !ER_FIRST_CONTAINER type ref to CL_GUI_CONTAINER
      !ERT_CONTAINER type CWB_CONTAINER
      !EV_CONTAINER_NAME type CLIKE .
  methods GET_CONTROL
    returning
      value(OBJECT) type ref to CL_GUI_CONTROL .
  methods GET_CONTROL_LIST
    importing
      !IR_PARENT_CONTROL type ref to ZCL_GUIDRASIL_CONTROL_BASE
    changing
      !CT_CONTROL_LIST type ZGUIDRASIL_CTL_HIERARCHY_T .
  methods GET_DESIGN_FUNCTIONS
    exporting
      value(ET_FUNCTIONS) type TTB_BUTTON
      value(ET_FUNCMENUS) type TTB_BTNMNU .
  methods GET_PATTERN
    returning
      value(ET_PATTERN) type STRING_TABLE .
  methods GET_SETTINGS_VALUE
    importing
      !ATTR type CLIKE
    returning
      value(VALUE) type STRING .
  methods GET_SETTINGS_VAR
    exporting
      !ES_SETTINGS type ANY
      !EV_NO_SETTINGS type XFELD .
  methods HAS_PATTERN
    returning
      value(PATTERN_FLAG) type INTEGER .
  methods INIT
    exporting
      !ER_CONTROL type ref to CL_GUI_OBJECT .
  methods LOAD_SETTINGS .
  methods PROVIDE_CONTROL_NAME
  abstract
    exporting
      !EV_NAME type C
      !EV_TEXT type C
      !EV_DESC type C
      !EV_ICON type ICON_D
      !EV_SHORT type C
    exceptions
      REDEFINE .
  methods PROVIDE_ENHEMA_OBJECT
    exporting
      !EV_ENHEMA_NAME type C
    exceptions
      REDEFINE .
  methods PROVIDE_TOOLBAR
  abstract
    changing
      !CR_TOOLBAR type ref to CL_GUI_TOOLBAR
    exceptions
      ERROR .
  methods SAVE_ALL .
  methods SAVE_SETTINGS .
  methods SET_ATTRIBUTE
    importing
      !NAME type CLIKE
      !VALUE type ANY .
  methods SET_SETTINGS_VAR
    importing
      !IS_SETTINGS type ANY .
  methods VIEW_ATTRIBUTES
    importing
      !IV_EDIT type C .
  methods GET_CONTAINER_LIST
    returning
      value(ERT_CONTAINER) type CWB_CONTAINER .
  methods GET_CONTAINER_NAME
    returning
      value(EV_CONTAINER_NAME) type STRING .
  methods GET_CONTAINER_FIRST
    returning
      value(ER_FIRST_CONTAINER) type ref to CL_GUI_CONTAINER .
  PROTECTED SECTION.
*"* protected components of class ZCL_GUIDRASIL_CONTROL_BASE
*"* do not include other source files here!!!

    CLASS-DATA mr_random TYPE REF TO cl_abap_random_int .
    CLASS-DATA mt_all_icons TYPE treemictab .
    DATA gt_children TYPE zguidrasil_control_t .
    DATA grt_container TYPE cwb_container .
    DATA gv_no_settings TYPE xfeld .
    DATA mr_iterator_objects_func TYPE REF TO cl_object_collection .
    DATA mr_control_functions TYPE REF TO zcl_guidrasil_function .
    DATA mt_creation_code TYPE string_table .
    DATA md_data TYPE REF TO data .

    METHODS init_enhema .
    METHODS load
      CHANGING
        !cs_settings TYPE any OPTIONAL .
    METHODS save
      IMPORTING
        !is_settings TYPE any .
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
    er_control->init_enhema( ).

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


  METHOD init_enhema.

    CREATE OBJECT mr_control_functions
      EXPORTING
        enhema_control = me.

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
