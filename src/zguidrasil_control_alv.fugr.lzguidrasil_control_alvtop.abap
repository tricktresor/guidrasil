FUNCTION-POOL zguidrasil_control_alv.       "MESSAGE-ID ..

TABLES zguidrasil_setting_gridp.

DATA gr_grid             TYPE REF TO cl_gui_alv_grid.
DATA gr_docu             TYPE REF TO cl_gui_textedit.
DATA gr_container        TYPE REF TO cl_gui_custom_container.
DATA gv_okcode           TYPE syucomm.
DATA gs_settings_grid    TYPE zguidrasil_setting_grid.
DATA gd_data             TYPE REF TO data.

* INCLUDE LZGUIDRASIL_CONTROL_ALVD...        " Local class definition
