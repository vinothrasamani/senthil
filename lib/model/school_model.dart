import 'dart:convert';

SchoolModel schoolModelFromJson(String str) =>
    SchoolModel.fromJson(json.decode(str));

String schoolModelToJson(SchoolModel data) => json.encode(data.toJson());

class SchoolModel {
  bool success;
  List<School> data;
  String message;

  SchoolModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) => SchoolModel(
        success: json["success"],
        data: List<School>.from(json["data"].map((x) => School.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class School {
  int id;
  String name;
  int code;
  dynamic address;
  String city;
  dynamic mobileNo;
  String schlType;

  School({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.city,
    required this.mobileNo,
    required this.schlType,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        address: json["address"],
        city: json["city"],
        mobileNo: json["mobile_no"],
        schlType: json["schl_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "address": address,
        "city": city,
        "mobile_no": mobileNo,
        "schl_type": schlType,
      };
}
