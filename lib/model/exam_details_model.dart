import 'dart:convert';

ExamDetailsModel examDetailsModelFromJson(String str) =>
    ExamDetailsModel.fromJson(json.decode(str));

String examDetailsModelToJson(ExamDetailsModel data) =>
    json.encode(data.toJson());

class ExamDetailsModel {
  bool success;
  List<Examinfo> data;
  String message;

  ExamDetailsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ExamDetailsModel.fromJson(Map<String, dynamic> json) =>
      ExamDetailsModel(
        success: json["success"],
        data:
            List<Examinfo>.from(json["data"].map((x) => Examinfo.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Examinfo {
  int id;
  String? examName;
  int? ord;
  DateTime createdAt;
  DateTime updatedAt;
  int? stype;

  Examinfo({
    required this.id,
    required this.examName,
    required this.ord,
    required this.createdAt,
    required this.updatedAt,
    required this.stype,
  });

  factory Examinfo.fromJson(Map<String, dynamic> json) => Examinfo(
        id: json["id"],
        examName: json["exam_name"],
        ord: json["ord"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        stype: json["stype"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "exam_name": examName,
        "ord": ord,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "stype": stype,
      };
}
