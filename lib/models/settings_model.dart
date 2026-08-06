enum ReportFrequency { daily, monthly }

class SettingsModel {
  final String currencySymbol;
  final int paydayDayOfMonth; // e.g. 1st, 15th — used for "days until payday"
  final ReportFrequency reportFrequency;
  final double capAlertThreshold; // e.g. 0.8 = alert at 80% of cap

  const SettingsModel({
    this.currencySymbol = 'GHS',
    this.paydayDayOfMonth = 1,
    this.reportFrequency = ReportFrequency.monthly,
    this.capAlertThreshold = 0.8,
  });

  SettingsModel copyWith({
    String? currencySymbol,
    int? paydayDayOfMonth,
    ReportFrequency? reportFrequency,
    double? capAlertThreshold,
  }) =>
      SettingsModel(
        currencySymbol: currencySymbol ?? this.currencySymbol,
        paydayDayOfMonth: paydayDayOfMonth ?? this.paydayDayOfMonth,
        reportFrequency: reportFrequency ?? this.reportFrequency,
        capAlertThreshold: capAlertThreshold ?? this.capAlertThreshold,
      );
}
