import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/bottom_nav_child5/bottom_nav_child5_widget.dart';
import '/components/category_card/category_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'category_management_widget.dart' show CategoryManagementWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoryManagementModel
    extends FlutterFlowModel<CategoryManagementWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for CategoryCard.
  late CategoryCardModel categoryCardModel1;
  // Model for CategoryCard.
  late CategoryCardModel categoryCardModel2;
  // Model for CategoryCard.
  late CategoryCardModel categoryCardModel3;
  // Model for CategoryCard.
  late CategoryCardModel categoryCardModel4;
  // Model for CategoryCard.
  late CategoryCardModel categoryCardModel5;
  // Model for CategoryCard.
  late CategoryCardModel categoryCardModel6;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    categoryCardModel1 = createModel(context, () => CategoryCardModel());
    categoryCardModel2 = createModel(context, () => CategoryCardModel());
    categoryCardModel3 = createModel(context, () => CategoryCardModel());
    categoryCardModel4 = createModel(context, () => CategoryCardModel());
    categoryCardModel5 = createModel(context, () => CategoryCardModel());
    categoryCardModel6 = createModel(context, () => CategoryCardModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    categoryCardModel1.dispose();
    categoryCardModel2.dispose();
    categoryCardModel3.dispose();
    categoryCardModel4.dispose();
    categoryCardModel5.dispose();
    categoryCardModel6.dispose();
    bottomNavModel.dispose();
  }
}
