import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'token_chip_model.dart';
export 'token_chip_model.dart';

class TokenChipWidget extends StatefulWidget {
  const TokenChipWidget({
    super.key,
    bool? isAmount,
    String? label,
    bool? isKeyword,
  })  : this.isAmount = isAmount ?? true,
        this.label = label ?? 'Payment',
        this.isKeyword = isKeyword ?? true;

  final bool isAmount;
  final String label;
  final bool isKeyword;

  @override
  State<TokenChipWidget> createState() => _TokenChipWidgetState();
}

class _TokenChipWidgetState extends State<TokenChipWidget> {
  late TokenChipModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TokenChipModel());
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
          () {
            if (valueOrDefault<bool>(
              widget!.isAmount,
              true,
            )) {
              return FlutterFlowTheme.of(context).primary;
            } else if (valueOrDefault<bool>(
              widget!.isKeyword,
              true,
            )) {
              return FlutterFlowTheme.of(context).accent15;
            } else {
              return FlutterFlowTheme.of(context).secondaryBackground;
            }
          }(),
          FlutterFlowTheme.of(context).primary,
        ),
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: valueOrDefault<Color>(
            valueOrDefault<bool>(
              widget!.isAmount,
              true,
            )
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            FlutterFlowTheme.of(context).primary,
          ),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        child: Container(
          child: Text(
            valueOrDefault<String>(
              widget!.label,
              'Payment',
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: valueOrDefault<Color>(
                    () {
                      if (valueOrDefault<bool>(
                        widget!.isAmount,
                        true,
                      )) {
                        return FlutterFlowTheme.of(context).onPrimary;
                      } else if (valueOrDefault<bool>(
                        widget!.isKeyword,
                        true,
                      )) {
                        return FlutterFlowTheme.of(context).tertiary;
                      } else {
                        return FlutterFlowTheme.of(context).primaryText;
                      }
                    }(),
                    FlutterFlowTheme.of(context).onPrimary,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  lineHeight: 1.5,
                ),
          ),
        ),
      ),
    );
  }
}
