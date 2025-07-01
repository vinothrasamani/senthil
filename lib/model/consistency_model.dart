import 'dart:convert';

ConsistencyModel consistencyModelFromJson(String str) =>
    ConsistencyModel.fromJson(json.decode(str));

String consistencyModelToJson(ConsistencyModel data) =>
    json.encode(data.toJson());

class ConsistencyModel {
  bool success;
  ConsistencyData data;
  String message;

  ConsistencyModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ConsistencyModel.fromJson(Map<String, dynamic> json) =>
      ConsistencyModel(
        success: json["success"],
        data: ConsistencyData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class ConsistencyData {
  List<String> exams;
  List<ConSchool> schools;

  ConsistencyData({
    required this.exams,
    required this.schools,
  });

  factory ConsistencyData.fromJson(Map<String, dynamic> json) =>
      ConsistencyData(
        exams: List<String>.from(json["exams"].map((x) => x)),
        schools: List<ConSchool>.from(
            json["schools"].map((x) => ConSchool.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "exams": List<dynamic>.from(exams.map((x) => x)),
        "schools": List<dynamic>.from(schools.map((x) => x.toJson())),
      };
}

class ConSchool {
  String school;
  List<ConSchoolDatum> schoolData;

  ConSchool({
    required this.school,
    required this.schoolData,
  });

  factory ConSchool.fromJson(Map<String, dynamic> json) => ConSchool(
        school: json["school"],
        schoolData: List<ConSchoolDatum>.from(
            json["school_data"].map((x) => ConSchoolDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "school": school,
        "school_data": List<dynamic>.from(schoolData.map((x) => x.toJson())),
      };
}

class ConSchoolDatum {
  ConsistencyDetails details;
  List<ConExamDatum> examData;

  ConSchoolDatum({
    required this.details,
    required this.examData,
  });

  factory ConSchoolDatum.fromJson(Map<String, dynamic> json) => ConSchoolDatum(
        details: ConsistencyDetails.fromJson(json["details"]),
        examData: List<ConExamDatum>.from(
            json["exam_data"].map((x) => ConExamDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "details": details.toJson(),
        "exam_data": List<dynamic>.from(examData.map((x) => x.toJson())),
      };
}

class ConsistencyDetails {
  int ord;
  String studentName;
  String adminno;
  String sectionName;

  ConsistencyDetails({
    required this.ord,
    required this.studentName,
    required this.adminno,
    required this.sectionName,
  });

  factory ConsistencyDetails.fromJson(Map<String, dynamic> json) =>
      ConsistencyDetails(
        ord: json["Ord"],
        studentName: json["StudentName"],
        adminno: json["Adminno"],
        sectionName: json["SectionName"],
      );

  Map<String, dynamic> toJson() => {
        "Ord": ord,
        "StudentName": studentName,
        "Adminno": adminno,
        "SectionName": sectionName,
      };
}

class ConExamDatum {
  ConInfo? info;

  ConExamDatum({
    required this.info,
  });

  factory ConExamDatum.fromJson(Map<String, dynamic> json) => ConExamDatum(
        info: json["info"] == null ? null : ConInfo.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "info": info?.toJson(),
      };
}

class ConInfo {
  int id;
  String studentName;
  double value;
  int rank;

  ConInfo({
    required this.id,
    required this.studentName,
    required this.value,
    required this.rank,
  });

  factory ConInfo.fromJson(Map<String, dynamic> json) => ConInfo(
        id: json["id"],
        studentName: json["StudentName"],
        value: json["Value"]?.toDouble(),
        rank: json["Rank"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "StudentName": studentName,
        "Value": value,
        "Rank": rank,
      };
}
