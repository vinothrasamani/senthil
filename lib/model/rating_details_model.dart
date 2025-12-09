// To parse this JSON data, do
//
//     final ratingDetailsModel = ratingDetailsModelFromJson(jsonString);

import 'dart:convert';

RatingDetailsModel ratingDetailsModelFromJson(String str) =>
    RatingDetailsModel.fromJson(json.decode(str));

String ratingDetailsModelToJson(RatingDetailsModel data) =>
    json.encode(data.toJson());

class RatingDetailsModel {
  bool success;
  RatingDetails data;
  String message;

  RatingDetailsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory RatingDetailsModel.fromJson(Map<String, dynamic> json) =>
      RatingDetailsModel(
        success: json["success"],
        data: RatingDetails.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class RatingDetails {
  String subject;
  String staff;
  String question;
  List<ProvidedFeedback> providedFeedback;

  RatingDetails({
    required this.subject,
    required this.staff,
    required this.question,
    required this.providedFeedback,
  });

  factory RatingDetails.fromJson(Map<String, dynamic> json) => RatingDetails(
        subject: json["subject"],
        staff: json["staff"],
        question: json["question"],
        providedFeedback: List<ProvidedFeedback>.from(
            json["providedFeedback"].map((x) => ProvidedFeedback.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "staff": staff,
        "question": question,
        "providedFeedback":
            List<dynamic>.from(providedFeedback.map((x) => x.toJson())),
      };
}

class ProvidedFeedback {
  int id;
  int feedstudId;
  int feedquesid;
  int subjectid;
  int star;
  dynamic questype;
  dynamic remark;
  DateTime createdAt;
  DateTime updatedAt;
  String staffOid;
  String studOid;
  int excSubId;
  int active;

  ProvidedFeedback({
    required this.id,
    required this.feedstudId,
    required this.feedquesid,
    required this.subjectid,
    required this.star,
    required this.questype,
    required this.remark,
    required this.createdAt,
    required this.updatedAt,
    required this.staffOid,
    required this.studOid,
    required this.excSubId,
    required this.active,
  });

  factory ProvidedFeedback.fromJson(Map<String, dynamic> json) =>
      ProvidedFeedback(
        id: json["id"],
        feedstudId: json["feedstud_id"],
        feedquesid: json["feedquesid"],
        subjectid: json["subjectid"],
        star: json["star"],
        questype: json["questype"],
        remark: json["remark"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        staffOid: json["staff_oid"],
        studOid: json["StudOid"],
        excSubId: json["exc_sub_id"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "feedstud_id": feedstudId,
        "feedquesid": feedquesid,
        "subjectid": subjectid,
        "star": star,
        "questype": questype,
        "remark": remark,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "staff_oid": staffOid,
        "StudOid": studOid,
        "exc_sub_id": excSubId,
        "active": active,
      };
}
