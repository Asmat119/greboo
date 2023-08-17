// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'package:grebooo/ui/screens/messagesTab/model/chatListModel.dart';

class NotificationModel {
  NotificationModel({
    required this.code,
    required this.message,
    required this.data,
    required this.limit,
    required this.size,
    required this.hasMore,
    required this.format,
    required this.timestamp,
  });

  int code;
  String message;
  List<NotificationData> data;
  int limit;
  int size;
  bool hasMore;
  String format;
  String timestamp;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        code: json["code"],
        message: json["message"],
        data: List<NotificationData>.from(
            json["data"].map((x) => NotificationData.fromJson(x))),
        limit: json["limit"],
        size: json["size"],
        hasMore: json["hasMore"],
        format: json["format"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "limit": limit,
        "size": size,
        "hasMore": hasMore,
        "format": format,
        "timestamp": timestamp,
      };
}

class NotificationData {
  NotificationData({
    required this.id,
    required this.userRef,
    required this.channelRef,
    required this.seen,
    required this.image,
    required this.type,
    required this.sourceRef,
    required this.text,
    required this.createdAt,
    required this.deleted,
    required this.user,
  });

  String id;
  bool seen;
  String userRef;
  String image;
  User user;

  int type;
  String sourceRef;
  String channelRef;
  String text;
  DateTime createdAt;

  bool deleted;
  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["_id"] ?? "",
        user: User.fromJson(json["user"] ?? {}),
        seen: json["seen"] ?? "",
        userRef: json["userRef"] ?? "",
        channelRef: json["channelRef"] ?? "",
        image: json["image"] ?? "",
        type: json["type"] ?? 0,
        sourceRef: json["sourceRef"] ?? "",
        text: json["text"] ?? "",
        createdAt: DateTime.parse(json["createdAt"]),
        deleted: json["deleted"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "seen": seen,
        "userRef": userRef,
        "image": image,
        "user": user.toJson(),
        "type": type,
        "sourceRef": sourceRef,
        "text": text,
        "createdAt": createdAt.toIso8601String(),
        "deleted": deleted,
      };
}
