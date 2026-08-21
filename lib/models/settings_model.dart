import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/bottom_nav_child8/bottom_nav_child8_widget.dart';
import '/components/button/button_widget.dart';
import '/components/settings_group_header/settings_group_header_widget.dart';
import '/components/settings_row/settings_row_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'settings_widget.dart' show SettingsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsModel extends FlutterFlowModel<SettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for SettingsGroupHeader.
  late SettingsGroupHeaderModel settingsGroupHeaderModel1;
  // Model for SettingsRow.
  late SettingsRowModel settingsRowModel1;
  // Model for SettingsRow.
  late SettingsRowModel settingsRowModel2;
  // Model for SettingsRow.
  late SettingsRowModel settingsRowModel3;
  // Model for SettingsGroupHeader.
  late SettingsGroupHeaderModel settingsGroupHeaderModel2;
  // Model for SettingsRow.
  late SettingsRowModel settingsRowModel4;
  // Model for SettingsRow.
  late SettingsRowModel settingsRowModel5;
  // Model for SettingsRow.
  late SettingsRowModel settingsRowModel6;
  // Model for SettingsGroupHeader.
  late SettingsGroupHeaderModel settingsGroupHeaderModel3;
  // Model for SettingsRow.
  late SettingsRowModel settingsRowModel7;
  // Model for SettingsRow.
  late SettingsRowModel settingsRowModel8;
  // Model for SettingsRow.
  late SettingsRowModel settingsRowModel9;
  // Model for Button.
  late ButtonModel buttonModel;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    settingsGroupHeaderModel1 =
        createModel(context, () => SettingsGroupHeaderModel());
    settingsRowModel1 = createModel(context, () => SettingsRowModel());
    settingsRowModel2 = createModel(context, () => SettingsRowModel());
    settingsRowModel3 = createModel(context, () => SettingsRowModel());
    settingsGroupHeaderModel2 =
        createModel(context, () => SettingsGroupHeaderModel());
    settingsRowModel4 = createModel(context, () => SettingsRowModel());
    settingsRowModel5 = createModel(context, () => SettingsRowModel());
    settingsRowModel6 = createModel(context, () => SettingsRowModel());
    settingsGroupHeaderModel3 =
        createModel(context, () => SettingsGroupHeaderModel());
    settingsRowModel7 = createModel(context, () => SettingsRowModel());
    settingsRowModel8 = createModel(context, () => SettingsRowModel());
    settingsRowModel9 = createModel(context, () => SettingsRowModel());
    buttonModel = createModel(context, () => ButtonModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    settingsGroupHeaderModel1.dispose();
    settingsRowModel1.dispose();
    settingsRowModel2.dispose();
    settingsRowModel3.dispose();
    settingsGroupHeaderModel2.dispose();
    settingsRowModel4.dispose();
    settingsRowModel5.dispose();
    settingsRowModel6.dispose();
    settingsGroupHeaderModel3.dispose();
    settingsRowModel7.dispose();
    settingsRowModel8.dispose();
    settingsRowModel9.dispose();
    buttonModel.dispose();
    bottomNavModel.dispose();
  }
}
