class CategoryModel {
  int? id;
  String? category;

  CategoryModel({
    this.id,
    this.category,
  });
  //create from json
  factory CategoryModel.fromjson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        category: json["category"],
      );
  //to Json
  Map<String, dynamic> tojson() {
    return {"id": id, "category": category};
  }
}
// 
