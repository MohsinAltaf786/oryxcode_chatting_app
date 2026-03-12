import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _onboardingKey = 'onboarding_key';
  static const String _driverModeKey='drivermode';

  static Future<void> saveTokens({
     String? accessToken,
    String? refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if(accessToken!=null)await prefs.setString(_accessTokenKey, accessToken);
   if(refreshToken!=null) await prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(_refreshTokenKey) ?? '';
    return token.isNotEmpty;
  }

  static Future<void> updateAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
  }

  static Future<bool> isOnboardingSkipped() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> setOnboardingSkipped(bool skipped) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, skipped);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  static Future<void> savePaymentMethod({
    required int paymentMethodId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('PaymentMethod', paymentMethodId);
  }

  static Future<int?> getPaymentMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('PaymentMethod');
  }
  static Future saveDriverMode({
    required String mode ,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_driverModeKey, mode);
  }
  static Future<String?> getDriverMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_driverModeKey);
  }

}
