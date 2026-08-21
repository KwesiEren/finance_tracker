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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'settings_model.dart';
export 'settings_model.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  static String routeName = 'Settings';
  static String routePath = '/settings';

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late SettingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsModel());
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
                    padding: EdgeInsetsDirectional.fromSTEB(24, 32, 24, 16),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Settings',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                  lineHeight: 1.25,
                                ),
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 8,
                            buttonSize: 40,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.help_outline_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
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
              child: Container(
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      wrapWithModel(
                        model: _model.settingsGroupHeaderModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: SettingsGroupHeaderWidget(
                          title: 'FINANCIAL CONFIGURATION',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  wrapWithModel(
                                    model: _model.settingsRowModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SettingsRowWidget(
                                      icon: Icon(
                                        Icons.payments_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22,
                                      ),
                                      label: 'Primary Currency',
                                      showDivider: 'Show Divider',
                                      showDividerPresent: true,
                                      value: 'Ghanaian Cedi (GHS)',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.settingsRowModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SettingsRowWidget(
                                      icon: Icon(
                                        Icons.calendar_month_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22,
                                      ),
                                      label: 'Monthly Payday',
                                      showDivider: 'Show Divider',
                                      showDividerPresent: true,
                                      value: '25th of every month',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.settingsRowModel3,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SettingsRowWidget(
                                      icon: Icon(
                                        Icons.speed_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22,
                                      ),
                                      label: 'Daily Safe-Spend Logic',
                                      showDivider: 'false',
                                      showDividerPresent: false,
                                      value: 'Remaining / Days Left',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.settingsGroupHeaderModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: SettingsGroupHeaderWidget(
                          title: 'NOTIFICATIONS & ALERTS',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  wrapWithModel(
                                    model: _model.settingsRowModel4,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SettingsRowWidget(
                                      icon: Icon(
                                        Icons.notifications_active_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22,
                                      ),
                                      label: 'Budget Warning Threshold',
                                      showDivider: 'Show Divider',
                                      showDividerPresent: true,
                                      value: '80% of monthly cap',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.settingsRowModel5,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SettingsRowWidget(
                                      icon: Icon(
                                        Icons.assessment_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22,
                                      ),
                                      label: 'Scheduled Reports',
                                      showDivider: 'Show Divider',
                                      showDividerPresent: true,
                                      value: 'Daily Summary at 8:00 PM',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.settingsRowModel6,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SettingsRowWidget(
                                      icon: Icon(
                                        Icons.message_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22,
                                      ),
                                      label: 'SMS Detection',
                                      showDivider: 'false',
                                      showDividerPresent: false,
                                      value: 'Enabled (Teaching Mode)',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.settingsGroupHeaderModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: SettingsGroupHeaderWidget(
                          title: 'DATA & PRIVACY',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  wrapWithModel(
                                    model: _model.settingsRowModel7,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SettingsRowWidget(
                                      icon: Icon(
                                        Icons.model_training_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22,
                                      ),
                                      label: 'Learned Patterns',
                                      showDivider: 'Show Divider',
                                      showDividerPresent: true,
                                      value: '12 SMS templates saved',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.settingsRowModel8,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SettingsRowWidget(
                                      icon: Icon(
                                        Icons.download_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22,
                                      ),
                                      label: 'Export History',
                                      showDivider: 'Show Divider',
                                      showDividerPresent: true,
                                      value: 'Generate CSV or PDF',
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.settingsRowModel9,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SettingsRowWidget(
                                      icon: Icon(
                                        Icons.lock_outline_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22,
                                      ),
                                      label: 'App Lock',
                                      showDivider: 'false',
                                      showDividerPresent: false,
                                      value: 'Biometric / PIN',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Container(
                            child: Container(
                              alignment: AlignmentDirectional(0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'CediSense v1.0.4',
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                          lineHeight: 1.3,
                                        ),
                                  ),
                                  Text(
                                    'Fully Offline Finance Tracker',
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelSmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
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
                                  Container(
                                    height: 40,
                                  ),
                                  wrapWithModel(
                                    model: _model.buttonModel,
                                    updateCallback: () => safeSetState(() {}),
                                    child: ButtonWidget(
                                      iconPresent: false,
                                      iconEndPresent: false,
                                      content: 'Delete All Local Data',
                                      variant: 'destructive',
                                      size: 'small',
                                      fullWidth: false,
                                      loading: false,
                                      disabled: false,
                                    ),
                                  ),
                                ].divide(SizedBox(height: 4)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: Container(
                child: wrapWithModel(
                  model: _model.bottomNavModel,
                  updateCallback: () => safeSetState(() {}),
                  child: BottomNavWidget(
                    child: () => BottomNavChild8Widget(),
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
