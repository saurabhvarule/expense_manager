class ExpenseCategoryModel {
  List<ExpenseCategory> allCategoryList = [];

  ExpenseCategoryModel.fromJson(List jsonObject) {
    for (var element in jsonObject) {
      allCategoryList.add(
        ExpenseCategory(
          element['name'].toString(),
          element['image'],
          element['catId'].toString(),
        ),
      );
    }
  }
}

class ExpenseCategory {
  String id;
  String name;
  String imageUrl;

  ExpenseCategory(
    this.name,
    this.imageUrl,
    this.id,
  );
}
