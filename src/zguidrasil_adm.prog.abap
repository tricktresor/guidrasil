*&---------------------------------------------------------------------*
*& Report  ZGUIDRASIL_ADM
*&---------------------------------------------------------------------*
REPORT  zguidrasil_adm LINE-SIZE 200.

DATA g_mode     TYPE char01.
DATA gt_pattern TYPE string_table.
DATA gt_code    TYPE string_table.
DATA gr_builder TYPE REF TO zcl_guidrasil_builder.


PARAMETERS:
  p_name   TYPE zguidrasil_project MEMORY ID zguidrasil_project,
  p_design TYPE c RADIOBUTTON GROUP mode DEFAULT 'X',
  p_view   TYPE c RADIOBUTTON GROUP mode,
  p_tree   TYPE c RADIOBUTTON GROUP mode,
  p_delete TYPE c RADIOBUTTON GROUP mode.

PARAMETERS p_hires AS CHECKBOX DEFAULT space.

START-OF-SELECTION.

  IF p_hires = abap_true.
    zcl_guidrasil_constants=>set_design_container_high_res( ).
  ELSE.
    zcl_guidrasil_constants=>set_design_container_low_res( ).
  ENDIF.

  CASE 'X'.
    WHEN p_view.
      g_mode = space.
    WHEN p_design.
      g_mode = 'D'.
    WHEN p_delete.
      PERFORM delete.
      STOP.
    WHEN p_tree.
      PERFORM tree.
      STOP.
  ENDCASE.

*== Call Design Screen
  CALL SCREEN 1.

FORM tree.

  DATA gr_tree TYPE REF TO zcl_guidrasil_tree_display.


  CREATE OBJECT gr_tree EXPORTING id = p_name.

  gr_tree->read( ).
  gr_tree->display( ).
ENDFORM.


FORM delete.

*== data
  DATA lt_objects TYPE STANDARD TABLE OF zguidrasil_obj.
  FIELD-SYMBOLS <object> LIKE LINE OF lt_objects.

*== select controls
  SELECT * FROM zguidrasil_obj
    INTO TABLE lt_objects
   WHERE report = p_name.

  IF sy-subrc = 0.
*== delete settings
    WRITE: / 'Lösche Objekte für Projekt', p_name.
    LOOP AT lt_objects ASSIGNING <object>.
      DELETE FROM /inw/enhema_set WHERE guid = <object>-object_guid.
      IF sy-subrc = 0.
        WRITE: / 'Einstellungen für Objekt', <object>-control_name, 'gelöscht.'.
      ELSE.
        WRITE: / 'Keine Einstellungen vorhanden für', <object>-control_name.
      ENDIF.
    ENDLOOP.
*== delete project
    DELETE FROM zguidrasil_obj WHERE report = p_name.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0001  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0001 OUTPUT.

  DATA lt_excl TYPE STANDARD TABLE OF syucomm.

  CASE g_mode.
    WHEN 'D'.
      SET PF-STATUS 'ENHEMA'.
    WHEN space.
      IF lt_excl IS INITIAL.
        APPEND 'SAVE' TO lt_excl.
        APPEND 'TOP' TO lt_excl.
        APPEND 'BOTTOM' TO lt_excl.
        APPEND 'LEFT' TO lt_excl.
        APPEND 'RIGHT' TO lt_excl.
        APPEND 'CUSTOM' TO lt_excl.
        APPEND 'DIALOGBOX' TO lt_excl.
*        APPEND 'GET_PATTERN' TO lt_excl.
      ENDIF.
      SET PF-STATUS 'ENHEMA' EXCLUDING lt_excl.
    WHEN OTHERS.
      SET PF-STATUS 'ENHEMA' EXCLUDING 'SAVE'.
  ENDCASE.

  IF gr_builder IS NOT BOUND.
    CREATE OBJECT gr_builder
      EXPORTING
        iv_pname = p_name
        iv_mode  = g_mode.
    gr_builder->build( ).
  ENDIF.

ENDMODULE.                 " STATUS_0001  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0001  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0001 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'HOME' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
      CALL METHOD gr_builder->save.
    WHEN 'BOTTOM'.
      gr_builder->add_container( cl_gui_docking_container=>dock_at_bottom ).
    WHEN 'LEFT'.
      gr_builder->add_container( cl_gui_docking_container=>dock_at_left ).
    WHEN 'RIGHT'.
      gr_builder->add_container( cl_gui_docking_container=>dock_at_right ).
    WHEN 'TOP'.
      gr_builder->add_container( cl_gui_docking_container=>dock_at_top ).
    WHEN 'CUSTOM'.
      gr_builder->add_container_cc( 'CC' ).
    WHEN 'DIALOGBOX'.
      gr_builder->add_container_box( ).
    WHEN 'GET_PATTERN'.
      gt_pattern = gr_builder->get_event_pattern( ).
      PERFORM display_code USING gt_pattern.
    WHEN 'GET_PATTERN_PLUS'.
      gt_pattern = gr_builder->get_event_pattern_plus( ).
      PERFORM display_code USING gt_pattern.
    WHEN 'GET_CODE'.
      gt_code = gr_builder->get_creation_code( ).
      PERFORM display_code USING gt_code.
    WHEN OTHERS.
      EXIT.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0001  INPUT

FORM display_code USING it_code TYPE string_table.


  DATA lt_sourcecode TYPE string_table.


  CALL FUNCTION 'PRETTY_PRINTER'
    EXPORTING
      inctoo             = space
    TABLES
      ntext              = lt_sourcecode
      otext              = it_code
    EXCEPTIONS
      enqueue_table_full = 1
      include_enqueued   = 2
      include_readerror  = 3
      include_writeerror = 4
      OTHERS             = 5.



  DATA: ls_editor_mode LIKE editormode.
  DATA ls_trdir TYPE trdir.


  ls_trdir-name	= 'ZZ$$TEMP'.
  ls_trdir-varcl = 'X'.
  ls_trdir-subc	= '1'.
  ls_trdir-cnam	= sy-uname.
  ls_trdir-cdat	= sy-datum.
  ls_trdir-unam	= sy-uname.
  ls_trdir-udat	= sy-datum.
  ls_trdir-vern	= 1.
  ls_trdir-rmand  = sy-mandt.
  ls_trdir-rload = sy-langu.
  ls_trdir-fixpt = 'X'.
  ls_trdir-sdate = sy-datum.
  ls_trdir-stime = sy-uzeit.
  ls_trdir-idate = sy-datum.
  ls_trdir-itime = sy-uzeit.
  ls_trdir-uccheck = 'X'.

  DATA lv_message TYPE c LENGTH 100.
  DATA lv_line    TYPE i.
  DATA lv_word    TYPE c LENGTH 100.
  SYNTAX-CHECK FOR lt_sourcecode LINE lv_line WORD lv_word MESSAGE lv_message.


  CALL FUNCTION 'EDITOR_APPLICATION'
    EXPORTING
      anfangszeile     = '000001'
      application      = 'PG'
      called_by_scrp   = ' '
      cursor           = ' '
      display          = ' '
      message          = lv_message
      name             = 'ZZTEMP                             '
      new              = 'X'
      trdir_inf        = ls_trdir
      title_text       = 'guidrasil'
      editor_mode      = ls_editor_mode
      callback_program = 'ZGUIDRASIL_ADM'
      callback_usercom = 'CALLBACK_EDITOR'
    TABLES
      content          = lt_sourcecode
    EXCEPTIONS
      line             = 1
      linenumbers      = 2
      offset           = 3
      OTHERS           = 4.

ENDFORM.

FORM callback_editor.
  CASE sy-ucomm.
    WHEN space.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
