class ZCL_GUIDRASIL_TOOLS_ICONS definition
  public
  create public .

public section.

  class-data ICONNAME type ICONNAME .

  class-methods INIT
    importing
      !PARENT type ref to CL_GUI_CONTAINER .
protected section.

  types:
    BEGIN OF ts_icon,
             icon01 TYPE icon_d, name01 TYPE iconname,
             icon02 TYPE icon_d, name02 TYPE iconname,
             icon03 TYPE icon_d, name03 TYPE iconname,
             icon04 TYPE icon_d, name04 TYPE iconname,
             icon05 TYPE icon_d, name05 TYPE iconname,
             icon06 TYPE icon_d, name06 TYPE iconname,
             icon07 TYPE icon_d, name07 TYPE iconname,
             icon08 TYPE icon_d, name08 TYPE iconname,
             icon09 TYPE icon_d, name09 TYPE iconname,
             icon10 TYPE icon_d, name10 TYPE iconname,
             icon11 TYPE icon_d, name11 TYPE iconname,
             icon12 TYPE icon_d, name12 TYPE iconname,
             icon13 TYPE icon_d, name13 TYPE iconname,
             icon14 TYPE icon_d, name14 TYPE iconname,
             icon15 TYPE icon_d, name15 TYPE iconname,
             icon16 TYPE icon_d, name16 TYPE iconname,
             icon17 TYPE icon_d, name17 TYPE iconname,
             icon18 TYPE icon_d, name18 TYPE iconname,
             icon19 TYPE icon_d, name19 TYPE iconname,
             icon20 TYPE icon_d, name20 TYPE iconname,
             icon21 TYPE icon_d, name21 TYPE iconname,
             icon22 TYPE icon_d, name22 TYPE iconname,
             icon23 TYPE icon_d, name23 TYPE iconname,
             icon24 TYPE icon_d, name24 TYPE iconname,
             icon25 TYPE icon_d, name25 TYPE iconname,
             icon26 TYPE icon_d, name26 TYPE iconname,
             icon27 TYPE icon_d, name27 TYPE iconname,
             icon28 TYPE icon_d, name28 TYPE iconname,
             icon29 TYPE icon_d, name29 TYPE iconname,
             icon30 TYPE icon_d, name30 TYPE iconname,
           END OF ts_icon .

  class-data:
    t_data TYPE STANDARD TABLE OF ts_icon .

  class-methods DC
    for event DOUBLE_CLICK of CL_SALV_EVENTS_TABLE
    importing
      !COLUMN
      !ROW .
private section.
ENDCLASS.



CLASS ZCL_GUIDRASIL_TOOLS_ICONS IMPLEMENTATION.


  method DC.


    DATA(colname) = column.
    REPLACE 'ICON' IN colname WITH 'NAME'.
    ASSIGN t_data[ row ] TO FIELD-SYMBOL(<icons>).
    IF sy-subrc = 0.
      ASSIGN COMPONENT colname OF STRUCTURE <icons> TO FIELD-SYMBOL(<icon>).
      IF sy-subrc = 0.
        iconname = <icon>.
        cl_gui_cfw=>set_new_ok_code( 'FF' ).
      ENDIF.
    ENDIF.

  endmethod.


  METHOD init.



    DATA count TYPE i VALUE 20.
    DATA pos TYPE n LENGTH 2.

*    DATA(dock) = NEW cl_gui_docking_container(
*                       side                    = cl_gui_docking_container=>dock_at_bottom ).
    parent->get_width( IMPORTING width = DATA(size) ).
    cl_gui_cfw=>flush( ).

    count = size / 41.
    IF count > 30.
      "Max size of icons
      count = 30.
    ENDIF.

    SELECT id, name FROM icon INTO TABLE @DATA(icons).
    APPEND INITIAL LINE TO t_data ASSIGNING FIELD-SYMBOL(<icons>).
    pos = 0.

    LOOP AT icons INTO DATA(icon).
      pos = pos + 1.
      IF pos = count.
        APPEND INITIAL LINE TO t_data ASSIGNING <icons>.
        pos = 1.
      ENDIF.

      DATA(colname) = |ICON{ pos }|.
      ASSIGN COMPONENT colname OF STRUCTURE <icons> TO FIELD-SYMBOL(<icon>).
      <icon> = icon-id.

      colname = |NAME{ pos }|.
      ASSIGN COMPONENT colname OF STRUCTURE <icons> TO <icon>.
      <icon> = icon-name.

    ENDLOOP.

    TRY.
        cl_salv_table=>factory( EXPORTING r_container = parent
                                IMPORTING r_salv_table = DATA(salv)
                                CHANGING  t_table = t_data ).

        DATA rcol TYPE REF TO cl_salv_column_list.
        DATA(cols) = salv->get_columns( ).

        CLEAR pos.
        LOOP AT cols->get( ) INTO DATA(col_icon) WHERE columnname(4) = 'ICON'.
          ADD 1 TO pos.
          rcol ?=  col_icon-r_column.
          IF pos >= count.
            rcol->set_technical( abap_true ).
          ELSE.
            rcol->set_icon( abap_true ).
          ENDIF.
        ENDLOOP.

        LOOP AT cols->get( ) INTO DATA(col_name) WHERE columnname(4) = 'NAME'.
          rcol ?=  col_name-r_column.
          rcol->set_technical( abap_true ).
        ENDLOOP.


        SET HANDLER dc FOR salv->get_event( ).

        salv->display( ).
      CATCH cx_salv_msg.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
