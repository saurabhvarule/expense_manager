class TrashModel {
  List<Trash> trashList = [];

  TrashModel.fromjson(List jsonobject) {
    for (var element in jsonobject) {
      trashList.add(
        Trash(
          trashId: element['trashId'],
          trashAmount: element['trashAmount'].toString(),
          trashCategory: element['trashCategory']['name'],
          trashDate: element['trashDate'],
          imageUrl: element['trashCategory']['image'],
          trashTime: element['trashTime'],
          trashDescription: element['trashDescription'],
        ),
      );
    }
  }
}

class Trash {
  int trashId;
  String trashAmount;
  String trashTime;
  String trashCategory;
  String trashDate;
  String imageUrl;
  String trashDescription;

  Trash({
    required this.trashDescription,
    required this.trashAmount,
    required this.imageUrl,
    required this.trashCategory,
    required this.trashDate,
    required this.trashId,
    required this.trashTime,
  });
}
