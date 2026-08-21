import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'settings_row_widget.dart' show SettingsRowWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsRowModel extends FlutterFlowModel<SettingsRowWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'settings_row_model.dart';
export 'settings_row_model.dart';

class SettingsRowWidget extends StatefulWidget {
  const SettingsRowWidget({
    super.key,
    this.icon,
    String? label,
    String? showDivider,
    bool? showDividerPresent,
    String? value,
  })  : this.label = label ?? 'Primary Currency',
        this.showDivider = showDivider ?? 'Show Divider',
        this.showDividerPresent = showDividerPresent ?? true,
        this.value = value ?? 'Ghanaian Cedi (GHS)';

  final Widget? icon;
  final String label;
  final String showDivider;
  final bool showDividerPresent;
  final String value;

  @override
  State<SettingsRowWidget> createState() => _SettingsRowWidgetState();
}

class _SettingsRowWidgetState extends State<SettingsRowWidget> {
  late SettingsRowModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsRowModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 24),
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget!.icon!,
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget!.label,
                            'Primary Currency',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontStyle,
                                lineHeight: 1.5,
                              ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            widget!.value,
                            'Ghanaian Cedi (GHS)',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                                lineHeight: 1.4,
                              ),
                        ),
                      ].divide(SizedBox(height: 4)),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: FlutterFlowTheme.of(context).accent3,
                    size: 20,
                  ),
                ].divide(SizedBox(width: 16)),
              ),
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(56, 0, 0, 0),
            child: Container(
              child: Divider(
                height: 16,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: FlutterFlowTheme.of(context).alternate,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
