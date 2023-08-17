class MessageModel {
  MessageModel({
    required this.code,
    required this.message,
    required this.data,
    required this.page,
    required this.limit,
    required this.size,
    required this.hasMore,
    required this.format,
    required this.timestamp,
  });

  int code;
  String message;
  List<MessageData> data;
  int page;
  int limit;
  int size;
  bool hasMore;
  String format;
  String timestamp;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        data: List<MessageData>.from(
            json["data"].map((x) => MessageData.fromJson(x))),
        page: json["page"] ?? 0,
        limit: json["limit"] ?? 0,
        size: json["size"] ?? 0,
        hasMore: json["hasMore"] ?? false,
        format: json["format"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "page": page,
        "limit": limit,
        "size": size,
        "hasMore": hasMore,
        "format": format,
        "timestamp": timestamp,
      };
}

class MessageData {
  MessageData({
    this.id = "",
    this.userId = "",
    this.picture = "",
    this.message = "",
    required this.createdAt,
    this.name = "",
  });

  String id;
  String userId;
  String picture;
  String message;
  DateTime createdAt;
  String name;

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        id: json["_id"] ?? "",
        userId: json["userId"] ?? "",
        picture: json["picture"] ?? "",
        message: json["message"] ?? "",
        createdAt: DateTime.parse(
            json["createdAt"] ?? DateTime.now().toIso8601String()),
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "picture": picture,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "name": name == null ? null : name,
      };
}
