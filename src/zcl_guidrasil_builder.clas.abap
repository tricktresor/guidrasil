class ZCL_GUIDRASIL_BUILDER definition
  public
  final
  create public .

*"* public components of class ZCL_GUIDRASIL_BUILDER
*"* do not include other source files here!!!
public section.
  type-pools ABAP .
  type-pools CNTB .
  type-pools ICON .

  interfaces ZIF_GUIDRASIL_FUNC_RECEIVER .

  constants ICON_CONTAINER type ZGUIDRASIL_ICON_NAME value ICON_WD_VIEW_CONTAINER ##NO_TEXT.
  constants K_MODE_DESIGN type CHAR01 value 'D' ##NO_TEXT.
  constants K_MODE_PATTERN type CHAR01 value 'P' ##NO_TEXT.

  class-methods CLASS_CONSTRUCTOR .
  class-methods INIT_CONTROL_NAME
    importing
      !IV_TEXT type C
    returning
      value(EV_NAME) type TEXT30 .
  methods ADD_CONTAINER
    importing
      !IV_SIDE type I
      !IV_CONTROL_ID type I optional .
  methods ADD_CONTAINER_BOX .
  methods ADD_CONTAINER_CC
    importing
      !CC_NAME type CLIKE optional .
  methods BUILD .
  methods CONSTRUCTOR
    importing
      !IV_PNAME type ZGUIDRASIL_PROJECT
      !IV_MODE type CHAR01 default SPACE .
  methods GET_CREATION_CODE
    returning
      value(CODE) type STRING_TABLE .
  methods GET_EVENT_PATTERN
    returning
      value(PATTERN) type STRING_TABLE .
  methods GET_EVENT_PATTERN_PLUS
    returning
      value(PATTERN) type STRING_TABLE .
  methods GET_OBJECT_BY_NAME
    importing
      !NAME type CLIKE
    returning
      value(OBJECT) type ref to CL_GUI_OBJECT .
  methods SAVE .
  PROTECTED SECTION.
*"* protected components of class ZCL_GUIDRASIL_CONTROL_BUILDER
*"* do not include other source files here!!!

    METHODS add_control_object
      IMPORTING
        VALUE(fcode)      TYPE ui_func
        VALUE(r_sender)   TYPE REF TO object
        VALUE(r_receiver) TYPE REF TO object
        VALUE(r_toolbar)  TYPE REF TO cl_gui_toolbar .
    METHODS get_menu_functions
      IMPORTING
        !fcode              TYPE clike
      RETURNING
        VALUE(it_functions) TYPE ttb_button .
private section.

  types:
*"* private components of class ZCL_GUIDRASIL_BUILDER
*"* do not include other source files here!!!
    BEGIN OF gys_control_classes,
        id        TYPE i, "numc5,
        classname TYPE seoclsname,
      END OF gys_control_classes .
  types:
    gyt_control_classes TYPE SORTED TABLE OF gys_control_classes
        WITH UNIQUE KEY id .
  types:
    BEGIN OF gys_control_admin,
        id          TYPE i,
        name        TYPE string,
        parent      TYPE REF TO zcl_guidrasil_control_base,
        parent_name TYPE zguidrasil_container_name,
        control     TYPE REF TO zcl_guidrasil_control_base,
      END OF gys_control_admin .
  types:
    gyt_control_admin TYPE TABLE OF gys_control_admin .

  class-data MT_IDX type TY_IDX_T .
  class-data MT_CTLS type ZGUIDRASIL_CTLS_T .
  class-data GV_CONTROL_ID type NUMC3 .
  data CURRENT_CONTROL_ID type I .
  data R_TOOLBAR type ref to CL_GUI_TOOLBAR .
  data MT_CONTROLS type ZGUIDRASIL_OBJ_T .
  data MODE type CHAR01 .
  data PNAME type CHAR40 .
  data R_DOCKING type ref to CL_GUI_DOCKING_CONTAINER .
  data R_TOOLBAR_CONTAINER type ref to CL_GUI_DIALOGBOX_CONTAINER .
  class-data GT_CONTROL_CLASSES type GYT_CONTROL_CLASSES .
  data T_CONTROL_ADMIN type GYT_CONTROL_ADMIN .
  class-data GT_DELETE_FUNCTION type TTB_BUTTON .
  class-data GT_CLOSE_FUNCTION type TTB_BUTTON .
  class-data GT_INSERT_FUNCTION type TTB_BUTTON .
  class-data GT_PATTERN_FUNCTION type TTB_BUTTON .
  data GT_CONTROL_LIST type ZGUIDRASIL_CONTROL_LIST_T .

  class-methods GET_NAME_BUTTON
    importing
      !IR_CONTROL type ref to ZCL_GUIDRASIL_CONTROL_BASE
    changing
      !CT_FUNCTIONS type TTB_BUTTON .
  methods ADD_CONTROL
    importing
      !IR_CONTROL type ref to ZCL_GUIDRASIL_CONTROL_BASE
      !IR_PARENT type ref to ZCL_GUIDRASIL_CONTROL_BASE optional
      !IV_PARENT_NAME type CLIKE optional .
  methods BUILD_CONTROL_TOOLBAR
    importing
      !IR_WRAPPER type ref to ZCL_GUIDRASIL_DESIGN_CONTAINER .
  methods BUILD_DESIGN_TOOLBAR .
  methods BUILD_EDIT_TOOLBAR
    importing
      !IR_WRAPPER type ref to ZCL_GUIDRASIL_DESIGN_CONTAINER
      !IR_CONTROL_BUILDER type ref to ZCL_GUIDRASIL_CONTROL_BASE .
  methods BUILD_PATTERN_TOOLBAR
    importing
      !IR_WRAPPER type ref to ZCL_GUIDRASIL_DESIGN_CONTAINER
      !IR_CONTROL_BUILDER type ref to ZCL_GUIDRASIL_CONTROL_BASE .
  methods CODE_REPLACE
    importing
      !SEARCH type CLIKE
      !REPLACE type CLIKE
      !PREFIX type CLIKE
    changing
      !CODE type STRING_TABLE .
  methods CREATE_WRAPPER
    importing
      !IV_CONTROL_TOOLBAR type XFELD optional
      !IV_EDIT_TOOLBAR type XFELD optional
      !IR_CONTAINER type ref to CL_GUI_CONTAINER optional
      !IR_PARENT_BUILDER type ref to ZCL_GUIDRASIL_CONTROL_BASE
    exporting
      !ER_WRAPPER type ref to ZCL_GUIDRASIL_DESIGN_CONTAINER .
  methods IS_CLOSE_FUNCTION_ENABLED
    importing
      !IR_WRAPPER type ref to ZCL_GUIDRASIL_DESIGN_CONTAINER
    returning
      value(RV_ENABLED) type XFELD .
  methods ON_DESIGN_FUNCTION_SELECTED
    for event FUNCTION_SELECTED of CL_GUI_TOOLBAR
    importing
      !FCODE .
  methods SET_CURRENT_CONTROL_ID
    returning
      value(CONTROL_ID) type I .
  methods UPDATE_CONTROLS .
ENDCLASS.



CLASS ZCL_GUIDRASIL_BUILDER IMPLEMENTATION.


  METHOD add_container.

    DATA lv_extension         TYPE i.
    DATA lv_control_id        TYPE i.
    DATA lr_control_builder   TYPE REF TO zcl_guidrasil_control_base.
    DATA lr_wrapper           TYPE REF TO zcl_guidrasil_design_container.
    DATA lr_docking_container TYPE REF TO cl_gui_docking_container.

    IF iv_control_id IS INITIAL.
      lv_control_id = set_current_control_id( ).
    ELSE.
      lv_control_id = iv_control_id.
    ENDIF.

    CASE iv_side.
      WHEN cl_gui_docking_container=>dock_at_bottom
        OR cl_gui_docking_container=>dock_at_top.
        lv_extension = 160.
      WHEN cl_gui_docking_container=>dock_at_left
        OR cl_gui_docking_container=>dock_at_right.
        lv_extension = 400.
    ENDCASE.


* entsprechenden Control-Builder anlegen
    CALL METHOD zcl_guidrasil_control_base=>get_instance
      EXPORTING
        iv_classname  = 'ZCL_GUIDRASIL_CONTROL_DOCKING'
        iv_control_id = lv_control_id
      IMPORTING
        er_control    = lr_control_builder
      EXCEPTIONS
        OTHERS        = 1.



    zcl_guidrasil_tools=>todo( 'Setzen Daten innerhalb drasil-Control' ).
    lr_control_builder->apply_settings( ).


* Seite und Größe festlegen
    lr_docking_container ?= lr_control_builder->gr_control.
    lr_docking_container->dock_at( side   = iv_side ).
    lr_docking_container->set_extension( extension = lv_extension ).

* Control zur Verwaltungstabelle hinzufügen
    add_control( ir_control = lr_control_builder ).

* im Designmode Wrapper hinzufügen
    create_wrapper( iv_control_toolbar = abap_true
                    ir_parent_builder  = lr_control_builder ).


  ENDMETHOD.


  METHOD add_container_box.

    DATA lv_extension         TYPE i.
    DATA lr_control_builder   TYPE REF TO zcl_guidrasil_control_base.
    DATA lr_wrapper           TYPE REF TO zcl_guidrasil_design_container.

    DATA lv_control_id        TYPE i.

    lv_control_id = set_current_control_id( ).

* entsprechenden Control-Builder anlegen
    CALL METHOD zcl_guidrasil_control_base=>get_instance
      EXPORTING
        iv_classname        = 'ZCL_GUIDRASIL_CONTROL_DIABOX'
        ir_parent_container = cl_gui_container=>screen0
        iv_control_id       = 0
      IMPORTING
        er_control          = lr_control_builder
      EXCEPTIONS
        OTHERS              = 1.


* Control zur Verwaltungstabelle hinzufügen
    add_control( lr_control_builder ).


* im Designmode Wrapper hinzufügen
    CALL METHOD create_wrapper
      EXPORTING
        iv_control_toolbar = abap_true
        ir_parent_builder  = lr_control_builder.


  ENDMETHOD.


  METHOD add_container_cc.

    DATA lv_extension         TYPE i.
    DATA lr_control_builder   TYPE REF TO zcl_guidrasil_control_base.
    DATA lr_wrapper           TYPE REF TO zcl_guidrasil_design_container.
    DATA lr_cc_container      TYPE REF TO cl_gui_custom_container.
    DATA lv_control_id        TYPE i.

    lv_control_id = set_current_control_id( ).

* entsprechenden Control-Builder anlegen
    CALL METHOD zcl_guidrasil_control_base=>get_instance
      EXPORTING
        iv_classname  = 'ZCL_GUIDRASIL_CONTROL_CUSTOM'
        iv_name       = cc_name
        iv_control_id = 0
      IMPORTING
        er_control    = lr_control_builder
      EXCEPTIONS
        OTHERS        = 1.


* Seite und Größe festlegen
    lr_cc_container ?= lr_control_builder->gr_control.


* Control zur Verwaltungstabelle hinzufügen
    add_control( lr_control_builder ).


* im Designmode Wrapper hinzufügen
    CALL METHOD create_wrapper
      EXPORTING
        iv_control_toolbar = abap_true
        ir_parent_builder  = lr_control_builder.

  ENDMETHOD.


  METHOD add_control.

    DATA ls_control_admin         TYPE gys_control_admin.

*== New Control
    ls_control_admin-id          = current_control_id.
    ls_control_admin-name        = ir_control->gv_control_name.
    ls_control_admin-control     = ir_control.
    ls_control_admin-parent      = ir_parent.
    ls_control_admin-parent_name = iv_parent_name.
    APPEND ls_control_admin TO t_control_admin.
    set_current_control_id( ).

    DATA ls_control_list             TYPE zguidrasil_control_list.

    CLEAR ls_control_list.
    READ TABLE gt_control_list TRANSPORTING NO FIELDS WITH TABLE KEY guid = ir_control->gv_guid.
    IF sy-subrc > 0.
      ls_control_list-guid              = ir_control->gv_guid.
      ls_control_list-r_control_builder = ir_control.
      ls_control_list-t_container = ir_control->get_container_list( ).
      INSERT ls_control_list INTO TABLE gt_control_list.
    ENDIF.

  ENDMETHOD.


  METHOD add_control_object.

    DATA lr_container       TYPE REF TO cl_gui_container.
    DATA lr_wrapper         TYPE REF TO zcl_guidrasil_design_container.
    DATA lr_control_builder TYPE REF TO zcl_guidrasil_control_base.
    DATA ls_control_list    LIKE LINE OF gt_control_list.   "ew20160609

    FIELD-SYMBOLS <ls_control_classes> TYPE gys_control_classes.


    CHECK fcode(1) <> '$'.

*     Lesen, welches Control hinzugefügt werden soll
    READ TABLE gt_control_classes
      ASSIGNING <ls_control_classes>
      WITH KEY
        id = fcode.

*     Hinzufüge-Funktion eines Controls?
    CHECK sy-subrc = 0.

*     Container vom Wrapper holen
    lr_wrapper                      ?= r_sender.
    lr_container                     = lr_wrapper->get_container_first( ).
    ls_control_list-parent_container = lr_wrapper->get_container_name( ).

*     entsprechenden Control-Builder anlegen
    zcl_guidrasil_control_base=>get_instance(
      EXPORTING
        iv_classname        = <ls_control_classes>-classname
        ir_parent_container = lr_container
        iv_parent_container = ls_control_list-parent_container
        iv_control_id       = <ls_control_classes>-id
      IMPORTING
        er_control          = lr_control_builder
      EXCEPTIONS
        OTHERS              = 1 ).

    CHECK sy-subrc = 0.

    READ TABLE gt_control_list TRANSPORTING NO FIELDS
          WITH KEY guid = lr_control_builder->gv_guid.
    IF sy-subrc > 0.
      ls_control_list-guid              = lr_control_builder->gv_guid.
      ls_control_list-r_control_builder = lr_control_builder.
      INSERT ls_control_list
        INTO TABLE gt_control_list.                         "ew20160609
    ENDIF.


*     Untergeordnetes Control bekannt machen
    lr_wrapper->add_child( lr_control_builder ).

    add_control(
        ir_control     = lr_control_builder
        ir_parent      = lr_wrapper->get_parent( )
        iv_parent_name = ls_control_list-parent_container ).


*     Einfüge-Toolbar in Editiertoolbar ändern
    build_edit_toolbar(
       ir_wrapper         = lr_wrapper
       ir_control_builder = lr_control_builder ).


*     Wrapper aufbauen, falls Control weitere Kindcontainer hat
    create_wrapper(
        iv_control_toolbar = abap_true
        ir_parent_builder  = lr_control_builder ).

  ENDMETHOD.


  METHOD build.

    DATA lv_classname                TYPE seoclsname.
    DATA ls_control_list             TYPE zguidrasil_control_list.
    DATA lr_control_builder          TYPE REF TO zcl_guidrasil_control_base.
    DATA lr_container                TYPE REF TO cl_gui_container.
    DATA lr_wrapper                  TYPE REF TO zcl_guidrasil_design_container.
    DATA lv_parent_container_found   TYPE boolean.

    FIELD-SYMBOLS <ls_object>        TYPE zguidrasil_obj.
    FIELD-SYMBOLS <ls_control_list>  LIKE ls_control_list.


*TODO: Prüfung Klassennamen

    CASE mode.
      WHEN k_mode_design.
*      CALL METHOD build_design_toolbar.
    ENDCASE.

    SORT mt_controls BY control_index.

* Controls aufbauen
    LOOP AT mt_controls ASSIGNING <ls_object>.

      READ TABLE gt_control_list
        ASSIGNING <ls_control_list>
        WITH TABLE KEY
          guid = <ls_object>-parent_guid.

*   Root -> erzeugen
      IF sy-subrc <> 0.
*     derzeit nur Docking-Container/ Custom Control
        lv_classname = <ls_object>-parent.
        CALL METHOD zcl_guidrasil_control_base=>get_instance
          EXPORTING
            iv_classname  = lv_classname
            iv_guid       = <ls_object>-parent_guid
            iv_control_id = <ls_object>-control_index
          IMPORTING
            er_control    = lr_control_builder
          EXCEPTIONS
            OTHERS        = 1.



        CLEAR ls_control_list.
        ls_control_list-guid              = lr_control_builder->gv_guid.
        ls_control_list-r_control_builder = lr_control_builder.
        lr_container                     ?= lr_control_builder->gr_control.
        APPEND lr_container TO ls_control_list-t_container.

        INSERT ls_control_list
          INTO TABLE gt_control_list
               ASSIGNING <ls_control_list>.

*     Control zur Verwaltungstabelle hinzufügen
        set_current_control_id( ).
        add_control( ir_control = lr_control_builder ).

      ENDIF.

*   1. Container ermitteln

      LOOP AT <ls_control_list>-t_container INTO lr_container.
        IF lr_container->get_name( ) = <ls_object>-parent_container.
          lv_parent_container_found = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF lv_parent_container_found = abap_false.
        READ TABLE <ls_control_list>-t_container
          INTO lr_container  INDEX 1.

*   nur freie Container behalten und aktuellen rausnehmen
        DELETE <ls_control_list>-t_container INDEX 1.
      ENDIF.

*   es gibt keine?
      CHECK sy-subrc = 0.

*   im Designmode Wrapper mit Toolbar hinzufügen
      CASE mode.
        WHEN k_mode_design
          OR k_mode_pattern.

          CALL METHOD create_wrapper
            EXPORTING
              ir_container      = lr_container
              ir_parent_builder = <ls_control_list>-r_control_builder
            IMPORTING
              er_wrapper        = lr_wrapper.

          lr_container = lr_wrapper->get_container_first( ).

      ENDCASE.


*   Kind erzeugen
      lv_classname = <ls_object>-object.
      CALL METHOD zcl_guidrasil_control_base=>get_instance
        EXPORTING
          iv_classname        = lv_classname
          iv_guid             = <ls_object>-object_guid
          ir_parent_container = lr_container
          iv_parent_container = <ls_object>-parent_container
          iv_name             = <ls_object>-control_name
          iv_control_id       = <ls_object>-control_index
*         iv_dont_create      = lv_dont_create
        IMPORTING
          er_control          = lr_control_builder
        EXCEPTIONS
          OTHERS              = 1.

      CLEAR ls_control_list.
      ls_control_list-guid = lr_control_builder->gv_guid.
      ls_control_list-r_control_builder = lr_control_builder.
      ls_control_list-t_container = lr_control_builder->get_container_list( ).
      INSERT ls_control_list INTO TABLE gt_control_list.

      CASE mode.
        WHEN k_mode_design.
          lr_wrapper->add_child( lr_control_builder ).
          build_edit_toolbar(
              ir_wrapper         = lr_wrapper
              ir_control_builder = lr_control_builder ).
        WHEN k_mode_pattern.
          lr_wrapper->add_child( lr_control_builder ).
          build_pattern_toolbar(
              ir_wrapper         = lr_wrapper
              ir_control_builder = lr_control_builder ).

      ENDCASE.

      add_control( ir_control = lr_control_builder
                   ir_parent  = <ls_control_list>-r_control_builder ).
    ENDLOOP.


* Falls noch Container übrig sind -> Wrapper mit Control-Hinzufügefunktionen
    IF mode = k_mode_design.

      LOOP AT gt_control_list ASSIGNING <ls_control_list>.

        LOOP AT <ls_control_list>-t_container INTO lr_container.

          create_wrapper(
              iv_control_toolbar = abap_true
              ir_container       = lr_container
              ir_parent_builder  = <ls_control_list>-r_control_builder ).

        ENDLOOP.

      ENDLOOP.

    ENDIF.


  ENDMETHOD.


  METHOD build_control_toolbar.

    DATA lt_funcmenus TYPE ttb_btnmnu.                      "ew
    DATA lt_functions TYPE ttb_button.
    DATA ls_function  TYPE stb_button.


* Buttons löschen
    CALL METHOD ir_wrapper->clear_toolbar.

* Schließen Funktion
    IF is_close_function_enabled( ir_wrapper ) = abap_true.
      APPEND LINES OF gt_close_function TO lt_functions.
    ENDIF.

*== MENÜ Eintrag für Auswahl "CONTAINER"
    CLEAR ls_function.
    ls_function-function  = '$CONTAINER'.
    ls_function-text      = ''.
    ls_function-icon      = zcl_guidrasil_constants=>icon_container. "icon_wd_view_container.
    ls_function-butn_type = cntb_btype_dropdown.
    APPEND ls_function TO lt_functions.

*== MENÜ Eintrag für Auswahl "Control"
    CLEAR ls_function.
    ls_function-function  = '$CONTROLS'.
    ls_function-text      = ''.
    ls_function-icon      = icon_oo_object.
    ls_function-butn_type = zcl_guidrasil_constants=>icon_control. "cntb_btype_dropdown.
    APPEND ls_function TO lt_functions.

*== MENÜ Eintrag für Auswahl "Control"
    CLEAR ls_function.
    ls_function-function  = '$CUSTOM'.
    ls_function-text      = ''.
    ls_function-icon      = icon_interface.
    ls_function-butn_type = zcl_guidrasil_constants=>icon_control. "cntb_btype_dropdown.
    APPEND ls_function TO lt_functions.


* Hinzufügbare Controls
    APPEND LINES OF gt_insert_function TO lt_functions.

    CALL METHOD ir_wrapper->add_functions
      EXPORTING
        it_function = lt_functions
        it_funcmenu = lt_funcmenus
        ir_sender   = ir_wrapper
        ir_receiver = me.

  ENDMETHOD.


  METHOD build_design_toolbar.

    DATA lt_events TYPE cntl_simple_events.
    DATA ls_event  TYPE cntl_simple_event.


* Design-Toolbar einmalig aufbauen
    CHECK mode = k_mode_design.
    CHECK r_toolbar_container IS NOT BOUND.


* Dialogbox-Container
    CREATE OBJECT r_toolbar_container
      EXPORTING
        width   = 30
        height  = 30
        top     = 0
        left    = 0
        caption = 'Design-Toolbar'.

* Toolbar
    CREATE OBJECT r_toolbar
      EXPORTING
        parent = r_toolbar_container.

*  ls_event-eventid = cl_gui_toolbar=>m_id_dropdown_clicked. "ew
*  APPEND ls_event TO lt_event.

    ls_event-eventid = cl_gui_toolbar=>m_id_function_selected.
    APPEND ls_event TO lt_events.

    r_toolbar->set_registered_events( events = lt_events ).

    SET HANDLER on_design_function_selected FOR r_toolbar.


* Funktionen für neue Docking-Container
    CALL METHOD r_toolbar->add_button
      EXPORTING
        fcode            = '$BOTTOM'
        icon             = icon_previous_value
        butn_type        = cntb_btype_button
        quickinfo        = 'Dockingcontainer unten'
      EXCEPTIONS
        cntb_error_fcode = 1.


    CALL METHOD r_toolbar->add_button
      EXPORTING
        fcode            = '$LEFT'
        icon             = icon_column_left
        butn_type        = cntb_btype_button
        quickinfo        = 'Dockingcontainer links'
      EXCEPTIONS
        cntb_error_fcode = 1.


    CALL METHOD r_toolbar->add_button
      EXPORTING
        fcode            = '$RIGHT'
        icon             = icon_column_right
        butn_type        = cntb_btype_button
        quickinfo        = 'Dockingcontainer rechts'
      EXCEPTIONS
        cntb_error_fcode = 1.


    CALL METHOD r_toolbar->add_button
      EXPORTING
        fcode            = '$TOP'
        icon             = icon_next_value
        butn_type        = cntb_btype_button
        quickinfo        = 'Dockingcontainer oben'
      EXCEPTIONS
        cntb_error_fcode = 1.


  ENDMETHOD.


  METHOD build_edit_toolbar.

    DATA:
      lt_funcmenu   TYPE ttb_btnmnu, "ew
      lt_function   TYPE ttb_button,
      lrt_container TYPE cwb_container.


* Buttons löschen
    CALL METHOD ir_wrapper->clear_toolbar.

* Funktionen zum Container/Control löschen
    IF is_close_function_enabled( ir_wrapper ) = abap_true.
      APPEND LINES OF gt_close_function TO lt_function.
    ENDIF.
    APPEND LINES OF gt_delete_function TO lt_function.

*** add "Name of Control" Button
    CALL METHOD get_name_button
      EXPORTING
        ir_control   = ir_control_builder
      CHANGING
        ct_functions = lt_function.


    CALL METHOD ir_wrapper->add_functions
      EXPORTING
        it_function = lt_function
        it_funcmenu = lt_funcmenu "ew
        ir_sender   = ir_wrapper
        ir_receiver = me.


* Prüfen, ob das Control weitere Container bereitstellt
    lrt_container = ir_control_builder->get_container_list( ).

    CHECK lrt_container IS INITIAL.

    ir_control_builder->init( ).

* wennn nicht, evtl. Einstellungsfunktionen hinzufügen
    ir_control_builder->get_design_functions(
      IMPORTING
        et_functions = lt_function
        et_funcmenus = lt_funcmenu ).

    ir_wrapper->add_functions(
        it_function = lt_function
        it_funcmenu = lt_funcmenu
        ir_sender   = ir_wrapper
        ir_receiver = ir_control_builder ).


  ENDMETHOD.


  METHOD build_pattern_toolbar.


    DATA lt_funcmenu   TYPE ttb_btnmnu.
    DATA lt_function   TYPE ttb_button.
    DATA lrt_container TYPE cwb_container.


* Buttons löschen
    ir_wrapper->clear_toolbar( ).

    IF ir_control_builder->has_pattern( ) > 0.
      APPEND LINES OF gt_pattern_function TO lt_function.
    ENDIF.

*** add "Name of Control" Button
    get_name_button(
      EXPORTING ir_control   = ir_control_builder
      CHANGING  ct_functions = lt_function ).


    ir_wrapper->add_functions(
        it_function = lt_function
        it_funcmenu = lt_funcmenu
        ir_sender   = ir_wrapper
        ir_receiver = me ).


* Prüfen, ob das Control weitere Container bereitstellt
    lrt_container = ir_control_builder->get_container_list( ).

    CHECK lrt_container IS INITIAL.

* wennn nicht, evtl. Einstellungsfunktionen hinzufügen
*  lt_function = ir_control_builder->get_design_functions( ).

    ir_wrapper->add_functions(
        it_function = lt_function
        it_funcmenu = lt_funcmenu
        ir_sender   = ir_wrapper
        ir_receiver = ir_control_builder ).


  ENDMETHOD.


  METHOD class_constructor.

    DATA:
      ls_ctls            TYPE zguidrasil_ctls,
      ls_control_classes TYPE gys_control_classes,
      ls_function        TYPE stb_button.


* Funktion zum Schließen von Containern
    CLEAR ls_function.
    ls_function-function  = '$CLOSE'.
    ls_function-icon      = icon_close.
    ls_function-butn_type = cntb_btype_button.
    ls_function-quickinfo = 'Destroy Container'.
    APPEND ls_function TO gt_close_function.

    CLEAR ls_function.
    ls_function-function  = '$SEP0'.
    ls_function-butn_type = cntb_btype_sep.
    APPEND ls_function TO gt_close_function.


* Funktion zum Entfernen von Controls
    CLEAR ls_function.
    ls_function-function  = '$DELETE'.
    ls_function-icon      = icon_delete.
    ls_function-butn_type = cntb_btype_button.
    ls_function-quickinfo = 'Delete Current Control'.
    APPEND ls_function TO gt_delete_function.

    CLEAR ls_function.
    ls_function-function  = '$SEP1'.
    ls_function-butn_type = cntb_btype_sep.
    APPEND ls_function TO gt_delete_function.

* Funktion für die Auswahl eines Controls für Pattern
    CLEAR ls_function.
    ls_function-function  = '$SELECT'.
    ls_function-icon      = icon_system_okay.
    ls_function-butn_type = cntb_btype_button.
    APPEND ls_function TO gt_pattern_function.




    CLEAR ls_function.

    SELECT *
      FROM zguidrasil_ctls
      INTO TABLE mt_ctls
      WHERE usable = abap_true.

    LOOP AT mt_ctls INTO ls_ctls.
      ls_control_classes-classname = ls_ctls-classname.
*   verwendbare Klassen merken
      ADD 1 TO ls_control_classes-id.
      INSERT ls_control_classes INTO TABLE gt_control_classes.

*   Funktionsliste aufbauen
      SELECT SINGLE id FROM icon INTO ls_function-icon WHERE name = ls_ctls-iconname.
      ls_function-function  = ls_control_classes-id.
      SHIFT ls_function-function LEFT DELETING LEADING space.
      ls_function-quickinfo = ls_ctls-quickinfo.
      ls_function-butn_type = cntb_btype_menu.
      APPEND ls_function TO gt_insert_function.
    ENDLOOP.




  ENDMETHOD.


  METHOD code_replace.

    LOOP AT code ASSIGNING FIELD-SYMBOL(<line>).
      REPLACE ALL OCCURRENCES OF search IN <line> WITH |{ prefix }_{ replace }|.
    ENDLOOP.

  ENDMETHOD.


  METHOD constructor.

    mode  = iv_mode.
    pname = iv_pname.

* gespeicherten Zustand laden
    SELECT * FROM zguidrasil_obj
      INTO TABLE mt_controls
      WHERE report = iv_pname.

    DATA ls_control LIKE LINE OF mt_controls.


    FIELD-SYMBOLS <idx> LIKE LINE OF mt_idx.
    DATA ls_idx         LIKE LINE OF mt_idx.
    DATA name           TYPE zguidrasil_container_name.
    DATA id             LIKE ls_idx-control_id.

    LOOP AT mt_controls INTO ls_control.
      SPLIT ls_control-control_name AT '_' INTO name id.


      READ TABLE mt_idx WITH TABLE KEY name = name ASSIGNING <idx>.
      IF sy-subrc = 0.
        IF id > <idx>-control_id.
          <idx>-control_id = id .
        ENDIF.
      ELSE.
        ls_idx-name       = name.
        ls_idx-control_id = id.
        INSERT ls_idx INTO TABLE mt_idx.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD create_wrapper.

    DATA lrt_container TYPE cwb_container.
    DATA lr_container  TYPE REF TO cl_gui_container.


    CHECK mode = k_mode_design
       OR mode = k_mode_pattern.


* wenn angegeben, nur den übergebenen Container verwenden
    IF ir_container IS BOUND.
      CLEAR lrt_container.
      APPEND ir_container TO lrt_container.
    ELSE.
* Container ermitteln
      lrt_container = ir_parent_builder->get_container_list( ).
    ENDIF.

* Wrapper für jeden Container hinzufügen
    LOOP AT lrt_container INTO lr_container.

      DATA(lv_container_name) = lr_container->get_name( ).
      lr_container->set_name( |{ lr_container->get_name( ) }| ).

*   Wrappercontrol aufbauen
      CREATE OBJECT er_wrapper
        EXPORTING
          ir_parent_container = lr_container
          ir_parent_control   = ir_parent_builder.

*   Übergeordnetes Control und Wrapper verlinken
      CALL METHOD ir_parent_builder->add_child( er_wrapper ).

*   Toolbar mit hinzufügbaren Controls
      IF iv_control_toolbar = abap_true.

        CALL METHOD build_control_toolbar
          EXPORTING
            ir_wrapper = er_wrapper.

*   Toolbar mit Einstellungen zum Control
      ELSEIF iv_edit_toolbar = abap_true.

        CALL METHOD build_edit_toolbar
          EXPORTING
            ir_wrapper         = er_wrapper
            ir_control_builder = ir_parent_builder.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_creation_code.

    DATA lt_data TYPE string_table.
    DATA lt_code TYPE string_table.

    DATA xt_data TYPE string_table.
    DATA xt_code TYPE string_table.

    LOOP AT mt_controls ASSIGNING FIELD-SYMBOL(<control>).
      READ TABLE gt_control_list INTO DATA(ls_object) WITH TABLE KEY guid = <control>-object_guid.
      IF sy-subrc = 0.
        READ TABLE gt_control_list INTO DATA(ls_parent) WITH TABLE KEY guid = <control>-parent_guid.
        IF sy-subrc > 0.
          CLEAR ls_parent.
        ENDIF.
        IF ls_object-r_control_builder->return_creation_code( IMPORTING data = lt_data code = lt_code ) = abap_false.
          code_replace( EXPORTING search  = '$control'
                                  prefix  = 'lr'
                                  replace = ls_object-r_control_builder->gv_control_name
                        CHANGING code = lt_data ).
          code_replace( EXPORTING search  = '$control'
                                  prefix  = 'lr'
                                  replace = ls_object-r_control_builder->gv_control_name
                        CHANGING code = lt_code ).
          IF ls_parent IS NOT INITIAL.
            code_replace( EXPORTING search  = '$parent'
                                    prefix  = 'lr'
                                    replace = ls_parent-r_control_builder->gv_control_name
                          CHANGING code = lt_code ).
          ENDIF.
          APPEND LINES OF lt_data TO xt_data.
          APPEND LINES OF lt_code TO xt_code.
        ENDIF.
      ENDIF.
    ENDLOOP.

    APPEND LINES OF xt_data TO code.
    APPEND LINES OF xt_code TO code.


  ENDMETHOD.


  METHOD get_event_pattern.

    DATA ls_control  LIKE LINE OF gt_control_list.
    DATA ls_object   LIKE LINE OF mt_controls.
    DATA lr_object   TYPE REF TO cl_gui_object.

    DATA line        TYPE string.
    DATA event       TYPE string.

    DATA lr_obj                  TYPE REF TO cl_abap_classdescr.
    DATA lv_name     TYPE string.

    TYPES: BEGIN OF ty_event_ctrl,
             event   TYPE string,
             control TYPE string,
             name    TYPE string,
           END OF ty_event_ctrl,
           BEGIN OF ty_event,
             event   TYPE string,
             control TYPE string,
           END OF ty_event.

    DATA lt_events   TYPE STANDARD TABLE OF ty_event.
    DATA ls_event    TYPE ty_event.
    DATA lt_events_c TYPE STANDARD TABLE OF ty_event_ctrl.
    DATA ls_event_c  TYPE ty_event_ctrl.
    DATA ls_event2   TYPE ty_event.

*clear t_controls.
* update_controls( ).


    _code 'CLASS lcl_main DEFINITION.'.
    _code '  PUBLIC SECTION.'.
    _code '    DATA mr_guidrasil   TYPE REF TO zcl_guidrasil_builder.'.

    LOOP AT mt_controls INTO ls_object.
      READ TABLE gt_control_list INTO ls_control WITH KEY guid = ls_object-object_guid.
      IF sy-subrc = 0 .
*== DATA DEFINITION
        lr_object ?= ls_control-r_control_builder->get_control( ).
        IF lr_object IS BOUND.
          lr_obj ?= cl_abap_typedescr=>describe_by_object_ref( lr_object ).
          lv_name = lr_obj->get_relative_name( ).
          line = |    DATA mr_{ ls_object-control_name } TYPE REF TO { lv_name }.|.
        ENDIF.
        APPEND line TO pattern.
*== EVENT HANDLER
        IF ls_control-r_control_builder->gt_events IS NOT INITIAL.
          LOOP AT ls_control-r_control_builder->gt_events INTO ls_event-event.
            ls_event-control = lv_name.
            READ TABLE lt_events TRANSPORTING NO FIELDS
                  WITH KEY event = ls_event-event
                           control = ls_event-control.
            IF sy-subrc > 0.
              APPEND ls_event TO lt_events.
            ENDIF.
            ls_event_c-event   = ls_event-event.
            ls_event_c-control = lv_name.
            ls_event_c-name    = ls_object-control_name.
            APPEND ls_event_c TO lt_events_c.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDLOOP.

    _code '    METHODS constructor.'.

    LOOP AT lt_events_c INTO ls_event_c.
      line = |    METHODS h_{ ls_event_c-event } FOR EVENT { ls_event_c-event } OF { ls_event_c-control } IMPORTING sender.|.
      APPEND line TO pattern.
    ENDLOOP.


    _code 'ENDCLASS.'.

    _code 'CLASS lcl_main IMPLEMENTATION.'.
    _code '  METHOD constructor.'.
    _code '    CREATE OBJECT mr_guidrasil'.
    _code '      EXPORTING'.
    line = `        iv_pname = '$$PROJECT$$'.`.
    REPLACE '$$PROJECT$$' WITH pname INTO line.
    APPEND line TO pattern.
    _code '    mr_guidrasil->build( ).'.

    _code '  ENDMETHOD.'.

    LOOP AT lt_events INTO ls_event.
      line = |  METHOD h_{ ls_event-event }.|. APPEND line TO pattern.
      _code '    CASE sender.'.
      LOOP AT lt_events_c INTO ls_event_c
           WHERE event   = ls_event-event
             AND control = ls_event-control.
        line = |      WHEN mr_{ ls_event_c-name }.|.
        APPEND line TO pattern.
        line = |        MESSAGE i000(oo) WITH '{ ls_event_c-event }' '{ ls_event_c-name }'.|.
        APPEND line TO pattern.

      ENDLOOP.
      _code '    ENDCASE.'.
      _code '  ENDMETHOD.'.
    ENDLOOP.

    _code 'ENDCLASS.'.

    _code 'DATA gr_main TYPE REF TO lcl_main.'.


*CLASS lcl_main DEFINITION.
*  PUBLIC SECTION.
*    DATA mr_guidrasil   TYPE REF TO zcl_guidrasil_builder.
*    DATA mr_text1 TYPE REF TO cl_gui_textedit.
*    DATA mr_pic   TYPE REF TO cl_gui_picture.
*    METHODS constructor.
*    METHODS handle_pic_click
*                  FOR EVENT picture_click OF cl_gui_picture
*      IMPORTING sender.
*
*ENDCLASS.
*
*CLASS lcl_main IMPLEMENTATION.
*  METHOD constructor.
*    CREATE OBJECT mr_guidrasil
*      EXPORTING
*        iv_pname = 'GF'
*      EXCEPTIONS
*        OTHERS   = 3.
*    IF sy-subrc = 0.
*      mr_guidrasil->build( ).
*
*      mr_text1 ?= mr_guidrasil->get_object_by_name( 'INFOTEXT' ).
*      mr_pic   ?= mr_guidrasil->get_object_by_name( 'MEINHAUS' ).
*      IF mr_pic IS BOUND.
*        SET HANDLER handle_pic_click FOR mr_pic.
*      ENDIF.
*
*    ENDIF.
*  ENDMETHOD.
*  METHOD handle_pic_click.
*    MESSAGE i000(oo) WITH 'BildKlick!!'.
*  ENDMETHOD.
*
*ENDCLASS.
*
*DATA gr_guidrasil TYPE REF TO lcl_main.

  ENDMETHOD.


  METHOD get_event_pattern_plus.

    pattern = zcl_guidrasil_code_creation=>create_code_complete(
                  it_controls     = mt_controls
                  it_control_list = gt_control_list ).

  ENDMETHOD.


  METHOD get_menu_functions.

    DATA ls_function      TYPE stb_button.
    DATA ls_ctls      TYPE zguidrasil_ctls.
    DATA ls_control_class LIKE LINE OF gt_control_classes.

    CASE fcode.
      WHEN '$CONTAINER'.
        LOOP AT mt_ctls INTO ls_ctls WHERE type = 'C'.
*   Funktionsliste aufbauen für CONTAINER aufbauen
          READ TABLE gt_control_classes INTO ls_control_class WITH KEY classname = ls_ctls-classname.
          IF sy-subrc = 0.
            ls_function-function  = ls_control_class-id.
          ENDIF.
          ls_function-quickinfo = ls_ctls-quickinfo.
          APPEND ls_function TO it_functions.
        ENDLOOP.
      WHEN '$CONTROLS'.
        LOOP AT mt_ctls INTO ls_ctls WHERE type = 'O'.
*   Funktionsliste aufbauen für CONTROLS aufbauen
          READ TABLE gt_control_classes INTO ls_control_class WITH KEY classname = ls_ctls-classname.
          IF sy-subrc = 0.
            ls_function-function  = ls_control_class-id.
          ENDIF.
          ls_function-quickinfo = ls_ctls-quickinfo.
          APPEND ls_function TO it_functions.
        ENDLOOP.
      WHEN '$CUSTOM'.
        LOOP AT mt_ctls INTO ls_ctls WHERE type = 'Q'.
*   Funktionsliste aufbauen für CONTROLS aufbauen
          READ TABLE gt_control_classes INTO ls_control_class WITH KEY classname = ls_ctls-classname.
          IF sy-subrc = 0.
            ls_function-function  = ls_control_class-id.
          ENDIF.
          ls_function-quickinfo = ls_ctls-quickinfo.
          APPEND ls_function TO it_functions.
        ENDLOOP.
    ENDCASE.

  ENDMETHOD.


  METHOD get_name_button.

    DATA ls_function         TYPE stb_button.

    CHECK ir_control IS BOUND.

* Funktionen zur Controlsteuerung
    CLEAR ls_function.
    ls_function-function  = '$NAME'.
    ls_function-icon      = icon_interface.
    ls_function-butn_type = cntb_btype_button.
    ls_function-text      = ir_control->gv_control_name.
    APPEND ls_function TO ct_functions.

* Funktion für die Änderung des Namens
    CLEAR ls_function.
    ls_function-function  = '$ATTRIBUTES'.
    ls_function-icon      = icon_system_favorites.
    ls_function-butn_type = cntb_btype_button.
    ls_function-quickinfo = 'Change Control Attributes'.
    APPEND ls_function TO ct_functions.

  ENDMETHOD.


  METHOD get_object_by_name.

    DATA ls_control_list TYPE zguidrasil_control_list.

    READ TABLE mt_controls ASSIGNING FIELD-SYMBOL(<control>) WITH KEY control_name = name.
    IF sy-subrc = 0.
      READ TABLE gt_control_list INTO ls_control_list WITH KEY guid = <control>-object_guid.
      IF sy-subrc = 0.
        TRY .
            object ?= ls_control_list-r_control_builder->get_control( ).
          CATCH cx_sy_move_cast_error.
        ENDTRY.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD init_control_name.

    DATA lv_name        TYPE zguidrasil_container_name.
    FIELD-SYMBOLS <idx> LIKE LINE OF mt_idx.
    DATA ls_idx         LIKE LINE OF mt_idx.

    IF iv_text IS INITIAL.
      lv_name = 'CONTROL'.
    ELSE.
      lv_name = iv_text.
    ENDIF.

    READ TABLE mt_idx WITH TABLE KEY name = lv_name ASSIGNING <idx>.
    IF sy-subrc = 0.
      ADD 1 TO <idx>-control_id.
      CONCATENATE iv_text '_' <idx>-control_id INTO ev_name.
    ELSE.
      ls_idx-name = lv_name.
      ls_idx-control_id = 1.
      INSERT ls_idx INTO TABLE mt_idx.
      CONCATENATE iv_text '_' ls_idx-control_id INTO ev_name.
    ENDIF.

  ENDMETHOD.


  METHOD is_close_function_enabled.

    DATA lr_parent_builder TYPE REF TO zcl_guidrasil_control_base.
    DATA lrt_container     TYPE cwb_container.

    rv_enabled = abap_true.

* Vater fragen, ob er mehrere Container bereitstellt
    lr_parent_builder = ir_wrapper->get_parent( ).
    lrt_container = lr_parent_builder->get_container_list( ).

* wenn ja, dann können diese nicht einzeln geschlossen werden
    IF lines( lrt_container ) > 1.
      rv_enabled = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD on_design_function_selected.

    CASE fcode.
      WHEN '$BOTTOM'.
*      add_container( cl_gui_docking_container=>dock_at_bottom ).
      WHEN '$LEFT'.
*      add_container( cl_gui_docking_container=>dock_at_left ).
      WHEN '$RIGHT'.
*      add_container( cl_gui_docking_container=>dock_at_right ).
      WHEN '$TOP'.
*      add_container( cl_gui_docking_container=>dock_at_top ).
      WHEN OTHERS.
        EXIT.
    ENDCASE.


  ENDMETHOD.


  METHOD save.

    DATA lv_id              TYPE i.
    DATA lv_name            TYPE string.
    DATA ls_object          TYPE zguidrasil_obj.
    DATA lt_objects         TYPE TABLE OF zguidrasil_obj.
    DATA ls_control_admin   TYPE gys_control_admin.
    DATA ls_control_list    TYPE zguidrasil_ctl_hierarchy_s.
    DATA lt_control_list    TYPE zguidrasil_ctl_hierarchy_t.
    DATA lr_control_builder TYPE REF TO zcl_guidrasil_control_base.
    DATA lr_obj             TYPE REF TO cl_abap_classdescr.
    DATA lr_docking         TYPE REF TO cl_gui_docking_container.
    DATA lr_splitter        TYPE REF TO cl_gui_easy_splitter_container.


* anfangen bei den Basiscontrols
    LOOP AT t_control_admin INTO ls_control_admin.

      ls_control_list-control = ls_control_admin-control.
      APPEND ls_control_list TO lt_control_list.

*   Liste untergeordneter Controls ermitteln
      CALL METHOD ls_control_admin-control->get_control_list
        EXPORTING
          ir_parent_control = ls_control_list-control
        CHANGING
          ct_control_list   = lt_control_list.

*   Einstellungen der Controls speichern
      CALL METHOD ls_control_admin-control->save_all.

    ENDLOOP.

    ls_object-report = pname.

    LOOP AT lt_control_list INTO ls_control_list.


      CHECK ls_control_list-parent IS BOUND.

*   Control
      IF ls_control_list-control IS BOUND.

        lr_obj ?= cl_abap_typedescr=>describe_by_object_ref( ls_control_list-control ).
        lv_name = lr_obj->get_relative_name( ).

*     alles außer Wrapper speichern
        IF lv_name <> 'ZCL_GUIDRASIL_DESIGN_CONTAINER'.
          ls_object-object           = lv_name.
          ls_object-object_guid      = ls_control_list-control->gv_guid.
          ls_object-control_name     = ls_control_list-control->gv_control_name.
          ls_object-parent_container = ls_control_list-control->mv_parent_container_name.
        ENDIF.

      ENDIF.


*   ggf. Parent speichern
      IF ls_control_list-parent IS BOUND.

        lr_obj ?= cl_abap_typedescr=>describe_by_object_ref( ls_control_list-parent ).
        lv_name = lr_obj->get_relative_name( ).

*     alles außer Wrapper speichern
        IF lv_name <> 'ZCL_GUIDRASIL_DESIGN_CONTAINER'.
          ls_object-parent = lv_name.
          ls_object-parent_guid = ls_control_list-parent->gv_guid.
        ENDIF.

      ENDIF.


*   wenn sowohl Parent als auch Child gesetzt sind
      IF ls_object-parent IS NOT INITIAL AND
         ls_object-object IS NOT INITIAL.

        ADD 1 TO lv_id.
        ls_object-control_index = lv_id.
        APPEND ls_object TO lt_objects.

        CLEAR ls_object.
        ls_object-report = pname.

      ENDIF.

    ENDLOOP.
**  update_controls( ).
*
** anfangen bei den Basiscontrols
*  LOOP AT t_control_admin INTO ls_control_admin.
**   Einstellungen der Controls speichern
*    CALL METHOD ls_control_admin-control->save_all.
*  ENDLOOP.
*
*
*
* bisheriges Projekt löschen
    DELETE FROM zguidrasil_obj WHERE report = pname.

* und neuen Stand speichern
    IF lt_objects IS NOT INITIAL.
      INSERT zguidrasil_obj FROM TABLE lt_objects.
    ENDIF.
    COMMIT WORK.

    mt_controls = lt_objects.

    MESSAGE s001.

  ENDMETHOD.


  METHOD set_current_control_id.
    ADD 1 TO current_control_id.
    IF control_id IS REQUESTED.
      control_id = current_control_id.
    ENDIF.
  ENDMETHOD.


  METHOD update_controls.

*  DATA:
*    lv_id              TYPE i,
*    lv_name            TYPE string,
*    ls_guidrasil          TYPE /inw/guidrasil,
**    lt_guidrasil               TYPE TABLE OF /INW/guidrasil,
*    ls_control_admin   TYPE gys_control_admin,
*    ls_control_list    TYPE /inw/guidrasil_ctl_hierarchy,
*    lt_control_list    TYPE /inw/guidrasil_ctl_hierarchy_t,
*    lr_control_builder TYPE REF TO /inw/guidrasil_control_base,
*    lr_obj             TYPE REF TO cl_abap_classdescr,
*    lr_docking         TYPE REF TO cl_gui_docking_container,
*    lr_splitter        TYPE REF TO cl_gui_easy_splitter_container.
*
**== Geht noch nicht, wenn neue Controls hinzukommen.
**== es muss erst gespeichert werden... :/
*
    zcl_guidrasil_tools=>todo( ).
*
** anfangen bei den Basiscontrols
*  LOOP AT t_control_admin INTO ls_control_admin.
*
*    ls_control_list-control = ls_control_admin-control.
*    APPEND ls_control_list TO lt_control_list.
*
**   Liste untergeordneter Controls ermitteln
*    CALL METHOD ls_control_admin-control->get_control_list
*      EXPORTING
*        ir_parent_control = ls_control_list-control
*      CHANGING
*        ct_control_list   = lt_control_list.
*
**   Einstellungen der Controls speichern
**    CALL METHOD ls_control_admin-control->save_all.
*
*  ENDLOOP.
*
**      CLEAR ls_control_list.
**      ls_control_list-guid = ls_control-r_control_builder->gv_guid.
**      ls_control_list-r_control_builder = lr_control_builder.
**      lr_container ?= lr_control_builder->gr_control.
**      APPEND lr_container TO ls_control_list-t_container.
**      INSERT ls_control_list INTO TABLE gt_control_list
**        ASSIGNING <ls_control_list>.
*
*  ls_guidrasil-report = pname.
*
*  LOOP AT lt_control_list INTO ls_control_list.
*
*
*    CHECK ls_control_list-parent IS BOUND.
*
**   Control
*    IF ls_control_list-control IS BOUND.
*
*      lr_obj ?= cl_abap_typedescr=>describe_by_object_ref( ls_control_list-control ).
*      lv_name = lr_obj->get_relative_name( ).
*
**     alles außer Wrapper speichern
*      IF lv_name <> 'ZCL_GUIDRASIL_DESIGN_CONTAINER'.
*        ls_guidrasil-object       = lv_name.
*        ls_guidrasil-object_guid  = ls_control_list-control->gv_guid.
*        ls_guidrasil-control_name = ls_control_list-control->gv_control_name.
*      ENDIF.
*
*    ENDIF.
*
*
**   ggf. Parent speichern
*    IF ls_control_list-parent IS BOUND.
*
*      lr_obj ?= cl_abap_typedescr=>describe_by_object_ref( ls_control_list-parent ).
*      lv_name = lr_obj->get_relative_name( ).
*
**     alles außer Wrapper speichern
*      IF lv_name <> 'ZCL_GUIDRASIL_DESIGN_CONTAINER'.
*        ls_guidrasil-parent = lv_name.
*        ls_guidrasil-parent_guid = ls_control_list-parent->gv_guid.
*      ENDIF.
*
*    ENDIF.
*
*
**   wenn sowohl Parent als auch Child gesetzt sind
*    IF ls_guidrasil-parent IS NOT INITIAL AND
*       ls_guidrasil-object IS NOT INITIAL.
*
*      ADD 1 TO lv_id.
*      ls_guidrasil-control_index = lv_id.
*      APPEND ls_guidrasil TO t_controls.
*
*      CLEAR ls_guidrasil.
*      ls_guidrasil-report = pname.
*
*    ENDIF.
*
*  ENDLOOP.


  ENDMETHOD.


  METHOD zif_guidrasil_func_receiver~on_dropdown_clicked.

    "functions
    DATA lt_functions     TYPE ttb_button.
    DATA ls_function      TYPE stb_button.

    "Menu
    DATA lr_text          TYPE REF TO cl_gui_textedit.
    DATA lv_icon          TYPE icon_d.
    DATA lv_disabled      TYPE cua_active.
    DATA lv_checked       TYPE cua_active.
    DATA lv_text          TYPE gui_text.
    DATA lx_menu          TYPE REF TO cl_ctmenu.
    DATA lx_menu_sub      TYPE REF TO cl_ctmenu.
    DATA lv_flag          TYPE i.

    lt_functions = get_menu_functions( fcode ).

    IF lt_functions IS NOT INITIAL.

*== Create menu
      CREATE OBJECT lx_menu.

*== Set functions for Container and Controls
      LOOP AT lt_functions INTO ls_function.
        lv_text = ls_function-quickinfo.
        SHIFT ls_function-function LEFT DELETING LEADING space.
        CALL METHOD lx_menu->add_function
          EXPORTING
            fcode    = ls_function-function
            disabled = lv_disabled
            checked  = lv_checked
            text     = lv_text.
      ENDLOOP.

*      create object lx_menu_sub.
*        CALL METHOD lx_menu_sub->add_function
*          EXPORTING
*            fcode    = 'SUB1'
*            text     = 'Sub-Menu-Test 1'.
*
*        CALL METHOD lx_menu_sub->add_function
*          EXPORTING
*            fcode    = 'SUB2'
*            text     = 'Sub-Menu-Test 2'.
*
*      lx_menu->add_submenu( menu = lx_menu_sub
*                            text = 'Sub1' ).


*== set menu
      r_toolbar->track_context_menu(
          context_menu = lx_menu
          posx         = posx
          posy         = posy ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_guidrasil_func_receiver~on_function_selected.


    DATA lr_container                  TYPE REF TO cl_gui_container.
    DATA lr_wrapper                    TYPE REF TO zcl_guidrasil_design_container.
    DATA lr_control_builder            TYPE REF TO zcl_guidrasil_control_base.
    DATA lr_parent                     TYPE REF TO zcl_guidrasil_control_base.
    DATA lrt_container                 TYPE cwb_container.
    DATA ls_function                   TYPE stb_button.
    DATA lt_function                   TYPE ttb_button.
    DATA lt_controls                   TYPE zguidrasil_control_t.
    DATA ls_control_admin              TYPE gys_control_admin.
    DATA lv_string                     TYPE string.
    DATA lt_pattern                    TYPE STANDARD TABLE OF string.
    DATA lt_child_controls             TYPE zguidrasil_control_t.
    DATA lr_child_control              TYPE REF TO zcl_guidrasil_control_base.
    DATA ls_control_list               LIKE LINE OF gt_control_list.

    FIELD-SYMBOLS <string>             TYPE string.
    FIELD-SYMBOLS <control>            TYPE REF TO zcl_guidrasil_control_base.
    FIELD-SYMBOLS <ls_control_classes> TYPE gys_control_classes.


* bin ich gemeint oder ein anderes Objekt?
    CHECK r_receiver = me.


    CASE fcode.
*   Control wurde ausgewählt für Pattern
      WHEN '$SELECT'.
        lr_wrapper ?= r_sender.
        CALL METHOD lr_wrapper->get_children
          IMPORTING
            er_first_control = lr_control_builder.

        IF lr_control_builder IS BOUND.
          lt_pattern = lr_control_builder->get_pattern( ).
          IF lt_pattern IS NOT INITIAL.
            CLEAR lv_string.
            LOOP AT lt_pattern ASSIGNING <string>.
              CONCATENATE lv_string cl_abap_char_utilities=>cr_lf <string> INTO lv_string.
            ENDLOOP.
            CALL FUNCTION 'SRM_DISPLAY_TEXT'
              EXPORTING
                im_text = lv_string.
          ENDIF.
        ENDIF.

*   Control löschen
      WHEN '$DELETE'.

        lr_wrapper ?= r_sender.
        CALL METHOD lr_wrapper->get_children
          IMPORTING
            et_controls      = lt_child_controls
            er_first_control = lr_control_builder.

        LOOP AT lt_child_controls INTO lr_child_control.
          DELETE t_control_admin
           WHERE parent  = lr_child_control
              OR control = lr_child_control.
        ENDLOOP.

        IF lr_control_builder IS BOUND.
          lr_control_builder->destroy( ).
          lr_wrapper->remove_child( ).
        ENDIF.

        CALL METHOD build_control_toolbar
          EXPORTING
            ir_wrapper = lr_wrapper.


*   Basis-Container schließen
      WHEN '$CLOSE'.

        lr_wrapper ?= r_sender.
        lr_parent = lr_wrapper->get_parent( ).

        IF lr_parent IS BOUND.
          lr_parent->destroy( ).
        ENDIF.

      WHEN '$NAME'.

        DATA lv_answer TYPE c LENGTH 1.
        DATA lv_name   TYPE char30.

        lr_wrapper ?= r_sender.
        CALL METHOD lr_wrapper->get_children
          IMPORTING
            er_first_control = lr_control_builder
            et_controls      = lt_controls.
        READ TABLE lt_controls ASSIGNING <control> INDEX 1.
        IF sy-subrc = 0.
          lv_name = <control>->gv_control_name.
          TRANSLATE lv_name TO UPPER CASE.
          CALL FUNCTION 'POPUP_TO_GET_VALUE'
            EXPORTING
              fieldname           = 'CONTROL_NAME'
              tabname             = 'ZGUIDRASIL_OBJ'
              titel               = 'Name Of Control'
              valuein             = lv_name
            IMPORTING
              answer              = lv_answer
              valueout            = lv_name
            EXCEPTIONS
              fieldname_not_found = 1
              OTHERS              = 2.
          IF sy-subrc = 0 AND lv_answer IS INITIAL.
            TRANSLATE lv_name TO UPPER CASE.
            <control>->gv_control_name = lv_name.
          ENDIF.


*     Container vom Wrapper holen
          lr_wrapper  ?= r_sender.

*     Einfüge-Toolbar in Editiertoolbar ändern
          build_edit_toolbar(
              ir_wrapper         = lr_wrapper
              ir_control_builder = <control> ).
        ENDIF.

      WHEN '$ATTRIBUTES'.

        lr_wrapper ?= r_sender.
        CALL METHOD lr_wrapper->get_children
          IMPORTING
            er_first_control = lr_control_builder
            et_controls      = lt_controls.
        READ TABLE lt_controls ASSIGNING <control> INDEX 1.
        IF sy-subrc = 0.
          <control>->view_attributes( iv_edit = 'X' ).
*     Container vom Wrapper holen
          lr_wrapper  ?= r_sender.

*     Einfüge-Toolbar in Editiertoolbar ändern
          build_edit_toolbar(
              ir_wrapper         = lr_wrapper
              ir_control_builder = <control> ).
        ENDIF.

*   Control hinzufügen
      WHEN OTHERS.
        CHECK fcode(1) <> '$'.

        add_control_object( fcode      = fcode
                            r_sender   = r_sender
                            r_receiver = r_receiver
                            r_toolbar  = r_toolbar ).


    ENDCASE.

  ENDMETHOD.
ENDCLASS.
