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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'spending_reports_model.dart';
export 'spending_reports_model.dart';

class SpendingReportsWidget extends StatefulWidget {
  const SpendingReportsWidget({super.key});

  static String routeName = 'SpendingReports';
  static String routePath = '/spendingReports';

  @override
  State<SpendingReportsWidget> createState() => _SpendingReportsWidgetState();
}

class _SpendingReportsWidgetState extends State<SpendingReportsWidget> {
  late SpendingReportsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SpendingReportsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(24, 32, 24, 24),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Spending Reports',
                                          style: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .override(
                                                font:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontStyle,
                                                lineHeight: 1.3,
                                              ),
                                        ),
                                        Text(
                                          'Monthly summary for October',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                                lineHeight: 1.4,
                                              ),
                                        ),
                                      ].divide(SizedBox(height: 4)),
                                    ),
                                    FlutterFlowIconButton(
                                      borderRadius: 8,
                                      buttonSize: 40,
                                      fillColor: Colors.transparent,
                                      icon: Icon(
                                        Icons.calendar_today_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        print('IconButton pressed ...');
                                      },
                                    ),
                                  ],
                                ),
                                wrapWithModel(
                                  model: _model.tabGroupModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: TabGroupWidget(
                                    label2: 'Monthly',
                                    label2Present: true,
                                    label3: 'Yearly',
                                    label3Present: true,
                                    label4: '',
                                    label4Present: false,
                                    label5: '',
                                    label5Present: false,
                                    label1: 'Daily',
                                  ),
                                ),
                              ].divide(SizedBox(height: 16)),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: wrapWithModel(
                            model: _model.summaryCardModel1,
                            updateCallback: () => safeSetState(() {}),
                            child: SummaryCardWidget(
                              color: FlutterFlowTheme.of(context).success,
                              icon: Icon(
                                Icons.north_east_rounded,
                                color: FlutterFlowTheme.of(context).success,
                                size: 18,
                              ),
                              label: 'Total Income',
                              value: '4,850',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: wrapWithModel(
                            model: _model.summaryCardModel2,
                            updateCallback: () => safeSetState(() {}),
                            child: SummaryCardWidget(
                              color: FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.south_west_rounded,
                                color: FlutterFlowTheme.of(context).success,
                                size: 18,
                              ),
                              label: 'Total Spend',
                              value: '2,400',
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 16)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Container(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(20),
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Expense Breakdown',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                        lineHeight: 1.4,
                                      ),
                                ),
                                wrapWithModel(
                                  model: _model.pieChartModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: PieChartWidget(
                                    centerValue: '',
                                    centerValuePresent: false,
                                    centerLabel: '',
                                    centerLabelPresent: false,
                                    data: '42,28,15,10,5',
                                    labels: 'Food,Commute,Data,Rent,Misc',
                                    colors:
                                        'primary,accent,warning,info,divider',
                                    animate: false,
                                    startAngle: -90.0,
                                    variant: 'donut',
                                    size: 'medium',
                                    legend: 'right',
                                    legendValue: 'percent',
                                    ring: 'thick',
                                    gap: 'tight',
                                  ),
                                ),
                                Divider(
                                  height: 16,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    wrapWithModel(
                                      model: _model.reportListItemModel1,
                                      updateCallback: () => safeSetState(() {}),
                                      child: ReportListItemWidget(
                                        amount: '1,008.00',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        percent: '42',
                                        title: 'Food & Groceries',
                                      ),
                                    ),
                                    wrapWithModel(
                                      model: _model.reportListItemModel2,
                                      updateCallback: () => safeSetState(() {}),
                                      child: ReportListItemWidget(
                                        amount: '672.00',
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        percent: '28',
                                        title: 'Commute & Fuel',
                                      ),
                                    ),
                                    wrapWithModel(
                                      model: _model.reportListItemModel3,
                                      updateCallback: () => safeSetState(() {}),
                                      child: ReportListItemWidget(
                                        amount: '360.00',
                                        color: FlutterFlowTheme.of(context)
                                            .warning,
                                        percent: '15',
                                        title: 'Data & Airtime',
                                      ),
                                    ),
                                    wrapWithModel(
                                      model: _model.reportListItemModel4,
                                      updateCallback: () => safeSetState(() {}),
                                      child: ReportListItemWidget(
                                        amount: '240.00',
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        percent: '10',
                                        title: 'Rent & Utilities',
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 16)),
                                ),
                              ].divide(SizedBox(height: 24)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            wrapWithModel(
                              model: _model.buttonModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: ButtonWidget(
                                icon: Icon(
                                  Icons.share_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24,
                                ),
                                iconPresent: true,
                                iconEndPresent: false,
                                content: 'Send Report Now',
                                variant: 'primary',
                                size: 'medium',
                                fullWidth: true,
                                loading: false,
                                disabled: false,
                              ),
                            ),
                            wrapWithModel(
                              model: _model.buttonModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: ButtonWidget(
                                icon: Icon(
                                  Icons.description_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24,
                                ),
                                iconPresent: true,
                                iconEndPresent: false,
                                content: 'Export CSV History',
                                variant: 'outline',
                                size: 'medium',
                                fullWidth: true,
                                loading: false,
                                disabled: false,
                              ),
                            ),
                          ].divide(SizedBox(height: 16)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: Container(
                child: wrapWithModel(
                  model: _model.bottomNavModel,
                  updateCallback: () => safeSetState(() {}),
                  child: BottomNavWidget(
                    child: () => BottomNavChild6Widget(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
