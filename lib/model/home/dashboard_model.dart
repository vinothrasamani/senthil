import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  bool success;
  List<DashboardData> data;
  String message;

  DashboardModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        success: json["success"],
        data: List<DashboardData>.from(
            json["data"].map((x) => DashboardData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class DashboardData {
  School school;
  Banner banner;

  DashboardData({
    required this.school,
    required this.banner,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        school: School.fromJson(json["school"]),
        banner: Banner.fromJson(json["banner"]),
      );

  Map<String, dynamic> toJson() => {
        "school": school.toJson(),
        "banner": banner.toJson(),
      };
}

class Banner {
  int id;
  int schoolId;
  String academicYear;
  String schoolName;
  int targetamount;
  int exclusionamount;
  int concussionamount;
  int paidamount;
  int balanceamount;
  int netamount;

  Banner({
    required this.id,
    required this.schoolId,
    required this.academicYear,
    required this.schoolName,
    required this.targetamount,
    required this.exclusionamount,
    required this.concussionamount,
    required this.paidamount,
    required this.balanceamount,
    required this.netamount,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        id: json["id"],
        schoolId: json["school_id"],
        academicYear: json["academic_year"],
        schoolName: json["school_name"],
        targetamount: json["targetamount"],
        exclusionamount: json["exclusionamount"],
        concussionamount: json["concussionamount"],
        paidamount: json["paidamount"],
        balanceamount: json["balanceamount"],
        netamount: json["netamount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "school_id": schoolId,
        "academic_year": academicYear,
        "school_name": schoolName,
        "targetamount": targetamount,
        "exclusionamount": exclusionamount,
        "concussionamount": concussionamount,
        "paidamount": paidamount,
        "balanceamount": balanceamount,
        "netamount": netamount,
      };
}

class School {
  int id;
  String name;
  int code;
  dynamic address;
  String city;
  dynamic mobileNo;
  String schlType;

  School({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.city,
    required this.mobileNo,
    required this.schlType,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        address: json["address"],
        city: json["city"],
        mobileNo: json["mobile_no"],
        schlType: json["schl_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "address": address,
        "city": city,
        "mobile_no": mobileNo,
        "schl_type": schlType,
      };
}
