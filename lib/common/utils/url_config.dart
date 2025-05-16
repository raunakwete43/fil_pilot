import 'package:shared_preferences/shared_preferences.dart';

class UrlConfig {
  static const String _urlKey = 'http://192.168.0.100:8000';
  static const String defaultUrl = 'http://192.168.0.100:8000';

  // Get the current server URL
  static Future<String> getServerUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_urlKey) ?? defaultUrl;
  }

  // Set a new server URL
  static Future<bool> setServerUrl(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_urlKey, url);
  }
}
