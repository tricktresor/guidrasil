interface ZIF_GUIDRASIL_FUNC_RECEIVER
  public .


  events FUNCTION_SELECTED
    exporting
      value(FCODE) type UI_FUNC
      value(R_SENDER) type ref to OBJECT
      value(R_RECEIVER) type ref to OBJECT
      value(R_TOOLBAR) type ref to CL_GUI_TOOLBAR .
  events DROPDOWN_CLICKED
    exporting
      value(FCODE) type UI_FUNC
      value(R_SENDER) type ref to OBJECT
      value(R_RECEIVER) type ref to OBJECT
      value(R_TOOLBAR) type ref to CL_GUI_TOOLBAR
      value(POSX) type I
      value(POSY) type I .

  methods ON_FUNCTION_SELECTED
    for event FUNCTION_SELECTED of ZIF_GUIDRASIL_FUNC_RECEIVER
    importing
      !FCODE
      !R_SENDER
      !R_RECEIVER
      !R_TOOLBAR .
  methods ON_DROPDOWN_CLICKED
    for event DROPDOWN_CLICKED of ZIF_GUIDRASIL_FUNC_RECEIVER
    importing
      !FCODE
      !R_SENDER
      !R_RECEIVER
      !R_TOOLBAR
      !POSX
      !POSY .
endinterface.
