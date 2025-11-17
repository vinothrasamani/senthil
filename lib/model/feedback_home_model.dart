import 'dart:convert';

FeedbackHomeModel feedbackHomeModelFromJson(String str) =>
    FeedbackHomeModel.fromJson(json.decode(str));

String feedbackHomeModelToJson(FeedbackHomeModel data) =>
    json.encode(data.toJson());

class FeedbackHomeModel {
  bool success;
  FeedbackHome data;
  String message;

  FeedbackHomeModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FeedbackHomeModel.fromJson(Map<String, dynamic> json) =>
      FeedbackHomeModel(
        success: json["success"],
        data: FeedbackHome.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class FeedbackHome {
  String title;
  FeedbackNotice notice;
  List<String> schooltype;
  List<String> school;
  List<String> classname;
  List<String> sections;
  String staff;
  List<String> refgrouplist;

  FeedbackHome({
    required this.title,
    required this.notice,
    required this.schooltype,
    required this.school,
    required this.classname,
    required this.sections,
    required this.staff,
    required this.refgrouplist,
  });

  factory FeedbackHome.fromJson(Map<String, dynamic> json) => FeedbackHome(
        title: json["title"],
        notice: FeedbackNotice.fromJson(json["notice"]),
        schooltype: List<String>.from(json["Schooltype"].map((x) => x)),
        school: List<String>.from(json["School"].map((x) => x)),
        classname: List<String>.from(json["classname"].map((x) => x)),
        sections: List<String>.from(json["sections"].map((x) => x)),
        staff: json["Staff"],
        refgrouplist: List<String>.from(json["refgrouplist"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "notice": notice.toJson(),
        "Schooltype": List<dynamic>.from(schooltype.map((x) => x)),
        "School": List<dynamic>.from(school.map((x) => x)),
        "classname": List<dynamic>.from(classname.map((x) => x)),
        "sections": List<dynamic>.from(sections.map((x) => x)),
        "Staff": staff,
        "refgrouplist": List<dynamic>.from(refgrouplist.map((x) => x)),
      };
}

class FeedbackNotice {
  int id;
  String noticetext;
  String noticeby;
  String noticetitle;
  DateTime updatedAt;
  int active;
  int banner;
  String feedsession;
  String feedyear;
  String staffcode;
  String schooltype;
  String school;
  int stafffeedback;
  int animation;
  String slmStaffcode;
  String dpicStaffcode;
  String dpimStaffcode;
  String kgicStaffcode;
  String kgimStaffcode;
  dynamic dash;

  FeedbackNotice({
    required this.id,
    required this.noticetext,
    required this.noticeby,
    required this.noticetitle,
    required this.updatedAt,
    required this.active,
    required this.banner,
    required this.feedsession,
    required this.feedyear,
    required this.staffcode,
    required this.schooltype,
    required this.school,
    required this.stafffeedback,
    required this.animation,
    required this.slmStaffcode,
    required this.dpicStaffcode,
    required this.dpimStaffcode,
    required this.kgicStaffcode,
    required this.kgimStaffcode,
    required this.dash,
  });

  factory FeedbackNotice.fromJson(Map<String, dynamic> json) => FeedbackNotice(
        id: json["id"],
        noticetext: json["noticetext"],
        noticeby: json["noticeby"],
        noticetitle: json["noticetitle"],
        updatedAt: DateTime.parse(json["updated_at"]),
        active: json["active"],
        banner: json["banner"],
        feedsession: json["feedsession"],
        feedyear: json["feedyear"],
        staffcode: json["staffcode"],
        schooltype: json["Schooltype"],
        school: json["School"],
        stafffeedback: json["stafffeedback"],
        animation: json["animation"],
        slmStaffcode: json["slm_staffcode"],
        dpicStaffcode: json["dpic_staffcode"],
        dpimStaffcode: json["dpim_staffcode"],
        kgicStaffcode: json["kgic_staffcode"],
        kgimStaffcode: json["kgim_staffcode"],
        dash: json["dash"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "noticetext": noticetext,
        "noticeby": noticeby,
        "noticetitle": noticetitle,
        "updated_at": updatedAt.toIso8601String(),
        "active": active,
        "banner": banner,
        "feedsession": feedsession,
        "feedyear": feedyear,
        "staffcode": staffcode,
        "Schooltype": schooltype,
        "School": school,
        "stafffeedback": stafffeedback,
        "animation": animation,
        "slm_staffcode": slmStaffcode,
        "dpic_staffcode": dpicStaffcode,
        "dpim_staffcode": dpimStaffcode,
        "kgic_staffcode": kgicStaffcode,
        "kgim_staffcode": kgimStaffcode,
        "dash": dash,
      };
}
