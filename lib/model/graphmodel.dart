class GraphModel {
  Map<String, double> graphData = {};
  GraphModel.fromjson(Map json) {
    json.forEach((key, value) {
      graphData[key] = double.parse(value.toString());
    });
  }
}
