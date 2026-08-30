/// Normalizes sender IDs so "MTN MoMo", "mtnmomo", "MTN-MOMO", "+233244123456" and "0244123456" compare equal.
String normalizeSender(String raw) {
  var s = raw.trim().toLowerCase();
  // Canonicalize Ghana prefix: +233 -> 0, 233 -> 0 if looks like phone
  if (s.startsWith('+233')) {
    s = '0${s.substring(4)}';
  } else if (s.startsWith('233') && s.length >= 11 && RegExp(r'^233\d+$').hasMatch(s)) {
    s = '0${s.substring(3)}';
  }
  // Remove spaces, dashes, underscores, dots for comparison
  s = s.replaceAll(RegExp(r'[\s\-_\.]+'), '');
  return s;
}

bool senderEquals(String a, String b) => normalizeSender(a) == normalizeSender(b);
