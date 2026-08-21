import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'budget_row_model.dart';
export 'budget_row_model.dart';

class BudgetRowWidget extends StatefulWidget {
  const BudgetRowWidget({
    super.key,
    String? category,
    String? spent,
    Color? tone,
    String? total,
  })  : this.category = category ?? 'Groceries & Food',
        this.spent = spent ?? '420',
        this.tone = tone ?? const Color(0x00000000),
        this.total = total ?? '600';

  final String category;
  final String spent;
  final Color tone;
  final String total;

  @override
  State<BudgetRowWidget> createState() => _BudgetRowWidgetState();
}

class _BudgetRowWidgetState extends State<BudgetRowWidget> {
  late BudgetRowModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BudgetRowModel());
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
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: valueOrDefault<Color>(
                    widget!.tone,
                    FlutterFlowTheme.of(context).primary,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                ),
                child: Icon(
                  Icons.help,
                  color: valueOrDefault<Color>(
                    widget!.tone,
                    FlutterFlowTheme.of(context).primary,
                  ),
                  size: 24,
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
                            widget!.category,
                            'Groceries & Food',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                font: GoogleFonts.plusJakartaSans(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                                lineHeight: 1.4,
                              ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            'GHâµ ${widget!.spent} / ${widget!.total}',
                            'GHâµ 420 / 600',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .labelSmall
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                      ],
                    ),
                    LinearPercentIndicator(
                      percent: 0.65,
                      lineHeight: 8,
                      animation: true,
                      animateFromLastPercent: true,
                      progressColor: valueOrDefault<Color>(
                        widget!.tone,
                        FlutterFlowTheme.of(context).primary,
                      ),
                      backgroundColor:
                          FlutterFlowTheme.of(context).surfaceVariant,
                      barRadius: Radius.circular(9999),
                      padding: EdgeInsets.zero,
                    ),
                  ].divide(SizedBox(height: 4)),
                ),
              ),
            ].divide(SizedBox(width: 16)),
          ),
        ),
      ),
    );
  }
}
