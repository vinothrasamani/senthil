import 'dart:convert';

NoticeModel noticeModelFromJson(String str) =>
    NoticeModel.fromJson(json.decode(str));

String noticeModelToJson(NoticeModel data) => json.encode(data.toJson());

class NoticeModel {
  bool success;
  NoticeData data;
  String message;

  NoticeModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
        success: json["success"],
        data: NoticeData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class NoticeData {
  int id;
  String noticetext;
  String noticeby;
  String noticetitle;
  DateTime updatedAt;
  int active;
  int banner;
  String feedsession;
  dynamic feedyear;
  String staffcode;
  String schooltype;
  String school;
  int stafffeedback;
  int animation;
  dynamic slmStaffcode;
  dynamic dpicStaffcode;
  dynamic dpimStaffcode;
  dynamic kgicStaffcode;
  dynamic kgimStaffcode;
  int? dash;

  NoticeData({
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

  factory NoticeData.fromJson(Map<String, dynamic> json) => NoticeData(
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
