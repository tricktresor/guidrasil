REPORT zguidrasil_init_controls.

CONSTANTS c_type_container TYPE c LENGTH 1 VALUE 'C'.
CONSTANTS c_type_control   TYPE c LENGTH 1 VALUE 'O'.

PARAMETERS p_test AS CHECKBOX DEFAULT 'X'.

START-OF-SELECTION.
  PERFORM init.

FORM init.

  DATA(oo_class) = NEW cl_oo_class( clsname = 'ZCL_GUIDRASIL_CONTROL_BASE' ).
  DATA(subclasses) = oo_class->get_subclasses( ).
  DATA controls TYPE STANDARD TABLE OF zguidrasil_ctls.
  DATA control  TYPE zguidrasil_ctls.


  LOOP AT subclasses INTO DATA(subclass).
    CLEAR control.
    SELECT SINGLE * FROM zguidrasil_ctls INTO control WHERE classname = subclass-clsname.
    CHECK sy-subrc > 0.
    control-classname = subclass-clsname.

    CASE subclass-clsname.
      WHEN 'ZCL_GUIDRASIL_DESIGN_CONTAINER'.
        CONTINUE.
      WHEN 'ZCL_GUIDRASIL_CONTROL_CUSTOM'
        OR 'ZCL_GUIDRASIL_CONTROL_DIABOX'
        OR 'ZCL_GUIDRASIL_CONTROL_DOCKING'.
        CONTINUE.
      WHEN 'ZCL_GUIDRASIL_CONTROL_SPLITTER'.
        control-type   = c_type_container.
        control-usable = abap_true.

      WHEN OTHERS.
        control-type   = c_type_control.
        control-usable = abap_true.
        CASE subclass-clsname.
          WHEN 'ZCL_GUIDRASIL_CONTROL_ALV'.
            control-iconname = 'ICON_TABLE_SETTINGS'.
          WHEN 'ZCL_GUIDRASIL_CONTROL_CALENDAR'.
            control-iconname = 'ICON_DATE'.
          WHEN 'ZCL_GUIDRASIL_CONTROL_ICON'.
            control-iconname = 'ICON_LED_GREEN'.
          WHEN 'ZCL_GUIDRASIL_CONTROL_TEXT'.
            control-iconname = 'ICON_WD_TEXT_EDIT'.
          WHEN OTHERS.
            control-iconname = 'ICON_DETAIL'.
        ENDCASE.
    ENDCASE.
    control-usable = abap_true.
    APPEND control TO controls.

    WRITE: / control-classname, 'added'.

  ENDLOOP.

  IF p_test = abap_false.
    INSERT zguidrasil_ctls FROM TABLE controls.
  ENDIF.

ENDFORM.
