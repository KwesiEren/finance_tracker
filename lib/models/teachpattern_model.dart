import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/bottom_nav_child3/bottom_nav_child3_widget.dart';
import '/components/button/button_widget.dart';
import '/components/token_chip/token_chip_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'teach_pattern_widget.dart' show TeachPatternWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TeachPatternModel extends FlutterFlowModel<TeachPatternWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TokenChip.
  late TokenChipModel tokenChipModel1;
  // Model for TokenChip.
  late TokenChipModel tokenChipModel2;
  // Model for TokenChip.
  late TokenChipModel tokenChipModel3;
  // Model for TokenChip.
  late TokenChipModel tokenChipModel4;
  // Model for TokenChip.
  late TokenChipModel tokenChipModel5;
  // Model for TokenChip.
  late TokenChipModel tokenChipModel6;
  // Model for TokenChip.
  late TokenChipModel tokenChipModel7;
  // Model for TokenChip.
  late TokenChipModel tokenChipModel8;
  // Model for TokenChip.
  late TokenChipModel tokenChipModel9;
  // Model for TokenChip.
  late TokenChipModel tokenChipModel10;
  // Model for TokenChip.
  late TokenChipModel tokenChipModel11;
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for Button.
  late ButtonModel buttonModel2;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    tokenChipModel1 = createModel(context, () => TokenChipModel());
    tokenChipModel2 = createModel(context, () => TokenChipModel());
    tokenChipModel3 = createModel(context, () => TokenChipModel());
    tokenChipModel4 = createModel(context, () => TokenChipModel());
    tokenChipModel5 = createModel(context, () => TokenChipModel());
    tokenChipModel6 = createModel(context, () => TokenChipModel());
    tokenChipModel7 = createModel(context, () => TokenChipModel());
    tokenChipModel8 = createModel(context, () => TokenChipModel());
    tokenChipModel9 = createModel(context, () => TokenChipModel());
    tokenChipModel10 = createModel(context, () => TokenChipModel());
    tokenChipModel11 = createModel(context, () => TokenChipModel());
    buttonModel1 = createModel(context, () => ButtonModel());
    buttonModel2 = createModel(context, () => ButtonModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    tokenChipModel1.dispose();
    tokenChipModel2.dispose();
    tokenChipModel3.dispose();
    tokenChipModel4.dispose();
    tokenChipModel5.dispose();
    tokenChipModel6.dispose();
    tokenChipModel7.dispose();
    tokenChipModel8.dispose();
    tokenChipModel9.dispose();
    tokenChipModel10.dispose();
    tokenChipModel11.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
    bottomNavModel.dispose();
  }
}
