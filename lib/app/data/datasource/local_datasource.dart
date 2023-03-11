import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class LocalDataSource {
  String? _token;

  String? get token => _token;

  SharedPreferences? prefs;

  void loadUser() async {
    prefs = await SharedPreferences.getInstance();
    _token = prefs?.getString('token');
  }

  void clearPref() {
    prefs?.clear();
    _token = null;
  }
}
