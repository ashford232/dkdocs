import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepo {

  
  Future<void> setVal({required String key,required String value}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString( key, value);
  }

  Future<String?> getVal({required String key}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }
}
