class ZCL_GUIDRASIL_CONTROL_ICON definition
  public
  inheriting from ZCL_GUIDRASIL_CONTROL_BASE
  final
  create public .

*"* public components of class ZCL_GUIDRASIL_CONTROL_ICON
*"* do not include other source files here!!!
public section.

  class-methods CLASS_CONSTRUCTOR .
  methods CONSTRUCTOR .
  class-methods GET_ICON_ID
    importing
      !ICON_NAME type CLIKE
    returning
      value(ICON_ID) type ICON_D .

  methods APPLY_SETTINGS
    redefinition .
  methods CREATE
    redefinition .
  methods GET_DESIGN_FUNCTIONS
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
  methods SET_ATTRIBUTE
    redefinition .
  methods VIEW_ATTRIBUTES
    redefinition .
  methods ZIF_GUIDRASIL_FUNC_RECEIVER~ON_DROPDOWN_CLICKED
    redefinition .
  methods ZIF_GUIDRASIL_FUNC_RECEIVER~ON_FUNCTION_SELECTED
    redefinition .
protected section.
*"* protected components of class ZCL_GUIDRASIL_CONTROL_ICON
*"* do not include other source files here!!!

  data MR_CONTROL_SETTINGS type ref to ZCL_GUIDRASIL_ATTR_ICON .
  data MS_SETTINGS type ZGUIDRASIL_SETTING_ICON .
private section.
*"* private components of class ZCL_GUIDRASIL_CONTROL_ICON
*"* do not include other source files here!!!

  constants C_FUNCTION_FIT type UI_FUNC value 'PicFit' ##NO_TEXT.
  constants C_FUNCTION_FIT_CENTERED type UI_FUNC value 'PicFitCent' ##NO_TEXT.
  constants C_FUNCTION_NORMAL type UI_FUNC value 'PicNormal' ##NO_TEXT.
  constants C_FUNCTION_NORMAL_CENTERED type UI_FUNC value 'PicNormalCent' ##NO_TEXT.
  constants C_FUNCTION_STRETCH type UI_FUNC value 'PicStretch' ##NO_TEXT.

  class-methods GET_RANDOM_ICON
    returning
      value(ICON_NAME) type ICONNAME .
  methods ICON_CLICK
    for event PICTURE_CLICK of CL_GUI_PICTURE
    importing
      !MOUSE_POS_X
      !MOUSE_POS_Y .
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_ICON IMPLEMENTATION.


  METHOD APPLY_SETTINGS.

    DATA lr_picture TYPE REF TO cl_gui_picture.

    CHECK gr_control IS BOUND.

    lr_picture ?= gr_control.


    IF ms_settings-icon_name IS INITIAL.
      ms_settings-icon_name    = get_random_icon( ). "'ICON_CONNECTION_OBJECT'.
      ms_settings-display_mode = cl_gui_picture=>display_mode_fit_center.
    ENDIF.

*    IF ms_settings-display_mode IS INITIAL.
*      ms_settings-display_mode = cl_gui_picture=>display_mode_fit_center.
*    ENDIF.

    lr_picture->load_picture_from_sap_icons( get_icon_id( ms_settings-icon_name ) ).

    lr_picture->set_display_mode( ms_settings-display_mode ).

  ENDMETHOD.


  METHOD CLASS_CONSTRUCTOR.

    SELECT * FROM icon INTO TABLE mt_all_icons.

  ENDMETHOD.


METHOD CONSTRUCTOR.

  super->constructor( ).
  gv_control_short_name = 'ICON'.

ENDMETHOD.


METHOD CREATE.

  DATA lr_picture TYPE REF TO cl_gui_picture.


  CREATE OBJECT lr_picture
    EXPORTING
      parent = ir_parent
    EXCEPTIONS
      OTHERS = 6.

  er_control ?= lr_picture.
  gr_control = lr_picture.

  IF iv_name IS INITIAL.
    gv_control_name = zcl_guidrasil_builder=>init_control_name( 'ICON' ).
  ELSE.
    gv_control_name = iv_name.
  ENDIF.

  gv_control_short_name = 'ICO'.
  gv_control_technical  = 'CL_GUI_PICTURE'.


  mv_parent_container_name = iv_parent.

  apply_settings( ).

  DATA lt_events       TYPE        cntl_simple_events.
  DATA ls_event        TYPE        cntl_simple_event.

  ls_event-eventid = lr_picture->eventid_picture_click.
  APPEND ls_event TO lt_events.
  lr_picture->set_registered_events( lt_events ).

  SET HANDLER icon_click FOR lr_picture.

  APPEND 'PICTURE_CLICK' TO gt_events.


ENDMETHOD.


  METHOD get_design_functions.

    DATA lx_menu     TYPE REF TO cl_ctmenu.                 "ew
    DATA ls_function        TYPE stb_button.
    DATA ls_funcmenu TYPE stb_btnmnu.                       "ew

*    et_functions = mr_control_functions->get_design_functions( ).

*>>> dropdown
*    ls_function-icon       = icon_detail.
*    ls_function-butn_type  = cntb_id_dropdown. "cntb_btype_dropdown.
*    ls_function-function   = 'PIC_DROPDOWN'.
*    ls_function-text       = ''.
*    ls_function-quickinfo  = 'Controlfunktionen'.
*    APPEND ls_function TO et_functions.
*<<< dropdown


    ls_function-butn_type  = cntb_id_dropmenu.


    ls_function-function   = c_function_stretch.
    ls_function-text       = 'Stretch'.
    ls_function-quickinfo  = 'Stretch icon'.
    APPEND ls_function TO et_functions.

    ls_function-function   = c_function_normal.
    ls_function-text       = 'Normal'.
    ls_function-quickinfo  = 'Display normal'.
    APPEND ls_function TO et_functions.

    ls_function-function   = c_function_fit.
    ls_function-text       = 'Fit'.
    ls_function-quickinfo  = 'Stretch to fit container'.
    APPEND ls_function TO et_functions.

    ls_function-function   = c_function_normal_centered.
    ls_function-text       = 'Normal centered'.
    ls_function-quickinfo  = 'Display normal (centered)'.
    APPEND ls_function TO et_functions.

    ls_function-function   = c_function_fit_centered.
    ls_function-text       = 'Fit'.
    ls_function-quickinfo  = 'Fit container (centered)'.
    APPEND ls_function TO et_functions.

    ls_funcmenu-function = '$CTRLFUNC'.
    ls_funcmenu-ctmenu   = lx_menu.
    APPEND ls_funcmenu TO et_funcmenus.



  ENDMETHOD.


METHOD GET_ICON_ID.

  SELECT SINGLE id FROM icon INTO icon_id WHERE name = icon_name.
  IF sy-subrc > 0.
    icon_id = icon_alert.
  ENDIF.

ENDMETHOD.


  METHOD GET_RANDOM_ICON.

    data seed type i.

    seed = sy-uzeit.

    IF mr_random IS INITIAL.
      mr_random = cl_abap_random_int=>create(
                     seed = seed
                     min  = 1
                     max  = lines( mt_all_icons ) ).
    ENDIF.

    DATA ls_icon TYPE icon.

    READ TABLE mt_all_icons INDEX mr_random->get_next( ) INTO ls_icon.
    icon_name = ls_icon-name.


  ENDMETHOD.


METHOD ICON_CLICK.

  MESSAGE i000(oo) WITH gv_control_name 'IconClick (x/y)' mouse_pos_x mouse_pos_y.

ENDMETHOD.


METHOD LOAD_SETTINGS.

  CALL METHOD load
    CHANGING
      cs_settings = ms_settings.

ENDMETHOD.


METHOD PROVIDE_CONTROL_NAME.

  ev_name  = gv_control_name.
  ev_desc  = 'Picture-Control'.
  ev_icon  = icon_gis_pie.
  ev_short = gv_control_short_name.

ENDMETHOD.


METHOD PROVIDE_TOOLBAR.
ENDMETHOD.


METHOD RETURN_CREATION_CODE.


*== data
*  APPEND 'DATA $control TYPE REF TO cl_gui_picture.' TO data.

*== code
  APPEND 'CREATE OBJECT $control EXPORTING parent = $parent.' TO code.

  APPEND |$control->load_picture_from_sap_icons( zcl_guidrasil_control_icon=>get_icon_id( '{ ms_settings-icon_name }' ) ).| TO code.

  APPEND '*== Set Display mode' TO code.
  APPEND '$control->set_display_mode( cl_gui_picture=>display_mode_fit ).' TO code.

  APPEND '*== Picture-Click-Event' TO code.
  APPEND 'DATA lt_events                     TYPE        cntl_simple_events.' TO code.
  APPEND 'DATA ls_event                      TYPE        cntl_simple_event.' TO code.
  APPEND '*== register events' TO code.
  APPEND 'ls_event-eventid = $control->eventid_picture_click.' TO code.
  APPEND 'APPEND ls_event TO lt_events.' TO code.

  APPEND 'SET HANDLER h_picture_click FOR $control.' to code.

  APPEND '$control->set_registered_events( lt_events ).' TO code.

ENDMETHOD.


METHOD SAVE_SETTINGS.

  DATA lr_picture TYPE REF TO cl_gui_picture.

  lr_picture ?= gr_control.

  ms_settings-display_mode = lr_picture->display_mode.
  save( is_settings = ms_settings ).

ENDMETHOD.


METHOD set_attribute.

  zcl_guidrasil_control_base=>set_attribute_ext(
                     EXPORTING attr     = name
                               value    = value
                      CHANGING settings = ms_settings ).

ENDMETHOD.


  METHOD view_attributes.

    CALL FUNCTION 'Z_GUIDRASIL_CONTROL_ICON_POPUP'
      EXPORTING
        ir_control  = gr_control
      CHANGING
        cs_settings = ms_settings
      EXCEPTIONS
        cancelled  = 1.
    IF sy-subrc = 0.
      apply_settings( ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_guidrasil_func_receiver~on_dropdown_clicked.


    DATA lx_menu     TYPE REF TO cl_ctmenu.

    DATA: BEGIN OF checked,
            normal          TYPE rm_boolean,
            normal_centered TYPE rm_boolean,
            fit             TYPE rm_boolean,
            fit_centered    TYPE rm_boolean,
            stretch         TYPE rm_boolean,
          END OF checked.

*    CHECK r_receiver = me.


    CASE fcode.
      WHEN '$CTRLFUNC'.
        CREATE OBJECT lx_menu.
        CLEAR checked.
        CASE ms_settings-display_mode.
          WHEN cl_gui_picture=>display_mode_fit.
            checked-fit             = abap_true.
          WHEN cl_gui_picture=>display_mode_normal.
            checked-normal          = abap_true.
          WHEN cl_gui_picture=>display_mode_stretch.
            checked-stretch         = abap_true.
          WHEN cl_gui_picture=>display_mode_normal_center.
            checked-normal_centered = abap_true.
          WHEN cl_gui_picture=>display_mode_fit_center.
            checked-fit_centered    = abap_true.
        ENDCASE.

        lx_menu->add_function(
            fcode    = c_function_fit
            disabled = checked-fit
            checked  = checked-fit
            text     = 'Fit display' ).                     "#EC NOTEXT
        lx_menu->add_function(
            fcode    = c_function_normal
            disabled = checked-normal
            checked  = checked-normal
            text     = 'Normal display' ).                  "#EC NOTEXT
        lx_menu->add_function(
            fcode    = c_function_normal_centered
            disabled = checked-normal_centered
            checked  = checked-normal_centered
            text     = 'Normal centered' ).                 "#EC NOTEXT
        lx_menu->add_function(
            fcode    = c_function_fit_centered
            disabled = checked-fit_centered
            checked  = checked-fit_centered
            text     = 'Fit centered' ).                    "#EC NOTEXT
        lx_menu->add_function(
            fcode    = c_function_stretch
            disabled = checked-stretch
            checked  = checked-stretch
            text     = 'Stretched' ).                    "#EC NOTEXT

    ENDCASE. "fcode

    IF lx_menu IS BOUND.
      r_toolbar->track_context_menu(
           context_menu = lx_menu
           posx         = posx
           posy         = posy ).
    ENDIF.

*
*    CASE fcode.
*      WHEN 'PIC_DROPDOWN'.
*        mr_control_functions->on_dropdown_clicked(
*                     fcode     = fcode
*                     r_toolbar = r_toolbar
*                     posx      = posx
*                     posy      = posy ).
*
*    ENDCASE.

  ENDMETHOD.


  METHOD zif_guidrasil_func_receiver~on_function_selected.

    CASE fcode.
      WHEN c_function_fit.
        ms_settings-display_mode = cl_gui_picture=>display_mode_fit.
        apply_settings( ).

      WHEN c_function_normal.
        ms_settings-display_mode = cl_gui_picture=>display_mode_normal.
        apply_settings( ).

      WHEN c_function_stretch.
        ms_settings-display_mode = cl_gui_picture=>display_mode_stretch.
        apply_settings( ).

      WHEN c_function_normal_centered.
        ms_settings-display_mode = cl_gui_picture=>display_mode_normal_center.
        apply_settings( ).

      WHEN c_function_fit_centered.
        ms_settings-display_mode = cl_gui_picture=>display_mode_fit_center.
        apply_settings( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
