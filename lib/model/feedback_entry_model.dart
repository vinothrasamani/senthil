import 'dart:convert';

FeedbackEntryModel feedbackEntryModelFromJson(String str) =>
    FeedbackEntryModel.fromJson(json.decode(str));

String feedbackEntryModelToJson(FeedbackEntryModel data) =>
    json.encode(data.toJson());

class FeedbackEntryModel {
  bool success;
  List<FeedbackEntry> data;
  String message;

  FeedbackEntryModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FeedbackEntryModel.fromJson(Map<String, dynamic> json) =>
      FeedbackEntryModel(
        success: json["success"],
        data: List<FeedbackEntry>.from(
            json["data"].map((x) => FeedbackEntry.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class FeedbackEntry {
  int id;
  String? school;
  String? schooltype;
  dynamic admno;
  String? feedbacksession;
  String? feedbackyear;
  String? classname;
  String? section;
  dynamic coursegroup;
  dynamic streamgroup;
  int refgroup;
  String? sub;
  DateTime createdAt;
  DateTime updatedAt;
  String? feedbackType;
  dynamic staffOid;
  dynamic notedesc;
  DateTime entryDate;
  int userId;
  dynamic refgroupId;
  Feed feed;

  FeedbackEntry({
    required this.id,
    required this.school,
    required this.schooltype,
    required this.admno,
    required this.feedbacksession,
    required this.feedbackyear,
    required this.classname,
    required this.section,
    required this.coursegroup,
    required this.streamgroup,
    required this.refgroup,
    required this.sub,
    required this.createdAt,
    required this.updatedAt,
    required this.feedbackType,
    required this.staffOid,
    required this.notedesc,
    required this.entryDate,
    required this.userId,
    required this.refgroupId,
    required this.feed,
  });

  factory FeedbackEntry.fromJson(Map<String, dynamic> json) => FeedbackEntry(
        id: json["id"],
        school: json["school"],
        schooltype: json["schooltype"],
        admno: json["admno"],
        feedbacksession: json["feedbacksession"],
        feedbackyear: json["feedbackyear"],
        classname: json["classname"],
        section: json["section"],
        coursegroup: json["coursegroup"],
        streamgroup: json["streamgroup"],
        refgroup: json["refgroup"],
        sub: json["sub"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        feedbackType: json["feedback_type"],
        staffOid: json["staff_oid"],
        notedesc: json["notedesc"],
        entryDate: DateTime.parse(json["entry_date"]),
        userId: json["user_id"],
        refgroupId: json["refgroup_id"],
        feed: Feed.fromJson(json["feed"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "school": school,
        "schooltype": schooltype,
        "admno": admno,
        "feedbacksession": feedbacksession,
        "feedbackyear": feedbackyear,
        "classname": classname,
        "section": section,
        "coursegroup": coursegroup,
        "streamgroup": streamgroup,
        "refgroup": refgroup,
        "sub": sub,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "feedback_type": feedbackType,
        "staff_oid": staffOid,
        "notedesc": notedesc,
        "entry_date": entryDate.toIso8601String(),
        "user_id": userId,
        "refgroup_id": refgroupId,
        "feed": feed.toJson(),
      };
}

class Feed {
  int fCount;
  int eCount;
  List<String?> list;

  Feed({
    required this.fCount,
    required this.eCount,
    required this.list,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        fCount: json["fCount"],
        eCount: json["eCount"],
        list: List<String?>.from(json["list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "fCount": fCount,
        "eCount": eCount,
        "list": List<dynamic>.from(list.map((x) => x)),
      };
}
