import 'dart:convert';
import 'dart:developer';
import 'package:expense_manager/model/expense_model.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseProvider with ChangeNotifier {
  bool isModalBottomSheetOpen = false;

  /// THIS VARIABLE IS USED TO CLOSE THE BOTTOM SHEET IF THE USER PRESS THE SYSTEM BACK BUTTON
  bool isValidated = false;

  ///CONVERT THE DATETIME IN "2024-11-01" THIS FORMAT. THIS IS USED FOR API CALL
  String monthSelected = DateFormat('yyyy-MM-dd').format(DateTime.now());

  ///CONVERT THE DATETIME IN "Feb" THIS FORMAT. THIS  IS USED TO DISPLAY IN THE UI
  String monthDisplayed = DateFormat.MMM().format(DateTime.now());

  ///LIST OF EXPENSES
  List<Expense> expenseList = [];

  ///TEXT EDITING CONTROLLERS
  TextEditingController dateTextController = TextEditingController();
  TextEditingController categoryTextController = TextEditingController();
  TextEditingController amtTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();

  void changePickedMonth(String pickedMonth) {
    monthDisplayed = pickedMonth;
    notifyListeners();
  }

  ///THIS METHOD WILL VALIDATE TH ENETERED AMOUNT i.e WE WILL CHECK WHETHER THE ENTERED STRING
  ///IS IN THE VALID RANGE OF INTEGER ASCII VALUES
  String? get amtValidation {
    if (amtTextController.text.isEmpty) {
      return "Amount is required";
    }

    for (var i in amtTextController.text.codeUnits) {
      log(i.toString());
      if (i < 48 || i > 57) {
        return "Enter a valid amount ";
      }
    }
    if (int.parse(amtTextController.text) <= 0) {
      return "Enter a valid amount";
    }
    return null;
  }

  /*
  - This methods does the post request and sends the required data  as body to the api
  - if the expense id added successfully then the getAllExpense api is called
  */

  Future<void> addExpense(String selectedCategory) async {
    log("----------------------------------------------ADD EXPENSE ------------------------------------");
    try {
      final instance = await SharedPreferences.getInstance();

      ///URL
      final url =
          Uri.parse("http://46.250.229.35:8088/expense-manager/expense/add");

      ///CONVERT THE SELECTED DATE IN DATETIME FORMAT
      DateTime selectedDate = DateFormat.yMMMd().parse(dateTextController.text);

      ///NOW CONVERT THE DATETIME IN  "2024-05-22" FORMAT.
      /// BECAUSE THIS IS THE FORMAT WHICH IS REQUIRED BY THE BACKEND
      String selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDate);
      Map<String, dynamic> mapData = {
        "amount": amtTextController.text.toString(),
        "description": descTextController.text.toString(),
        "date": selectedDateString,
        "time": DateFormat.Hms().format(DateTime.now()),
        "category": {"catId": selectedCategory},
        "user": {"userName": instance.getString("Username")}
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
      if (statusCode == 200) {
        final data = json.decode(response.body);
        log("ADD EXPENSE DATA:${data.toString()}");
      }

      log("ADD EXPENSE STATUSCODE: $statusCode");

      await getAllExpenses(doNotify: true);
      clearTextEditingControllers();
      notifyListeners();
    } catch (e) {
      log("ADD EXPENSE ERROR: $e");
    }
  }

  void changeValidation() {
    isValidated = true;
    log("Validation Changed");
  }

  /*
  - This methods does the get  request
  - the response body from the API is given to ExpenseModel.fromjson  and expenseList is accessed form 
  - ExpenseModel.fromjson object  and is assigned to expenseList
  */
  Future<void> getAllExpenses({required bool doNotify}) async {
    log("------------------------------------IN GET ALL EXPENSES---------------------------------");

    try {
      final instance = await SharedPreferences.getInstance();
      String userName = instance.getString("Username")!;

      final url = Uri.parse(
          "http://46.250.229.35:8088/expense-manager/expense/all/$monthSelected?userName=$userName");
      final response = await http.get(
        url,
      );

      int statusCode = response.statusCode;
      log("GET ALL EXPENSE STATUSCODE: $statusCode");

      if (statusCode == 200) {
        final data = json.decode(response.body);
        log("GET ALL EXPENSE : $data");
        expenseList.clear();
        final expenseModelObj = ExpenseModel.fromjson(data);
        expenseModelObj.expenseList.toList();
        expenseList.addAll(expenseModelObj.expenseList);
        expenseList = expenseList.reversed.toList();
      } else if (statusCode == 204) {
        expenseList.clear();
      }

      if (doNotify) {
        notifyListeners();
      }
    } catch (e) {
      log("GET ALL EXPENSE ERROR: $e");
    }
  }

/*
- This method calls the delete request. 
- If the status code is 200 i.e success then getAllExpenses api is called.
*/
  Future<int> addTotrash(int id) async {
    log("--------------------------------------ADD TO TRASH ---------------------------------");
    try {
      final url = Uri.parse(
          "http://46.250.229.35:8088/expense-manager/expense/delete/$id"); //{loginSignupProvider!.currentUser}
      final response = await http.delete(url);

      int statusCode = response.statusCode;
      log("ADD TO TRASH STATUSCODE: $statusCode");
      log(response.body.toString());
      if (statusCode == 200) {
        await getAllExpenses(doNotify: true);
      } else if (statusCode == 204) {
        expenseList.clear();
        notifyListeners();
      }
      return statusCode;
    } catch (e) {
      log("ADD TO TRASH STATUSCODE ERROR: $e");
    }
    return -1;
  }

//This method will clear the controllers which we use in TextFromField to take input
  void clearTextEditingControllers() {
    dateTextController.clear();
    categoryTextController.clear();
    amtTextController.clear();
    descTextController.clear();
  }
}
