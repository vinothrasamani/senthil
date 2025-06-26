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
  List<ClsTopper> clsToppers;
  SubjectToppers subToppers;

  TopperListData({
    required this.clsToppers,
    required this.subToppers,
  });

  factory TopperListData.fromJson(Map<String, dynamic> json) => TopperListData(
        clsToppers: List<ClsTopper>.from(
            json["cls_toppers"].map((x) => ClsTopper.fromJson(x))),
        subToppers: SubjectToppers.fromJson(json["sub_toppers"]),
      );

  Map<String, dynamic> toJson() => {
        "cls_toppers": List<dynamic>.from(clsToppers.map((x) => x.toJson())),
        "sub_toppers": subToppers.toJson(),
      };
}

class ClsTopper {
  dynamic school;
  List<TopperDetail> details;

  ClsTopper({
    required this.school,
    required this.details,
  });

  factory ClsTopper.fromJson(Map<String, dynamic> json) => ClsTopper(
        school: json["school"],
        details: List<TopperDetail>.from(
            json["details"].map((x) => TopperDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "school": school,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class TopperDetail {
  int rank;
  List<Topper> topper;

  TopperDetail({
    required this.rank,
    required this.topper,
  });

  factory TopperDetail.fromJson(Map<String, dynamic> json) => TopperDetail(
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
  List<TopDatum> list;

  Topper({
    required this.list,
  });

  factory Topper.fromJson(Map<String, dynamic> json) => Topper(
        list:
            List<TopDatum>.from(json["list"].map((x) => TopDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class TopDatum {
  int id;
  dynamic schooltype;
  dynamic school;
  dynamic examName;
  dynamic className;
  dynamic classgroup;
  dynamic subjectName;
  String studentName;
  int value;
  int ord;
  dynamic year;
  dynamic sectionGroup;
  dynamic filename;
  dynamic subjectTeacher;
  dynamic adminno;
  dynamic photo;
  dynamic toppertype;
  int rank;
  int subord;
  int schord;
  dynamic courseGroup;
  dynamic streamGroup;
  dynamic refGroup;
  dynamic refnote;
  int examid;
  dynamic course;
  dynamic maincourse;

  TopDatum({
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

  factory TopDatum.fromJson(Map<String, dynamic> json) => TopDatum(
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

class SubjectToppers {
  List<SubList> subList;
  List<dynamic> schools;

  SubjectToppers({
    required this.subList,
    required this.schools,
  });

  factory SubjectToppers.fromJson(Map<String, dynamic> json) => SubjectToppers(
        subList:
            List<SubList>.from(json["subList"].map((x) => SubList.fromJson(x))),
        schools: List<dynamic>.from(json["schools"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "subList": List<dynamic>.from(subList.map((x) => x.toJson())),
        "schools": List<dynamic>.from(schools.map((x) => x)),
      };
}

class SubList {
  Subject subject;
  List<Value> value;

  SubList({
    required this.subject,
    required this.value,
  });

  factory SubList.fromJson(Map<String, dynamic> json) => SubList(
        subject: Subject.fromJson(json["subject"]),
        value: List<Value>.from(json["value"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subject": subject.toJson(),
        "value": List<dynamic>.from(value.map((x) => x.toJson())),
      };
}

class Subject {
  String subjectName;

  Subject({
    required this.subjectName,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        subjectName: json["SubjectName"],
      );

  Map<String, dynamic> toJson() => {
        "SubjectName": subjectName,
      };
}

class Value {
  Top? top;
  List<TopDatum> topData;

  Value({
    required this.top,
    required this.topData,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        top: json["top"] == null ? null : Top.fromJson(json["top"]),
        topData: List<TopDatum>.from(
            json["topData"].map((x) => TopDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "top": top?.toJson(),
        "topData": List<dynamic>.from(topData.map((x) => x.toJson())),
      };
}

class Top {
  int max;

  Top({
    required this.max,
  });

  factory Top.fromJson(Map<String, dynamic> json) => Top(
        max: json["max"],
      );

  Map<String, dynamic> toJson() => {
        "max": max,
      };
}
