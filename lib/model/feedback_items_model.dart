import 'dart:convert';

FeedbackItemsModel feedbackItemsModelFromJson(String str) =>
    FeedbackItemsModel.fromJson(json.decode(str));

String feedbackItemsModelToJson(FeedbackItemsModel data) =>
    json.encode(data.toJson());

class FeedbackItemsModel {
  bool success;
  List<FeedbackItem> data;
  String message;

  FeedbackItemsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FeedbackItemsModel.fromJson(Map<String, dynamic> json) =>
      FeedbackItemsModel(
        success: json["success"],
        data: List<FeedbackItem>.from(
            json["data"].map((x) => FeedbackItem.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class FeedbackItem {
  int id;
  String subject;
  String questype;
  String board;
  int show;
  DateTime updatedAt;
  DateTime createdAt;
  int ord;

  FeedbackItem({
    required this.id,
    required this.subject,
    required this.questype,
    required this.board,
    required this.show,
    required this.updatedAt,
    required this.createdAt,
    required this.ord,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) => FeedbackItem(
        id: json["id"],
        subject: json["subject"],
        questype: json["questype"],
        board: json["board"],
        show: json["show"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        ord: json["ord"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject": subject,
        "questype": questype,
        "board": board,
        "show": show,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "ord": ord,
      };
}
