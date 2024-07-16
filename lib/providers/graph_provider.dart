import 'dart:convert';
import 'dart:developer';
import 'package:expense_manager/model/graphmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;

class GraphProvider with ChangeNotifier {
  List<int> percentageList = [];
  Map<String, double> dataMap =
      {}; //this is the map which we pass to the GraphWidget
  double total = 0;

/*
- This method calculates the total of the transactions and stores it in the instance variable total.
*/

  void getTotal() {
    total = 0;
    for (double i in dataMap.values) {
      total += i;
    }
  }

/*
- This method gets the map data from the api and we store this data in the GraphModel 
 */

  Future<void> getDataForGraph(String monthSelected) async {
    log("--------------------------------------------GET DATA FOR GRAPH----------------------------------------------");
    try {
      final instance = await SharedPreferences.getInstance();
      String userName = instance.getString("Username")!;
      final url = Uri.parse(
          "http://46.250.229.35:8088/expense-manager/category/all/amount?date=$monthSelected&userName=$userName"); //{expense!.loginSignupProvider!.currentUser}
      final response = await http.get(url);
      int statusCode = response.statusCode;
      log("IN GET DATA FOR GRAPH STATUSCODE: $statusCode");
      if (statusCode == 200) {
        final data = json.decode(response.body);

        final graphModelObj = GraphModel.fromjson(data);
        dataMap.clear();
        dataMap = graphModelObj.graphData;
      } else if (statusCode == 204) {
        dataMap.clear();
      }
    } catch (e) {
      log("GET DATA FOR GRAPH: ERROR$e");
    }
  }
}
