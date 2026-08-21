import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/bottom_nav_child5/bottom_nav_child5_widget.dart';
import '/components/category_card/category_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'category_management_model.dart';
export 'category_management_model.dart';

class CategoryManagementWidget extends StatefulWidget {
  const CategoryManagementWidget({super.key});

  static String routeName = 'CategoryManagement';
  static String routePath = '/categoryManagement';

  @override
  State<CategoryManagementWidget> createState() =>
      _CategoryManagementWidgetState();
}

class _CategoryManagementWidgetState extends State<CategoryManagementWidget> {
  late CategoryManagementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategoryManagementModel());
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('FAB pressed ...');
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          icon: Icon(
            Icons.add_rounded,
            color: FlutterFlowTheme.of(context).onPrimary,
            size: 24,
          ),
          elevation: 0,
          label: Text(
            'New Category',
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).onPrimary,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  lineHeight: 1.3,
                ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 32, 24, 24),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Categories',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .onPrimary,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontStyle,
                                          lineHeight: 1.25,
                                        ),
                                  ),
                                  Text(
                                    'Manage your spending buckets',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .onPrimary80,
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
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color:
                                      FlutterFlowTheme.of(context).onPrimary20,
                                  borderRadius: BorderRadius.circular(9999),
                                  shape: BoxShape.rectangle,
                                ),
                                alignment: AlignmentDirectional(0, 0),
                                child: Icon(
                                  Icons.category_rounded,
                                  color: FlutterFlowTheme.of(context).onSurface,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ].divide(SizedBox(height: 16)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(24),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Active Categories',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                                lineHeight: 1.3,
                                              ),
                                        ),
                                        Text(
                                          '6 total',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .onBackground,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontStyle,
                                                lineHeight: 1.3,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.categoryCardModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: CategoryCardWidget(
                                      cap: '400',
                                      icon: Icon(
                                        Icons.directions_bus_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24,
                                      ),
                                      name: 'Transport',
                                      tone:
                                          FlutterFlowTheme.of(context).primary,
                                      isCapped: false,
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.categoryCardModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: CategoryCardWidget(
                                      cap: '250',
                                      icon: Icon(
                                        Icons.signal_cellular_alt_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24,
                                      ),
                                      name: 'Airtime & Data',
                                      tone:
                                          FlutterFlowTheme.of(context).tertiary,
                                      isCapped: false,
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.categoryCardModel3,
                                    updateCallback: () => safeSetState(() {}),
                                    child: CategoryCardWidget(
                                      cap: '800',
                                      icon: Icon(
                                        Icons.restaurant_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24,
                                      ),
                                      name: 'Food',
                                      tone:
                                          FlutterFlowTheme.of(context).success,
                                      isCapped: false,
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.categoryCardModel4,
                                    updateCallback: () => safeSetState(() {}),
                                    child: CategoryCardWidget(
                                      cap: '300',
                                      icon: Icon(
                                        Icons.electric_bolt_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24,
                                      ),
                                      name: 'Utilities',
                                      tone:
                                          FlutterFlowTheme.of(context).warning,
                                      isCapped: false,
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.categoryCardModel5,
                                    updateCallback: () => safeSetState(() {}),
                                    child: CategoryCardWidget(
                                      cap: '500',
                                      icon: Icon(
                                        Icons.payments_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24,
                                      ),
                                      name: 'Debt Repayment',
                                      tone: FlutterFlowTheme.of(context).error,
                                      isCapped: false,
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.categoryCardModel6,
                                    updateCallback: () => safeSetState(() {}),
                                    child: CategoryCardWidget(
                                      cap: '0',
                                      icon: Icon(
                                        Icons.account_balance_wallet_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24,
                                      ),
                                      name: 'Salary',
                                      tone: FlutterFlowTheme.of(context).info,
                                      isCapped: false,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .surfaceVariant30,
                                      borderRadius: BorderRadius.circular(12),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(24),
                                      child: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.info_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 18,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Uncapped categories (like Salary) are tracked for income but won\'t trigger overspend alerts.',
                                                style: FlutterFlowTheme.of(
                                                        context)
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
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
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
                                                      lineHeight: 1.4,
                                                    ),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 8)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 100,
                                  ),
                                ].divide(SizedBox(height: 16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: Container(
                child: wrapWithModel(
                  model: _model.bottomNavModel,
                  updateCallback: () => safeSetState(() {}),
                  child: BottomNavWidget(
                    child: () => BottomNavChild5Widget(),
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
