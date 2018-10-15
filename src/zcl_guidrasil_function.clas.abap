class ZCL_GUIDRASIL_FUNCTION definition
  public
  create public .

public section.

  methods ADD_FUNCTIONS .
  methods GET_DESIGN_FUNCTIONS
    returning
      value(FUNCTIONS) type TTB_BUTTON .
  methods CONSTRUCTOR
    importing
      !GUIDRASIL_CONTROL type ref to ZCL_GUIDRASIL_CONTROL_BASE .
  methods ON_FUNCTION_SELECTED
    importing
      !FCODE type CLIKE .
  methods ON_DROPDOWN_CLICKED
    importing
      !FCODE type CLIKE
      !R_TOOLBAR type ref to CL_GUI_TOOLBAR
      !POSX type I
      !POSY type I .
  PROTECTED SECTION.

    DATA mr_iterator_objects_func TYPE REF TO cl_object_collection .
    DATA mr_guidrasil_control TYPE REF TO zcl_guidrasil_control_base .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GUIDRASIL_FUNCTION IMPLEMENTATION.


  METHOD add_functions.

    DATA lr_object_function TYPE REF TO zif_guidrasil_control_func.
    DATA lv_classname TYPE string.
    DATA lv_number    TYPE numc2.

*== Iteratorliste erzeugen
    CREATE OBJECT mr_iterator_objects_func.

    DO.
      ADD 1 TO lv_number.
      lv_classname = |ZCL_GUIDRASIL_CTRL_{ mr_guidrasil_control->gv_control_short_name }_FUNC_{ lv_number }|.

      TRY .
          CREATE OBJECT lr_object_function
            TYPE (lv_classname).
          lr_object_function->set_control( mr_guidrasil_control ).

          mr_iterator_objects_func->add( lr_object_function ).

        CATCH cx_root.
          EXIT. "from do
      ENDTRY.

    ENDDO.

  ENDMETHOD.


  METHOD constructor.

    mr_guidrasil_control = guidrasil_control.
    add_functions( ).

  ENDMETHOD.


  METHOD get_design_functions.

    DATA lt_functions     TYPE ttb_button.
    DATA lr_iterator_func TYPE REF TO cl_object_collection_iterator.
    DATA lr_control_func  TYPE REF TO zif_guidrasil_control_func.

    lr_iterator_func = mr_iterator_objects_func->if_object_collection~get_iterator( ).

    WHILE lr_iterator_func->has_next( ).
      lr_control_func ?= lr_iterator_func->get_next( ).
      lt_functions = lr_control_func->get_design_functions( ).
      APPEND LINES OF lt_functions TO functions.
    ENDWHILE.

  ENDMETHOD.


  METHOD on_dropdown_clicked.

    DATA lx_menu          TYPE REF TO cl_ctmenu.
    DATA lr_iterator_func TYPE REF TO cl_object_collection_iterator.
    DATA lr_control_func  TYPE REF TO zif_guidrasil_control_func.

    CREATE OBJECT lx_menu.

    lr_iterator_func = mr_iterator_objects_func->if_object_collection~get_iterator( ).

    WHILE lr_iterator_func->has_next( ).
      lr_control_func ?= lr_iterator_func->get_next( ).
      lr_control_func->on_dropdown_selected( iv_fcode = fcode ir_menu = lx_menu ).
    ENDWHILE.

    r_toolbar->track_context_menu(
        context_menu = lx_menu
        posx         = posx
        posy         = posy ).

  ENDMETHOD.


  METHOD on_function_selected.

    DATA lt_functions     TYPE ttb_button.
    DATA lr_iterator_func TYPE REF TO cl_object_collection_iterator.
    DATA lr_control_func  TYPE REF TO zif_guidrasil_control_func.
    DATA lr_control       TYPE REF TO cl_gui_control.

    lr_control ?= mr_guidrasil_control->get_control( ).

    lr_iterator_func = mr_iterator_objects_func->if_object_collection~get_iterator( ).

    WHILE lr_iterator_func->has_next( ).
      lr_control_func ?= lr_iterator_func->get_next( ).
      lr_control_func->on_function_selected(
                          iv_fcode   = fcode
                          ir_control = lr_control ).
    ENDWHILE.

  ENDMETHOD.
ENDCLASS.
