import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferencesService {
  static const String _pushNotificationsKey = 'push_notifications';
  static const String _emailNotificationsKey = 'email_notifications';
  static const String _smsNotificationsKey = 'sms_notifications';

  // Get push notifications preference
  static Future<bool> getPushNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_pushNotificationsKey) ?? true; // Default: enabled
  }

  // Set push notifications preference
  static Future<void> setPushNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushNotificationsKey, value);
  }

  // Get email notifications preference
  static Future<bool> getEmailNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_emailNotificationsKey) ?? true; // Default: enabled
  }

  // Set email notifications preference
  static Future<void> setEmailNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailNotificationsKey, value);
  }

  // Get SMS notifications preference
  static Future<bool> getSmsNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_smsNotificationsKey) ?? false; // Default: disabled
  }

  // Set SMS notifications preference
  static Future<void> setSmsNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_smsNotificationsKey, value);
  }

  // Get all notification preferences
  static Future<Map<String, bool>> getAllPreferences() async {
    return {
      'push': await getPushNotifications(),
      'email': await getEmailNotifications(),
      'sms': await getSmsNotifications(),
    };
  }

  // Reset all preferences to default
  static Future<void> resetToDefaults() async {
    await setPushNotifications(true);
    await setEmailNotifications(true);
    await setSmsNotifications(false);
  }
}
