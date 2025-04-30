bool isGlobPattern(String input) {
  return input.contains('*') || input.contains('?') || input.contains('[');
}
