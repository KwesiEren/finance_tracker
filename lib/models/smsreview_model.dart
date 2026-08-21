import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/bottom_nav_child2/bottom_nav_child2_widget.dart';
import '/components/sms_review_card/sms_review_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 's_m_s_review_queue_widget.dart' show SMSReviewQueueWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SMSReviewQueueModel extends FlutterFlowModel<SMSReviewQueueWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for SmsReviewCard.
  late SmsReviewCardModel smsReviewCardModel1;
  // Model for SmsReviewCard.
  late SmsReviewCardModel smsReviewCardModel2;
  // Model for SmsReviewCard.
  late SmsReviewCardModel smsReviewCardModel3;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    smsReviewCardModel1 = createModel(context, () => SmsReviewCardModel());
    smsReviewCardModel2 = createModel(context, () => SmsReviewCardModel());
    smsReviewCardModel3 = createModel(context, () => SmsReviewCardModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    smsReviewCardModel1.dispose();
    smsReviewCardModel2.dispose();
    smsReviewCardModel3.dispose();
    bottomNavModel.dispose();
  }
}
