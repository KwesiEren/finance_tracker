import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/bottom_nav_child6/bottom_nav_child6_widget.dart';
import '/components/button/button_widget.dart';
import '/components/pie_chart/pie_chart_widget.dart';
import '/components/report_list_item/report_list_item_widget.dart';
import '/components/summary_card/summary_card_widget.dart';
import '/components/tab_group/tab_group_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'spending_reports_widget.dart' show SpendingReportsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SpendingReportsModel extends FlutterFlowModel<SpendingReportsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TabGroup.
  late TabGroupModel tabGroupModel;
  // Model for SummaryCard.
  late SummaryCardModel summaryCardModel1;
  // Model for SummaryCard.
  late SummaryCardModel summaryCardModel2;
  // Model for PieChart.
  late PieChartModel pieChartModel;
  // Model for ReportListItem.
  late ReportListItemModel reportListItemModel1;
  // Model for ReportListItem.
  late ReportListItemModel reportListItemModel2;
  // Model for ReportListItem.
  late ReportListItemModel reportListItemModel3;
  // Model for ReportListItem.
  late ReportListItemModel reportListItemModel4;
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for Button.
  late ButtonModel buttonModel2;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    tabGroupModel = createModel(context, () => TabGroupModel());
    summaryCardModel1 = createModel(context, () => SummaryCardModel());
    summaryCardModel2 = createModel(context, () => SummaryCardModel());
    pieChartModel = createModel(context, () => PieChartModel());
    reportListItemModel1 = createModel(context, () => ReportListItemModel());
    reportListItemModel2 = createModel(context, () => ReportListItemModel());
    reportListItemModel3 = createModel(context, () => ReportListItemModel());
    reportListItemModel4 = createModel(context, () => ReportListItemModel());
    buttonModel1 = createModel(context, () => ButtonModel());
    buttonModel2 = createModel(context, () => ButtonModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    tabGroupModel.dispose();
    summaryCardModel1.dispose();
    summaryCardModel2.dispose();
    pieChartModel.dispose();
    reportListItemModel1.dispose();
    reportListItemModel2.dispose();
    reportListItemModel3.dispose();
    reportListItemModel4.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
    bottomNavModel.dispose();
  }
}
