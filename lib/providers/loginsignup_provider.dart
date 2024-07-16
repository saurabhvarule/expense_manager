import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class LoginSignupProvider with ChangeNotifier {
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupUserNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
      TextEditingController();

  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController loginUsernameController = TextEditingController();

  bool obsecurePassword = false;
  bool obsecureConfirmPassword = false;
  String? currentUser;
  String? password;
  bool isLoading = false;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  void changePasswordVisiblity() {
    obsecurePassword = !obsecurePassword;
    notifyListeners();
  }

  void changeConfirmPasswordVisiblity() {
    obsecureConfirmPassword = !obsecureConfirmPassword;
    notifyListeners();
  }

  ///Converts the ascii characters in the ascii values and then check
  /// Whether the values fall in the valid character range
  String? nameValidator(String? name) {
    for (int i = 0; i < name!.codeUnits.length; i++) {
      if (name.codeUnits[i] == 32) {
        continue;
      }
      if ((name.codeUnits[i] < 65 ||
              (name.codeUnits[i] > 90 && name.codeUnits[i] < 97)) ||
          (name.codeUnits[i] > 122)) {
        log(i.toString());
        return "Enter A Valid Name";
      }
    }

    if (name.isEmpty) {
      return "Enter Your Name";
    }
    return null;
  }

/*
- This method is used to signup .It is a post request which requires userName 
- name and password as body after successful  signup we store the currentuser login and password
*/

  Future<String> signUp() async {
    log("---------------------------------------------IN SIGNUP----------------------------------------------");

    String message = "";
    try {
      isLoading = true;
      notifyListeners();
      final url =
          Uri.parse("http://46.250.229.35:8088/expense-manager/user/signup");
      Map<String, String> mapData = {
        "userName": signupUserNameController.text,
        "name": signupUserNameController.text,
        "password": signupPasswordController.text,
      };

      var encodedData = json.encode(mapData);
      final response = await http.post(
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        url,
        body: encodedData,
      );

      int statusCode = response.statusCode;
      var responseData = json.decode(response.body);
      log(responseData.toString());
      if (statusCode != 201) {
        var responseData = json.decode(response.body);
        message = responseData['message'];
      } else {
        message = response.body;
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      log("SIGNUP ERROR: $e");
    }
    isLoading = false;
    return message;
  }

  /*
  - This method is used to signin .It is a get request and the url need the username and password 
  - After successful login we save the username and password 
  */
  Future<String> signIn() async {
    log("-----------------------------------------In signin------------------------------");
    String message = '';
    try {
      final url =
          Uri.parse("http://46.250.229.35:8088/expense-manager/user/login");
      Map<String, dynamic> mapData = {
        "userName": loginUsernameController.text,
        "password": loginPasswordController.text,
      };
      var encodedData = json.encode(mapData);
      final response = await http.post(
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        url,
        body: encodedData,
      );
      int statusCode = response.statusCode;

      log("IN THE SIGN IN STATUSCODE: $statusCode");
      log(response.body.toString());

      log(message);
      if (statusCode != 200) {
        var responseData = json.decode(response.body);
        message = responseData['message'];
      } else if (statusCode == 200) {
        message = response.body;
        currentUser = loginUsernameController.text;
        password = loginPasswordController.text;
        clearLoginControlers();
      }
      // return statusCode;
    } catch (e) {
      log("IN THE SIGN IN STATUSCODE: $e");
      // return -1;
    }
    // return message;
    return message;
  }

  //clear the  Texteditingcontrollers .
  void clearSignupControlers() {
    signupConfirmPasswordController.clear();
    signupNameController.clear();
    signupUserNameController.clear();
    signupPasswordController.clear();
  }

  void clearLoginControlers() {
    loginUsernameController.clear();
    loginPasswordController.clear();
  }
}
