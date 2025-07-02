import 'dart:convert';

QuestionModel questionModelFromJson(String str) =>
    QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {
  bool success;
  List<QuestionData> data;
  String message;

  QuestionModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        success: json["success"],
        data: List<QuestionData>.from(
            json["data"].map((x) => QuestionData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class QuestionData {
  String school;
  List<QuestionDetail> details;

  QuestionData({
    required this.school,
    required this.details,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) => QuestionData(
        school: json["school"],
        details: List<QuestionDetail>.from(
            json["details"].map((x) => QuestionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "school": school,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class QuestionDetail {
  QuestionSubject subject;
  QuestionInfo info;

  QuestionDetail({
    required this.subject,
    required this.info,
  });

  factory QuestionDetail.fromJson(Map<String, dynamic> json) => QuestionDetail(
        subject: QuestionSubject.fromJson(json["subject"]),
        info: QuestionInfo.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "subject": subject.toJson(),
        "info": info.toJson(),
      };
}

class QuestionInfo {
  int id;
  String schooltype;
  String year;
  String school;
  String examName;
  String className;
  dynamic classgroup;
  String sectionGroup;
  String subjectName;
  String? examQuestion;
  String? markingScheme;
  int ord;
  String remark;
  int schord;
  int examid;

  QuestionInfo({
    required this.id,
    required this.schooltype,
    required this.year,
    required this.school,
    required this.examName,
    required this.className,
    required this.classgroup,
    required this.sectionGroup,
    required this.subjectName,
    required this.examQuestion,
    required this.markingScheme,
    required this.ord,
    required this.remark,
    required this.schord,
    required this.examid,
  });

  factory QuestionInfo.fromJson(Map<String, dynamic> json) => QuestionInfo(
        id: json["id"],
        schooltype: json["Schooltype"],
        year: json["Year"],
        school: json["School"],
        examName: json["ExamName"],
        className: json["ClassName"],
        classgroup: json["Classgroup"],
        sectionGroup: json["SectionGroup"],
        subjectName: json["SubjectName"],
        examQuestion: json["ExamQuestion"],
        markingScheme: json["MarkingScheme"],
        ord: json["Ord"],
        remark: json["Remark"],
        schord: json["schord"],
        examid: json["examid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Schooltype": schooltype,
        "Year": year,
        "School": school,
        "ExamName": examName,
        "ClassName": className,
        "Classgroup": classgroup,
        "SectionGroup": sectionGroup,
        "SubjectName": subjectName,
        "ExamQuestion": examQuestion,
        "MarkingScheme": markingScheme,
        "Ord": ord,
        "Remark": remark,
        "schord": schord,
        "examid": examid,
      };
}

class QuestionSubject {
  int ord;
  String subjectName;

  QuestionSubject({
    required this.ord,
    required this.subjectName,
  });

  factory QuestionSubject.fromJson(Map<String, dynamic> json) =>
      QuestionSubject(
        ord: json["ord"],
        subjectName: json["SubjectName"],
      );

  Map<String, dynamic> toJson() => {
        "ord": ord,
        "SubjectName": subjectName,
      };
}
