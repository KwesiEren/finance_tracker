import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'step_indicator_model.dart';
export 'step_indicator_model.dart';

class StepIndicatorWidget extends StatefulWidget {
  const StepIndicatorWidget({
    super.key,
    double? total,
    String? current,
  })  : this.total = total ?? 3.0,
        this.current = current ?? '2';

  final double total;
  final String current;

  @override
  State<StepIndicatorWidget> createState() => _StepIndicatorWidgetState();
}

class _StepIndicatorWidgetState extends State<StepIndicatorWidget> {
  late StepIndicatorModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StepIndicatorModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 4,
          decoration: BoxDecoration(
            color: valueOrDefault<Color>(
              valueOrDefault<String>(
                        widget!.current,
                        '2',
                      ) >=
                      '1.0'
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
              FlutterFlowTheme.of(context).primary,
            ),
            borderRadius: BorderRadius.circular(9999),
            shape: BoxShape.rectangle,
          ),
        ),
        Container(
          width: 24,
          height: 4,
          decoration: BoxDecoration(
            color: valueOrDefault<Color>(
              valueOrDefault<String>(
                        widget!.current,
                        '2',
                      ) >=
                      '2.0'
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
              FlutterFlowTheme.of(context).primary,
            ),
            borderRadius: BorderRadius.circular(9999),
            shape: BoxShape.rectangle,
          ),
        ),
        Container(
          width: 24,
          height: 4,
          decoration: BoxDecoration(
            color: valueOrDefault<Color>(
              valueOrDefault<String>(
                        widget!.current,
                        '2',
                      ) >=
                      '3.0'
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
              FlutterFlowTheme.of(context).alternate,
            ),
            borderRadius: BorderRadius.circular(9999),
            shape: BoxShape.rectangle,
          ),
        ),
      ].divide(SizedBox(width: 4)),
    );
  }
}
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'step_indicator_widget.dart' show StepIndicatorWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StepIndicatorModel extends FlutterFlowModel<StepIndicatorWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
