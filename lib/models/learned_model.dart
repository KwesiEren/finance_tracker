import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/bottom_nav_child7/bottom_nav_child7_widget.dart';
import '/components/pattern_card/pattern_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'learned_patterns_widget.dart' show LearnedPatternsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LearnedPatternsModel extends FlutterFlowModel<LearnedPatternsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for PatternCard.
  late PatternCardModel patternCardModel1;
  // Model for PatternCard.
  late PatternCardModel patternCardModel2;
  // Model for PatternCard.
  late PatternCardModel patternCardModel3;
  // Model for PatternCard.
  late PatternCardModel patternCardModel4;
  // Model for PatternCard.
  late PatternCardModel patternCardModel5;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    patternCardModel1 = createModel(context, () => PatternCardModel());
    patternCardModel2 = createModel(context, () => PatternCardModel());
    patternCardModel3 = createModel(context, () => PatternCardModel());
    patternCardModel4 = createModel(context, () => PatternCardModel());
    patternCardModel5 = createModel(context, () => PatternCardModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    patternCardModel1.dispose();
    patternCardModel2.dispose();
    patternCardModel3.dispose();
    patternCardModel4.dispose();
    patternCardModel5.dispose();
    bottomNavModel.dispose();
  }
}
