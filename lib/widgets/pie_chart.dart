import '/components/chart_legend/chart_legend_widget.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'pie_chart_widget.dart' show PieChartWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PieChartModel extends FlutterFlowModel<PieChartWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for ChartLegend.
  late ChartLegendModel chartLegendModel1;
  // Model for ChartLegend.
  late ChartLegendModel chartLegendModel2;

  @override
  void initState(BuildContext context) {
    chartLegendModel1 = createModel(context, () => ChartLegendModel());
    chartLegendModel2 = createModel(context, () => ChartLegendModel());
  }

  @override
  void dispose() {
    chartLegendModel1.dispose();
    chartLegendModel2.dispose();
  }
}
import '/components/chart_legend/chart_legend_widget.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pie_chart_model.dart';
export 'pie_chart_model.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({
    super.key,
    String? centerValue,
    bool? centerValuePresent,
    String? centerLabel,
    bool? centerLabelPresent,
    String? data,
    String? labels,
    String? colors,
    bool? animate,
    double? startAngle,
    String? variant,
    String? size,
    String? legend,
    String? legendValue,
    String? ring,
    String? gap,
  })  : this.centerValue = centerValue ?? '',
        this.centerValuePresent = centerValuePresent ?? false,
        this.centerLabel = centerLabel ?? '',
        this.centerLabelPresent = centerLabelPresent ?? false,
        this.data = data ?? '42,28,15,10,5',
        this.labels = labels ?? 'Food,Commute,Data,Rent,Misc',
        this.colors = colors ?? 'primary,accent,warning,info,divider',
        this.animate = animate ?? false,
        this.startAngle = startAngle ?? -90.0,
        this.variant = variant ?? 'donut',
        this.size = size ?? 'medium',
        this.legend = legend ?? 'right',
        this.legendValue = legendValue ?? 'percent',
        this.ring = ring ?? 'thick',
        this.gap = gap ?? 'tight';

  final String centerValue;
  final bool centerValuePresent;
  final String centerLabel;
  final bool centerLabelPresent;
  final String data;
  final String labels;
  final String colors;
  final bool animate;
  final double startAngle;
  final String variant;
  final String size;
  final String legend;
  final String legendValue;
  final String ring;
  final String gap;

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  late PieChartModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PieChartModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pieChartPieChartColorsList1 = [
      FlutterFlowTheme.of(context).primary,
      FlutterFlowTheme.of(context).secondary,
      FlutterFlowTheme.of(context).tertiary
    ];
    final pieChartPieChartColorsList2 = [
      FlutterFlowTheme.of(context).primary,
      FlutterFlowTheme.of(context).secondary,
      FlutterFlowTheme.of(context).tertiary
    ];
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional(0, 0),
                  children: [
                    Container(
                      width: valueOrDefault<double>(
                        () {
                          if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'compact') {
                            return 120.0;
                          } else if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'large') {
                            return 200.0;
                          } else if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'expanded') {
                            return infinity;
                          } else {
                            return 156.0;
                          }
                        }(),
                        156.0,
                      ),
                      height: valueOrDefault<double>(
                        () {
                          if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'compact') {
                            return 120.0;
                          } else if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'large') {
                            return 200.0;
                          } else if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'expanded') {
                            return infinity;
                          } else {
                            return 156.0;
                          }
                        }(),
                        156.0,
                      ),
                      child: FlutterFlowPieChart(
                        data: FFPieChartData(
                          values: ((String? data) {
                            return data
                                .split(',')
                                .map((value) =>
                                    double.tryParse(value.trim()) ?? 0)
                                .toList();
                          }(valueOrDefault<String>(
                            widget!.data,
                            '42,28,15,10,5',
                          )))!,
                          colors: pieChartPieChartColorsList1,
                          radius: [50],
                        ),
                        donutHoleRadius: 30,
                        donutHoleColor: Colors.transparent,
                        sectionLabelStyle:
                            FlutterFlowTheme.of(context).labelSmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 10,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontStyle,
                                  lineHeight: 1,
                                ),
                        sectionsSpace: valueOrDefault<double>(
                          () {
                            if (valueOrDefault<String>(
                                  widget!.gap,
                                  'tight',
                                ) ==
                                'none') {
                              return 0.0;
                            } else if (valueOrDefault<String>(
                                  widget!.gap,
                                  'tight',
                                ) ==
                                'tight') {
                              return 2.0;
                            } else if (valueOrDefault<String>(
                                  widget!.gap,
                                  'tight',
                                ) ==
                                'wide') {
                              return 8.0;
                            } else {
                              return 4.0;
                            }
                          }(),
                          2.0,
                        ),
                        startDegreeOffset: valueOrDefault<double>(
                          widget!.startAngle,
                          -90.0,
                        ),
                        labelPositionOffset: 0.6,
                      ),
                    ),
                    Container(
                      width: valueOrDefault<double>(
                        () {
                          if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'compact') {
                            return 120.0;
                          } else if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'large') {
                            return 200.0;
                          } else if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'expanded') {
                            return infinity;
                          } else {
                            return 156.0;
                          }
                        }(),
                        156.0,
                      ),
                      height: valueOrDefault<double>(
                        () {
                          if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'compact') {
                            return 120.0;
                          } else if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'large') {
                            return 200.0;
                          } else if (valueOrDefault<String>(
                                widget!.size,
                                'medium',
                              ) ==
                              'expanded') {
                            return infinity;
                          } else {
                            return 156.0;
                          }
                        }(),
                        156.0,
                      ),
                      child: FlutterFlowPieChart(
                        data: FFPieChartData(
                          values: ((String? data) {
                            return data
                                .split(',')
                                .map((value) =>
                                    double.tryParse(value.trim()) ?? 0)
                                .toList();
                          }(valueOrDefault<String>(
                            widget!.data,
                            '42,28,15,10,5',
                          )))!,
                          colors: pieChartPieChartColorsList2,
                          radius: [50],
                        ),
                        donutHoleRadius: 0,
                        donutHoleColor: Colors.transparent,
                        sectionLabelStyle:
                            FlutterFlowTheme.of(context).labelSmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 10,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontStyle,
                                  lineHeight: 1,
                                ),
                        sectionsSpace: valueOrDefault<double>(
                          () {
                            if (valueOrDefault<String>(
                                  widget!.gap,
                                  'tight',
                                ) ==
                                'none') {
                              return 0.0;
                            } else if (valueOrDefault<String>(
                                  widget!.gap,
                                  'tight',
                                ) ==
                                'tight') {
                              return 2.0;
                            } else if (valueOrDefault<String>(
                                  widget!.gap,
                                  'tight',
                                ) ==
                                'wide') {
                              return 8.0;
                            } else {
                              return 4.0;
                            }
                          }(),
                          2.0,
                        ),
                        startDegreeOffset: valueOrDefault<double>(
                          widget!.startAngle,
                          -90.0,
                        ),
                        labelPositionOffset: 0.6,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget!.centerValue,
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: GoogleFonts.plusJakartaSans(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                                lineHeight: 1.4,
                              ),
                        ),
                        Text(
                          widget!.centerLabel,
                          textAlign: TextAlign.center,
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
                      ].divide(SizedBox(height: 0)),
                    ),
                  ],
                ),
                wrapWithModel(
                  model: _model.chartLegendModel1,
                  updateCallback: () => safeSetState(() {}),
                  child: ChartLegendWidget(
                    data: valueOrDefault<String>(
                      widget!.data,
                      '42,28,15,10,5',
                    ),
                    labels: valueOrDefault<String>(
                      widget!.labels,
                      'Food,Commute,Data,Rent,Misc',
                    ),
                    colors: valueOrDefault<String>(
                      widget!.colors,
                      'primary,accent,warning,info,divider',
                    ),
                    markerSize: 8.0,
                    spacing: 6.0,
                    runSpacing: 8.0,
                    labelColor: FlutterFlowTheme.of(context).primaryText,
                    valueColor: FlutterFlowTheme.of(context).secondaryText,
                    textStyle: 'label_small',
                    valueStyle: 'label_small',
                    labelMaxWidth: 0.0,
                    direction: 'vertical',
                    valueMode: 'percent',
                  ),
                ),
              ],
            ),
          ),
          wrapWithModel(
            model: _model.chartLegendModel2,
            updateCallback: () => safeSetState(() {}),
            child: ChartLegendWidget(
              data: valueOrDefault<String>(
                widget!.data,
                '42,28,15,10,5',
              ),
              labels: valueOrDefault<String>(
                widget!.labels,
                'Food,Commute,Data,Rent,Misc',
              ),
              colors: valueOrDefault<String>(
                widget!.colors,
                'primary,accent,warning,info,divider',
              ),
              markerSize: 8.0,
              spacing: 6.0,
              runSpacing: 8.0,
              labelColor: FlutterFlowTheme.of(context).primaryText,
              valueColor: FlutterFlowTheme.of(context).secondaryText,
              textStyle: 'label_small',
              valueStyle: 'label_small',
              labelMaxWidth: 0.0,
              direction: 'horizontal',
              valueMode: 'percent',
            ),
          ),
        ].divide(SizedBox(height: 12)),
      ),
    );
  }
}
