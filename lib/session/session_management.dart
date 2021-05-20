import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManagement {
  static SharedPreferences preferences;
  static const KEY_UID = 'uid';
  static const KEY_EMAIL = 'email';
  static const KEY_LOGGED = 'loggedIn';

  static void storeUserCredentials({@required String email}) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString(KEY_EMAIL, email);
  }

  static void storeLoggedInDetails({@required String uid}) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setBool(KEY_LOGGED, true);
    preferences.setString(KEY_UID, uid);
  }

  static Future<bool> getLoggedInStatus() async {
    preferences = await SharedPreferences.getInstance();
    return preferences.getBool(KEY_LOGGED) ?? false;
  }

  static Future<String> getLoggedInUID() async {
    preferences = await SharedPreferences.getInstance();
    return preferences.getString(KEY_UID) ?? '';
  }

  static Future<bool> removeLoggedInUser() async {
    preferences = await SharedPreferences.getInstance();
    // return preferences.remove(KEY_UID); // for deleting particular key
    return preferences.clear(); // clears the data relevant to that session
  }
}