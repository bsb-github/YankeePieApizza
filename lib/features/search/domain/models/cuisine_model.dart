import 'dart:convert';

class CuisineModel {
  int? id;
  String? name;
  String? image;
  int? priority;
  CuisineModel({
    this.id,
    this.name,
    this.image,
    this.priority,
  });

  factory CuisineModel.fromJson(String str) => CuisineModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CuisineModel.fromMap(Map<String, dynamic> json) => CuisineModel(
    id: int.tryParse('${json["id"]}'),
    name: json["name"],
    image: json["image"],
    priority: int.tryParse('${json["priority"]}'),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "image": image,
    "priority": priority,
  };
}
