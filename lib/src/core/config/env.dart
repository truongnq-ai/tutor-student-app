/// Environment configuration for the application
class Env {
  // API Configuration
  // Production API URL (base domain only, without /api)
  static const String _productionApiUrl = 'https://apitutor.dienluc.vn';
  // Development API URL
  static const String _developmentApiUrl = 'https://apitutor.dienluc.vn';
  
  /// Get API base URL based on environment
  /// 
  /// Priority:
  /// 1. API_BASE_URL from build-time (--dart-define)
  /// 2. Auto-select based on ENVIRONMENT (production/development)
  /// 3. Default to development URL
  static String get apiBaseUrl {
    // Check if API_BASE_URL is explicitly provided via --dart-define
    const urlFromEnv = String.fromEnvironment('API_BASE_URL');
    if (urlFromEnv.isNotEmpty) {
      return urlFromEnv;
    }
    
    // Auto-select based on ENVIRONMENT
    const env = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );
    
    return env == 'production' ? _productionApiUrl : _developmentApiUrl;
  }

  // Application
  static const String appName = 'Tutor';
  static const String appVersion = '1.0.0';
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  // Helper methods
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
}

