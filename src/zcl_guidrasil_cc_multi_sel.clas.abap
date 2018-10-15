class ZCL_GUIDRASIL_CC_MULTI_SEL definition
  public
  create public .

public section.

  types:
    BEGIN OF ty_option,
        mark  TYPE rm_boolean,
        icon  TYPE icon_d,
        key   TYPE c LENGTH 10,
        text  TYPE c LENGTH 100,
        _col_ TYPE lvc_t_scol,
      END OF ty_option .
  types:
    ty_options TYPE STANDARD TABLE OF ty_option WITH DEFAULT KEY .

  methods SET
    importing
      !OPTIONS type TY_OPTIONS .
  methods GET
    returning
      value(OPTIONS) type TY_OPTIONS .
  methods DISPLAY
    importing
      !I_CONTAINER type ref to CL_GUI_CONTAINER .
  methods FREE .
  PROTECTED SECTION.

    DATA mt_options TYPE ty_options .
    DATA mo_salv TYPE REF TO cl_salv_table .

    METHODS on_click
          FOR EVENT link_click OF cl_salv_events_table
      IMPORTING
          !column
          !row
          !sender .
    METHODS set_colors .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GUIDRASIL_CC_MULTI_SEL IMPLEMENTATION.


  METHOD display.


    DATA o_column TYPE REF TO cl_salv_column_table.

    cl_salv_table=>factory( EXPORTING r_container = i_container
                            IMPORTING r_salv_table = mo_salv
                            CHANGING t_table = mt_options ).

    DATA(layout)  = mo_salv->get_display_settings( ).
    layout->set_list_header( 'Select option' ).



    DATA(columns) = mo_salv->get_columns( ).
    columns->set_color_column( '_COL_' ).
    columns->set_headers_visible( abap_false ).

    o_column ?= columns->get_column( 'MARK' ).
*    o_column->set_cell_type( if_salv_c_cell_type=>checkbox_hotspot ).
    o_column->set_technical( abap_true ).

    o_column ?= columns->get_column( 'ICON' ).
    o_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
    o_column->set_icon( abap_true ).

    o_column ?= columns->get_column( 'KEY' ).
    o_column->set_technical( abap_true ).

    o_column ?= columns->get_column( 'TEXT' ).

    mo_salv->display( ).

    DATA(handler) = mo_salv->get_event( ).
    SET HANDLER on_click FOR handler.



  ENDMETHOD.


  METHOD free.
     zcl_guidrasil_tools=>todo( 'find free method for SALV control' ).
  ENDMETHOD.


  METHOD get.

    options = mt_options.

  ENDMETHOD.


  METHOD on_click.


    READ TABLE mt_options ASSIGNING FIELD-SYMBOL(<option>) INDEX row.
    IF sy-subrc = 0.
      IF <option>-mark = abap_true.
        <option>-mark = abap_false.
        <option>-icon = icon_led_red.
        CLEAR <option>-_col_.
        APPEND INITIAL LINE TO <option>-_col_ ASSIGNING FIELD-SYMBOL(<col>).
      ELSE.
        <option>-mark  = abap_true.
        <option>-icon = icon_led_green.
        CLEAR <option>-_col_.
        APPEND INITIAL LINE TO <option>-_col_ ASSIGNING <col>.
      ENDIF.
    ENDIF.

    mo_salv->refresh( ).
    DATA(selections) = mo_salv->get_selections( ).
    selections->set_selected_cells( VALUE #( ) ).



  ENDMETHOD.


  METHOD set.

    mt_options = options.
    set_colors( ).

  ENDMETHOD.


  METHOD set_colors.


    LOOP AT mt_options ASSIGNING FIELD-SYMBOL(<option>).
      CLEAR <option>-_col_.
      APPEND INITIAL LINE TO <option>-_col_ ASSIGNING FIELD-SYMBOL(<col>).
      IF <option>-mark = abap_false.
        <option>-icon = icon_led_red.
      ELSE.
        <option>-icon = icon_led_green.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
