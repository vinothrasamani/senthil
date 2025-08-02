import 'dart:convert';

ExamResultsModel examResultsModelFromJson(String str) =>
    ExamResultsModel.fromJson(json.decode(str));

String examResultsModelToJson(ExamResultsModel data) =>
    json.encode(data.toJson());

class ExamResultsModel {
  bool success;
  List<ExamResult> data;
  String message;

  ExamResultsModel(
      {required this.success, required this.data, required this.message});

  factory ExamResultsModel.fromJson(Map<String, dynamic> json) =>
      ExamResultsModel(
        success: json["success"],
        data: List<ExamResult>.from(
            json["data"].map((x) => ExamResult.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ExamResult {
  String title;
  String image;
  String year;

  ExamResult({required this.title, required this.image, required this.year});

  factory ExamResult.fromJson(Map<String, dynamic> json) => ExamResult(
      title: json["title"], image: json["image"], year: json["year"]);

  Map<String, dynamic> toJson() =>
      {"title": title, "image": image, "year": year};
}
