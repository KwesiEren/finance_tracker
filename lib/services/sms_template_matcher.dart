import '../models/sms_template_model.dart';

/// Turns a user-tagged example message into a reusable template, and
/// matches future incoming messages against saved templates.
///
/// No provider-specific knowledge lives here. The app learns entirely from
/// what the user teaches it, which means it works for any bank or mobile
/// money provider — including ones added after this code was written —
/// without needing an update.
class SmsTemplateMatcher {
  /// Splits a message into tokens (words + standalone numbers), used both
  /// when building a template from a tagged example and when locating a
  /// candidate amount in a new message.
  static List<String> tokenize(String text) {
    return text
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();
  }

  /// Call this when the user taps a token in a sample message to mark it
  /// as "the amount". Builds a template from the surrounding context.
  static SmsTemplateModel buildTemplate({
    required String id,
    required String senderId,
    required String body,
    required int amountTokenIndex,
    required String direction,
  }) {
    final tokens = tokenize(body);
    final beforeCount = 3;
    final afterCount = 2;

    final beforeStart = (amountTokenIndex - beforeCount).clamp(0, tokens.length);
    final before = tokens.sublist(beforeStart, amountTokenIndex).join(' ');

    final afterEnd = (amountTokenIndex + 1 + afterCount).clamp(0, tokens.length);
    final after = amountTokenIndex + 1 < tokens.length
        ? tokens.sublist(amountTokenIndex + 1, afterEnd).join(' ')
        : '';

    return SmsTemplateModel(
      id: id,
      senderId: senderId,
      before: before,
      after: after,
      direction: direction,
      sampleBody: body,
      createdAt: DateTime.now(),
    );
  }

  /// Tries every saved template for this sender against a new message.
  /// Returns the extracted amount if a match is found, else null.
  static double? match(String senderId, String body, List<SmsTemplateModel> templates) {
    final candidates = templates.where((t) => t.senderId == senderId);
    for (final template in candidates) {
      final amount = _tryMatch(body, template);
      if (amount != null) return amount;
    }
    return null;
  }

  /// Returns the direction of the first matching template, if any.
  static String? matchDirection(String senderId, String body, List<SmsTemplateModel> templates) {
    final candidates = templates.where((t) => t.senderId == senderId);
    for (final template in candidates) {
      if (_tryMatch(body, template) != null) return template.direction;
    }
    return null;
  }

  static double? _tryMatch(String body, SmsTemplateModel template) {
    // Build a regex anchored on the "before" context, capturing whatever
    // number comes right after it, and — if present — requiring the
    // "after" context to follow. This tolerates the amount itself
    // differing (that's the whole point) while requiring the surrounding
    // wording to match closely enough to be confident it's the same kind
    // of alert.
    if (template.before.isEmpty && template.after.isEmpty) return null;

    final beforeEscaped = RegExp.escape(template.before);
    final afterEscaped = RegExp.escape(template.after);

    final pattern = template.after.isNotEmpty
        ? '$beforeEscaped\\s+([\\d,]+\\.?\\d*)\\s+$afterEscaped'
        : '$beforeEscaped\\s+([\\d,]+\\.?\\d*)';

    final match = RegExp(pattern, caseSensitive: false).firstMatch(body);
    if (match == null) return null;

    return double.tryParse(match.group(1)!.replaceAll(',', ''));
  }

  /// Soft heuristic used only to decide whether an *unmatched* message is
  /// worth showing the user in the "teach" queue — not used for actually
  /// extracting amounts. Deliberately loose; false positives here just mean
  /// an extra card the user dismisses, which is a low-cost mistake.
  static bool looksFinancial(String body) {
    final lower = body.toLowerCase();
    final hasKeyword = [
      'debited',
      'credited',
      'received',
      'balance',
      'sent',
      'payment',
      'transaction',
      'ghs',
      'gh₵',
    ].any(lower.contains);
    final hasNumber = RegExp(r'\d').hasMatch(body);
    return hasKeyword && hasNumber;
  }
}
