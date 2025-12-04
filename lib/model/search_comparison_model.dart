import 'dart:convert';

SearchComparisonModel searchComparisonModelFromJson(String str) =>
    SearchComparisonModel.fromJson(json.decode(str));

String searchComparisonModelToJson(SearchComparisonModel data) =>
    json.encode(data.toJson());

class SearchComparisonModel {
  bool success;
  Data data;
  String message;

  SearchComparisonModel(
      {required this.success, required this.data, required this.message});

  factory SearchComparisonModel.fromJson(Map<String, dynamic> json) =>
      SearchComparisonModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() =>
      {"success": success, "data": data.toJson(), "message": message};
}

class Data {
  List<School> schools;
  List<String> subjects;
  List<ValueElement> myValues;
  Map<String, Map<String, SubjectReport>> report;
  List<Content> content;

  Data({
    required this.schools,
    required this.subjects,
    required this.myValues,
    required this.report,
    required this.content,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        schools:
            List<School>.from(json["school"].map((x) => School(school: x))),
        subjects: List<String>.from(json["subjects"].map((x) => x)),
        myValues: List<ValueElement>.from(
            json["values"]?.map((x) => ValueElement.fromJson(x)) ?? []),
        report: Map.from(json["report"]).map((schoolKey, schoolValue) =>
            MapEntry<String, Map<String, SubjectReport>>(
              schoolKey,
              Map.from(schoolValue).map(
                  (subjectKey, subjectValue) => MapEntry<String, SubjectReport>(
                        subjectKey,
                        SubjectReport.fromJson(subjectValue),
                      )),
            )),
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "school": List<dynamic>.from(schools.map((x) => x.toJson())),
        "subjects": List<dynamic>.from(subjects.map((x) => x)),
        "values": List<dynamic>.from(myValues.map((x) => x.toJson())),
        "report": Map.from(report).map((schoolKey, schoolValue) => MapEntry(
              schoolKey,
              Map.from(schoolValue).map((subjectKey, subjectValue) =>
                  MapEntry(subjectKey, subjectValue.toJson())),
            )),
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class School {
  String school;
  String? short;

  School({required this.school, this.short});
  factory School.fromJson(Map<String, dynamic> json) => School(
        school: json["school"] ?? json["School"] ?? '',
        short: json["short"],
      );

  Map<String, dynamic> toJson() => {"school": school, "short": short};
}

class SubjectReport {
  int onRoll;
  int present;
  int absent;
  int passed;
  int failed;
  int centum;
  int a1_91_99;
  int a1_96_99;
  int a1_91_95;
  int a2_81_90;
  int b1_71_80;
  int b2_61_70;
  int c1_51_60;
  int c2_41_50;
  int d_33_40;
  int e1_21_32;
  int e2_0_20;
  int lt_33;
  dynamic highestFirst;
  dynamic highestSecond;
  dynamic highestThird;
  dynamic highestFourth;
  dynamic highestFifth;
  dynamic lowestLast;
  dynamic lowestSecond;
  dynamic lowestThird;
  dynamic lowestFourth;
  dynamic lowestFifth;
  double average;
  double passPercent;
  double failPercent;

  SubjectReport({
    required this.onRoll,
    required this.present,
    required this.absent,
    required this.passed,
    required this.failed,
    required this.centum,
    required this.a1_91_99,
    required this.a1_96_99,
    required this.a1_91_95,
    required this.a2_81_90,
    required this.b1_71_80,
    required this.b2_61_70,
    required this.c1_51_60,
    required this.c2_41_50,
    required this.d_33_40,
    required this.e1_21_32,
    required this.e2_0_20,
    required this.lt_33,
    required this.highestFirst,
    required this.highestSecond,
    required this.highestThird,
    required this.highestFourth,
    required this.highestFifth,
    required this.lowestLast,
    required this.lowestSecond,
    required this.lowestThird,
    required this.lowestFourth,
    required this.lowestFifth,
    required this.average,
    required this.passPercent,
    required this.failPercent,
  });

  factory SubjectReport.fromJson(Map<String, dynamic> json) => SubjectReport(
        onRoll: json["on_roll"],
        present: json["present"],
        absent: json["absent"],
        passed: json["passed"],
        failed: json["failed"],
        centum: json["centum"],
        a1_91_99: json["a1_91_99"],
        a1_96_99: json["a1_96_99"],
        a1_91_95: json["a1_91_95"],
        a2_81_90: json["a2_81_90"],
        b1_71_80: json["b1_71_80"],
        b2_61_70: json["b2_61_70"],
        c1_51_60: json["c1_51_60"],
        c2_41_50: json["c2_41_50"],
        d_33_40: json["d_33_40"],
        e1_21_32: json["e1_21_32"],
        e2_0_20: json["e2_0_20"],
        lt_33: json["lt_33"],
        highestFirst: json["highest_first"],
        highestSecond: json["highest_second"],
        highestThird: json["highest_third"],
        highestFourth: json["highest_fourth"],
        highestFifth: json["highest_fifth"],
        lowestLast: json["lowest_last"],
        lowestSecond: json["lowest_second"],
        lowestThird: json["lowest_third"],
        lowestFourth: json["lowest_fourth"],
        lowestFifth: json["lowest_fifth"],
        average: json["average"].toDouble(),
        passPercent: json["pass_percent"].toDouble(),
        failPercent: json["fail_percent"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "on_roll": onRoll,
        "present": present,
        "absent": absent,
        "passed": passed,
        "failed": failed,
        "centum": centum,
        "a1_91_99": a1_91_99,
        "a1_96_99": a1_96_99,
        "a1_91_95": a1_91_95,
        "a2_81_90": a2_81_90,
        "b1_71_80": b1_71_80,
        "b2_61_70": b2_61_70,
        "c1_51_60": c1_51_60,
        "c2_41_50": c2_41_50,
        "d_33_40": d_33_40,
        "e1_21_32": e1_21_32,
        "e2_0_20": e2_0_20,
        "lt_33": lt_33,
        "highest_first": highestFirst,
        "highest_second": highestSecond,
        "highest_third": highestThird,
        "highest_fourth": highestFourth,
        "highest_fifth": highestFifth,
        "lowest_last": lowestLast,
        "lowest_second": lowestSecond,
        "lowest_third": lowestThird,
        "lowest_fourth": lowestFourth,
        "lowest_fifth": lowestFifth,
        "average": average,
        "pass_percent": passPercent,
        "fail_percent": failPercent,
      };

  dynamic getValueByContentId(int contentId) {
    switch (contentId) {
      case 1:
        return onRoll;
      case 2:
        return present;
      case 3:
        return absent;
      case 4:
        return highestFirst;
      case 5:
        return highestSecond;
      case 6:
        return highestThird;
      case 7:
        return highestFourth;
      case 8:
        return highestFifth;
      case 9:
        return lowestFifth;
      case 10:
        return lowestFourth;
      case 11:
        return lowestThird;
      case 12:
        return lowestSecond;
      case 13:
        return lowestLast;
      case 14:
        return average;
      case 15:
        return passed;
      case 16:
        return passPercent;
      case 17:
        return failed;
      case 18:
        return failPercent;
      case 19:
        return centum;
      case 20:
        return a1_96_99;
      case 21:
        return a1_91_95;
      case 22:
        return a2_81_90;
      case 23:
        return b1_71_80;
      case 24:
        return b2_61_70;
      case 25:
        return c1_51_60;
      case 26:
        return c2_41_50;
      case 27:
      case 29:
        return d_33_40;
      case 28:
        return lt_33;
      case 30:
        return e1_21_32;
      case 31:
        return e2_0_20;
      case 32:
        return a1_91_99;
      default:
        return '-';
    }
  }
}

class Content {
  int id;
  String name;
  int ord;
  int sl;
  int ctype;
  DateTime createdAt;
  DateTime updatedAt;

  Content({
    required this.id,
    required this.name,
    required this.ord,
    required this.sl,
    required this.ctype,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        name: json["name"],
        ord: json["Ord"],
        sl: json["sl"],
        ctype: json["ctype"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "Ord": ord,
        "sl": sl,
        "ctype": ctype,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class ValueElement {
  String title;
  List<ListElement> myList;

  ValueElement({required this.title, required this.myList});

  factory ValueElement.fromJson(Map<String, dynamic> json) => ValueElement(
        title: json["title"],
        myList: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "list": List<dynamic>.from(myList.map((x) => x.toJson())),
      };
}

class ListElement {
  List<Count> counts;

  ListElement({required this.counts});

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        counts: List<Count>.from(json["counts"].map((x) => Count.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "counts": List<dynamic>.from(counts.map((x) => x.toJson())),
      };
}

class Count {
  dynamic value;

  Count({required this.value});

  factory Count.fromJson(Map<String, dynamic> json) =>
      Count(value: json["value"]);

  Map<String, dynamic> toJson() => {"value": value};
}
