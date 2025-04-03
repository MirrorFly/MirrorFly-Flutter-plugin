/// A utility class that provides methods to validate text input for potential
/// Cross-Site Scripting (XSS) attacks.
///
/// The `TextSafety.isUnsafeText` method performs a series of checks to detect
/// and block suspicious or malicious content, such as embedded scripts,
/// dangerous HTML attributes, encoded payloads, and JavaScript injection.
class TextSafety {
  /// Checks if the provided [input] string contains potentially unsafe or
  /// malicious content (e.g., XSS).
  ///
  /// This function performs multiple validations including:
  ///
  /// 1. `<script>` tag detection with dangerous JavaScript functions (e.g., `alert()`, `eval()`).
  /// 2. Event attributes like `onclick`, `onerror`, etc.
  /// 3. JavaScript URLs in `src` or `href` attributes.
  /// 4. Encoded payloads using HTML entities (e.g., `&#x6a;`).
  /// 5. CSS-based XSS attacks using `expression()`.
  /// 6. Iframe injection (`<iframe src="...">`).
  /// 7. Base64 embedded HTML using `data:text/html;base64,...`.
  ///
  /// Returns:
  /// - `true` if the input contains suspicious patterns and is unsafe.
  /// - `false` if the input is considered clean and safe.
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

    // Step 8: Block any HTML tags if required
    RegExp anyHTMLTagPattern = RegExp(r'<[^>]+>');
    if (anyHTMLTagPattern.hasMatch(normalizedInput)) return true;

    // Step 9: Block meta/object/embed/etc.
    RegExp metaTagPattern = RegExp(r'<\s*(meta|object|embed|applet|link|base)\b');
    if (metaTagPattern.hasMatch(normalizedInput)) return true;

    // Step 10: Block srcdoc attributes in iframes
    RegExp srcDocPattern = RegExp(r'srcdoc\s*=');
    if (srcDocPattern.hasMatch(normalizedInput)) return true;

    // Step 11: Block SVG tags and event handlers in them
    RegExp svgTagPattern = RegExp(r'<\s*svg\b|<\s*/\s*svg\s*>');
    if (svgTagPattern.hasMatch(normalizedInput)) return true;

    RegExp svgOnEventPattern = RegExp(r'<svg[^>]+on[a-z]+\s*=');
    if (svgOnEventPattern.hasMatch(normalizedInput)) return true;

    // Step 12: Block data: JavaScript or SVG
    RegExp dataJsOrSvgPattern = RegExp(r'data:(text/javascript|image/svg\+xml)', caseSensitive: false);
    if (dataJsOrSvgPattern.hasMatch(normalizedInput)) return true;

    // Step 13: Block access to document.cookie, location, etc.
    RegExp jsAccessors = RegExp(r'\b(document\.cookie|window\.location|localStorage|getElementById)\b');
    if (jsAccessors.hasMatch(normalizedInput)) return true;

    return false; // No XSS detected
  }

}
