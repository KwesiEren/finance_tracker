import '/components/tab_item/tab_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'tab_group_model.dart';
export 'tab_group_model.dart';

class TabGroupWidget extends StatefulWidget {
  const TabGroupWidget({
    super.key,
    String? label2,
    bool? label2Present,
    String? label3,
    bool? label3Present,
    String? label4,
    bool? label4Present,
    String? label5,
    bool? label5Present,
    String? label1,
  })  : this.label2 = label2 ?? 'Monthly',
        this.label2Present = label2Present ?? true,
        this.label3 = label3 ?? 'Yearly',
        this.label3Present = label3Present ?? true,
        this.label4 = label4 ?? '',
        this.label4Present = label4Present ?? false,
        this.label5 = label5 ?? '',
        this.label5Present = label5Present ?? false,
        this.label1 = label1 ?? 'Daily';

  final String label2;
  final bool label2Present;
  final String label3;
  final bool label3Present;
  final String label4;
  final bool label4Present;
  final String label5;
  final bool label5Present;
  final String label1;

  @override
  State<TabGroupWidget> createState() => _TabGroupWidgetState();
}

class _TabGroupWidgetState extends State<TabGroupWidget> {
  late TabGroupModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TabGroupModel());
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
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: wrapWithModel(
                model: _model.tabItemModel1,
                updateCallback: () => safeSetState(() {}),
                child: TabItemWidget(
                  label: valueOrDefault<String>(
                    widget!.label1,
                    'Daily',
                  ),
                  selected: true,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: wrapWithModel(
                model: _model.tabItemModel2,
                updateCallback: () => safeSetState(() {}),
                child: TabItemWidget(
                  label: valueOrDefault<String>(
                    widget!.label2,
                    'Monthly',
                  ),
                  selected: false,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: wrapWithModel(
                model: _model.tabItemModel3,
                updateCallback: () => safeSetState(() {}),
                child: TabItemWidget(
                  label: valueOrDefault<String>(
                    widget!.label3,
                    'Yearly',
                  ),
                  selected: false,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: wrapWithModel(
                model: _model.tabItemModel4,
                updateCallback: () => safeSetState(() {}),
                child: TabItemWidget(
                  label: widget!.label4,
                  selected: false,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: wrapWithModel(
                model: _model.tabItemModel5,
                updateCallback: () => safeSetState(() {}),
                child: TabItemWidget(
                  label: widget!.label5,
                  selected: false,
                ),
              ),
            ),
          ].divide(SizedBox(width: 0)),
        ),
      ),
    );
  }
}
import '/components/tab_item/tab_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'tab_group_widget.dart' show TabGroupWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TabGroupModel extends FlutterFlowModel<TabGroupWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for TabItem.
  late TabItemModel tabItemModel1;
  // Model for TabItem.
  late TabItemModel tabItemModel2;
  // Model for TabItem.
  late TabItemModel tabItemModel3;
  // Model for TabItem.
  late TabItemModel tabItemModel4;
  // Model for TabItem.
  late TabItemModel tabItemModel5;

  @override
  void initState(BuildContext context) {
    tabItemModel1 = createModel(context, () => TabItemModel());
    tabItemModel2 = createModel(context, () => TabItemModel());
    tabItemModel3 = createModel(context, () => TabItemModel());
    tabItemModel4 = createModel(context, () => TabItemModel());
    tabItemModel5 = createModel(context, () => TabItemModel());
  }

  @override
  void dispose() {
    tabItemModel1.dispose();
    tabItemModel2.dispose();
    tabItemModel3.dispose();
    tabItemModel4.dispose();
    tabItemModel5.dispose();
  }
}
