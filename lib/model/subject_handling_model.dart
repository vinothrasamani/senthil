import 'dart:convert';

SubjectHandlingModel subjectHandlingModelFromJson(String str) =>
    SubjectHandlingModel.fromJson(json.decode(str));

String subjectHandlingModelToJson(SubjectHandlingModel data) =>
    json.encode(data.toJson());

class SubjectHandlingModel {
  bool success;
  List<HandlingSubject> data;
  String message;

  SubjectHandlingModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory SubjectHandlingModel.fromJson(Map<String, dynamic> json) =>
      SubjectHandlingModel(
        success: json["success"],
        data: List<HandlingSubject>.from(
            json["data"].map((x) => HandlingSubject.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class HandlingSubject {
  int id;
  String fullname;
  String code;
  String staffName;
  String classname;
  String department;
  int subhandid;
  String secname;
  dynamic courseGroup;
  dynamic streamGroup;
  dynamic refGroup;
  dynamic status;

  HandlingSubject({
    required this.id,
    required this.fullname,
    required this.code,
    required this.staffName,
    required this.classname,
    required this.department,
    required this.subhandid,
    required this.secname,
    required this.courseGroup,
    required this.streamGroup,
    required this.refGroup,
    required this.status,
  });

  factory HandlingSubject.fromJson(Map<String, dynamic> json) =>
      HandlingSubject(
        id: json["id"],
        fullname: json["fullname"],
        code: json["code"],
        staffName: json["StaffName"],
        classname: json["classname"],
        department: json["department"],
        subhandid: json["subhandid"],
        secname: json["secname"],
        courseGroup: json["CourseGroup"] ?? '',
        streamGroup: json["StreamGroup"] ?? '',
        refGroup: json["RefGroup"] ?? '',
        status: json["status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "code": code,
        "StaffName": staffName,
        "classname": classname,
        "department": department,
        "subhandid": subhandid,
        "secname": secname,
        "CourseGroup": courseGroup,
        "StreamGroup": streamGroup,
        "RefGroup": refGroup,
        "status": status,
      };
}
