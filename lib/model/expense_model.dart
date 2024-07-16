class ExpenseModel {
  List<Expense> expenseList = [];

  ExpenseModel.fromjson(List jsonobject) {
    for (var element in jsonobject) {
      expenseList.add(
        Expense(
          description: element['description'],
          id: element['expId'],
          amount: element['amount'].toString(),
          category: element['category']['name'],
          date: element['date'],
          imageUrl: element['category']['image'],
          time: element['time'],
        ),
      );
    }
  }
}

class Expense {
  String description;
  int id;
  String amount;
  String time;
  String category;
  String date;
  String imageUrl;

  Expense(
      {required this.description,
      required this.id,
      required this.date,
      required this.amount,
      required this.category,
      required this.imageUrl,
      required this.time});
}
