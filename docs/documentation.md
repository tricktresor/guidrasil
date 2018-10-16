# start

make sure to execute ZGUIDRASIL_INIT_CONTROLS to initially fill the controls table ZGUIDRASIL_CTLS.

# change log

## control functions (2018-10-16)

added ability to add functions directly in control edit menu.

To implement control settings directly in the dropdown menu:
- redefine GET_DESIGN_FUNCTIONS
- redefine ON_DROPDOWN_SELECTED
- redefine ON_FUNCTION_SELECTED

refer to ZCL_GUIDRASIL_CONTROL_TEXT for exact coding.
