REPORT zguidrsail_demo_generic_ctrl.

SELECTION-SCREEN BEGIN OF BLOCK ctrl WITH FRAME TITLE TEXT-ctl.
PARAMETERS p_text RADIOBUTTON GROUP ctrl DEFAULT 'X'.
PARAMETERS p_icon RADIOBUTTON GROUP ctrl.
SELECTION-SCREEN END OF BLOCK ctrl.

SELECTION-SCREEN BEGIN OF BLOCK side WITH FRAME TITLE TEXT-sid.
PARAMETERS p_left RADIOBUTTON GROUP side DEFAULT 'X'.
PARAMETERS p_rigt RADIOBUTTON GROUP side.
PARAMETERS p_botm RADIOBUTTON GROUP side.
SELECTION-SCREEN END OF BLOCK side.

CLASS ctrl_demo DEFINITION.
  PUBLIC SECTION.
    METHODS add_text
      IMPORTING
        side TYPE i.
    METHODS add_icon
      IMPORTING
        side TYPE i.
  PROTECTED SECTION.
    TYPES: BEGIN OF ts_object,
             container TYPE REF TO cl_gui_container,
             control   TYPE REF TO cl_gui_control,
           END OF ts_object.

    DATA objects TYPE STANDARD TABLE OF ts_object.
    METHODS append_control
      IMPORTING
        container TYPE REF TO cl_gui_container
        control   TYPE REF TO cl_gui_control.

ENDCLASS.

CLASS ctrl_demo IMPLEMENTATION.
  METHOD add_text.
    DATA(parent) = NEW cl_gui_docking_container( side = side ratio = 20 ).
    DATA(textedit) = NEW cl_gui_textedit( parent = parent ).
    textedit->set_text_as_stream( VALUE texttab( ( tdline = `This is a demonstration` ) ) ).
    append_control( container = parent control = textedit ).
  ENDMETHOD.
  METHOD add_icon.
    DATA(parent) = NEW cl_gui_docking_container( side = side ratio = 20 ).
    DATA(icon) = NEW cl_gui_picture( parent = parent ).
    data(clsnam) = cl_abap_typedescr=>describe_by_object_ref( parent )->get_relative_name( ).
    data dock2 type ref to cl_gui_control.
  DATA(xside) = parent->get_docking_side( ).
   parent->get_ratio( IMPORTING ratio = DATA(xratio) ).

DATA: container TYPE REF TO cl_gui_container,
      exc_ref TYPE REF TO cx_root.

DATA ptab TYPE abap_parmbind_tab.

ptab = VALUE #(
                ( name  = 'SIDE'
                  kind  = cl_abap_objectdescr=>exporting
                  value = REF #( xside ) )
                ( name  = 'RATIO'
                  kind  = cl_abap_objectdescr=>exporting
                  value = REF #( xratio ) ) ).

TRY.
    CREATE OBJECT container TYPE (clsnam)
      PARAMETER-TABLE ptab.
  CATCH cx_sy_create_object_error INTO exc_ref.
    MESSAGE exc_ref->get_text( ) TYPE 'I'.
ENDTRY.



    icon->load_picture_from_sap_icons( icon_message_question ).
    icon->set_display_mode( cl_gui_picture=>display_mode_fit_center ).
    append_control( container = parent control = icon ).
  ENDMETHOD.
  METHOD append_control.
    APPEND VALUE #( container = container control = control ) TO objects.
  ENDMETHOD.
ENDCLASS.

INITIALIZATION.
  DATA(demo) = NEW ctrl_demo( ).

AT SELECTION-SCREEN.

  CASE 'X'.
    WHEN p_left.
      DATA(side) = cl_gui_docking_container=>dock_at_left.
    WHEN p_rigt.
      side = cl_gui_docking_container=>dock_at_right.
    WHEN p_botm.
      side = cl_gui_docking_container=>dock_at_bottom.
  ENDCASE.

  CASE 'X'.
    WHEN p_text.
      demo->add_text( side = side ).
    WHEN p_icon.
      demo->add_icon( side = side ).
  ENDCASE.
