import '../models/sms_template_model.dart';
import 'sms_sender_normalizer.dart';

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
    final norm = normalizeSender(senderId);
    final candidates = templates.where((t) => normalizeSender(t.senderId) == norm);
    for (final template in candidates) {
      final amount = _tryMatch(body, template);
      if (amount != null) return amount;
    }
    return null;
  }

  /// Returns the direction of the first matching template, if any.
  static String? matchDirection(String senderId, String body, List<SmsTemplateModel> templates) {
    final norm = normalizeSender(senderId);
    final candidates = templates.where((t) => normalizeSender(t.senderId) == norm);
    for (final template in candidates) {
      if (_tryMatch(body, template) != null) return template.direction;
    }
    return null;
  }

  static String _normalize(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();

  static double? _tryMatch(String body, SmsTemplateModel template) {
    if (template.before.isEmpty && template.after.isEmpty) return null;

    final normBody = _normalize(body);
    final normBefore = _normalize(template.before);
    final normAfter = _normalize(template.after);

    final beforeEscaped = RegExp.escape(normBefore);
    final afterEscaped = RegExp.escape(normAfter);

    // Tolerate optional punctuation/separators around amount and support both prefix and suffix currency.
    const amountPat = r'(?:GH₵|GHS|GHC|₵)?\s*([\d, ]+\.?\d*)\s*(?:GH₵|GHS|GHC|₵)?';
    // Allow broader separators: colon, dash, dot, comma, equals, parentheses, quotes
    const sep = r'[\s:\-.,=()"' + "'" + r']*';
    final pattern = normAfter.isNotEmpty
        ? '$beforeEscaped$sep$amountPat$sep$afterEscaped'
        : '$beforeEscaped$sep$amountPat';

    final match = RegExp(pattern, caseSensitive: false).firstMatch(normBody);
    if (match == null) return null;

    return double.tryParse(match.group(1)!.replaceAll(',', '').replaceAll(' ', '').trim());
  }

  /// Returns all amount candidates in a body for UI highlighting.
  static List<({String token, double value, int index})> findAmountCandidates(String body) {
    final tokens = tokenize(body);
    final out = <({String token, double value, int index})>[];
    for (int i = 0; i < tokens.length; i++) {
      final cleaned = tokens[i].replaceAll(RegExp(r'[^\d.,]'), '').replaceAll(',', '');
      final v = double.tryParse(cleaned);
      // Consider token an amount if it looks like currency or decimal number
      if (v != null && RegExp(r'^\d[\d,]*\.?\d*$').hasMatch(tokens[i].replaceAll(RegExp(r'^[GH₵₵\s]+'), '')) && (tokens[i].contains(RegExp(r'\d')) && (tokens[i].contains('.') || v >= 1))) {
        // Extra check: contains GH₵/GHS nearby or is decimal-like
        final raw = tokens[i].toLowerCase();
        final isCurrencyLike = raw.contains('gh') || raw.contains('₵') || RegExp(r'\d+\.\d{1,2}').hasMatch(tokens[i]) || RegExp(r'^\d+,\d{3}').hasMatch(tokens[i]);
        if (isCurrencyLike || v >= 0.5) out.add((token: tokens[i], value: v, index: i));
      }
    }
    // Fallback: also regex scan whole body for amounts
    if (out.isEmpty) {
      for (final m in RegExp(r'(?:GH₵|GHS|₵|GHC)?\s*([\d,]+\.\d{1,2})').allMatches(body)) {
        final v = double.tryParse(m.group(1)!.replaceAll(',', ''));
        if (v != null) out.add((token: m.group(0)!, value: v, index: body.indexOf(m.group(0)!)));
      }
    }
    return out;
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
