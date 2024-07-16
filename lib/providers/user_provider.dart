import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  bool isuserLoggedIn = false;

  String? userName = "";

  ///THIS METHOD CHECKS WHETHER THE VALUE FOR THE Username IS AVAILABLE IN SHAREDPREFERENCES
  Future<void> userLoggedInOrNot() async {
    final instance = await SharedPreferences.getInstance();
    String? userName = instance.getString("Username");
    log("USERLOGGED IN OR NOT: $userName");
    if (userName == null) {
      isuserLoggedIn = false;
    } else {
      isuserLoggedIn = true;
      this.userName = userName;
    }
    notifyListeners();
  }

  Future<void> setData(String userName) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString("Username", userName);
  }

  Future<void> logOut() async {
    final instance = await SharedPreferences.getInstance();
    await instance.remove("Username");
    log("USER NAME AFTER LOGOUT: ${instance.getString("Username")}");
  }
}
