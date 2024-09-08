int calculateReadingTime(String content) {
  /// The \s part of the regex matches any whitespace character, such as spaces, tabs, newlines, etc.
  /// The + quantifier means it will match one or more occurrences of these whitespace characters.
  final wordCount = content.split(RegExp(r'\s+')).length;

  /// taking avg reading time = 225 word per/min
  final readingTime = wordCount / 225;

  return readingTime.ceil();
}
