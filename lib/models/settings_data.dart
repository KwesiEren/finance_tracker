import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsData {
  final String currencyCode;
  final String currencySymbol;
  final int payday;
  final double capAlertThreshold;
  final String reportFrequency;
  final bool smsDetectionEnabled;
  final bool onboardingComplete;
  final bool appLockEnabled;
  final bool biometricEnabled;
  final String? pinHash; // Simple PIN hash storage

  const SettingsData({
    this.currencyCode = 'GHS',
    this.currencySymbol = 'GH₵',
    this.payday = 25,
    this.capAlertThreshold = 0.8,
    this.reportFrequency = 'daily',
    this.smsDetectionEnabled = true,
    this.onboardingComplete = false,
    this.appLockEnabled = false,
    this.biometricEnabled = false,
    this.pinHash,
  });

  SettingsData copyWith({
    String? currencyCode,
    String? currencySymbol,
    int? payday,
    double? capAlertThreshold,
    String? reportFrequency,
    bool? smsDetectionEnabled,
    bool? onboardingComplete,
    bool? appLockEnabled,
    bool? biometricEnabled,
    String? pinHash,
  }) {
    return SettingsData(
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      payday: payday ?? this.payday,
      capAlertThreshold: capAlertThreshold ?? this.capAlertThreshold,
      reportFrequency: reportFrequency ?? this.reportFrequency,
      smsDetectionEnabled: smsDetectionEnabled ?? this.smsDetectionEnabled,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinHash: pinHash ?? this.pinHash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'payday': payday,
      'capAlertThreshold': capAlertThreshold,
      'reportFrequency': reportFrequency,
      'smsDetectionEnabled': smsDetectionEnabled,
      'onboardingComplete': onboardingComplete,
      'appLockEnabled': appLockEnabled,
      'biometricEnabled': biometricEnabled,
      'pinHash': pinHash,
    };
  }

  factory SettingsData.fromMap(Map<String, dynamic> map) {
    return SettingsData(
      currencyCode: map['currencyCode'] as String? ?? 'GHS',
      currencySymbol: map['currencySymbol'] as String? ?? 'GH₵',
      payday: _parseInt(map['payday']) ?? 25,
      capAlertThreshold: _parseDouble(map['capAlertThreshold']) ?? 0.8,
      reportFrequency: map['reportFrequency'] as String? ?? 'daily',
      smsDetectionEnabled: _parseBool(map['smsDetectionEnabled']) ?? true,
      onboardingComplete: _parseBool(map['onboardingComplete']) ?? false,
      appLockEnabled: _parseBool(map['appLockEnabled']) ?? false,
      biometricEnabled: _parseBool(map['biometricEnabled']) ?? false,
      pinHash: map['pinHash'] as String?,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    if (value is num) return value.toDouble();
    return null;
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value == 1;
    return null;
  }

  static const _prefsKey = 'app_settings';

  static Future<SettingsData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString != null) {
      try {
        final map = json.decode(jsonString) as Map<String, dynamic>;
        return SettingsData.fromMap(map);
      } catch (_) {
        // Fallback: try legacy CSV format
        final mapStr = prefs.getString(_prefsKey);
        if (mapStr != null && !mapStr.startsWith('{')) {
          final map = Map<String, dynamic>.from(
              mapStr.split(',').map((e) => e.split(':')).fold(<String, dynamic>{},
                  (acc, pair) => acc..[pair[0]] = pair[1]));
          return SettingsData.fromMap(map);
        }
      }
    }
    return const SettingsData();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, json.encode(toMap()));
  }
}

class SettingsNotifier extends StateNotifier<AsyncValue<SettingsData>> {
  SettingsNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final settings = await SettingsData.load();
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _update(SettingsData Function(SettingsData) updater) async {
    final current = state.value ?? const SettingsData();
    final updated = updater(current);
    state = AsyncValue.data(updated);
    await updated.save();
  }

  Future<void> setCurrency(String code, String symbol) async {
    await _update((s) => s.copyWith(currencyCode: code, currencySymbol: symbol));
  }

  Future<void> setPayday(int day) async {
    await _update((s) => s.copyWith(payday: day));
  }

  Future<void> setCapAlertThreshold(double threshold) async {
    await _update((s) => s.copyWith(capAlertThreshold: threshold));
  }

  Future<void> setReportFrequency(String frequency) async {
    await _update((s) => s.copyWith(reportFrequency: frequency));
  }

  Future<void> setSmsDetectionEnabled(bool enabled) async {
    await _update((s) => s.copyWith(smsDetectionEnabled: enabled));
  }

  Future<void> setOnboardingComplete(bool complete) async {
    await _update((s) => s.copyWith(onboardingComplete: complete));
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    await _update((s) => s.copyWith(appLockEnabled: enabled));
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _update((s) => s.copyWith(biometricEnabled: enabled));
  }

  Future<void> setPin(String pin) async {
    await _update((s) => s.copyWith(pinHash: pin));
  }
}