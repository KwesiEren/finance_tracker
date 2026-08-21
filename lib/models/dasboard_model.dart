import '/components/activity_item/activity_item_widget.dart';
import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/bottom_nav_child/bottom_nav_child_widget.dart';
import '/components/budget_row/budget_row_widget.dart';
import '/components/button/button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for BudgetRow.
  late BudgetRowModel budgetRowModel1;
  // Model for BudgetRow.
  late BudgetRowModel budgetRowModel2;
  // Model for BudgetRow.
  late BudgetRowModel budgetRowModel3;
  // Model for ActivityItem.
  late ActivityItemModel activityItemModel1;
  // Model for ActivityItem.
  late ActivityItemModel activityItemModel2;
  // Model for ActivityItem.
  late ActivityItemModel activityItemModel3;
  // Model for Button.
  late ButtonModel buttonModel2;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    buttonModel1 = createModel(context, () => ButtonModel());
    budgetRowModel1 = createModel(context, () => BudgetRowModel());
    budgetRowModel2 = createModel(context, () => BudgetRowModel());
    budgetRowModel3 = createModel(context, () => BudgetRowModel());
    activityItemModel1 = createModel(context, () => ActivityItemModel());
    activityItemModel2 = createModel(context, () => ActivityItemModel());
    activityItemModel3 = createModel(context, () => ActivityItemModel());
    buttonModel2 = createModel(context, () => ButtonModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    buttonModel1.dispose();
    budgetRowModel1.dispose();
    budgetRowModel2.dispose();
    budgetRowModel3.dispose();
    activityItemModel1.dispose();
    activityItemModel2.dispose();
    activityItemModel3.dispose();
    buttonModel2.dispose();
    bottomNavModel.dispose();
  }
}
