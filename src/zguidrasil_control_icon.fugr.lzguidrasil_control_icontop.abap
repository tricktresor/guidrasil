FUNCTION-POOL zguidrasil_control_icon.      "MESSAGE-ID ..

* INCLUDE LZGUIDRASIL_CONTROL_ICOND...       " Local class definition
TABLES zguidrasil_setting_icon_p.

DATA gs_settings         TYPE zguidrasil_setting_icon.

DATA gv_okcode           TYPE syucomm.
DATA gv_set_data         TYPE boolean.
DATA gr_picture          TYPE REF TO cl_gui_picture.
DATA gr_container        TYPE REF TO cl_gui_custom_container.
DATA gr_docu             TYPE REF TO cl_gui_textedit.
DATA gr_docu_container   TYPE REF TO cl_gui_custom_container.
data gr_dialogbox        type REF TO cl_gui_dialogbox_container.
