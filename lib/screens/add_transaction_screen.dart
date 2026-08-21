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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'add_transaction_model.dart';
export 'add_transaction_model.dart';

class AddTransactionWidget extends StatefulWidget {
  const AddTransactionWidget({super.key});

  static String routeName = 'AddTransaction';
  static String routePath = '/addTransaction';

  @override
  State<AddTransactionWidget> createState() => _AddTransactionWidgetState();
}

class _AddTransactionWidgetState extends State<AddTransactionWidget> {
  late AddTransactionModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddTransactionModel());
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
          mainAxisSize: MainAxisSize.max,
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
                    padding: EdgeInsetsDirectional.fromSTEB(24, 32, 24, 24),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8,
                            buttonSize: 40,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.close_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                          Text(
                            'Manual Entry',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                  lineHeight: 1.4,
                                ),
                          ),
                          Container(
                            width: 40,
                          ),
                        ],
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
            Expanded(
              flex: 1,
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
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'HOW MUCH?',
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                        lineHeight: 1.3,
                                      ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'GHâµ',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineLarge
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .fontStyle,
                                            lineHeight: 1.2,
                                          ),
                                    ),
                                    Container(
                                      width: 180,
                                      child: wrapWithModel(
                                        model: _model.textFieldModel1,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: TextFieldWidget(
                                          label: '',
                                          labelPresent: false,
                                          helper: '',
                                          helperPresent: false,
                                          leadingIconPresent: false,
                                          trailingIconPresent: false,
                                          hint: '0.00',
                                          value: '0.00',
                                          onChange: '',
                                          onSubmit: '',
                                          variant: 'ghost',
                                          error: false,
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 8)),
                                ),
                              ].divide(SizedBox(height: 4)),
                            ),
                            Column(
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
                                    Text(
                                      'Select Category',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                            lineHeight: 1.4,
                                          ),
                                    ),
                                    Text(
                                      'Edit List',
                                      style: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontStyle,
                                            lineHeight: 1.3,
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: wrapWithModel(
                                            model:
                                                _model.categorySelectorModel1,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: CategorySelectorWidget(
                                              icon: Icon(
                                                Icons.restaurant_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .onPrimary,
                                                size: 24,
                                              ),
                                              label: 'Food',
                                              selected: true,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: wrapWithModel(
                                            model:
                                                _model.categorySelectorModel2,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: CategorySelectorWidget(
                                              icon: Icon(
                                                Icons.directions_bus_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .onPrimary,
                                                size: 24,
                                              ),
                                              label: 'Transport',
                                              selected: true,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: wrapWithModel(
                                            model:
                                                _model.categorySelectorModel3,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: CategorySelectorWidget(
                                              icon: Icon(
                                                Icons
                                                    .signal_cellular_alt_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .onPrimary,
                                                size: 24,
                                              ),
                                              label: 'Airtime',
                                              selected: true,
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 16)),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: wrapWithModel(
                                            model:
                                                _model.categorySelectorModel4,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: CategorySelectorWidget(
                                              icon: Icon(
                                                Icons.electric_bolt_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .onPrimary,
                                                size: 24,
                                              ),
                                              label: 'Utilities',
                                              selected: true,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: wrapWithModel(
                                            model:
                                                _model.categorySelectorModel5,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: CategorySelectorWidget(
                                              icon: Icon(
                                                Icons.payments_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .onPrimary,
                                                size: 24,
                                              ),
                                              label: 'Debt',
                                              selected: true,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: wrapWithModel(
                                            model:
                                                _model.categorySelectorModel6,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: CategorySelectorWidget(
                                              icon: Icon(
                                                Icons.category_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .onPrimary,
                                                size: 24,
                                              ),
                                              label: 'Other',
                                              selected: true,
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 16)),
                                    ),
                                  ].divide(SizedBox(height: 16)),
                                ),
                              ].divide(SizedBox(height: 16)),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.calendar_today_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 20,
                                              ),
                                              Text(
                                                'Date',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                      lineHeight: 1.5,
                                                    ),
                                              ),
                                            ].divide(SizedBox(width: 16)),
                                          ),
                                          Container(
                                            height: 34,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 1,
                                              ),
                                            ),
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 0, 12, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 16,
                                                  ),
                                                  Text(
                                                    'Today, Oct 24',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 14,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.3,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(width: 6)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        height: 16,
                                        thickness: 1,
                                        indent: 0,
                                        endIndent: 0,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.sticky_note_2_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 20,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: wrapWithModel(
                                              model: _model.textFieldModel2,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: TextFieldWidget(
                                                label: 'Note',
                                                labelPresent: true,
                                                helper: '',
                                                helperPresent: false,
                                                leadingIconPresent: false,
                                                trailingIconPresent: false,
                                                hint: 'Add a note (optional)',
                                                value: '',
                                                onChange: '',
                                                onSubmit: '',
                                                variant: 'ghost',
                                                error: false,
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 16)),
                                      ),
                                    ].divide(SizedBox(height: 24)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).warning20,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .onBackground,
                                        size: 18,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'This will be deducted from your \'Safe to Spend\' for today.',
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
                                                        .onSurface,
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
                                      ),
                                    ].divide(SizedBox(width: 8)),
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(height: 24)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Container(
                      child: wrapWithModel(
                        model: _model.buttonModel,
                        updateCallback: () => safeSetState(() {}),
                        child: ButtonWidget(
                          iconPresent: false,
                          iconEndPresent: false,
                          content: 'Save Transaction',
                          variant: 'primary',
                          size: 'large',
                          fullWidth: true,
                          loading: false,
                          disabled: false,
                        ),
                      ),
                    ),
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
                    child: () => BottomNavChild4Widget(),
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
