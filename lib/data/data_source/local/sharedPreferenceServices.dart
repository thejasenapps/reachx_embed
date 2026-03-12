import 'package:reachx_embed/core/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for interacting with SharedPreferences, including caching options
class SharedPreferenceServices {

  final SharedPreferencesAsync _prefsAsync = SharedPreferencesAsync();

  void setValue(storage, value) async {
    final SharedPreferencesAsync prefs =  _prefsAsync;
    if(value is bool) {
      prefs.setBool(storage, value);
    } else if(value is int) {
      prefs.setInt(storage, value);
    } else if(value is String) {
      if(value == "offline" || value == "online") {
        status = value;
      }
      prefs.setString(storage, value);
    }
  }


  Future<dynamic> getValue(storage, {bool lessonId = false, bool countValue = false}) async {
    SharedPreferencesAsync prefs = _prefsAsync;

    if(storage == 'name' || lessonId || storage == "feed_latest") {
      return prefs.getString(storage) ;// Return the value or false if not found
    } else if(storage == 'shutdownTime' || storage == 'tries' || countValue) {
      return prefs.getInt(storage);
    } else {
      return prefs.getBool(storage);
    }
  }

}
