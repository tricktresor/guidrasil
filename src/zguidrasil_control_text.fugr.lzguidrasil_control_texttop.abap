FUNCTION-POOL zguidrasil_control_text.      "MESSAGE-ID ..

TABLES zguidrasil_setting_textp.
DATA gr_text             TYPE REF TO cl_gui_textedit.
DATA gr_docu             TYPE REF TO cl_gui_textedit.
DATA gr_container        TYPE REF TO cl_gui_custom_container.
DATA gv_okcode           TYPE syucomm.
DATA gs_settings_text    TYPE zguidrasil_setting_text.
DATA gd_data             TYPE REF TO data.

* INCLUDE LZGUIDRASIL_CONTROL_TEXTD...       " Local class definition
