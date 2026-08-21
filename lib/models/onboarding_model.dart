import '/components/button/button_widget.dart';
import '/components/sms_token/sms_token_widget.dart';
import '/components/step_indicator/step_indicator_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'onboarding_widget.dart' show OnboardingWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OnboardingModel extends FlutterFlowModel<OnboardingWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for StepIndicator.
  late StepIndicatorModel stepIndicatorModel;
  // Model for SmsToken.
  late SmsTokenModel smsTokenModel1;
  // Model for SmsToken.
  late SmsTokenModel smsTokenModel2;
  // Model for SmsToken.
  late SmsTokenModel smsTokenModel3;
  // Model for SmsToken.
  late SmsTokenModel smsTokenModel4;
  // Model for SmsToken.
  late SmsTokenModel smsTokenModel5;
  // Model for SmsToken.
  late SmsTokenModel smsTokenModel6;
  // Model for SmsToken.
  late SmsTokenModel smsTokenModel7;
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for Button.
  late ButtonModel buttonModel2;

  @override
  void initState(BuildContext context) {
    stepIndicatorModel = createModel(context, () => StepIndicatorModel());
    smsTokenModel1 = createModel(context, () => SmsTokenModel());
    smsTokenModel2 = createModel(context, () => SmsTokenModel());
    smsTokenModel3 = createModel(context, () => SmsTokenModel());
    smsTokenModel4 = createModel(context, () => SmsTokenModel());
    smsTokenModel5 = createModel(context, () => SmsTokenModel());
    smsTokenModel6 = createModel(context, () => SmsTokenModel());
    smsTokenModel7 = createModel(context, () => SmsTokenModel());
    buttonModel1 = createModel(context, () => ButtonModel());
    buttonModel2 = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    stepIndicatorModel.dispose();
    smsTokenModel1.dispose();
    smsTokenModel2.dispose();
    smsTokenModel3.dispose();
    smsTokenModel4.dispose();
    smsTokenModel5.dispose();
    smsTokenModel6.dispose();
    smsTokenModel7.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
  }
}
