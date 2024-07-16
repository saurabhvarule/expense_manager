import 'dart:convert';
import 'dart:developer';
import 'package:expense_manager/model/trashmodel.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class TrashProvider with ChangeNotifier {
  List<Trash> trashList = [];

  /*
    - This method is called to get the trash for current month .It is the get request and the url 
    - requires the month and username .The response body is decoded and is passed to the  TrashModel.fromjson object 
    - From the TrashModel.fromjson object we can get the  trashList which we can assign to trashList present in this class
    */

  Future<void> getAllTrash(bool doNotify, String selectedMonth) async {
    log("--------------------------------------IN GET ALL TRASH ----------------------------");
    try {
      final instance = await SharedPreferences.getInstance();
      String username = instance.getString("Username")!;
      final url = Uri.parse(
          "http://46.250.229.35:8088/expense-manager/trash/all/$selectedMonth?userName=$username"); //{loginSignupProvider!.currentUser}
      final response = await http.get(
        url,
      );
      log(" STATUS CODE GET ALL TRASH  ${response.statusCode.toString()}");
      int statusCode = response.statusCode;
      log(response.body);
      if (statusCode == 200) {
        final data = json.decode(response.body);
        final trashModel = TrashModel.fromjson(data);
        trashList = trashModel.trashList;
        if (doNotify) {
          notifyListeners();
        }
      } else if (statusCode == 204) {
        trashList.clear();
        if (doNotify) {
          notifyListeners();
        }
      }
    } catch (e) {
      log("IN GET All Trash  ERROR$e");
    }
  }

/*
- This method is called to delete the data from the trash this is a delete request call
- the url requires the id ,date and username .
- aftet the delete request is completed we will call teh getAllTrash method.
*/

  Future<void> clearFromTrash(int id, String selectedMonth) async {
    log("----------------------------------IN CLEAR FROM TRASH-----------------------------");
    try {
      final url = Uri.parse(
          "http://46.250.229.35:8088/expense-manager/trash/delete/$id?date=$selectedMonth");

      final response = await http.delete(url);

      log("IN CLEAR FROM TRASH STATUSCODE: ${response.statusCode.toString()}");
      await getAllTrash(true, selectedMonth);
    } catch (e) {
      log("IN CLEAR FROM TRASH ERROR: $e");
    }
  }

  /*
- This method is called to restore  the data from the trash this is a delete request call
- the url requires the id and  selectedMonth

*/

  Future<int> restoreFromTrash(String id, String selectedMonth) async {
    log("--------------------------------IN RESTORE FROM TRASH ---------------------------------");
    try {
      final url = Uri.parse(
          "http://46.250.229.35:8088/expense-manager/trash/restore/$id?date=$selectedMonth");
      final response = await http.delete(url);
      log("RESTORE FROM TRASH STATUS CODE ${response.statusCode.toString()}");
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 204) {
        notifyListeners();
      }
      return statusCode;
    } catch (e) {
      log("IN RESTORE FROM TRASH ERROR: $e");
    }
    return -1;
  }
}
