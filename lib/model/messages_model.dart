import 'dart:convert';

MessagesModel messagesModelFromJson(String str) =>
    MessagesModel.fromJson(json.decode(str));

String messagesModelToJson(MessagesModel data) => json.encode(data.toJson());

class MessagesModel {
  bool success;
  List<MessageItem> data;
  String message;

  MessagesModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
        success: json["success"],
        data: List<MessageItem>.from(
            json["data"].map((x) => MessageItem.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class MessageItem {
  int id;
  String chatId;
  int senderId;
  String message;
  dynamic file;
  int isReaded;
  DateTime updatedAt;
  DateTime createdAt;

  MessageItem({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.file,
    required this.isReaded,
    required this.updatedAt,
    required this.createdAt,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) => MessageItem(
        id: json["id"],
        chatId: json["chat_id"],
        senderId: int.parse(json["sender_id"].toString()),
        message: json["message"],
        file: json["file"],
        isReaded: int.parse(json["is_readed"].toString()),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chat_id": chatId,
        "sender_id": senderId,
        "message": message,
        "file": file,
        "is_readed": isReaded,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}
