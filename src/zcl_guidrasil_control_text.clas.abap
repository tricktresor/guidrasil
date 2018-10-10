class ZCL_GUIDRASIL_CONTROL_TEXT definition
  public
  inheriting from ZCL_GUIDRASIL_CONTROL_BASE
  final
  create public .

*"* public components of class ZCL_GUIDRASIL_CONTROL_TEXT
*"* do not include other source files here!!!
public section.


  methods APPLY_SETTINGS
    redefinition .
  methods CREATE
    redefinition .
  methods FUNCTION
    redefinition .
  methods GET_DESIGN_FUNCTIONS
    redefinition .
  methods GET_PATTERN
    redefinition .
  methods HAS_PATTERN
    redefinition .
  methods INIT
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
  methods ZIF_GUIDRASIL_FUNC_RECEIVER~ON_FUNCTION_SELECTED
    redefinition .
  methods ZIF_GUIDRASIL_FUNC_RECEIVER~ON_DROPDOWN_CLICKED
    redefinition .
protected section.
*"* protected components of class ZCL_GUIDRASIL_CONTROL_TEXT
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_GUIDRASIL_CONTROL_TEXT
*"* do not include other source files here!!!

  data GS_SETTINGS type /INW/S_ENHEMA_SETTING_TEXT .
  data C_FUNCTION_READONLY type UI_FUNC value 'FUNCTN_TEXTEDIT_READONLY' ##NO_TEXT.
  data MR_TEXT type ref to CL_GUI_TEXTEDIT .
  data C_FUNCTION_TOOLBAR type UI_FUNC value 'FUNCTN_TEXTEDIT_TOOLBAR' ##NO_TEXT.
  data C_FUNCTION_STATUSBAR type UI_FUNC value 'FUNCTN_TEXTEDIT_STATUSBAR' ##NO_TEXT.
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_TEXT IMPLEMENTATION.


  METHOD APPLY_SETTINGS.

    mr_text->set_textstream( |{ gs_settings-text }| ).
    mr_text->set_readonly_mode( gs_settings-readonly ).
    mr_text->set_toolbar_mode( gs_settings-toolbar ).
    mr_text->set_statusbar_mode( gs_settings-statusbar ).
    mr_text->set_wordwrap_behavior( wordwrap_mode = gs_settings-wordwrap ).

  ENDMETHOD.


METHOD CREATE.

  IF gv_no_settings = abap_true.
    gs_settings-toolbar   = 1.
    gs_settings-statusbar = 1.
    gs_settings-readonly  = 0.
    gs_settings-text      = 'Demotext // Demotext // Demotext'.
  ENDIF.

  IF iv_name IS INITIAL.
    CALL METHOD /inw/enhema_builder=>init_control_name
      EXPORTING
        iv_text = 'TEXT'
      RECEIVING
        ev_name = gv_control_name.
  ELSE.
    gv_control_name = iv_name.
  ENDIF.

  mv_parent_container_name = iv_parent.

  CREATE OBJECT mr_text
    EXPORTING
      parent = ir_parent.

  apply_settings( ).

  er_control ?= mr_text.
  gr_control = mr_text.


ENDMETHOD.


METHOD FUNCTION.

*  DATA lx_menu TYPE REF TO cl_ctmenu.
*  DATA lv_flag TYPE i.
*
*  CASE iv_function.
*    WHEN 'SWITCH'.
*      CREATE OBJECT lx_menu.
*
*
*    WHEN 'TEXT_DROPDOWN'.
*      CREATE OBJECT lx_menu.
*      BREAK-POINT.
*
*    WHEN c_function_readonly.
*** _______________________________________________________________ ***
***                                                                 ***
***  SWITCH Read-only attribute
*** _______________________________________________________________ ***
***                                                                 ***
*      IF gr_text->m_readonly_mode = 0.
*        lv_flag = 1.
*      ELSE.
*        lv_flag = 0.
*      ENDIF.
*      CALL METHOD gr_text->set_readonly_mode
*        EXPORTING
*          readonly_mode          = lv_flag
*        EXCEPTIONS
*          error_cntl_call_method = 1
*          OTHERS                 = 2.
*
*    WHEN c_function_toolbar.
*** _______________________________________________________________ ***
***                                                                 ***
***  SWITCH toolbar attribute
*** _______________________________________________________________ ***
***                                                                 ***
*      IF gr_text->m_toolbar_mode = 0.
*        lv_flag = 1.
*      ELSE.
*        lv_flag = 0.
*      ENDIF.
*
*      CALL METHOD gr_text->set_toolbar_mode
*        EXPORTING
*          toolbar_mode = lv_flag
*        EXCEPTIONS
*          OTHERS       = 3.
*
*    WHEN c_function_statusbar.
*** _______________________________________________________________ ***
***                                                                 ***
***  SWITCH statusbar attribute
*** _______________________________________________________________ ***
***                                                                 ***
*      IF gr_text->m_statusbar_mode = 0.
*        lv_flag = 1.
*      ELSE.
*        lv_flag = 0.
*      ENDIF.
*      CALL METHOD gr_text->set_statusbar_mode
*        EXPORTING
*          statusbar_mode = lv_flag
*        EXCEPTIONS
*          OTHERS         = 3.
*
*  ENDCASE.

ENDMETHOD.


METHOD GET_DESIGN_FUNCTIONS.

  DATA:
        lx_menu     TYPE REF TO cl_ctmenu,                 "ew
        lv_text     TYPE gui_text,                         "ew
        ls_funcmenu TYPE stb_btnmnu,                       "ew
        ls_function TYPE stb_button.

*>>> dropdown
  ls_function-icon      = icon_detail.
  ls_function-butn_type = cntb_id_dropdown.                "cntb_btype_dropdown.
  ls_function-function  = 'TEXT_DROPDOWN'.
  ls_function-text      = ''.
  ls_function-quickinfo = 'Controlfunktionen'.
  APPEND ls_function TO et_functions.
*<<< dropdown

*  ls_function-icon       = icon_active_inactive.
  ls_function-butn_type  = cntb_id_dropmenu.


  ls_function-function  = c_function_readonly.
  ls_function-text      = 'Anzeige/Editieren'.
  ls_function-quickinfo = 'Anzeige-/Editiermodus'.
  APPEND ls_function TO et_functions.

  ls_function-function  = c_function_toolbar.
  ls_function-text      = 'Toolbar'.
  ls_function-quickinfo = 'Toolbar ein-/ausblenden'.
  APPEND ls_function TO et_functions.

  ls_function-function  = c_function_statusbar.
  ls_function-text      = 'Statusbar'.
  ls_function-quickinfo = 'Statusbar ein-/ausblenden'.
  APPEND ls_function TO et_functions.


ENDMETHOD.


METHOD GET_PATTERN.


*** Variablen

  DATA l_string TYPE string.
  DATA l_name   TYPE string.

  DATA t_head TYPE TABLE OF char100.
  DATA t_list TYPE TABLE OF char100.
  DATA t_mark TYPE TABLE OF char100.
  FIELD-SYMBOLS <mark> TYPE char100.

*** Überschrift
  APPEND 'Diese Muster stehen zur Verfügung.' TO t_head.
  APPEND 'Bitte auswählen!' TO t_head.

*** Tabelleneinträge zur Asuwahl
  APPEND '1Data' TO t_list.
  APPEND '2Assign Object' TO t_list.
  APPEND '3Set Text' TO t_list.
  APPEND '4Get Text' TO t_list.
  APPEND '5Set Readonly' TO t_list.

*** Popup anzeigen
  CALL FUNCTION 'RH_LISTPOPUP'
    EXPORTING
      title           = 'Muster'
      mark_mode       = 1
      mark_max        = 100
      fullscreen      = ' '
      cucol           = 5
      curow           = 5
      visible_offset  = 1   "Erstes Zeichen nicht ausgeben
      visible_length  = 40  "20 Zeichen der Tabelle ausgeben
    TABLES
      page_header     = t_head
      list            = t_list
      marked_lines    = t_mark
    EXCEPTIONS
      list_empty      = 1
      wrong_mark_mode = 2
      f15             = 3
      OTHERS          = 4.
  IF sy-subrc = 0 AND NOT t_mark IS INITIAL.
*** Es wurde eine Auswahl getroffen:
    LOOP AT t_mark ASSIGNING <mark>.
      CASE <mark>(1).
        WHEN '1'.
          CONCATENATE '*** DATA DEFINITION FOR' gv_control_name '***' INTO l_string SEPARATED BY space.
          APPEND l_string TO et_pattern.

          l_string = 'DATA GR_<NAME> TYPE REF TO cl_gui_textedit.'.
          l_name   = gv_control_name.
          TRANSLATE l_name TO UPPER CASE.
          REPLACE '<NAME>' WITH l_name INTO l_string.
          APPEND l_string TO et_pattern.
        WHEN OTHERS.
          CONCATENATE '*** NOT YET SUPPORTED:' <mark>+1 INTO l_string.
          APPEND l_string TO et_pattern.
      ENDCASE.
    ENDLOOP.
  ENDIF.



ENDMETHOD.


METHOD HAS_PATTERN.

  pattern_flag = 1.

ENDMETHOD.


METHOD INIT.
ENDMETHOD.


METHOD LOAD_SETTINGS.

  CALL METHOD load
    CHANGING
      cs_settings = gs_settings.

ENDMETHOD.


  method PROVIDE_CONTROL_NAME.

  ev_name = 'TEXTEDIT'.
  ev_desc = 'TextEdit-Control'.
  ev_icon = icon_create_text.

  endmethod.


  method PROVIDE_TOOLBAR.

exit. "unused!! => GET_DESIGN_FUNCTIONS
*  CALL METHOD cr_toolbar->add_button
*    EXPORTING
*      fcode      = 'SWITCH'
*      icon       = icon_active_inactive
*      butn_type  = cntb_btype_dropdown
*      text       = 'test'
*      quickinfo  = 'Readonly option'
*      is_checked = space
*    EXCEPTIONS
*      OTHERS     = 4.


  CALL METHOD cr_toolbar->add_button
    EXPORTING
      fcode      = c_function_readonly
      icon       = icon_active_inactive
      butn_type  = cntb_btype_button
      text       = 'ReadOnly'
      quickinfo  = 'Readonly option'
      is_checked = space
    EXCEPTIONS
      OTHERS     = 4.

  CALL METHOD cr_toolbar->add_button
    EXPORTING
      fcode      = c_function_toolbar
      icon       = icon_active_inactive
      butn_type  = cntb_btype_button
      text       = 'Toolbar'
      quickinfo  = 'Switch toolbar'
      is_checked = space
    EXCEPTIONS
      OTHERS     = 4.

  CALL METHOD cr_toolbar->add_button
    EXPORTING
      fcode      = c_function_statusbar
      icon       = icon_active_inactive
      butn_type  = cntb_btype_button
      text       = 'Statusbar'
      quickinfo  = 'Switch Statusbar'
      is_checked = space
    EXCEPTIONS
      OTHERS     = 4.

  endmethod.


  METHOD RETURN_CREATION_CODE.


    APPEND 'CREATE OBJECT $control' TO code.
    APPEND '  EXPORTING' TO code.
    APPEND '    parent = $parent.' TO code.


    APPEND |$control->set_textstream( '{ gs_settings-text }' ).| TO code.
    APPEND |$control->set_readonly_mode( '{ gs_settings-readonly }' ).| TO code.
    APPEND |$control->set_toolbar_mode( '{ gs_settings-toolbar }' ).| TO code.
    APPEND |$control->set_statusbar_mode( '{ gs_settings-statusbar }' ).| TO code.
    APPEND |$control->set_wordwrap_behavior( wordwrap_mode = '{ gs_settings-wordwrap }' ).| TO code.


  ENDMETHOD.


METHOD SAVE_SETTINGS.

  DATA lr_text   TYPE REF TO cl_gui_textedit.
  data lv_String type string.

  lr_text ?= gr_control.

  CLEAR gs_settings.
  gs_settings-readonly  = lr_text->m_readonly_mode.
  gs_settings-statusbar = lr_text->m_statusbar_mode.
  gs_settings-toolbar   = lr_text->m_toolbar_mode.
  gs_settings-wordwrap  = lr_text->M_WORDWRAP_MODE.
  lr_text->get_textstream( IMPORTING text = lv_string ).
  cl_gui_cfw=>flush( ).
  gs_settings-text      = lv_string.

  save( is_settings = gs_settings ).

ENDMETHOD.


METHOD VIEW_ATTRIBUTES.

  DATA ls_ctext TYPE /inw/enhc_text.
  DATA lr_text  TYPE REF TO cl_gui_textedit.

  lr_text ?= gr_control.


  CALL FUNCTION '/INW/ENHEMA_POPUP_TEXT'
    EXPORTING
      ir_control  = gr_control
    CHANGING
      cs_settings = gs_settings.

  apply_settings( ).

ENDMETHOD.


  METHOD zif_guidrasil_func_receiver~on_dropdown_clicked.

    DATA:
      lr_text     TYPE REF TO cl_gui_textedit,
      lv_disabled TYPE cua_active,
      lv_checked  TYPE cua_active,
      lv_text     TYPE gui_text,
      lx_menu     TYPE REF TO cl_ctmenu,
      lv_flag     TYPE i.


    CHECK r_receiver = me.

    lr_text ?= gr_control.


    CASE fcode.
      WHEN 'TEXT_DROPDOWN'.
        CREATE OBJECT lx_menu.

*** EDIT
        IF lr_text->m_readonly_mode = 0.
          lv_checked  = 'X'.
        ELSE.
          lv_checked  = space.
        ENDIF.
        lv_text = 'Editierbar'.
        CALL METHOD lx_menu->add_function
          EXPORTING
            fcode    = c_function_readonly
            disabled = lv_disabled
            checked  = lv_checked
            text     = lv_text.                                "#EC NOTEXT

*** TOOLBAR
        IF lr_text->m_toolbar_mode = 1.
          lv_checked  = 'X'.
        ELSE.
          lv_checked  = space.
        ENDIF.
        lv_text = 'Toolbar'.

        CALL METHOD lx_menu->add_function
          EXPORTING
            fcode    = c_function_toolbar
            disabled = lv_disabled
            checked  = lv_checked
            text     = lv_text.                                "#EC NOTEXT

*** STATUSBAR
        IF lr_text->m_statusbar_mode = 1.
          lv_checked  = 'X'.
        ELSE.
          lv_checked  = space.
        ENDIF.
        lv_text = 'Statuszeile'.

        CALL METHOD lx_menu->add_function
          EXPORTING
            fcode    = c_function_statusbar
            disabled = lv_disabled
            checked  = lv_checked
            text     = lv_text.                                "#EC NOTEXT

        CALL METHOD r_toolbar->track_context_menu
          EXPORTING
            context_menu = lx_menu
            posx         = posx
            posy         = posy.

    ENDCASE.

  ENDMETHOD.


  METHOD zif_guidrasil_func_receiver~on_function_selected.

    DATA:
      lr_text TYPE REF TO cl_gui_textedit,
      lv_text TYPE gui_text,
      lx_menu TYPE REF TO cl_ctmenu,
      lv_flag TYPE i.


    CHECK r_receiver = me.

    lr_text ?= gr_control.


    CASE fcode.

      WHEN 'SWITCH'.
*      CREATE OBJECT lx_menu.

      WHEN c_function_readonly.

        IF lr_text->m_readonly_mode = 0.
          lv_flag = 1.
        ELSE.
          lv_flag = 0.
        ENDIF.

        CALL METHOD lr_text->set_readonly_mode
          EXPORTING
            readonly_mode          = lv_flag
          EXCEPTIONS
            error_cntl_call_method = 1
            OTHERS                 = 2.


      WHEN c_function_toolbar.

        IF lr_text->m_toolbar_mode = 0.
          lv_flag = 1.
        ELSE.
          lv_flag = 0.
        ENDIF.

        CALL METHOD lr_text->set_toolbar_mode
          EXPORTING
            toolbar_mode = lv_flag
          EXCEPTIONS
            OTHERS       = 3.


      WHEN c_function_statusbar.

        IF lr_text->m_statusbar_mode = 0.
          lv_flag = 1.
        ELSE.
          lv_flag = 0.
        ENDIF.

        CALL METHOD lr_text->set_statusbar_mode
          EXPORTING
            statusbar_mode = lv_flag
          EXCEPTIONS
            OTHERS         = 3.

    ENDCASE.

    cl_gui_cfw=>flush( ).

  ENDMETHOD.
ENDCLASS.
