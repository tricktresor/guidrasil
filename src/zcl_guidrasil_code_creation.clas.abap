class ZCL_GUIDRASIL_CODE_CREATION definition
  public
  final
  create public .

public section.

  class-methods CREATE_CODE_COMPLETE
    importing
      !IT_CONTROLS type ZGUIDRASIL_OBJ_T
      !IT_CONTROL_LIST type ZGUIDRASIL_CONTROL_LIST_T
    returning
      value(RT_PATTERN) type STRING_TABLE .
protected section.
private section.

  class-methods CODE_REPLACE
    importing
      !SEARCH type CLIKE
      !REPLACE type CLIKE
      !PREFIX type CLIKE
    changing
      !CODE type STRING_TABLE .
  class-methods CREATE_DATA_FOR_OBJECT
    importing
      !IS_CONTROL type ZGUIDRASIL_CONTROL_LIST_CC
    returning
      value(RT_PATTERN) type STRING_TABLE .
  class-methods CREATE_DATA_FOR_PARENT
    importing
      !IS_CONTROL type ZGUIDRASIL_CONTROL_LIST_CC
    returning
      value(RT_PATTERN) type STRING_TABLE .
ENDCLASS.



CLASS ZCL_GUIDRASIL_CODE_CREATION IMPLEMENTATION.


  METHOD code_replace.

    LOOP AT code ASSIGNING FIELD-SYMBOL(<line>).
      REPLACE ALL OCCURRENCES OF search IN <line> WITH |{ prefix }_{ replace }|.
    ENDLOOP.

  ENDMETHOD.


  METHOD create_code_complete.

    DATA ls_control             TYPE zguidrasil_control_list_cc.
    FIELD-SYMBOLS <ls_control>  TYPE zguidrasil_control_list_cc.
    DATA ls_ctrl_list           LIKE LINE OF it_control_list.
    DATA ls_object              LIKE LINE OF it_controls.
    DATA lr_object              TYPE REF TO object.
    DATA lt_pattern             TYPE string_table.

    DATA line                   TYPE string.
    DATA event                  TYPE string.
    DATA lv_index               TYPE i.

    DATA lr_obj                 TYPE REF TO cl_abap_classdescr.
    DATA lv_name                TYPE string.
    DATA lt_code                TYPE string_table.
    DATA lt_data                TYPE string_table.

    TYPES: BEGIN OF ty_event_ctrl,
             event              TYPE string,
             control            TYPE string,
             name               TYPE string,
           END OF ty_event_ctrl,
           BEGIN OF ty_event,
             event              TYPE string,
             control            TYPE string,
           END OF ty_event.

    DATA lt_events              TYPE STANDARD TABLE OF ty_event.
    DATA ls_event               TYPE ty_event.
    DATA lt_events_c            TYPE STANDARD TABLE OF ty_event_ctrl.
    DATA ls_event_c             TYPE ty_event_ctrl.
    DATA ls_event2              TYPE ty_event.
    DATA lr_container           TYPE REF TO cl_gui_container.
    DATA lt_control_list        TYPE zguidrasil_control_list_cc_t.
    DATA lt_controls            TYPE STANDARD TABLE OF zguidrasil_obj.

*clear t_controls.
* update_controls( ).

    LOOP AT it_control_list INTO ls_ctrl_list.
      MOVE-CORRESPONDING ls_ctrl_list TO ls_control.
      INSERT ls_control INTO TABLE lt_control_list.
    ENDLOOP.

    lt_controls     = it_controls.


    _code 'CLASS lcl_main DEFINITION.'.
    _code '  PUBLIC SECTION.'.
    _code '    METHODS constructor.'.

    LOOP AT lt_controls INTO ls_object.
      READ TABLE lt_control_list ASSIGNING <ls_control> WITH KEY guid = ls_object-parent_guid.
      IF sy-subrc = 0 .
*== DATA DEFINITION parent
        lt_pattern = create_data_for_parent( <ls_control> ).
        <ls_control>-data = abap_true.
        APPEND LINES OF lt_pattern TO rt_pattern.
      ENDIF.

      READ TABLE lt_control_list ASSIGNING <ls_control> WITH KEY guid = ls_object-object_guid.
      IF sy-subrc = 0 .
*== DATA DEFINITION object
        lt_pattern = create_data_for_object( <ls_control> ).
        <ls_control>-data = abap_true.
        APPEND LINES OF lt_pattern TO rt_pattern.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_controls INTO ls_object.

      READ TABLE lt_control_list INTO ls_control WITH KEY guid = ls_object-object_guid.
      IF sy-subrc = 0 .

*== METHOD DEFINITION
        lr_object = ls_control-r_control_builder->get_control( ).
        IF lr_object IS BOUND.
          lr_obj ?= cl_abap_typedescr=>describe_by_object_ref( lr_object ).
          lv_name = lr_obj->get_relative_name( ).

          line = |    METHODS init_{ ls_object-control_name }.|.
          APPEND line TO rt_pattern.
        ENDIF.
      ENDIF.



*== EVENT HANDLER
      IF ls_control-r_control_builder->gt_events IS NOT INITIAL.
        LOOP AT ls_control-r_control_builder->gt_events INTO ls_event-event.
          ls_event-control = lv_name.
          READ TABLE lt_events TRANSPORTING NO FIELDS
                WITH KEY event = ls_event-event
                         control = ls_event-control.
          IF sy-subrc > 0.
            COLLECT ls_event INTO lt_events.
          ENDIF.
          ls_event_c-event   = ls_event-event.
          ls_event_c-control = lv_name.
          ls_event_c-name    = ls_object-control_name.
          COLLECT ls_event_c INTO lt_events_c.
        ENDLOOP.
      ENDIF.
      READ TABLE lt_control_list INTO ls_control WITH KEY guid = ls_object-parent_guid.
      IF sy-subrc = 0 AND ls_object-parent_container CS 'DOCKER'.

*== METHOD DEFINITION PARENT
        lr_object = ls_control-r_control_builder->get_control( ).
        IF lr_object IS BOUND.
          lr_obj ?= cl_abap_typedescr=>describe_by_object_ref( lr_object ).
          lv_name = lr_obj->get_relative_name( ).

          line = |    METHODS init_{ ls_object-parent_container }.|.
          APPEND line TO rt_pattern.
        ENDIF.
      ENDIF.
    ENDLOOP.


    LOOP AT lt_events INTO ls_event.
      line = |    METHODS h_{ ls_event-event WIDTH = 25 } FOR EVENT { ls_event-event } OF { ls_event_c-control } IMPORTING sender.|.
      APPEND line TO rt_pattern.
    ENDLOOP.


    _code 'ENDCLASS.'.

    _code 'CLASS lcl_main IMPLEMENTATION.'.
    _code '  METHOD constructor.'.
    LOOP AT lt_controls INTO ls_object.
      IF ls_object-parent_container CS 'DOCKER'.
        line = |    init_{ ls_object-parent_container }( ).|.
        APPEND line TO rt_pattern.
      ENDIF.
      line = |    init_{ ls_object-control_name }( ).|.
      APPEND line TO rt_pattern.
    ENDLOOP.
    _code '  ENDMETHOD.'.

    LOOP AT lt_controls INTO ls_object.
      line = |  METHOD  init_{ ls_object-control_name }.|.
      APPEND line TO rt_pattern.
      READ TABLE lt_control_list INTO ls_control WITH TABLE KEY guid = ls_object-object_guid.
      IF sy-subrc = 0.

        IF ls_control-r_control_builder->return_creation_code(
                   IMPORTING code = lt_code
                             data = lt_data ) = abap_false.
          code_replace( EXPORTING search  = '$control'
                                  prefix  = 'mr'
                                  replace = ls_control-r_control_builder->gv_control_name
                        CHANGING code = lt_code ).
          code_replace( EXPORTING search  = '$parent'
                                  prefix  = 'mr'
                                  replace = ls_object-parent_container
                        CHANGING code = lt_code ).
          APPEND LINES OF lt_data TO rt_pattern.
          APPEND LINES OF lt_code TO rt_pattern.
        ENDIF.
      ENDIF.

      _code '  ENDMETHOD.'.

*== PARENT
      IF ls_object-parent(27) <> 'ZCL_GUIDRASIL_CONTROL_SPLIT'.
        "Die einzelnen Container vom Splitter nicht extra erzeugen.
        line = |  METHOD  init_{ ls_object-parent_container }.|.
        APPEND line TO rt_pattern.
        READ TABLE lt_control_list INTO ls_control WITH TABLE KEY guid = ls_object-parent_guid.
        IF sy-subrc = 0.

          IF ls_control-r_control_builder->return_creation_code(
                     IMPORTING code = lt_code
                               data = lt_data ) = abap_false.
            code_replace( EXPORTING search  = '$control'
                                    prefix  = 'mr'
                                    replace = ls_control-r_control_builder->gv_control_name
                          CHANGING code = lt_code ).
            code_replace( EXPORTING search  = '$parent'
                                    prefix  = 'mr'
                                    replace = ls_object-parent_container
                          CHANGING code = lt_code ).
            APPEND LINES OF lt_data TO rt_pattern.
            APPEND LINES OF lt_code TO rt_pattern.
          ENDIF.
        ENDIF.

        _code '  ENDMETHOD.'.
      ENDIF.




    ENDLOOP.


    LOOP AT lt_events INTO ls_event.
      line = |  METHOD h_{ ls_event-event }.|. APPEND line TO rt_pattern.
      _code '    CASE sender.'.
      LOOP AT lt_events_c INTO ls_event_c
           WHERE event   = ls_event-event
             AND control = ls_event-control.
        line = |      WHEN mr_{ ls_event_c-name }.|.
        APPEND line TO rt_pattern.
        line = |        MESSAGE i000(oo) WITH '{ ls_event_c-event }' '{ ls_event_c-name }'.|.
        APPEND line TO rt_pattern.

      ENDLOOP.
      _code '    ENDCASE.'.
      _code '  ENDMETHOD.'.
    ENDLOOP.

    _code 'ENDCLASS.'.

    _code 'DATA gr_main TYPE REF TO lcl_main.'.

    _code 'AT SELECTION-SCREEN.'.
    _code '  CREATE OBJECT gr_main.'.



*CLASS lcl_main DEFINITION.
*  PUBLIC SECTION.
*    DATA mr_enhema   TYPE REF TO /inw/enhema_builder.
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
*    CREATE OBJECT mr_enhema
*      EXPORTING
*        iv_pname = 'GF'
*      EXCEPTIONS
*        OTHERS   = 3.
*    IF sy-subrc = 0.
*      mr_enhema->build( ).
*
*      mr_text1 ?= mr_enhema->get_object_by_name( 'INFOTEXT' ).
*      mr_pic   ?= mr_enhema->get_object_by_name( 'MEINHAUS' ).
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
*DATA gr_main TYPE REF TO lcl_main.


  ENDMETHOD.


  METHOD create_data_for_object.

    DATA lr_descr     TYPE REF TO cl_abap_classdescr.
    DATA lv_name      TYPE string.
    DATA lv_typ       TYPE string.
    DATA lv_line      TYPE string.
    DATA lr_container TYPE REF TO cl_gui_container.
    DATA lr_object    TYPE REF TO object.
    DATA lr_control   TYPE REF TO cl_gui_control.

    CHECK is_control-data = abap_false.

    lr_object = is_control-r_control_builder->get_control( ).
    IF lr_object IS INITIAL.
      BREAK-POINT.
      RETURN.
    ENDIF.

    lr_descr ?= cl_abap_typedescr=>describe_by_object_ref( lr_object ).
    lv_typ    = lr_descr->get_relative_name( ).
    TRANSLATE lv_name TO LOWER CASE.
*    lv_line = |    DATA mr_{ is_control-r_control_builder->gv_control_name } TYPE REF TO { lv_name }.|.
    lv_name = is_control-r_control_builder->gv_control_name.
    IF lv_name IS INITIAL.
      IF lr_object IS INSTANCE OF cl_gui_control.
        lr_control ?= lr_object.
        lv_name = lr_control->get_name( ).
      else.
        lv_name = 'DUMMY'.
      ENDIF.
    ENDIF.
    lv_line = |    DATA mr_{ lv_name WIDTH = 27 } TYPE REF TO { lv_typ }.|.
    APPEND lv_line TO rt_pattern.
    LOOP AT is_control-t_container INTO lr_container.
      lr_descr ?= cl_abap_typedescr=>describe_by_object_ref( lr_container ).
      lv_typ = lr_descr->get_relative_name( ).
      TRANSLATE lv_name TO LOWER CASE.
      lv_line = |    DATA mr_{ lr_container->get_name( ) WIDTH = 27 } TYPE REF TO { lv_typ }.|.
      APPEND lv_line TO rt_pattern.
    ENDLOOP.


  ENDMETHOD.


  METHOD create_data_for_parent.

    DATA lr_descr     TYPE REF TO cl_abap_classdescr.
    DATA lv_name      TYPE string.
    DATA lv_typ       TYPE string.
    DATA lv_line      TYPE string.
    DATA lr_container TYPE REF TO cl_gui_container.
    DATA lr_object    TYPE REF TO object.
    DATA lr_control   TYPE REF TO cl_gui_control.

    CHECK is_control-data = abap_false.

    lr_object = is_control-r_control_builder->get_control( ).

    lr_descr ?= cl_abap_typedescr=>describe_by_object_ref( lr_object ).
    lv_typ    = lr_descr->get_relative_name( ).
    TRANSLATE lv_name TO LOWER CASE.
*    lv_line = |    DATA mr_{ is_control-r_control_builder->gv_control_name } TYPE REF TO { lv_name }.|.
    lv_name = is_control-r_control_builder->gv_control_name.
    IF lv_name IS INITIAL.
      IF lr_object IS INSTANCE OF cl_gui_control.
        lr_control ?= lr_object.
        lv_name = lr_control->get_name( ).
      else.
        lv_name = 'DUMMY'.
      ENDIF.
    ENDIF.
    lv_line = |    DATA mr_{ lv_name WIDTH = 27 } TYPE REF TO { lv_typ }.|.
    APPEND lv_line TO rt_pattern.


  ENDMETHOD.
ENDCLASS.
