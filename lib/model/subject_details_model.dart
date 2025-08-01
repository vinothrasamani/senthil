import 'dart:convert';

SubjectDetailsModel subjectDetailsModelFromJson(String str) =>
    SubjectDetailsModel.fromJson(json.decode(str));

String subjectDetailsModelToJson(SubjectDetailsModel data) =>
    json.encode(data.toJson());

class SubjectDetailsModel {
  bool success;
  List<SubjectInfo> data;
  String message;

  SubjectDetailsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory SubjectDetailsModel.fromJson(Map<String, dynamic> json) =>
      SubjectDetailsModel(
        success: json["success"],
        data: List<SubjectInfo>.from(
            json["data"].map((x) => SubjectInfo.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class SubjectInfo {
  int id;
  String? shortname;
  String fullname;
  int? show;
  DateTime createdAt;
  dynamic updatedAt;
  int? shortShow;
  String? subgroup;
  int? ord;
  int? mOrd;

  SubjectInfo({
    required this.id,
    this.shortname,
    required this.fullname,
    this.show,
    required this.createdAt,
    required this.updatedAt,
    this.shortShow,
    this.subgroup,
    this.ord,
    this.mOrd,
  });

  SubjectInfo copyWidth(int val) {
    return SubjectInfo(
        id: id,
        shortname: shortname,
        shortShow: shortShow,
        fullname: fullname,
        createdAt: createdAt,
        updatedAt: updatedAt,
        show: val,
        subgroup: subgroup,
        ord: ord,
        mOrd: mOrd);
  }

  factory SubjectInfo.fromJson(Map<String, dynamic> json) => SubjectInfo(
        id: json["id"],
        shortname: json["shortname"] ?? '',
        fullname: json["fullname"],
        show: json["show"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        shortShow: json["ShortShow"] ?? '',
        subgroup: json["Subgroup"] ?? '',
        ord: json["Ord"] ?? 0,
        mOrd: json["MOrd"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shortname": shortname,
        "fullname": fullname,
        "show": show,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "ShortShow": shortShow,
        "Subgroup": subgroup,
        "Ord": ord,
        "MOrd": mOrd,
      };
}
