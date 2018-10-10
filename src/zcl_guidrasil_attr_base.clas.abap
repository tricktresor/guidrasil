class ZCL_GUIDRASIL_ATTR_BASE definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .

  methods SET
    importing
      !ATTR type CLIKE
      !VALUE type ANY .
  methods GET
    importing
      !ATTR type CLIKE
    exporting
      !VALUE type ANY .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GUIDRASIL_ATTR_BASE IMPLEMENTATION.


METHOD get.

  ASSIGN (attr) TO FIELD-SYMBOL(<value>).
  IF sy-subrc = 0.
    value = <value>.
  ELSE.
    MESSAGE 'Error Get Attribute' TYPE 'I'.
  ENDIF.

ENDMETHOD.


METHOD SET.

  FIELD-SYMBOLS <value> TYPE any.

  ASSIGN me->(attr) TO <value>.
  IF sy-subrc = 0.
    <value> = value.
  ELSE.
    message 'Error setting attribute' type 'I'.
  ENDIF.

ENDMETHOD.
ENDCLASS.
