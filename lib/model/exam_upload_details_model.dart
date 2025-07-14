import 'dart:convert';

ExamUploadDetailsModel examUploadDetailsModelFromJson(String str) =>
    ExamUploadDetailsModel.fromJson(json.decode(str));

String examUploadDetailsModelToJson(ExamUploadDetailsModel data) =>
    json.encode(data.toJson());

class ExamUploadDetailsModel {
  bool success;
  ExamUploadDetails data;
  String message;

  ExamUploadDetailsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ExamUploadDetailsModel.fromJson(Map<String, dynamic> json) =>
      ExamUploadDetailsModel(
        success: json["success"],
        data: ExamUploadDetails.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class ExamUploadDetails {
  List<ExamDetailResult> result;
  List<String> resSch;

  ExamUploadDetails({
    required this.result,
    required this.resSch,
  });

  factory ExamUploadDetails.fromJson(Map<String, dynamic> json) =>
      ExamUploadDetails(
        result: List<ExamDetailResult>.from(
            json["result"].map((x) => ExamDetailResult.fromJson(x))),
        resSch: List<String>.from(json["res_sch"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "res_sch": List<dynamic>.from(resSch.map((x) => x)),
      };
}

class ExamDetailResult {
  String exam;
  String year;
  int examId;
  String i;
  String ii;
  String iii;
  String iv;
  String ix;
  String v;
  String vi;
  String vii;
  String viii;
  String x;
  String xi;
  String resultXi;
  String xii;
  String resultXii;

  ExamDetailResult({
    required this.exam,
    required this.year,
    required this.examId,
    required this.i,
    required this.ii,
    required this.iii,
    required this.iv,
    required this.ix,
    required this.v,
    required this.vi,
    required this.vii,
    required this.viii,
    required this.x,
    required this.xi,
    required this.resultXi,
    required this.xii,
    required this.resultXii,
  });

  factory ExamDetailResult.fromJson(Map<String, dynamic> json) =>
      ExamDetailResult(
        exam: json["Exam"],
        year: json["Year"],
        examId: json["exam_id"],
        i: json["I"],
        ii: json["II"],
        iii: json["III"],
        iv: json["IV"],
        ix: json["IX"],
        v: json["V"],
        vi: json["VI"],
        vii: json["VII"],
        viii: json["VIII"],
        x: json["X"],
        xi: json["XI"],
        resultXi: json["XI*"],
        xii: json["XII"],
        resultXii: json["XII*"],
      );

  Map<String, dynamic> toJson() => {
        "Exam": exam,
        "Year": year,
        "exam_id": examId,
        "I": i,
        "II": ii,
        "III": iii,
        "IV": iv,
        "IX": ix,
        "V": v,
        "VI": vi,
        "VII": vii,
        "VIII": viii,
        "X": x,
        "XI": xi,
        "XI*": resultXi,
        "XII": xii,
        "XII*": resultXii,
      };
}
