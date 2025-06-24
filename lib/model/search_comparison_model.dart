
import 'dart:convert';

SearchComparisonModel searchComparisonModelFromJson(String str) => SearchComparisonModel.fromJson(json.decode(str));

String searchComparisonModelToJson(SearchComparisonModel data) => json.encode(data.toJson());

class SearchComparisonModel {
    bool success;
    Data data;
    String message;

    SearchComparisonModel({
        required this.success,
        required this.data,
        required this.message,
    });

    factory SearchComparisonModel.fromJson(Map<String, dynamic> json) => SearchComparisonModel(
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
    List<School> schools;
    List<String> subjects;
    List<ValueElement> myValues;

    Data({
        required this.schools,
        required this.subjects,
        required this.myValues,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        schools: List<School>.from(json["schools"].map((x) => School.fromJson(x))),
        subjects: List<String>.from(json["subjects"].map((x) => x)),
        myValues: List<ValueElement>.from(json["values"].map((x) => ValueElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "schools": List<dynamic>.from(schools.map((x) => x.toJson())),
        "subjects": List<dynamic>.from(subjects.map((x) => x)),
        "values": List<dynamic>.from(myValues.map((x) => x.toJson())),
    };
}

class School {
    int schord;
    String school;

    School({
        required this.schord,
        required this.school,
    });

    factory School.fromJson(Map<String, dynamic> json) => School(
        schord: json["schord"],
        school: json["School"],
    );

    Map<String, dynamic> toJson() => {
        "schord": schord,
        "School": school,
    };
}

class ValueElement {
    String title;
    List<ListElement> myList;

    ValueElement({
        required this.title,
        required this.myList,
    });

    factory ValueElement.fromJson(Map<String, dynamic> json) => ValueElement(
        title: json["title"],
        myList: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "list": List<dynamic>.from(myList.map((x) => x.toJson())),
    };
}

class ListElement {
    List<Count> counts;

    ListElement({
        required this.counts,
    });

    factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        counts: List<Count>.from(json["counts"].map((x) => Count.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "counts": List<dynamic>.from(counts.map((x) => x.toJson())),
    };
}

class Count {
    dynamic value;

    Count({
        required this.value,
    });

    factory Count.fromJson(Map<String, dynamic> json) => Count(
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
    };
}

enum ValueEnum {
    EMPTY
}

final valueEnumValues = EnumValues({
    "_": ValueEnum.EMPTY
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
