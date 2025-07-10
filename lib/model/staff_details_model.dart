// To parse this JSON data, do
//
//     final staffDetailsModel = staffDetailsModelFromJson(jsonString);

import 'dart:convert';

StaffDetailsModel staffDetailsModelFromJson(String str) =>
    StaffDetailsModel.fromJson(json.decode(str));

String staffDetailsModelToJson(StaffDetailsModel data) =>
    json.encode(data.toJson());

class StaffDetailsModel {
  bool success;
  List<Datum> data;
  String message;

  StaffDetailsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory StaffDetailsModel.fromJson(Map<String, dynamic> json) =>
      StaffDetailsModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int id;
  String staffName;
  String code;
  String gender;
  String designation;
  String qualification;
  DateTime dob;
  String blood;
  String religion;
  String community;
  String caste;
  String? toSpeak;
  String? toRead;
  String? toWrite;
  String? homeTown;
  String contact;
  String? landline;
  String email;
  String? address;
  String? distance;
  String? spouse;
  String? spContact;
  String? spOccup;
  String? children;
  String? modeTrans;
  String? aadhar;
  String? pan;
  String? acc;
  String? bank;
  String? ifsc;
  DateTime doj;
  String? catJoin;
  String? catPres;
  String? yeSchool;
  String? yeOverall;
  String handSub;
  String? handClass;
  String handSec;
  String handNoCs;
  dynamic pyAvg;
  dynamic pyHigh;
  dynamic pylow;
  dynamic pyPer;
  String? centums;
  String? statusObserver;
  String? responsibilities;
  String? talent;
  String? workshops;
  dynamic testmark;
  String? etExam;
  String? sct1;
  String? sct2;
  dynamic att;
  dynamic feed1;
  dynamic feed2;
  dynamic feed3;
  dynamic appraisal;
  String oid;
  String department;
  String? status;
  DateTime createdAt;
  DateTime updatedAt;
  int showhide;
  String photo;
  String school;
  String schooltype;

  Datum({
    required this.id,
    required this.staffName,
    required this.code,
    required this.gender,
    required this.designation,
    required this.qualification,
    required this.dob,
    required this.blood,
    required this.religion,
    required this.community,
    required this.caste,
    required this.toSpeak,
    required this.toRead,
    required this.toWrite,
    required this.homeTown,
    required this.contact,
    required this.landline,
    required this.email,
    required this.address,
    required this.distance,
    required this.spouse,
    required this.spContact,
    required this.spOccup,
    required this.children,
    required this.modeTrans,
    required this.aadhar,
    required this.pan,
    required this.acc,
    required this.bank,
    required this.ifsc,
    required this.doj,
    required this.catJoin,
    required this.catPres,
    required this.yeSchool,
    required this.yeOverall,
    required this.handSub,
    required this.handClass,
    required this.handSec,
    required this.handNoCs,
    required this.pyAvg,
    required this.pyHigh,
    required this.pylow,
    required this.pyPer,
    required this.centums,
    required this.statusObserver,
    required this.responsibilities,
    required this.talent,
    required this.workshops,
    required this.testmark,
    required this.etExam,
    required this.sct1,
    required this.sct2,
    required this.att,
    required this.feed1,
    required this.feed2,
    required this.feed3,
    required this.appraisal,
    required this.oid,
    required this.department,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.showhide,
    required this.photo,
    required this.school,
    required this.schooltype,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        staffName: json["StaffName"],
        code: json["Code"],
        gender: json["Gender"],
        designation: json["Designation"],
        qualification: json["Qualification"],
        dob: DateTime.parse(json["DOB"]),
        blood: json["Blood"],
        religion: json["Religion"],
        community: json["Community"],
        caste: json["Caste"],
        toSpeak: json["ToSpeak"],
        toRead: json["ToRead"],
        toWrite: json["ToWrite"],
        homeTown: json["HomeTown"],
        contact: json["Contact"],
        landline: json["landline"],
        email: json["email"],
        address: json["Address"],
        distance: json["Distance"],
        spouse: json["spouse"],
        spContact: json["sp_contact"],
        spOccup: json["sp_occup"],
        children: json["Children"],
        modeTrans: json["ModeTrans"],
        aadhar: json["Aadhar"],
        pan: json["Pan"],
        acc: json["ACC"],
        bank: json["Bank"],
        ifsc: json["IFSC"],
        doj: DateTime.parse(json["DOJ"]),
        catJoin: json["Cat_join"],
        catPres: json["Cat_Pres"],
        yeSchool: json["YESchool"],
        yeOverall: json["YEOverall"],
        handSub: json["Hand_Sub"],
        handClass: json["Hand_Class"],
        handSec: json["Hand_Sec"],
        handNoCs: json["Hand_NoCS"],
        pyAvg: json["PYAvg"],
        pyHigh: json["PYHigh"],
        pylow: json["Pylow"],
        pyPer: json["PYPer"],
        centums: json["centums"],
        statusObserver: json["StatusObserver"],
        responsibilities: json["Responsibilities"],
        talent: json["Talent"],
        workshops: json["workshops"],
        testmark: json["Testmark"],
        etExam: json["ETExam"],
        sct1: json["SCT1"],
        sct2: json["SCT2"],
        att: json["Att"],
        feed1: json["Feed1"],
        feed2: json["Feed2"],
        feed3: json["Feed3"],
        appraisal: json["Appraisal"],
        oid: json["oid"],
        department: json["department"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        showhide: json["showhide"],
        photo: json["photo"],
        school: json["School"],
        schooltype: json["schooltype"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "StaffName": staffName,
        "Code": code,
        "Gender": gender,
        "Designation": designation,
        "Qualification": qualification,
        "DOB": dob.toIso8601String(),
        "Blood": blood,
        "Religion": religion,
        "Community": community,
        "Caste": caste,
        "ToSpeak": toSpeak,
        "ToRead": toRead,
        "ToWrite": toWrite,
        "HomeTown": homeTown,
        "Contact": contact,
        "landline": landline,
        "email": email,
        "Address": address,
        "Distance": distance,
        "spouse": spouse,
        "sp_contact": spContact,
        "sp_occup": spOccup,
        "Children": children,
        "ModeTrans": modeTrans,
        "Aadhar": aadhar,
        "Pan": pan,
        "ACC": acc,
        "Bank": bank,
        "IFSC": ifsc,
        "DOJ":
            "${doj.year.toString().padLeft(4, '0')}-${doj.month.toString().padLeft(2, '0')}-${doj.day.toString().padLeft(2, '0')}",
        "Cat_join": catJoin,
        "Cat_Pres": catPres,
        "YESchool": yeSchool,
        "YEOverall": yeOverall,
        "Hand_Sub": handSub,
        "Hand_Class": handClass,
        "Hand_Sec": handSec,
        "Hand_NoCS": handNoCs,
        "PYAvg": pyAvg,
        "PYHigh": pyHigh,
        "Pylow": pylow,
        "PYPer": pyPer,
        "centums": centums,
        "StatusObserver": statusObserver,
        "Responsibilities": responsibilities,
        "Talent": talent,
        "workshops": workshops,
        "Testmark": testmark,
        "ETExam": etExam,
        "SCT1": sct1,
        "SCT2": sct2,
        "Att": att,
        "Feed1": feed1,
        "Feed2": feed2,
        "Feed3": feed3,
        "Appraisal": appraisal,
        "oid": oid,
        "department": department,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "showhide": showhide,
        "photo": photo,
        "School": school,
        "schooltype": schooltype,
      };
}
