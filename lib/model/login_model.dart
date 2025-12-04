import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool success;
  Data? data;
  String message;

  LoginModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": (data != null) ? data!.toJson() : null,
        "message": message,
      };
}

class Data {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  dynamic fcmToken;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic className;
  dynamic board;
  dynamic school;
  dynamic refName;
  String fullname;
  dynamic mobile;
  int role;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
    required this.className,
    required this.board,
    required this.school,
    required this.refName,
    required this.fullname,
    required this.mobile,
    required this.role,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        fcmToken: json["fcm_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        className: json["class_name"],
        board: json["board"],
        school: json["school"],
        refName: json["ref_name"],
        fullname: json["fullname"],
        mobile: json["mobile"],
        role: int.parse(json["role"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "fcm_token": fcmToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "class_name": className,
        "board": board,
        "school": school,
        "ref_name": refName,
        "fullname": fullname,
        "mobile": mobile,
        "role": role,
      };
}
