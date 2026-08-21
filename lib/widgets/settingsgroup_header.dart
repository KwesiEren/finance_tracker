import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'settings_group_header_model.dart';
export 'settings_group_header_model.dart';

class SettingsGroupHeaderWidget extends StatefulWidget {
  const SettingsGroupHeaderWidget({
    super.key,
    String? title,
  }) : this.title = title ?? 'FINANCIAL CONFIGURATION';

  final String title;

  @override
  State<SettingsGroupHeaderWidget> createState() =>
      _SettingsGroupHeaderWidgetState();
}

class _SettingsGroupHeaderWidgetState extends State<SettingsGroupHeaderWidget> {
  late SettingsGroupHeaderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsGroupHeaderModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 8),
        child: Container(
          child: Text(
            valueOrDefault<String>(
              widget!.title,
              'FINANCIAL CONFIGURATION',
            ),
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primary,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  lineHeight: 1.3,
                ),
          ),
        ),
      ),
    );
  }
}
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'settings_group_header_widget.dart' show SettingsGroupHeaderWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsGroupHeaderModel
    extends FlutterFlowModel<SettingsGroupHeaderWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
