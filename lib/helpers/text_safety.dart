class TextSafety {
  static bool isUnsafeText(String input) {
    // Normalize input (remove excessive whitespace)
    String normalizedInput = input.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();

    // Step 1: Detect <script> tags
    RegExp scriptTagPattern = RegExp(r'<\s*script\b[^>]*>(.*?)<\s*/\s*script\s*>', dotAll: true);
    var scriptMatches = scriptTagPattern.allMatches(normalizedInput);

    for (var match in scriptMatches) {
      String scriptContent = match.group(1) ?? "";
      // Check if the script contains dangerous JavaScript functions
      RegExp dangerousJSFunctions = RegExp(
          r'\b(alert|eval|setTimeout|setInterval|Function|document\.write|innerHTML|fetch|XMLHttpRequest)\s*\(');
      if (dangerousJSFunctions.hasMatch(scriptContent)) {
        return true; // XSS Detected
      }
    }
    // Step 2: Detect dangerous event attributes (e.g., onclick, onerror, etc.)
    RegExp eventHandlersPattern = RegExp(r'\bon[a-z]+\s*=');
    if (eventHandlersPattern.hasMatch(normalizedInput)) return true;

    // Step 3: Detect JavaScript-based URLs
    RegExp javascriptURLPattern = RegExp(r'''\b(src|href)\s*=\s*["\']?\s*javascript\s*:''');
    if (javascriptURLPattern.hasMatch(normalizedInput)) return true;

    // Step 4: Detect encoded XSS payloads (e.g., &#x6a; for "j")
    RegExp encodedPayloadPattern = RegExp(r'&#x[0-9a-fA-F]+;');
    if (encodedPayloadPattern.hasMatch(normalizedInput)) return true;

    // Step 5: Detect CSS-based XSS (e.g., <div style="expression(alert(1))">)
    RegExp cssExpressionPattern = RegExp(r'''style\s*=\s*["\'][^"\']*expression\s*\(''');
    if (cssExpressionPattern.hasMatch(normalizedInput)) return true;

    // Step 6: Detect iframe injections (e.g., <iframe src="malicious.com">)
    RegExp iframePattern = RegExp(r'<\s*iframe\b');
    if (iframePattern.hasMatch(normalizedInput)) return true;

    // Step 7: Detect Base64 encoded payloads (data:text/html;base64,...)
    RegExp base64Pattern = RegExp(r'\bdata:\s*text\/html\s*;\s*base64\s*,');
    if (base64Pattern.hasMatch(normalizedInput)) return true;
    return false; // No XSS detected
  }

}
