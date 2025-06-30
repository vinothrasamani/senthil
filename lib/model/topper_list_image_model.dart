import 'dart:convert';

TopperListImageModel topperListImageModelFromJson(String str) =>
    TopperListImageModel.fromJson(json.decode(str));

String topperListImageModelToJson(TopperListImageModel data) =>
    json.encode(data.toJson());

class TopperListImageModel {
  bool success;
  TopperListImageData data;
  String message;

  TopperListImageModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory TopperListImageModel.fromJson(Map<String, dynamic> json) =>
      TopperListImageModel(
        success: json["success"],
        data: TopperListImageData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class TopperListImageData {
  List<TopperListImageClsTopper> clsToppers;
  TopperListImageSubToppers subToppers;

  TopperListImageData({
    required this.clsToppers,
    required this.subToppers,
  });

  factory TopperListImageData.fromJson(Map<String, dynamic> json) =>
      TopperListImageData(
        clsToppers: List<TopperListImageClsTopper>.from(json["cls_toppers"]
            .map((x) => TopperListImageClsTopper.fromJson(x))),
        subToppers: TopperListImageSubToppers.fromJson(json["sub_toppers"]),
      );

  Map<String, dynamic> toJson() => {
        "cls_toppers": List<dynamic>.from(clsToppers.map((x) => x.toJson())),
        "sub_toppers": subToppers.toJson(),
      };
}

class TopperListImageClsTopper {
  String school;
  List<TopperDatum> topperData;

  TopperListImageClsTopper({
    required this.school,
    required this.topperData,
  });

  factory TopperListImageClsTopper.fromJson(Map<String, dynamic> json) =>
      TopperListImageClsTopper(
        school: json["school"],
        topperData: List<TopperDatum>.from(
            json["topper_data"].map((x) => TopperDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "school": school,
        "topper_data": List<dynamic>.from(topperData.map((x) => x.toJson())),
      };
}

class TopperDatum {
  int rank;
  List<TopperListImageDetail> details;

  TopperDatum({
    required this.rank,
    required this.details,
  });

  factory TopperDatum.fromJson(Map<String, dynamic> json) => TopperDatum(
        rank: json["rank"],
        details: List<TopperListImageDetail>.from(
            json["details"].map((x) => TopperListImageDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class TopperListImageDetail {
  TopperListImageStud stud;
  List<TopperListImageListElement> info;

  TopperListImageDetail({
    required this.stud,
    required this.info,
  });

  factory TopperListImageDetail.fromJson(Map<String, dynamic> json) =>
      TopperListImageDetail(
        stud: TopperListImageStud.fromJson(json["Stud"]),
        info: List<TopperListImageListElement>.from(
            json["info"].map((x) => TopperListImageListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Stud": stud.toJson(),
        "info": List<dynamic>.from(info.map((x) => x.toJson())),
      };
}

class TopperListImageListElement {
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

  TopperListImageListElement({
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

  factory TopperListImageListElement.fromJson(Map<String, dynamic> json) =>
      TopperListImageListElement(
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

class TopperListImageStud {
  String studentName;
  String photo;
  String adminno;
  String subjectTeacher;
  String refnote;

  TopperListImageStud({
    required this.studentName,
    required this.photo,
    required this.adminno,
    required this.subjectTeacher,
    required this.refnote,
  });

  factory TopperListImageStud.fromJson(Map<String, dynamic> json) =>
      TopperListImageStud(
        studentName: json["StudentName"],
        photo: json["photo"],
        adminno: json["Adminno"],
        subjectTeacher: json["SubjectTeacher"],
        refnote: json["refnote"],
      );

  Map<String, dynamic> toJson() => {
        "StudentName": studentName,
        "photo": photo,
        "Adminno": adminno,
        "SubjectTeacher": subjectTeacher,
        "refnote": refnote,
      };
}

class TopperListImageSubToppers {
  List<String> schools;
  List<TopperListImageSubList> subList;

  TopperListImageSubToppers({
    required this.schools,
    required this.subList,
  });

  factory TopperListImageSubToppers.fromJson(Map<String, dynamic> json) =>
      TopperListImageSubToppers(
        schools: List<String>.from(json["schools"].map((x) => x)),
        subList: List<TopperListImageSubList>.from(
            json["subList"].map((x) => TopperListImageSubList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "schools": List<dynamic>.from(schools.map((x) => x)),
        "subList": List<dynamic>.from(subList.map((x) => x.toJson())),
      };
}

class TopperListImageSubList {
  String subject;
  List<TopperListImageValueList> valueList;

  TopperListImageSubList({
    required this.subject,
    required this.valueList,
  });

  factory TopperListImageSubList.fromJson(Map<String, dynamic> json) =>
      TopperListImageSubList(
        subject: json["subject"],
        valueList: List<TopperListImageValueList>.from(json["value_list"]
            .map((x) => TopperListImageValueList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "value_list": List<dynamic>.from(valueList.map((x) => x.toJson())),
      };
}

class TopperListImageValueList {
  int max;
  List<TopperListImageListElement> list;

  TopperListImageValueList({
    required this.max,
    required this.list,
  });

  factory TopperListImageValueList.fromJson(Map<String, dynamic> json) =>
      TopperListImageValueList(
        max: json["max"],
        list: List<TopperListImageListElement>.from(
            json["list"].map((x) => TopperListImageListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "max": max,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}
