import 'dart:convert';

TopperListModel topperListModelFromJson(String str) =>
    TopperListModel.fromJson(json.decode(str));

String topperListModelToJson(TopperListModel data) =>
    json.encode(data.toJson());

class TopperListModel {
  bool success;
  TopperListData data;
  String message;

  TopperListModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory TopperListModel.fromJson(Map<String, dynamic> json) =>
      TopperListModel(
        success: json["success"],
        data: TopperListData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class TopperListData {
  List<String> schools;
  Map<String, List<ClassTopperStudent>> classToppers;
  Map<String, Map<String, SubjectTopperData>> subjectToppers;

  TopperListData({
    required this.schools,
    required this.classToppers,
    required this.subjectToppers,
  });

  factory TopperListData.fromJson(Map<String, dynamic> json) {
    List<String> schools = List<String>.from(json["schools"]);

    Map<String, List<ClassTopperStudent>> classToppers = {};
    (json["classToppers"] as Map<String, dynamic>).forEach((school, students) {
      classToppers[school] = (students as List)
          .map((s) => ClassTopperStudent.fromJson(s))
          .toList();
    });

    Map<String, Map<String, SubjectTopperData>> subjectToppers = {};
    (json["subjectToppers"] as Map<String, dynamic>)
        .forEach((subject, schoolData) {
      subjectToppers[subject] = {};
      (schoolData as Map<String, dynamic>).forEach((school, data) {
        subjectToppers[subject]![school] = SubjectTopperData.fromJson(data);
      });
    });

    return TopperListData(
      schools: schools,
      classToppers: classToppers,
      subjectToppers: subjectToppers,
    );
  }

  Map<String, dynamic> toJson() => {
        "schools": schools,
        "classToppers": classToppers.map(
          (school, students) => MapEntry(
            school,
            students.map((s) => s.toJson()).toList(),
          ),
        ),
        "subjectToppers": subjectToppers.map(
          (subject, schoolData) => MapEntry(
            subject,
            schoolData.map((school, data) => MapEntry(school, data.toJson())),
          ),
        ),
      };
}

class ClassTopperStudent {
  String? stuOid;
  String? student;
  String school;
  int total;
  int maxTotal;
  int examTotal;
  List<SubjectMark> subjects;
  String? photo;
  String? file;

  ClassTopperStudent({
    this.stuOid,
    this.student,
    required this.school,
    required this.total,
    required this.maxTotal,
    required this.examTotal,
    required this.subjects,
    this.photo,
    this.file,
  });

  factory ClassTopperStudent.fromJson(Map<String, dynamic> json) =>
      ClassTopperStudent(
        stuOid: json["stuOid"],
        student: json["student"],
        school: json["school"],
        total: json["total"],
        maxTotal: json["maxTotal"],
        examTotal: json["examTotal"],
        subjects: List<SubjectMark>.from(
            json["subjects"].map((x) => SubjectMark.fromJson(x))),
        photo: json["photo"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "stuOid": stuOid,
        "student": student,
        "school": school,
        "total": total,
        "maxTotal": maxTotal,
        "examTotal": examTotal,
        "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
        "photo": photo,
        "file": file,
      };
}

class SubjectMark {
  String subject;
  int mark;
  int maxMark;
  String? file;

  SubjectMark({
    required this.subject,
    required this.mark,
    required this.maxMark,
    this.file,
  });

  factory SubjectMark.fromJson(Map<String, dynamic> json) => SubjectMark(
        subject: json["subject"],
        mark: json["mark"],
        maxMark: json["maxMark"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "mark": mark,
        "maxMark": maxMark,
        "file": file,
      };
}

class SubjectTopperData {
  List<SubjectTopperStudent> students;
  int topMark;
  int count;

  SubjectTopperData({
    required this.students,
    required this.topMark,
    required this.count,
  });

  factory SubjectTopperData.fromJson(Map<String, dynamic> json) =>
      SubjectTopperData(
        students: List<SubjectTopperStudent>.from(
            json["students"].map((x) => SubjectTopperStudent.fromJson(x))),
        topMark: json["topMark"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "students": List<dynamic>.from(students.map((x) => x.toJson())),
        "topMark": topMark,
        "count": count,
      };
}

class SubjectTopperStudent {
  String? stuOid;
  String? name;
  int mark;
  String? photo;
  String? file;

  SubjectTopperStudent({
    this.stuOid,
    this.name,
    required this.mark,
    this.photo,
    this.file,
  });

  factory SubjectTopperStudent.fromJson(Map<String, dynamic> json) =>
      SubjectTopperStudent(
        stuOid: json["stuOid"],
        name: json["name"],
        mark: json["mark"],
        photo: json["photo"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "stuOid": stuOid,
        "name": name,
        "mark": mark,
        "photo": photo,
        "file": file,
      };
}
