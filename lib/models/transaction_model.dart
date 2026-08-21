import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/bottom_nav_child4/bottom_nav_child4_widget.dart';
import '/components/button/button_widget.dart';
import '/components/category_selector/category_selector_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'add_transaction_widget.dart' show AddTransactionWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddTransactionModel extends FlutterFlowModel<AddTransactionWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextField.
  late TextFieldModel textFieldModel1;
  // Model for CategorySelector.
  late CategorySelectorModel categorySelectorModel1;
  // Model for CategorySelector.
  late CategorySelectorModel categorySelectorModel2;
  // Model for CategorySelector.
  late CategorySelectorModel categorySelectorModel3;
  // Model for CategorySelector.
  late CategorySelectorModel categorySelectorModel4;
  // Model for CategorySelector.
  late CategorySelectorModel categorySelectorModel5;
  // Model for CategorySelector.
  late CategorySelectorModel categorySelectorModel6;
  // Model for TextField.
  late TextFieldModel textFieldModel2;
  // Model for Button.
  late ButtonModel buttonModel;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    textFieldModel1 = createModel(context, () => TextFieldModel());
    categorySelectorModel1 =
        createModel(context, () => CategorySelectorModel());
    categorySelectorModel2 =
        createModel(context, () => CategorySelectorModel());
    categorySelectorModel3 =
        createModel(context, () => CategorySelectorModel());
    categorySelectorModel4 =
        createModel(context, () => CategorySelectorModel());
    categorySelectorModel5 =
        createModel(context, () => CategorySelectorModel());
    categorySelectorModel6 =
        createModel(context, () => CategorySelectorModel());
    textFieldModel2 = createModel(context, () => TextFieldModel());
    buttonModel = createModel(context, () => ButtonModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    textFieldModel1.dispose();
    categorySelectorModel1.dispose();
    categorySelectorModel2.dispose();
    categorySelectorModel3.dispose();
    categorySelectorModel4.dispose();
    categorySelectorModel5.dispose();
    categorySelectorModel6.dispose();
    textFieldModel2.dispose();
    buttonModel.dispose();
    bottomNavModel.dispose();
  }
}
