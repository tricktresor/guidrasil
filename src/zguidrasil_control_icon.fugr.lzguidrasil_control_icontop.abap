FUNCTION-POOL zguidrasil_control_icon.      "MESSAGE-ID ..

* INCLUDE LZGUIDRASIL_CONTROL_ICOND...       " Local class definition
TABLES zguidrasil_setting_icon.
DATA gv_okcode           TYPE syucomm.
DATA gv_set_data         TYPE boolean.
DATA gr_picture          TYPE REF TO cl_gui_picture.
DATA gr_container        TYPE REF TO cl_gui_custom_container.
