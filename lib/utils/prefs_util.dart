import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PrefsUtil {
  static final PrefsUtil _prefsUtil = PrefsUtil._();
  factory PrefsUtil() => _prefsUtil;
  PrefsUtil._();

  SharedPreferences prefs;

  Future<Map<String, dynamic>> init() async {
    prefs = await SharedPreferences.getInstance();

    String savedHeadlines = prefs.getString('trending');

    List<String> headlines = [];
    if (savedHeadlines != null) {
      headlines = List<String>.from(json.decode(savedHeadlines));
    }

    return <String, dynamic>{
      'trending': headlines,
    };
  }

  void nullifySignedInDetails() {
    prefs.setString('trending', null);
  }
}
