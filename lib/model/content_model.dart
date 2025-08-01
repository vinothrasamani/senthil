import 'dart:convert';

ContentModel contentModelFromJson(String str) =>
    ContentModel.fromJson(json.decode(str));

String contentModelToJson(ContentModel data) => json.encode(data.toJson());

class ContentModel {
  bool success;
  ContentData data;
  String message;

  ContentModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
        success: json["success"],
        data: ContentData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class ContentData {
  List<SchoolData> cbse;
  List<SchoolData> matric;

  ContentData({
    required this.cbse,
    required this.matric,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) => ContentData(
        cbse: List<SchoolData>.from(
            json["cbse"].map((x) => SchoolData.fromJson(x))),
        matric: List<SchoolData>.from(
            json["matric"].map((x) => SchoolData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cbse": List<dynamic>.from(cbse.map((x) => x.toJson())),
        "matric": List<dynamic>.from(matric.map((x) => x.toJson())),
      };
}

class SchoolData {
  int id;
  String name;
  int ord;
  int ctype;

  SchoolData({
    required this.id,
    required this.name,
    required this.ord,
    required this.ctype,
  });

  factory SchoolData.fromJson(Map<String, dynamic> json) => SchoolData(
        id: json["id"],
        name: json["name"],
        ord: json["Ord"],
        ctype: json["ctype"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "Ord": ord,
        "ctype": ctype,
      };
}
