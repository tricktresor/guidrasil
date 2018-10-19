class ZCL_GUIDRASIL_TOOLS definition
  public
  final
  create public .

*"* public components of class ZCL_GUIDRASIL_TOOLS
*"* do not include other source files here!!!
public section.
  type-pools SLIS .

  class-methods GUID_CREATE
    returning
      value(EV_GUID) type GUID_16 .
  class-methods VIEW_ATTRIBUTES
    importing
      !IV_STRUCTURE_NAME type TABNAME
      !IS_STRUCTURE_VALUES type ANY
    changing
      !CV_NAME type CLIKE
    exceptions
      ERROR .
  class-methods TODO
    importing
      !WAS type STRING optional .
  class-methods SWITCH_BOOL
    importing
      !CURRENT_STATE type ABAP_BOOL
    returning
      value(SWITCHED_STATE) type ABAP_BOOL .
  class-methods SWITCH_INT
    importing
      !CURRENT_STATE type INT4
    returning
      value(SWITCHED_STATE) type INT4 .
protected section.
*"* protected components of class ZCL_GUIDRASIL_TOOLS
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_GUIDRASIL_TOOLS
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_GUIDRASIL_TOOLS IMPLEMENTATION.


  method GUID_CREATE.

  STATICS lv_guid TYPE i.
  ADD 1 TO lv_guid.
  ev_guid = lv_guid.

  endmethod.


  METHOD switch_bool.

    IF current_state = abap_true.
      switched_state = abap_false.
    ELSE.
      switched_state = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD switch_int.

    IF current_state = 1.
      switched_state = 0.
    ELSE.
      switched_state = 1.
    ENDIF.

  ENDMETHOD.


METHOD TODO.
ENDMETHOD.


METHOD view_attributes.

  MESSAGE 'No attributes to display'(msg) TYPE 'S'.

ENDMETHOD.
ENDCLASS.
