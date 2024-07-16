import 'dart:convert';
import 'dart:developer';
import 'package:expense_manager/model/expense_category.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  ///TEXT EDITING CONTROLLERS
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  bool isModalBottomSheetOpened = false;
  bool isLoading = false;

  List<ExpenseCategory> expenseCategoriesList = []; //List of ExpenseCategory
  bool isImgPicked = false;

  /*
  - This method creates the instance of the SharedPreferences and  gets the username stored.
  - the post request takes the body  in form of encoded json object 
  - If the StatusCode  from the api is 201 The getAllCategory Api is called.
  
  */

  Future<int> addCategory() async {
    log("--------------------------------ADD CATEGORY REQUEST------------------------------");
    try {
      //
      final instance = await SharedPreferences.getInstance();
      String userName = instance.getString("Username")!;
      final url =
          Uri.parse("http://46.250.229.35:8088/expense-manager/category/add");
      Map<String, dynamic> mapData = {
        "name": nameController.text,
        "image": imageController.text,
        "user": {"userName": userName}
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
      log("ADD CATEGORY STATUSCODE: $statusCode");
      if (statusCode == 201) {
        expenseCategoriesList.clear();
        final data = json.decode(response.body);
        log(data.toString());

        ///OF THE CATEGORY IS ADDED SUCCESSFULLY THEN GETALLCATEGORIES
        await getAllCategories();

        notifyListeners();
      }

      return statusCode;
    } catch (e) {
      log("ADD CATEGORY ERROR: $e ");
      return -1;
    }
  }

  ///IN THE UPDATE CATEGORY METHOD WE WILL PASS THE CATEGORY ID  CATEGORYnAME AND iMAGE TO THE BODY OF THE PUT REQUEST
  ///IF THE STATUSCODE OF THE PUT REQUEST ID 201 THE GETALLCATEGORY API IS CALLED
  Future<int> updateCategory(int categoryId) async {
    log("--------------------------------UPDATE CATEGORY REQUEST------------------------------");
    try {
      final instance = await SharedPreferences.getInstance();
      String username = instance.getString("Username")!;
      final url = Uri.parse(
          "http://46.250.229.35:8088/expense-manager/category/update");
      Map<String, dynamic> mapData = {
        "catId": categoryId,
        "name": nameController.text,
        "image": imageController.text,
        "user": {
          "userName": username,
        }
      };
      var encodedData = json.encode(mapData);
      final response = await http.put(
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        url,
        body: encodedData,
      );

      int statusCode = response.statusCode;
      log("UPDATE CATEGORY STATUSCODE: $statusCode");
      log(response.body.toString());
      if (statusCode == 201 || statusCode == 200) {
        await getAllCategories();

        notifyListeners();
      }

      return statusCode;
    } catch (e) {
      log("UPDATE CATEGORY ERROR: $e ");
      return -1;
    }
  }

/*
- This method will call the http.get method and the response body is sent to CategoryModel.fromJson
- and from the object of CategoryModel.fromJson   allCategoryList is accessed and is assigned to the categoriesList
*/
  Future<void> getAllCategories() async {
    log("-------------------------------------GET ALL CATEGORIES-------------------------------");
    try {
      ///GET THE USERNAME FROM THE SHAREDPREFERENCE
      final instance = await SharedPreferences.getInstance();
      String username = instance.getString("Username")!;
      final url = Uri.parse(
          "http://46.250.229.35:8088/expense-manager/category/all?userName=$username");
      final response = await http.get(url);
      int statusCode = response.statusCode;
      print(response.statusCode.toString());

      if (statusCode == 200) {
        expenseCategoriesList.clear();

        final data = json.decode(response.body);
        print(data);
        final categorymodel = ExpenseCategoryModel.fromJson(data);
        expenseCategoriesList = categorymodel.allCategoryList;
      } else if (statusCode == 204) {
        expenseCategoriesList.clear();
      }
    } catch (e) {
      log("GET ALL CATEGORIES ERROR: $e");
      isLoading = true;
      notifyListeners();
    }
  }

/*
- This method calls the https.delete method if the status code is 200 or 204 it will call the getAllCategories api
*/

  Future<int> removeCategory(String id) async {
    log("------------------------------------------------REMOVE CATEGORY--------------------------------");
    try {
      final instance = await SharedPreferences.getInstance();
      String username = instance.getString("Username")!;
      final url = Uri.parse(
          "http://46.250.229.35:8088/expense-manager/category/delete/$id?userName=$username");
      final response = await http.delete(url);

      int statusCode = response.statusCode;
      log("DELETE CATEGORY STATUSCODE: $statusCode");
      log("DELETE CATEGORY BODY :  ${response.body.toString()}");

      if (statusCode == 200 || statusCode == 204) {
        await getAllCategories();
        notifyListeners();
      }
      isLoading = false;
      return statusCode;
    } catch (e) {
      log("DELETE CATEGORY ERROR: $e");
      isLoading = true;
      return -1;
    }
  }

  //change the imagePicked value if value is true turn it to false and viceversa.
  void togglePickedImg(bool value) {
    isImgPicked = value;
    notifyListeners();
  }

  void clearControllers() {
    nameController.clear();
    imageController.clear();
  }
}
