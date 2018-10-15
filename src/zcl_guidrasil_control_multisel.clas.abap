class ZCL_GUIDRASIL_CONTROL_MULTISEL definition
  public
  inheriting from ZCL_GUIDRASIL_CONTROL_BASE
  final
  create public .

public section.

  methods CONSTRUCTOR .

  methods CREATE
    redefinition .
  methods PROVIDE_CONTROL_NAME
    redefinition .
  methods PROVIDE_TOOLBAR
    redefinition .
  methods RETURN_CREATION_CODE
    redefinition .
  methods VIEW_ATTRIBUTES
    redefinition .
protected section.

  data MR_MULTISEL type ref to ZCL_GUIDRASIL_CC_MULTI_SEL .
private section.
ENDCLASS.



CLASS ZCL_GUIDRASIL_CONTROL_MULTISEL IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).
    gv_control_name = 'MULTISEL'.
  ENDMETHOD.


  METHOD create.

    CREATE OBJECT mr_multisel.
    mr_multisel->set( VALUE #(
                        ( text = 'One'   key = '1' )
                        ( text = `Two`   key = '2' )
                        ( text = `Three` key = '3'  )
                        ( text = `Four`  key = '4'  ) ) ).
    mr_multisel->display( i_container = ir_parent ).

    gr_control ?= mr_multisel.

  ENDMETHOD.


  METHOD provide_control_name.

    ev_name = 'MULTISELECTION'.
    ev_desc = 'Multi-selection'.
    ev_icon = icon_table_settings.

  ENDMETHOD.


  METHOD provide_toolbar.

    EXIT.  "unused!! => GET_DESIGN_FUNCTIONS
    zcl_guidrasil_tools=>todo( 'delete Method from caller' ).
*   The redefinition of the method ZCL_GUIDRASIL_CONTROL_MULTISEL=>PROVIDE_T
*   OOLBAR is missing or the class ZCL_GUIDRASIL_CONTROL_MULTISEL was not
*   defined as abstract. you must define the class as abstract


  ENDMETHOD.


  METHOD return_creation_code.

    APPEND 'CREATE OBJECT $control.' TO code.
    APPEND 'mr_$control->set( VALUE #(' TO code.
    APPEND '                     ( text = `one`   key = `1` )' to code.
    APPEND '                     ( text = `Two`   key = `2` )' to code.
    APPEND '                     ( text = `Three` key = `3`  )' to code.
    APPEND '                     ( text = `Four`  key = `4`  ) ) ).' to code.
    APPEND '$control->display( i_container = $parent ).' TO code.


  ENDMETHOD.


  METHOD view_attributes.
    MESSAGE 'no attributes to maintain' TYPE 'S'.
  ENDMETHOD.
ENDCLASS.
