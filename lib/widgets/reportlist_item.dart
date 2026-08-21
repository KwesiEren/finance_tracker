import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'report_list_item_model.dart';
export 'report_list_item_model.dart';

class ReportListItemWidget extends StatefulWidget {
  const ReportListItemWidget({
    super.key,
    String? amount,
    Color? color,
    String? percent,
    String? title,
  })  : this.amount = amount ?? '1,008.00',
        this.color = color ?? const Color(0x00000000),
        this.percent = percent ?? '42',
        this.title = title ?? 'Food & Groceries';

  final String amount;
  final Color color;
  final String percent;
  final String title;

  @override
  State<ReportListItemWidget> createState() => _ReportListItemWidgetState();
}

class _ReportListItemWidgetState extends State<ReportListItemWidget> {
  late ReportListItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportListItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: valueOrDefault<Color>(
              widget!.color,
              FlutterFlowTheme.of(context).primary,
            ),
            borderRadius: BorderRadius.circular(9999),
            shape: BoxShape.rectangle,
          ),
        ),
        Expanded(
          flex: 1,
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
                  Text(
                    valueOrDefault<String>(
                      widget!.title,
                      'Food & Groceries',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                          lineHeight: 1.5,
                        ),
                  ),
                  Text(
                    valueOrDefault<String>(
                      'GHâµ ${widget!.amount}',
                      'GHâµ 1,008.00',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                          lineHeight: 1.5,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: LinearPercentIndicator(
                      percent: 0,
                      lineHeight: 6,
                      animation: true,
                      animateFromLastPercent: true,
                      progressColor: valueOrDefault<Color>(
                        widget!.color,
                        FlutterFlowTheme.of(context).primary,
                      ),
                      backgroundColor:
                          FlutterFlowTheme.of(context).surfaceVariant,
                      barRadius: Radius.circular(9999),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Container(
                    width: 32,
                    child: Text(
                      valueOrDefault<String>(
                        '${widget!.percent}%',
                        '42%',
                      ),
                      style: FlutterFlowTheme.of(context).labelSmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelSmall
                                .fontStyle,
                            lineHeight: 1.3,
                          ),
                    ),
                  ),
                ].divide(SizedBox(width: 8)),
              ),
            ].divide(SizedBox(height: 4)),
          ),
        ),
      ].divide(SizedBox(width: 16)),
    );
  }
}
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'report_list_item_widget.dart' show ReportListItemWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ReportListItemModel extends FlutterFlowModel<ReportListItemWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
