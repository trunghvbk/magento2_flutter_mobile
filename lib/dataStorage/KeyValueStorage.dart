import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorage {
  dynamic getValueWithKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
  
  set(String value, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}