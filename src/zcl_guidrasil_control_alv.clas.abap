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
  methods GET_DESIGN_FUNCTIONS
    redefinition .
protected section.

*"* protected components of class ZCL_GUIDRASIL_CONTROL_ALV
*"* do not include other source files here!!!
  methods HANDLE_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
private section.

  data:
*"* private components of class ZCL_GUIDRASIL_CONTROL_ALV
*"* do not include other source files here!!!
    gt_alv_dummy TYPE STANDARD TABLE OF icon .
  data C_FUNCTION_STRUCTURE type UI_FUNC value 'FUNCTN_GRID_STRUCTURE' ##NO_TEXT.
  data C_FUNCTION_TOOLBAR type UI_FUNC value 'FUNCTN_GRID_TOOLBAR' ##NO_TEXT.
  data MS_SETTINGS type ZGUIDRASIL_SETTING_GRID .
  data MR_ALV type ref to CL_GUI_ALV_GRID .
  data MR_PARENT type ref to CL_GUI_CONTAINER .
  data C_FUNCTION_NO_TOOLBAR type UI_FUNC value 'Layout_No_Toolbar' ##NO_TEXT.
  data C_FUNCTION_NO_HEADERS type UI_FUNC value 'Layout_No_Headers' ##NO_TEXT.
  data C_FUNCTION_SMALLTITLE type UI_FUNC value 'Layout_Small_Title' ##NO_TEXT.
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_ALV IMPLEMENTATION.


  METHOD apply_settings.

    DATA ls_layout TYPE lvc_s_layo.

    FIELD-SYMBOLS <data> TYPE STANDARD TABLE.

    CREATE DATA md_data TYPE STANDARD TABLE OF (ms_settings-structure_name).
    ASSIGN md_data->* TO <data>.

    IF mr_alv IS BOUND.
      mr_alv->free( ).
      FREE mr_alv.
    ENDIF.

    TRY .
        "Try to get some sample data
        SELECT * FROM (ms_settings-structure_name)
                 INTO TABLE <data> UP TO 40 ROWS.
      CATCH cx_root INTO DATA(lx_root).
        MESSAGE lx_root TYPE 'S'.
    ENDTRY.

    "Grid must be created anew if structure changed
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
*      mr_alv->refresh_table_display( ).
    ENDIF.

    mr_alv->get_frontend_layout( IMPORTING es_layout = ls_layout ).
    ls_layout-no_toolbar = ms_settings-no_toolbar.
    ls_layout-no_headers = ms_settings-no_headers.
    ls_layout-smalltitle = ms_settings-smalltitle.
    mr_alv->set_frontend_layout( ls_layout ).
    mr_alv->refresh_table_display( ).

*    DATA lt_events TYPE cntl_simple_events.
*    DATA ls_event  TYPE cntl_simple_event.
*    mr_alv->get_registered_events( IMPORTING events = lt_events ).
*
*    SET HANDLER handle_double_click FOR mr_alv.

  ENDMETHOD.


  METHOD create.

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

*    DATA lt_events TYPE cntl_simple_events.
*    DATA ls_event  TYPE cntl_simple_event.
*    mr_alv->get_registered_events( IMPORTING events = lt_events ).

    SET HANDLER handle_double_click FOR mr_alv.

    APPEND 'GRID_DOUBLE_CLICK' TO gt_events.

  ENDMETHOD.


  METHOD get_design_functions.

    DATA lx_menu     TYPE REF TO cl_ctmenu.                 "ew
    DATA lv_text     TYPE gui_text.                         "ew
    DATA ls_funcmenu TYPE stb_btnmnu.                       "ew
    DATA ls_function TYPE stb_button.

    CREATE OBJECT lx_menu.


    ls_function-icon       = icon_active_inactive.
    ls_function-butn_type  = cntb_id_dropmenu.


    ls_function-function  = c_function_no_toolbar.
    ls_function-text      = 'Hide toolbar'.
    ls_function-quickinfo = 'Do not show toolbar'.
    APPEND ls_function TO et_functions.


    ls_function-function  = c_function_no_headers.
    ls_function-text      = 'Hide headers'.
    ls_function-quickinfo = 'Do not show column headers'.
    APPEND ls_function TO et_functions.

    ls_function-function  = c_function_smalltitle.
    ls_function-text      = 'Small title'.
    ls_function-quickinfo = 'Use small title'.
    APPEND ls_function TO et_functions.

    ls_funcmenu-function = '$CTRLFUNC'.
    ls_funcmenu-ctmenu   = lx_menu.
    APPEND ls_funcmenu TO et_funcmenus.

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


  METHOD return_creation_code.

    no_code = abap_false.

    DATA lv_string TYPE string.

    lv_string = |  DATA lt_data TYPE STANDARD TABLE OF { ms_settings-structure_name }.|.
    APPEND lv_string TO data.

    lv_string = |SELECT * FROM { ms_settings-structure_name } INTO TABLE gt_data.|.
    APPEND lv_string TO code.



    APPEND  'CREATE OBJECT mr_$control' TO code.
    APPEND  '  EXPORTING' TO code.
    APPEND  '    i_parent      = $parent' TO code.
    APPEND  '    i_appl_events = space.' TO code.
    APPEND  'mr_$control->set_table_for_first_display('  TO code.
    APPEND  |  EXPORTING  i_structure_name = { ms_settings-structure_name }|  TO code.
    APPEND  '  CHANGING   it_outtab        = <data>' TO code.
    APPEND  '  EXCEPTIONS OTHERS           = 4. )' TO code.

*    IF ms_settings-fcat IS NOT INITIAL OR
*       ms_settings-sort IS NOT INITIAL.
*
*      IF ms_settings-fcat IS NOT INITIAL.
*        mr_alv->set_frontend_fieldcatalog( it_fieldcatalog = ms_settings-fcat ).
*      ENDIF.
*      IF ms_settings-sort IS NOT INITIAL.
*        mr_alv->set_sort_criteria( it_sort = ms_settings-sort ).
*      ENDIF.
**      mr_alv->refresh_table_display( ).
*    ENDIF.
*
*    mr_alv->get_frontend_layout( IMPORTING es_layout = ls_layout ).
*    ls_layout-no_toolbar = ms_settings-no_toolbar.
*    ls_layout-no_headers = ms_settings-no_headers.
*    ls_layout-smalltitle = ms_settings-smalltitle.
*    mr_alv->set_frontend_layout( ls_layout ).
*    mr_alv->refresh_table_display( ).

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

*    data: Begin of checked,
*            no_toolbar type rm_boolean,
*            no_headers type rm_boolean,
*            smalltitle type rm_booelean,
*          end of checked.

*    CHECK r_receiver = me.

    lr_grid ?= gr_control.

    CASE fcode.
      WHEN '$CTRLFUNC'.
        CREATE OBJECT lx_menu.

*        lr_grid->get_frontend_layout( IMPORTING es_layout = ls_layout ).

        " Struktur
        lv_text = 'Struktur'(str).
        CALL METHOD lx_menu->add_function
          EXPORTING
            fcode    = c_function_structure
            disabled = lv_disabled
            checked  = lv_checked
            text     = lv_text.                                "#EC NOTEXT


        lx_menu->add_function(
            fcode    = c_function_no_toolbar
            disabled = space
            checked  = ms_settings-no_toolbar
            text     = 'Hide toolbar' ).                           "#EC NOTEXT

        lx_menu->add_function(
            fcode    = c_function_no_headers
            disabled = space
            checked  = ms_settings-no_headers
            text     = 'Hide column headers' ).                           "#EC NOTEXT

        lx_menu->add_function(
            fcode    = c_function_smalltitle
            disabled = space
            checked  = ms_settings-smalltitle
            text     = 'Use small title' ).                           "#EC NOTEXT

        r_toolbar->track_context_menu(
            context_menu = lx_menu
            posx         = posx
            posy         = posy ).

    ENDCASE.

  ENDMETHOD.


  METHOD zif_guidrasil_func_receiver~on_function_selected.

    CHECK r_receiver = me.

    CASE fcode.


      WHEN c_function_structure.


      WHEN c_function_no_toolbar.
        ms_settings-no_toolbar = zcl_guidrasil_tools=>switch_bool( ms_settings-no_toolbar ).
        apply_settings( ).

      WHEN c_function_no_headers.
        ms_settings-no_headers = zcl_guidrasil_tools=>switch_bool( ms_settings-no_headers ).
        apply_settings( ).

      WHEN c_function_smalltitle.
        ms_settings-smalltitle = zcl_guidrasil_tools=>switch_bool( ms_settings-smalltitle ).
        apply_settings( ).
    ENDCASE.

    cl_gui_cfw=>flush( ).

  ENDMETHOD.
ENDCLASS.
