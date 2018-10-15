CLASS zcl_guidrasil_tree_display DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
      !ID type ZGUIDRASIL_PROJECT .
    METHODS read .
    METHODS display .
  PROTECTED SECTION.

    DATA mv_id TYPE zguidrasil_project .
    DATA mt_controls TYPE zguidrasil_obj_t .
    DATA mr_docker TYPE REF TO cl_gui_docking_container .
    DATA mr_tree TYPE REF TO cl_gui_list_tree .
    DATA mt_nodes TYPE treev_ntab .
    DATA mt_items TYPE gui_item .
    DATA mt_guids TYPE zguidrasil_tt_guid .

    METHODS tree_add_container
      IMPORTING
        !ctrl     TYPE zguidrasil_obj
        !relatkey TYPE any DEFAULT 'root' .
    METHODS tree_add_control
      IMPORTING
        !ctrl          TYPE zguidrasil_obj
        !relatkey      TYPE tv_nodekey OPTIONAL
      RETURNING
        VALUE(nodekey) TYPE tv_nodekey .
    METHODS tree_init .
    METHODS tree_add_root .
    METHODS tree_node_key_for_guid
      IMPORTING
        !guid           TYPE guid_16
      RETURNING
        VALUE(node_key) TYPE tv_nodekey .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GUIDRASIL_TREE_DISPLAY IMPLEMENTATION.


  METHOD constructor.

    mv_id = id.

  ENDMETHOD.


  METHOD display.

    FIELD-SYMBOLS <ctrl> LIKE LINE OF mt_controls.
    DATA ls_ctrl LIKE LINE OF mt_controls.

    tree_init( ).


    LOOP AT mt_controls ASSIGNING <ctrl>.
      CHECK <ctrl>-parent_guid <> 0.
      tree_add_container( <ctrl> ).
    ENDLOOP.


    CALL METHOD mr_tree->add_nodes_and_items
      EXPORTING
        node_table                = mt_nodes
        item_table                = mt_items
        item_table_structure_name = 'MTREEITM'.

    DATA lt_expand TYPE treev_nks.
    DATA ls_node   LIKE LINE OF mt_nodes.
    LOOP AT mt_nodes INTO ls_node.
      APPEND ls_node-node_key TO lt_expand.
    ENDLOOP.

    mr_tree->expand_nodes( lt_expand ).

  ENDMETHOD.


  METHOD read.

    SELECT * FROM zguidrasil_obj INTO TABLE mt_controls
     WHERE report = mv_id.


  ENDMETHOD.


  METHOD tree_add_container.


    DATA node         TYPE treev_node.
    DATA item         TYPE mtreeitm.
    DATA new_node_key TYPE tv_nodekey.

    CLEAR node.
    node-node_key = tree_node_key_for_guid( ctrl-parent_guid ).
    IF relatkey IS INITIAL.
      node-relatkey  = 'Root'.
    ELSE.
      node-relatkey  = relatkey.
    ENDIF.
    node-relatship = cl_gui_list_tree=>relat_last_child.
    node-isfolder  = 'X'.
    APPEND node TO mt_nodes.


    CLEAR item.
    item-node_key  = node-node_key.
    item-item_name = '1'.
    item-class     = cl_gui_list_tree=>item_class_text.
    item-alignment = cl_gui_list_tree=>align_auto.
    item-font      = cl_gui_list_tree=>item_font_prop.
    item-text      = ctrl-parent.
    APPEND item TO mt_items.


    new_node_key = tree_add_control( ctrl ).


    FIELD-SYMBOLS <ctrl> LIKE LINE OF mt_controls.
    DATA ls_ctrl LIKE LINE OF mt_controls.


    LOOP AT mt_controls ASSIGNING <ctrl> WHERE parent_guid = ctrl-object_guid.

      tree_add_control(
        ctrl     = <ctrl>
        relatkey = new_node_key ).
      <ctrl>-parent_guid = space.

    ENDLOOP.


  ENDMETHOD.


  METHOD tree_add_control.

    DATA node_container TYPE treev_node.
    DATA node TYPE treev_node.
    DATA item TYPE mtreeitm.

    "Add Container
    CLEAR node_container.
    node_container-node_key    = tree_node_key_for_guid( ctrl-object_guid ). "ctrl-parent_container .
    node_container-node_key(1) = 'C'.

    IF relatkey IS INITIAL.
      node_container-relatkey = tree_node_key_for_guid( ctrl-parent_guid ).
    ELSE.
      node_container-relatkey = relatkey.
    ENDIF.
    node_container-relatship  = cl_gui_list_tree=>relat_last_child.
    node_container-n_image    = icon_wd_component.
    node_container-isfolder   = abap_true.
    APPEND node_container TO mt_nodes.

    CLEAR item.
    item-node_key  = node_container-node_key.
    item-item_name = '1'.
    item-length    = 50.
    item-class     = cl_gui_list_tree=>item_class_text.
    item-alignment = cl_gui_list_tree=>align_auto.
    item-font      = cl_gui_list_tree=>item_font_prop.
    item-text      = ctrl-parent_container.
    APPEND item TO mt_items.


    "add control
    CLEAR node.
    node-node_key  = tree_node_key_for_guid( ctrl-object_guid ).
    node-relatkey  = node_container-node_key.
*  IF relatkey IS INITIAL.
*    node-relatkey  = tree_node_key_for_guid( ctrl-parent_guid ).
*  ELSE.
*    node-relatkey = relatkey.
*  ENDIF.
    node-relatship = cl_gui_list_tree=>relat_last_child.
    SELECT SINGLE iconname
      FROM zguidrasil_ctls
      INTO node-n_image
     WHERE classname = ctrl-object.

    SELECT SINGLE id
      FROM icon
      INTO node-n_image
     WHERE name = node-n_image.

    node-isfolder  = abap_true.
    APPEND node TO mt_nodes.

    CLEAR item.
    item-node_key  = node-node_key.
    item-item_name = '1'.
    item-length    = 50.
    item-class     = cl_gui_list_tree=>item_class_text.
    item-alignment = cl_gui_list_tree=>align_auto.
    item-font      = cl_gui_list_tree=>item_font_prop.
    item-text      = ctrl-object.
    APPEND item TO mt_items.

    CLEAR item.
    item-node_key  = node-node_key.
    item-item_name = '2'.
    item-length    = 40.
    item-class     = cl_gui_list_tree=>item_class_text.
    item-alignment = cl_gui_list_tree=>align_auto.
    item-font      = cl_gui_list_tree=>item_font_prop.
    item-text      = ctrl-control_name.
    item-style     = 2.
    APPEND item TO mt_items.

    nodekey = node-node_key.

  ENDMETHOD.


  METHOD tree_add_root.

    DATA node TYPE treev_node.
    DATA item TYPE mtreeitm.

* Node with key 'Root'
    node-node_key = 'root'.
    " Key of the node
    CLEAR node-relatkey.      " Special case: A root node has no parent
    CLEAR node-relatship.                " node.

    node-hidden = ' '.                   " The node is visible,
    node-disabled = ' '.                 " selectable,
    node-isfolder = 'X'.                 " a folder.
    CLEAR node-n_image.       " Folder-/ Leaf-Symbol in state "closed":
    " use default.
    CLEAR node-exp_image.     " Folder-/ Leaf-Symbol in state "open":
    " use default
    CLEAR node-expander.                 " see below.
    " the width of the item is adjusted to its content (text)
    APPEND node TO mt_nodes.

* Node with key 'Root'
    CLEAR item.
    item-node_key = 'root'.
    item-item_name = '1'.                " Item with name '1'
    item-class = cl_gui_list_tree=>item_class_text. " Text Item
    " the with of the item is adjusted to its content (text)
    item-alignment = cl_gui_list_tree=>align_auto.
    " use proportional font for the item
    item-font = cl_gui_list_tree=>item_font_prop.
    item-text = 'Objekte'(003).
    APPEND item TO mt_items.

  ENDMETHOD.


  METHOD tree_init.

    DATA events     TYPE cntl_simple_events.
    DATA event      TYPE cntl_simple_event.


*  CREATE OBJECT mr_docker
*    EXPORTING
*      ratio = 70.
*
    WRITE space.
* create a list tree
    CREATE OBJECT mr_tree
      EXPORTING
        parent              = cl_gui_container=>screen0 "mr_docker
        node_selection_mode = cl_gui_list_tree=>node_sel_mode_single
        item_selection      = 'X'
        with_headers        = ' '.

* define the events which will be passed to the backend
    " node double click
    event-eventid = cl_gui_list_tree=>eventid_node_double_click.
    event-appl_event = 'X'.                                   "
    APPEND event TO events.

    " item double click
    event-eventid = cl_gui_list_tree=>eventid_item_double_click.
    event-appl_event = 'X'.
    APPEND event TO events.

    " expand no children
    event-eventid = cl_gui_list_tree=>eventid_expand_no_children.
    event-appl_event = 'X'.
    APPEND event TO events.

    " link click
    event-eventid = cl_gui_list_tree=>eventid_link_click.
    event-appl_event = 'X'.
    APPEND event TO events.

    " button click
    event-eventid = cl_gui_list_tree=>eventid_button_click.
    event-appl_event = 'X'.
    APPEND event TO events.

    " checkbox change
    event-eventid = cl_gui_list_tree=>eventid_checkbox_change.
    event-appl_event = 'X'.
    APPEND event TO events.

    mr_tree->set_registered_events( events ).

** assign event handlers in the application class to each desired event
*  SET HANDLER g_application->handle_node_double_click FOR g_tree.
*  SET HANDLER g_application->handle_item_double_click FOR g_tree.
*  SET HANDLER g_application->handle_expand_no_children FOR g_tree.
*  SET HANDLER g_application->handle_link_click FOR g_tree.
*  SET HANDLER g_application->handle_button_click FOR g_tree.
*  SET HANDLER g_application->handle_checkbox_change FOR g_tree.

* add some nodes to the tree control
* NOTE: the tree control does not store data at the backend. If an
* application wants to access tree data later, it must store the
* tree data itself.

    tree_add_root( ).

  ENDMETHOD.


  METHOD tree_node_key_for_guid.

    READ TABLE mt_guids TRANSPORTING NO FIELDS
          WITH KEY table_line = guid.
    IF sy-subrc = 0.
      node_key = sy-tabix.
    ELSE.
      APPEND guid TO mt_guids.
      node_key = sy-tabix.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
