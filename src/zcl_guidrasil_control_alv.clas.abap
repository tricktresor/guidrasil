class ZCL_GUIDRASIL_CONTROL_ALV definition
  public
  inheriting from ZCL_GUIDRASIL_CONTROL_BASE
  final
  create public .

*"* public components of class ZCL_GUIDRASIL_CONTROL_ALV
*"* do not include other source files here!!!
public section.

  methods APPLY_SETTINGS
    redefinition .
  methods CREATE
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
  methods VIEW_ATTRIBUTES
    redefinition .
  methods ZIF_GUIDRASIL_FUNC_RECEIVER~ON_DROPDOWN_CLICKED
    redefinition .
  methods ZIF_GUIDRASIL_FUNC_RECEIVER~ON_FUNCTION_SELECTED
    redefinition .
  PROTECTED SECTION.
*"* protected components of class ZCL_GUIDRASIL_CONTROL_ALV
*"* do not include other source files here!!!

    METHODS handle_double_click
          FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
          !e_row
          !e_column
          !es_row_no .
  PRIVATE SECTION.
*"* private components of class ZCL_GUIDRASIL_CONTROL_ALV
*"* do not include other source files here!!!

    DATA gt_alv_dummy TYPE STANDARD TABLE OF icon .
    DATA c_function_structure TYPE ui_func VALUE 'FUNCTN_GRID_STRUCTURE' ##NO_TEXT.
    DATA c_function_toolbar TYPE ui_func VALUE 'FUNCTN_GRID_TOOLBAR' ##NO_TEXT.
    DATA ms_settings TYPE zguidrasil_setting_grid .
    DATA mr_alv TYPE REF TO cl_gui_alv_grid .
    DATA mr_parent TYPE REF TO cl_gui_container .
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_ALV IMPLEMENTATION.


  METHOD APPLY_SETTINGS.


    FIELD-SYMBOLS <data> TYPE STANDARD TABLE.

    CREATE DATA md_data TYPE STANDARD TABLE OF (ms_settings-structure_name).
    ASSIGN md_data->* TO <data>.

    IF mr_alv IS BOUND.
      mr_alv->free( ).
      FREE mr_alv.
    ENDIF.

    TRY .
        SELECT * FROM (ms_settings-structure_name) INTO TABLE <data> UP TO 40 ROWS.
      CATCH cx_root INTO DATA(lx_root).
        MESSAGE lx_root TYPE 'S'.
    ENDTRY.

    CREATE OBJECT mr_alv
      EXPORTING
        i_parent      = mr_parent
        i_appl_events = space.

    CALL METHOD mr_alv->set_table_for_first_display
      EXPORTING
        i_structure_name = ms_settings-structure_name
      CHANGING
        it_outtab        = <data>
      EXCEPTIONS
        OTHERS           = 4.

    IF ms_settings-fcat IS NOT INITIAL OR
       ms_settings-sort IS NOT INITIAL.

      IF ms_settings-fcat IS NOT INITIAL.
        mr_alv->set_frontend_fieldcatalog( it_fieldcatalog = ms_settings-fcat ).
      ENDIF.
      IF ms_settings-sort IS NOT INITIAL.
        mr_alv->set_sort_criteria( it_sort = ms_settings-sort ).
      ENDIF.
      mr_alv->refresh_table_display( ).
    ENDIF.

    DATA lt_events TYPE cntl_simple_events.
    DATA ls_event  TYPE cntl_simple_event.
    mr_alv->get_registered_events( IMPORTING events = lt_events ).

    SET HANDLER handle_double_click FOR mr_alv.

  ENDMETHOD.


  METHOD CREATE.

    IF iv_name IS INITIAL.
      gv_control_name = zcl_guidrasil_builder=>init_control_name( iv_text = 'GRID' ).
    ELSE.
      gv_control_name = iv_name.
    ENDIF.

    mv_parent_container_name = iv_parent.

    IF ms_settings-structure_name IS INITIAL.
      ms_settings-structure_name = 'ICON'.
    ENDIF.

    er_control ?= mr_alv.
    gr_control = mr_alv.

    mr_parent  = ir_parent.

    apply_settings( ).

  ENDMETHOD.


  METHOD HANDLE_DOUBLE_CLICK.
* E_ROW Type  LVC_S_ROW
* E_COLUMN  Type  LVC_S_COL
* ES_ROW_NO Type  LVC_S_ROID

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <line>  TYPE any.

    ASSIGN md_data->* TO <table>.

    MESSAGE |{ gv_control_name }{ text-idc } row: { e_row-index } column: { e_column-fieldname }| type 'I'.


  ENDMETHOD.


  METHOD LOAD_SETTINGS.

    load( CHANGING cs_settings = ms_settings ).

  ENDMETHOD.


  METHOD PROVIDE_CONTROL_NAME.

    ev_name = 'ALVGRID'.
    ev_desc = 'ALV-Grid'(alv).
    ev_icon = icon_list.


  ENDMETHOD.


  METHOD PROVIDE_TOOLBAR.

*  DATA lv_text TYPE text40.
*  lv_text = gv_enhema_name.
*
*
*  CALL METHOD cr_toolbar->add_button
*    EXPORTING
*      fcode      = '$NAME'
*      icon       = icon_interface
*      butn_type  = cntb_btype_button
*      text       = lv_text
*      quickinfo  = 'Name of control'
*      is_checked = space
*    EXCEPTIONS
*      OTHERS     = 4.

  ENDMETHOD.


  METHOD RETURN_CREATION_CODE.

    no_code = abap_false.

    DATA lv_string TYPE string.

    lv_string = |  DATA lt_data TYPE STANDARD TABLE OF { ms_settings-structure_name }.|.
    APPEND lv_string TO data.

    lv_string = |SELECT * FROM { ms_settings-structure_name } INTO TABLE gt_data.|.
    APPEND lv_string TO code.

  ENDMETHOD.


  METHOD SAVE_SETTINGS.

    save( ms_settings ).

  ENDMETHOD.


  METHOD view_attributes.

    CALL FUNCTION 'Z_GUIDRASIL_CONTROL_ALV_POPUP'
      CHANGING
        cs_settings         = ms_settings
      EXCEPTIONS
        operation_cancelled = 1.
    CHECK sy-subrc = 0.
    apply_settings( ).

  ENDMETHOD.


  METHOD ZIF_GUIDRASIL_FUNC_RECEIVER~ON_DROPDOWN_CLICKED.

    DATA lr_grid     TYPE REF TO cl_gui_alv_grid.
    DATA lv_disabled TYPE cua_active.
    DATA lv_checked  TYPE cua_active.
    DATA lv_text     TYPE gui_text.
    DATA lx_menu     TYPE REF TO cl_ctmenu.
    DATA lv_flag     TYPE i.
    DATA ls_layout   TYPE lvc_s_layo.

    CHECK r_receiver = me.

    lr_grid ?= gr_control.

    CASE fcode.
      WHEN 'GRID_DROPDOWN'.
        CREATE OBJECT lx_menu.

        lr_grid->get_frontend_layout( IMPORTING es_layout = ls_layout ).

        " Struktur
        lv_text = 'Struktur'(str).
        CALL METHOD lx_menu->add_function
          EXPORTING
            fcode    = c_function_structure
            disabled = lv_disabled
            checked  = lv_checked
            text     = lv_text.                                "#EC NOTEXT

        " TOOLBAR
        lv_text = 'Toolbar'(tob).
        IF ls_layout-no_toolbar = space.
          lv_checked = abap_true.
        ELSE.
          lv_checked = abap_false.
        ENDIF.

        lx_menu->add_function(
            fcode    = c_function_toolbar
            disabled = lv_disabled
            checked  = lv_checked
            text     = lv_text ).                           "#EC NOTEXT

        r_toolbar->track_context_menu(
            context_menu = lx_menu
            posx         = posx
            posy         = posy ).

    ENDCASE.

  ENDMETHOD.


  METHOD ZIF_GUIDRASIL_FUNC_RECEIVER~ON_FUNCTION_SELECTED.

    DATA lr_grid   TYPE REF TO cl_gui_alv_grid.
    DATA lv_text   TYPE gui_text.
    DATA lx_menu   TYPE REF TO cl_ctmenu.
    DATA lv_flag   TYPE i.
    DATA ls_layout TYPE lvc_s_layo.

    CHECK r_receiver = me.
    lr_grid ?= gr_control.

    CASE fcode.


      WHEN c_function_structure.


      WHEN c_function_toolbar.

        lr_grid->get_frontend_layout( IMPORTING es_layout = ls_layout ).
        IF ls_layout-no_toolbar = space.
          ls_layout-no_toolbar = 'X'.
        ELSE.
          ls_layout-no_toolbar = space.
        ENDIF.
        lr_grid->set_frontend_layout( EXPORTING is_layout = ls_layout ).
        lr_grid->refresh_table_display( ).
    ENDCASE.

    cl_gui_cfw=>flush( ).

  ENDMETHOD.
ENDCLASS.
