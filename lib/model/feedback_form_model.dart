import 'dart:convert';

FeedbackFormModel feedbackFormModelFromJson(String str) =>
    FeedbackFormModel.fromJson(json.decode(str));

String feedbackFormModelToJson(FeedbackFormModel data) =>
    json.encode(data.toJson());

class FeedbackFormModel {
  bool success;
  FeedbackFormData data;
  String message;

  FeedbackFormModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FeedbackFormModel.fromJson(Map<String, dynamic> json) =>
      FeedbackFormModel(
        success: json["success"],
        data: FeedbackFormData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class FeedbackFormData {
  String title;
  String studOid;
  List<FeedQues> feedQues;
  List<FeedFormSubject> subject;

  FeedbackFormData({
    required this.title,
    required this.studOid,
    required this.feedQues,
    required this.subject,
  });

  factory FeedbackFormData.fromJson(Map<String, dynamic> json) =>
      FeedbackFormData(
        title: json["title"],
        studOid: json["studOid"],
        feedQues: List<FeedQues>.from(
          json["feedQues"].map((x) => FeedQues.fromJson(x)),
        ),
        subject: List<FeedFormSubject>.from(
          json["subject"].map((x) => FeedFormSubject.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "studOid": studOid,
        "feedQues": feedQues.map((x) => x.toJson()).toList(),
        "subject": subject.map((x) => x.toJson()).toList(),
      };
}

class FeedQues {
  int id;
  String subject;
  int ord;
  String questype;
  String board;
  int show;
  DateTime updatedAt;
  DateTime createdAt;

  FeedQues({
    required this.id,
    required this.subject,
    required this.ord,
    required this.questype,
    required this.board,
    required this.show,
    required this.updatedAt,
    required this.createdAt,
  });

  factory FeedQues.fromJson(Map<String, dynamic> json) => FeedQues(
        id: json["id"],
        subject: json["subject"],
        ord: int.parse(json["ord"].toString()),
        questype: json["questype"],
        board: json["board"],
        show: int.parse(json["show"].toString()),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject": subject,
        "ord": ord,
        "questype": questype,
        "board": board,
        "show": show,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}

class FeedFormSubject {
  int id;
  String fullname;
  String? staffName;
  String department;

  FeedFormSubject({
    required this.id,
    required this.fullname,
    required this.staffName,
    required this.department,
  });

  factory FeedFormSubject.fromJson(Map<String, dynamic> json) =>
      FeedFormSubject(
        id: json["id"],
        fullname: json["fullname"],
        staffName: json["StaffName"],
        department: json["department"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "StaffName": staffName,
        "department": department,
      };
}
