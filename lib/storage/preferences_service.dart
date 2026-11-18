import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _loginKey = 'is_logged_in';
  static const String _usernameKey = 'username';

  // GANTI nilai ini dengan NIM kamu sebelum menjalankan aplikasi.
  static const String validNim = '124240054';
  static const String validPassword = '123';

  static Future<bool> login(String username, String password) async {
    if (username.trim() != validNim || password != validPassword) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, true);
    await prefs.setString(_usernameKey, username.trim());
    return true;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? '';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
    await prefs.remove(_usernameKey);
  }
}
