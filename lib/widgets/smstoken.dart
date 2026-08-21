import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'sms_token_model.dart';
export 'sms_token_model.dart';

class SmsTokenWidget extends StatefulWidget {
  const SmsTokenWidget({
    super.key,
    String? text,
    bool? highlighted,
  })  : this.text = text ?? 'Payment',
        this.highlighted = highlighted ?? false;

  final String text;
  final bool highlighted;

  @override
  State<SmsTokenWidget> createState() => _SmsTokenWidgetState();
}

class _SmsTokenWidgetState extends State<SmsTokenWidget> {
  late SmsTokenModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SmsTokenModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: valueOrDefault<Color>(
          valueOrDefault<bool>(
            widget!.highlighted,
            false,
          )
              ? FlutterFlowTheme.of(context).primary15
              : FlutterFlowTheme.of(context).surfaceVariant,
          FlutterFlowTheme.of(context).surfaceVariant,
        ),
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: valueOrDefault<Color>(
            valueOrDefault<bool>(
              widget!.highlighted,
              false,
            )
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            FlutterFlowTheme.of(context).alternate,
          ),
          width: valueOrDefault<double>(
            valueOrDefault<bool>(
              widget!.highlighted,
              false,
            )
                ? 1.0
                : 1.0,
            1.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        child: Container(
          child: Text(
            valueOrDefault<String>(
              widget!.text,
              'Payment',
            ),
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  color: valueOrDefault<Color>(
                    valueOrDefault<bool>(
                      widget!.highlighted,
                      false,
                    )
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).primaryText,
                    FlutterFlowTheme.of(context).primaryText,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
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
import 'sms_token_widget.dart' show SmsTokenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SmsTokenModel extends FlutterFlowModel<SmsTokenWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
