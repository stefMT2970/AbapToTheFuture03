*&---------------------------------------------------------------------*
*&  Include           Z_MONSTER_MONITOR_CD01
*&---------------------------------------------------------------------*
************************************************************************
* Class Definitions
************************************************************************

*----------------------------------------------------------------------*
*       CLASS lcl_persistency_layer DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_persistency_layer DEFINITION.

  PUBLIC SECTION.
    METHODS: constructor,
             get_data EXPORTING et_output_data TYPE g_tt_output_data.
  PRIVATE SECTION.
    DATA: mo_monster_model TYPE REF TO zcl_monster_model.

ENDCLASS.                    "lcl_persistency_layer DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_model DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_model DEFINITION INHERITING FROM zcl_bc_model.

  PUBLIC SECTION.
    DATA: mo_persistency_layer TYPE REF TO lcl_persistency_layer,
          mt_output_data       TYPE g_tt_output_data.

    METHODS: constructor IMPORTING io_access_class TYPE REF TO lcl_persistency_layer OPTIONAL,
             data_retrieval,
             prepare_data_for_ouput,
             fill_user_commands    REDEFINITION,
             fill_editable_fields  REDEFINITION,
             fill_hidden_fields    REDEFINITION,
             fill_technical_fields REDEFINITION,
             fill_hotspot_fields   REDEFINITION,
             fill_subtotal_fields  REDEFINITION,
             fill_field_texts      REDEFINITION,
             fill_checkbox_fields  REDEFINITION,
             fill_layout_data      REDEFINITION,
             user_command          REDEFINITION.

ENDCLASS.                    "lcl_model DEFINITION

*--------------------------------------------------------------------*
* VIEW definition
*--------------------------------------------------------------------*
CLASS lcl_view DEFINITION INHERITING FROM zcl_bc_view_salv_table.
  PUBLIC SECTION.
    METHODS: application_specific_changes REDEFINITION,
             ida_demo.
ENDCLASS.                    "lcl_view DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_controller DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_controller DEFINITION.

  PUBLIC SECTION.
    INTERFACES zif_bc_controller.

    ALIASES: on_user_command FOR zif_bc_controller~on_user_command.

    DATA: mo_model TYPE REF TO lcl_model,
          mo_view  TYPE REF TO lcl_view.

    METHODS : constructor  IMPORTING io_model TYPE REF TO lcl_model
                                     io_view  TYPE REF TO lcl_view,
              send_email,
              build_hyperlink_url IMPORTING id_transaction TYPE  sy-tcode
                                            id_parameters  TYPE  string
                                            id_ok_code     TYPE  string
                                  RETURNING value(rs_url)  TYPE string,
              on_data_changed FOR EVENT data_changed OF lcl_model.

  PRIVATE SECTION.
    METHODS : make_column_editable IMPORTING id_column_name TYPE dd03l-fieldname
                                   CHANGING  ct_fcat        TYPE lvc_t_fcat.

ENDCLASS.                    "lcl_controller DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_application DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_application DEFINITION.

  PUBLIC SECTION.
    CLASS-DATA: mo_model      TYPE REF TO lcl_model,
                mo_controller TYPE REF TO lcl_controller,
                mo_view       TYPE REF TO lcl_view.

    CLASS-METHODS: main.

ENDCLASS.                    "lcl_application DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_selections DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_selections DEFINITION.
  PUBLIC SECTION.
    DATA: s_numbr TYPE RANGE OF zsc_monster_header-monster_number,
          s_name  TYPE RANGE OF zsc_monster_header-name,
          p_bhf   TYPE ZDE_MONSTER_BED_HIDER_FLAG,
          p_vari  TYPE disvariant-variant,
          p_edit  TYPE abap_bool,
          p_macro TYPE abap_bool,
          p_send  TYPE char01,
          p_email TYPE ad_smtpadr.

    METHODS : constructor IMPORTING
       is_numbr LIKE s_numbr
       is_name  LIKE s_name
       ip_bhf   LIKE p_bhf
       ip_vari  LIKE p_vari
       ip_edit  LIKE p_edit
       ip_macro LIKE p_macro
       ip_send  LIKE p_send
       ip_email LIKE p_email.

ENDCLASS.                    "lcl_selections DEFINITION
