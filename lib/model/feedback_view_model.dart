import 'dart:convert';

FeedbackViewModel feedbackViewModelFromJson(String str) =>
    FeedbackViewModel.fromJson(json.decode(str));

String feedbackViewModelToJson(FeedbackViewModel data) =>
    json.encode(data.toJson());

class FeedbackViewModel {
  bool success;
  Data data;
  String message;

  FeedbackViewModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FeedbackViewModel.fromJson(Map<String, dynamic> json) =>
      FeedbackViewModel(
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
  List<int> feedbackStudents;
  List<FeedbackSubject> feedbackSubjects;
  FeedbackTab1 feedbackTab1;
  FeedbackTab2 feedbackTab2;
  String generalnote;

  Data({
    required this.feedbackStudents,
    required this.feedbackSubjects,
    required this.feedbackTab1,
    required this.feedbackTab2,
    required this.generalnote,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        feedbackStudents:
            List<int>.from(json["feedback_students"].map((x) => x)),
        feedbackSubjects: List<FeedbackSubject>.from(
            json["feedback_subjects"].map((x) => FeedbackSubject.fromJson(x))),
        feedbackTab1: FeedbackTab1.fromJson(json["feedback_tab1"]),
        feedbackTab2: FeedbackTab2.fromJson(json["feedback_tab2"]),
        generalnote: json["generalnote"],
      );

  Map<String, dynamic> toJson() => {
        "feedback_students": List<dynamic>.from(feedbackStudents.map((x) => x)),
        "feedback_subjects":
            List<dynamic>.from(feedbackSubjects.map((x) => x.toJson())),
        "feedback_tab1": feedbackTab1.toJson(),
        "feedback_tab2": feedbackTab2.toJson(),
        "generalnote": generalnote,
      };
}

class FeedbackSubject {
  int id;
  String fullname;
  String shortname;
  int shortShow;
  String oid;
  String staffName;

  FeedbackSubject({
    required this.id,
    required this.fullname,
    required this.shortname,
    required this.shortShow,
    required this.oid,
    required this.staffName,
  });

  factory FeedbackSubject.fromJson(Map<String, dynamic> json) =>
      FeedbackSubject(
        id: json["id"],
        fullname: json["fullname"],
        shortname: json["shortname"],
        shortShow: json["ShortShow"],
        oid: json["oid"],
        staffName: json["StaffName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "shortname": shortname,
        "ShortShow": shortShow,
        "oid": oid,
        "StaffName": staffName,
      };
}

class FeedbackTab1 {
  List<FeedbackCount> feedbackCounts;
  List<double> totalMarks;
  List<int> noOfStudents;
  FeedbackTotal feedbackTotal;
  List<double> feedbackPercent;

  FeedbackTab1({
    required this.feedbackCounts,
    required this.totalMarks,
    required this.noOfStudents,
    required this.feedbackTotal,
    required this.feedbackPercent,
  });

  factory FeedbackTab1.fromJson(Map<String, dynamic> json) => FeedbackTab1(
        feedbackCounts: List<FeedbackCount>.from(
            json["feedback_counts"].map((x) => FeedbackCount.fromJson(x))),
        totalMarks:
            List<double>.from(json["total_marks"].map((x) => x?.toDouble())),
        noOfStudents: List<int>.from(json["no_of_students"].map((x) => x)),
        feedbackTotal: FeedbackTotal.fromJson(json["feedback_total"]),
        feedbackPercent: List<double>.from(
            json["feedback_percent"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "feedback_counts":
            List<dynamic>.from(feedbackCounts.map((x) => x.toJson())),
        "total_marks": List<dynamic>.from(totalMarks.map((x) => x)),
        "no_of_students": List<dynamic>.from(noOfStudents.map((x) => x)),
        "feedback_total": feedbackTotal.toJson(),
        "feedback_percent": List<dynamic>.from(feedbackPercent.map((x) => x)),
      };
}

class FeedbackCount {
  Feedback feedback;
  List<String> feedbackValues;

  FeedbackCount({
    required this.feedback,
    required this.feedbackValues,
  });

  factory FeedbackCount.fromJson(Map<String, dynamic> json) => FeedbackCount(
        feedback: Feedback.fromJson(json["feedback"]),
        feedbackValues:
            List<String>.from(json["feedback_values"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "feedback": feedback.toJson(),
        "feedback_values": List<dynamic>.from(feedbackValues.map((x) => x)),
      };
}

class Feedback {
  int id;
  String subject;
  String questype;
  int show;

  Feedback({
    required this.id,
    required this.subject,
    required this.questype,
    required this.show,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
        id: json["id"],
        subject: json["subject"],
        questype: json["questype"],
        show: json["show"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject": subject,
        "questype": questype,
        "show": show,
      };
}

class FeedbackTotal {
  int mark;
  List<double> percentage;

  FeedbackTotal({
    required this.mark,
    required this.percentage,
  });

  factory FeedbackTotal.fromJson(Map<String, dynamic> json) => FeedbackTotal(
        mark: json["mark"],
        percentage:
            List<double>.from(json["percentage"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "mark": mark,
        "percentage": List<dynamic>.from(percentage.map((x) => x)),
      };
}

class FeedbackTab2 {
  List<int> feedRemCounts;
  List<Remark> remarks;

  FeedbackTab2({
    required this.feedRemCounts,
    required this.remarks,
  });

  factory FeedbackTab2.fromJson(Map<String, dynamic> json) => FeedbackTab2(
        feedRemCounts: List<int>.from(json["feed_rem_counts"].map((x) => x)),
        remarks:
            List<Remark>.from(json["remarks"].map((x) => Remark.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "feed_rem_counts": List<dynamic>.from(feedRemCounts.map((x) => x)),
        "remarks": List<dynamic>.from(remarks.map((x) => x.toJson())),
      };
}

class Remark {
  List<Feedrem> feedrem;

  Remark({
    required this.feedrem,
  });

  factory Remark.fromJson(Map<String, dynamic> json) => Remark(
        feedrem:
            List<Feedrem>.from(json["feedrem"].map((x) => Feedrem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "feedrem": List<dynamic>.from(feedrem.map((x) => x.toJson())),
      };
}

class Feedrem {
  String remark;

  Feedrem({
    required this.remark,
  });

  factory Feedrem.fromJson(Map<String, dynamic> json) => Feedrem(
        remark: json["remark"],
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
      };
}
