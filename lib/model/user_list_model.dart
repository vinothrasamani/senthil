import 'dart:convert';

UserListModel userListtModelFromJson(String str) =>
    UserListModel.fromJson(json.decode(str));

String userListtModelToJson(UserListModel data) => json.encode(data.toJson());

class UserListModel {
  bool success;
  List<UserList> data;
  String message;

  UserListModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) => UserListModel(
        success: json["success"],
        data:
            List<UserList>.from(json["data"].map((x) => UserList.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class UserList {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  dynamic fcmToken;
  DateTime createdAt;
  DateTime updatedAt;
  String? className;
  String? board;
  String school;
  String? refName;
  String? fullname;
  String? mobile;
  int? role;

  UserList({
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

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
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
        role: json["role"],
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
