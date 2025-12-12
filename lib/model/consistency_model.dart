class ConsistencyModel {
  final List<ExamName> examNames;
  final Map<String, Map<String, List<dynamic>>>? results;
  final List<School> schools;

  ConsistencyModel({
    required this.examNames,
    required this.results,
    required this.schools,
  });

  factory ConsistencyModel.fromJson(Map<String, dynamic> json) {
    final examNamesList = (json['examNames'] as List<dynamic>?)
            ?.map((e) => ExamName.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final resultsMap = <String, Map<String, List<dynamic>>>{};
    final resultsJson = json['results'] == null
        ? null
        : json['results'] as Map<String, dynamic>?;
    if (resultsJson != null) {
      resultsJson.forEach((schoolKey, schoolData) {
        final schoolExams = <String, List<dynamic>>{};
        if (schoolData is Map<String, dynamic>) {
          schoolData.forEach((examKey, examStudents) {
            if (examStudents is List) {
              schoolExams[examKey] = examStudents;
            }
          });
        }
        resultsMap[schoolKey] = schoolExams;
      });
    }

    final schoolsList = (json['schools'] as List<dynamic>?)
            ?.map((e) => School.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return ConsistencyModel(
      examNames: examNamesList,
      results: resultsMap,
      schools: schoolsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'examNames': examNames.map((e) => e.toJson()).toList(),
      'results': results?.map((key, value) {
        final examMap = <String, dynamic>{};
        value.forEach((examKey, examData) {
          examMap[examKey] = examData;
        });
        return MapEntry(key, examMap);
      }),
      'schools': schools.map((e) => e.toJson()).toList(),
    };
  }
}

class ExamName {
  final int id;
  final String shortname;

  ExamName({
    required this.id,
    required this.shortname,
  });

  factory ExamName.fromJson(Map<String, dynamic> json) {
    return ExamName(
      id: json['id'] as int? ?? 0,
      shortname: json['shortname'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shortname': shortname,
    };
  }
}

class School {
  final String short;

  School({
    required this.short,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      short: json['short'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'short': short,
    };
  }
}
