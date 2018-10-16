class ZCL_GUIDRASIL_DESIGN_CONTAINER definition
  public
  inheriting from ZCL_GUIDRASIL_CONTROL_BASE
  final
  create public .

*"* public components of class ZCL_GUIDRASIL_DESIGN_CONTAINER
*"* do not include other source files here!!!
public section.

  methods GET_PARENT
    returning
      value(RR_CONTROL) type ref to ZCL_GUIDRASIL_CONTROL_BASE .
  methods REMOVE_CHILD .
  methods CLEAR_TOOLBAR .
  methods ADD_FUNCTIONS
    importing
      !IT_FUNCTION type TTB_BUTTON
      !IR_SENDER type ref to OBJECT
      !IR_RECEIVER type ref to ZIF_GUIDRASIL_FUNC_RECEIVER
      !IT_FUNCMENU type TTB_BTNMNU optional .
  methods CONSTRUCTOR
    importing
      !IR_PARENT_CONTAINER type ref to CL_GUI_CONTAINER
      !IR_PARENT_CONTROL type ref to ZCL_GUIDRASIL_CONTROL_BASE .

  methods GET_CONTAINER_FIRST
    redefinition .
  methods GET_CONTAINER_LIST
    redefinition .
  methods GET_CONTAINER_NAME
    redefinition .
  methods PROVIDE_CONTROL_NAME
    redefinition .
  methods PROVIDE_TOOLBAR
    redefinition .
  PROTECTED SECTION.
*"* protected components of class ZCL_GUIDRASIL_DESIGN_CONTAINER
*"* do not include other source files here!!!
  PRIVATE SECTION.
*"* private components of class ZCL_GUIDRASIL_DESIGN_CONTAINER
*"* do not include other source files here!!!

    TYPES:
      BEGIN OF gys_function,
        fcode    TYPE ui_func,
        sender   TYPE REF TO object,
        receiver TYPE REF TO object, "enno
      END OF gys_function .
    TYPES:
      gyt_function TYPE SORTED TABLE OF gys_function WITH
        UNIQUE KEY fcode .

    DATA r_parent_control TYPE REF TO zcl_guidrasil_control_base .
    DATA t_function_list TYPE gyt_function .
    DATA r_splitter TYPE REF TO cl_gui_splitter_container .
    DATA r_toolbar TYPE REF TO cl_gui_toolbar .

    METHODS on_tb_function_selected
          FOR EVENT function_selected OF cl_gui_toolbar
      IMPORTING
          !fcode
          !sender .
    METHODS on_tb_dropdown_selected
          FOR EVENT dropdown_clicked OF cl_gui_toolbar
      IMPORTING
          !fcode
          !posx
          !posy
          !sender .
ENDCLASS.



CLASS ZCL_GUIDRASIL_DESIGN_CONTAINER IMPLEMENTATION.


  METHOD add_functions.

    DATA lt_menufunctions          TYPE ui_funcattr.
    DATA ls_function_list          TYPE gys_function.


    FIELD-SYMBOLS <fcode>                   TYPE uiattentry.
    FIELD-SYMBOLS <ls_funcmenu>             TYPE stb_btnmnu.
    FIELD-SYMBOLS <ls_function>             TYPE stb_button.


    LOOP AT it_function ASSIGNING <ls_function>.

      IF <ls_function>-butn_type <> cntb_btype_sep AND
         <ls_function>-butn_type <> cntb_btype_menu.
        CALL METHOD r_toolbar->add_button
          EXPORTING
            fcode            = <ls_function>-function
            icon             = <ls_function>-icon
            is_disabled      = <ls_function>-disabled
            butn_type        = <ls_function>-butn_type
            text             = <ls_function>-text
            quickinfo        = <ls_function>-quickinfo
            is_checked       = <ls_function>-checked
          EXCEPTIONS
            cntl_error       = 1
            cntb_btype_error = 2
            cntb_error_fcode = 3
            OTHERS           = 4.
      ENDIF.

      ls_function_list-fcode    = <ls_function>-function.
      ls_function_list-sender   = ir_sender.
      ls_function_list-receiver = ir_receiver.
      INSERT ls_function_list INTO TABLE t_function_list.

    ENDLOOP.

    CHECK sy-subrc = 0.

    if 1 = 2.
    IF it_funcmenu IS NOT INITIAL.
      r_toolbar->assign_static_ctxmenu_table( table_ctxmenu = it_funcmenu ).
      LOOP AT it_funcmenu ASSIGNING <ls_funcmenu>.
        <ls_funcmenu>-ctmenu->get_functions(
          IMPORTING
            fcodes = lt_menufunctions ).
        LOOP AT lt_menufunctions ASSIGNING <fcode>.
          ls_function_list-fcode    = <fcode>.
          ls_function_list-sender   = ir_sender.
          ls_function_list-receiver = ir_receiver.
          INSERT ls_function_list INTO TABLE t_function_list.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
    ENDIF.

    SET HANDLER ir_receiver->on_function_selected FOR me.
    SET HANDLER ir_receiver->on_dropdown_clicked  FOR me.

  ENDMETHOD.


  METHOD clear_toolbar.

    r_toolbar->delete_all_buttons( ).
    REFRESH t_function_list.

  ENDMETHOD.


  METHOD constructor.

    DATA lr_toolbar_container TYPE REF TO cl_gui_container.
    DATA lt_event             TYPE cntl_simple_events.
    DATA ls_event             TYPE cntl_simple_event.


    super->constructor( ).

* Splitter erzeugen
    CREATE OBJECT r_splitter
      EXPORTING
        parent  = ir_parent_container
        rows    = 2
        columns = 1
      EXCEPTIONS
        OTHERS  = 3.

* Trenner einstellen
    r_splitter->set_row_sash(
        id    = 1
        type  = cl_gui_splitter_container=>type_sashvisible
        value = cl_gui_splitter_container=>false ).

    r_splitter->set_row_mode( mode = cl_gui_splitter_container=>mode_absolute ).

    r_splitter->set_row_height( id     = 1
                                height = zcl_guidrasil_constants=>design_container_height ).

    r_splitter->set_name( 'DESIGN_SPLITTER' ).

* unteren Container benennen
    lr_toolbar_container = r_splitter->get_container( row = 2 column = 1 ).
    lr_toolbar_container->set_name( 'DESIGN_CONTROL' ).

* Toolbar im oberen Container aufbauen
    lr_toolbar_container = r_splitter->get_container( row = 1 column = 1 ).
    lr_toolbar_container->set_name( 'DESIGN_TOOLBAR' ).

    CREATE OBJECT r_toolbar
      EXPORTING
        parent = lr_toolbar_container.


* Ereignisse registrieren
    ls_event-eventid    = cl_gui_toolbar=>m_id_function_selected.
    APPEND ls_event TO lt_event.

    ls_event-eventid    = cl_gui_toolbar=>m_id_dropdown_clicked. "ew
    APPEND ls_event TO lt_event.

    r_toolbar->set_registered_events( lt_event ).

    SET HANDLER on_tb_function_selected FOR r_toolbar.
    SET HANDLER on_tb_dropdown_selected FOR r_toolbar.

    r_parent_control = ir_parent_control.

  ENDMETHOD.


  METHOD get_container_first.

    er_first_container = r_splitter->get_container(
      row       = 2
      column    = 1 ).

  ENDMETHOD.


  METHOD get_container_list.

    APPEND r_splitter->get_container(
       row       = 2
       column    = 1 ) TO ert_container.

  ENDMETHOD.


  METHOD get_container_name.

    ev_container_name = r_splitter->get_container(
                          row       = 2
                          column    = 1 )->parent->parent->get_name( ).

  ENDMETHOD.


  METHOD get_parent.

    rr_control = r_parent_control.

  ENDMETHOD.


  METHOD on_tb_dropdown_selected.

* hier behandeln wir die toolbar-events und leiten sie
* an das objekt weiter, welche sie behandeln soll.
* da mehrere objekte auf das event function_selected registriert
* sind, liefern wir den empfänger mit, damit die jeweiligen
* objekte wissen, ob sie gemeint sind oder nicht.

    DATA ls_function_list         TYPE gys_function.


* Eintrag zur Funktion finden
    READ TABLE t_function_list
      INTO ls_function_list
      WITH TABLE KEY
        fcode  = fcode.

    CHECK sy-subrc = 0.

* Event auslösen
    RAISE EVENT zif_guidrasil_func_receiver~dropdown_clicked
      EXPORTING
        fcode      = fcode
        r_sender   = ls_function_list-sender
        r_receiver = ls_function_list-receiver
        r_toolbar  = sender "ew
        posx       = posx   "ew
        posy       = posy.  "ew

  ENDMETHOD.


  METHOD on_tb_function_selected.

* Hier behandeln wir die Toolbar-Events und leiten sie
* an das Objekt weiter, welche sie behandeln soll.
* Da mehrere Objekte auf das Event function_selected registriert
* sind, liefern wir den Empfänger mit, damit die jeweiligen
* Objekte wissen, ob sie gemeint sind oder nicht.

    DATA ls_function_list         TYPE gys_function.


* Eintrag zur Funktion finden
    READ TABLE t_function_list
      INTO ls_function_list
      WITH TABLE KEY
        fcode  = fcode.

    CHECK sy-subrc = 0.

* Event auslösen
    RAISE EVENT zif_guidrasil_func_receiver~function_selected
      EXPORTING
        fcode      = fcode
        r_sender   = ls_function_list-sender
        r_receiver = ls_function_list-receiver
        r_toolbar  = sender. "ew

  ENDMETHOD.


  METHOD provide_control_name.
  ENDMETHOD.


  METHOD provide_toolbar.
  ENDMETHOD.


  METHOD remove_child.

    REFRESH gt_children.

  ENDMETHOD.
ENDCLASS.
