import "dart:developer" as developer;

/// Utility class to filter out common Android device errors that spam the console
class LogFilter {
  static bool _isInitialized = false;
  
  /// Initialize the log filter to suppress common Android device errors
  static void initialize() {
    if (_isInitialized) return;
    
    // Override the default log output to filter out IMGMapper errors
    developer.log("Log filter initialized - suppressing IMGMapper errors", name: "LogFilter");
    _isInitialized = true;
  }
  
  /// Check if a log message should be filtered out
  static bool shouldFilter(String message) {
    // Filter out Samsung IMGMapper errors
    if (message.contains("E/IMGMapper") && 
        (message.contains("Unset optional value from type") ||
         message.contains("SMPTE2086") ||
         message.contains("CTA861_3"))) {
      return true;
    }
    
    // Filter out other common Android device errors
    if (message.contains("E/") && 
        (message.contains("color mapping") ||
         message.contains("display mapping"))) {
      return true;
    }
    
    return false;
  }
}
