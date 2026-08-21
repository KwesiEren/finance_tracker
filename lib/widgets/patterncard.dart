import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'pattern_card_widget.dart' show PatternCardWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PatternCardModel extends FlutterFlowModel<PatternCardWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pattern_card_model.dart';
export 'pattern_card_model.dart';

class PatternCardWidget extends StatefulWidget {
  const PatternCardWidget({
    super.key,
    String? amountPreview,
    String? category,
    this.icon,
    String? sender,
    Color? tone,
  })  : this.amountPreview = amountPreview ?? 'Amt: GH₵...',
        this.category = category ?? 'MoMo Transfer',
        this.sender = sender ?? 'MTN MobileMoney',
        this.tone = tone ?? const Color(0x00000000);

  final String amountPreview;
  final String category;
  final Widget? icon;
  final String sender;
  final Color tone;

  @override
  State<PatternCardWidget> createState() => _PatternCardWidgetState();
}

class _PatternCardWidgetState extends State<PatternCardWidget> {
  late PatternCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PatternCardModel());
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
                  borderRadius: BorderRadius.circular(12),
                  shape: BoxShape.rectangle,
                ),
                child: widget!.icon!,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        widget!.sender,
                        'MTN MobileMoney',
                      ),
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                            lineHeight: 1.4,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget!.category,
                            'MoMo Transfer',
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
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(9999),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            widget!.amountPreview,
                            'Amt: GH₵...',
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
                      ].divide(SizedBox(width: 4)),
                    ),
                  ].divide(SizedBox(height: 4)),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 8,
                    buttonSize: 40,
                    fillColor: Colors.transparent,
                    icon: Icon(
                      Icons.edit_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 8,
                    buttonSize: 40,
                    fillColor: Colors.transparent,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: FlutterFlowTheme.of(context).error,
                      size: 20,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ].divide(SizedBox(width: 8)),
              ),
            ].divide(SizedBox(width: 16)),
          ),
        ),
      ),
    );
  }
}
