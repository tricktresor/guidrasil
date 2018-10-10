interface ZIF_GUIDRASIL_CONTROL_FUNC
  public .


  data MR_ENHEMA_CONTROL type ref to ZCL_GUIDRASIL_CONTROL_BASE .

  methods ON_FUNCTION_SELECTED
    importing
      !IV_FCODE type CLIKE
      !IR_CONTROL type ref to CL_GUI_CONTROL .
  methods ON_DROPDOWN_SELECTED
    importing
      !IV_FCODE type CLIKE optional
      !IR_MENU type ref to CL_CTMENU .
  methods GET_DESIGN_FUNCTIONS
    returning
      value(ET_FUNCTIONS) type TTB_BUTTON .
  methods SAVE .
  methods SET_CONTROL
    importing
      !CONTROL type ref to ZCL_GUIDRASIL_CONTROL_BASE .
endinterface.
