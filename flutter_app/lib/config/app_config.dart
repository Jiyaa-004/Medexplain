/// Application Configuration
///
/// Update these values based on your development/deployment environment

class AppConfig {
  // ==================== API CONFIGURATION ====================
  // LOCAL DEVELOPMENT: Use your machine's IP address instead of localhost
  // Find your IP:
  //   Windows: Open Command Prompt and type: ipconfig
  //   Look for "IPv4 Address" (e.g., 192.168.x.x or 10.0.x.x)
  //
  // Examples:
  // - Local Machine: http://192.168.1.100:8000/api/v1
  // - Emulator: http://10.0.2.2:8000/api/v1 (Android emulator special IP)
  // - WiFi Network: http://192.168.x.x:8000/api/v1
  static const String apiBaseUrl = 'http://192.168.220.108:8000/api/v1';

  // API TIMEOUT (seconds)
  static const int apiTimeoutSeconds = 30;

  // ==================== APP CONFIGURATION ====================
  static const String appName = 'MedExplain';
  static const String appVersion = '1.0.0';

  // ==================== ENVIRONMENT ====================
  static const String environment =
      'development'; // development, staging, production
  static const bool enableDebugLogs = true;

  /// Static method to get API base URL
  static String getApiBaseUrl() => apiBaseUrl;

  /// Validate configuration
  static bool isConfigurationValid() {
    return apiBaseUrl.isNotEmpty && !apiBaseUrl.contains('localhost');
  }

  /// Get configuration status message
  static String getConfigurationStatus() {
    if (!isConfigurationValid()) {
      return 'API URL not properly configured. Please update AppConfig with your machine IP.';
    }
    return 'Configuration OK: $apiBaseUrl';
  }
}
