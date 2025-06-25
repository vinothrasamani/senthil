// To parse this JSON data, do
//
//     final classTopperListModel = classTopperListModelFromJson(jsonString);

import 'dart:convert';

ClassTopperListModel classTopperListModelFromJson(String str) =>
    ClassTopperListModel.fromJson(json.decode(str));

String classTopperListModelToJson(ClassTopperListModel data) =>
    json.encode(data.toJson());

class ClassTopperListModel {
  bool success;
  Data data;
  String message;

  ClassTopperListModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ClassTopperListModel.fromJson(Map<String, dynamic> json) =>
      ClassTopperListModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  List<ClsTopper> clsToppers;

  Data({
    required this.clsToppers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        clsToppers: List<ClsTopper>.from(
            json["cls_toppers"].map((x) => ClsTopper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cls_toppers": List<dynamic>.from(clsToppers.map((x) => x.toJson())),
      };
}

class ClsTopper {
  String school;
  List<Detail> details;

  ClsTopper({
    required this.school,
    required this.details,
  });

  factory ClsTopper.fromJson(Map<String, dynamic> json) => ClsTopper(
        school: json["school"]!,
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "school": school,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class Detail {
  int rank;
  List<Topper> topper;

  Detail({
    required this.rank,
    required this.topper,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        rank: json["rank"],
        topper:
            List<Topper>.from(json["topper"].map((x) => Topper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "topper": List<dynamic>.from(topper.map((x) => x.toJson())),
      };
}

class Topper {
  List<ListElement> list;

  Topper({
    required this.list,
  });

  factory Topper.fromJson(Map<String, dynamic> json) => Topper(
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class ListElement {
  int id;
  String schooltype;
  String school;
  String examName;
  String className;
  dynamic classgroup;
  String subjectName;
  String studentName;
  int value;
  int ord;
  String year;
  String sectionGroup;
  String filename;
  String subjectTeacher;
  String adminno;
  String photo;
  String toppertype;
  int rank;
  int subord;
  int schord;
  String courseGroup;
  String streamGroup;
  String refGroup;
  String refnote;
  int examid;
  dynamic course;
  dynamic maincourse;

  ListElement({
    required this.id,
    required this.schooltype,
    required this.school,
    required this.examName,
    required this.className,
    required this.classgroup,
    required this.subjectName,
    required this.studentName,
    required this.value,
    required this.ord,
    required this.year,
    required this.sectionGroup,
    required this.filename,
    required this.subjectTeacher,
    required this.adminno,
    required this.photo,
    required this.toppertype,
    required this.rank,
    required this.subord,
    required this.schord,
    required this.courseGroup,
    required this.streamGroup,
    required this.refGroup,
    required this.refnote,
    required this.examid,
    required this.course,
    required this.maincourse,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        schooltype: json["Schooltype"],
        school: json["School"],
        examName: json["ExamName"],
        className: json["ClassName"],
        classgroup: json["Classgroup"],
        subjectName: json["SubjectName"],
        studentName: json["StudentName"],
        value: json["Value"],
        ord: json["Ord"],
        year: json["Year"],
        sectionGroup: json["SectionGroup"],
        filename: json["filename"],
        subjectTeacher: json["SubjectTeacher"],
        adminno: json["Adminno"],
        photo: json["photo"],
        toppertype: json["toppertype"],
        rank: json["Rank"],
        subord: json["subord"],
        schord: json["schord"],
        courseGroup: json["CourseGroup"],
        streamGroup: json["StreamGroup"],
        refGroup: json["RefGroup"],
        refnote: json["refnote"],
        examid: json["examid"],
        course: json["course"],
        maincourse: json["maincourse"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Schooltype": schooltype,
        "School": school,
        "ExamName": examName,
        "ClassName": className,
        "Classgroup": classgroup,
        "SubjectName": subjectName,
        "StudentName": studentName,
        "Value": value,
        "Ord": ord,
        "Year": year,
        "SectionGroup": sectionGroup,
        "filename": filename,
        "SubjectTeacher": subjectTeacher,
        "Adminno": adminno,
        "photo": photo,
        "toppertype": toppertype,
        "Rank": rank,
        "subord": subord,
        "schord": schord,
        "CourseGroup": courseGroup,
        "StreamGroup": streamGroup,
        "RefGroup": refGroup,
        "refnote": refnote,
        "examid": examid,
        "course": course,
        "maincourse": maincourse,
      };
}
