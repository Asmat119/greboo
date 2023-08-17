class ChatListModel {
  ChatListModel({
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
  List<AllChatData> data;
  int page;
  int limit;
  int size;
  bool hasMore;
  String format;
  String timestamp;

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        data: List<AllChatData>.from(
            (json["data"] ?? []).map((x) => AllChatData.fromJson(x))),
        page: json["page"] ?? 0,
        limit: json["limit"] ?? 0,
        size: json["size"] ?? 0,
        hasMore: json["hasMore"] ?? false,
        format: json["format"] ?? "",
        timestamp: json["timestamp"] ?? "",
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

class AllChatData {
  AllChatData({
    required this.channelType,
    required this.chatUserDetail,
    required this.channelRef,
    required this.unreadCount,
    required this.lastMessage,
  });

  int channelType;
  ChatUserDetail chatUserDetail;
  String channelRef;
  int unreadCount;
  LastMessage lastMessage;

  factory AllChatData.fromJson(Map<String, dynamic> json) => AllChatData(
        channelType: json["channelType"] ?? 0,
        chatUserDetail: ChatUserDetail.fromJson(json["chatUserDetail"]),
        channelRef: json["channelRef"] ?? "",
        unreadCount: json["unreadCount"] ?? 0,
        lastMessage: LastMessage.fromJson(json["lastMessage"]),
      );

  Map<String, dynamic> toJson() => {
        "channelType": channelType,
        "chatUserDetail": chatUserDetail.toJson(),
        "channelRef": channelRef,
        "unreadCount": unreadCount,
        "lastMessage": lastMessage.toJson(),
      };
}

class ChatUserDetail {
  ChatUserDetail({
    required this.name,
    required this.id,
    required this.businessName,
    required this.picture,
  });

  String id;
  String picture;
  String name;
  String businessName;

  factory ChatUserDetail.fromJson(Map<String, dynamic> json) => ChatUserDetail(
        id: json["_id"] ?? "",
        picture: json["picture"] ?? "",
        name: json["name"] ?? "",
        businessName: json["businessName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "picture": picture,
        "name": name,
        "businessName": businessName
      };
}

class LastMessage {
  LastMessage({
    required this.message,
    required this.createdAt,
    required this.user,
  });

  String message;
  DateTime createdAt;
  User user;

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        message: json["message"] ?? "",
        createdAt:
            DateTime.parse(json["createdAt"] ?? DateTime.now().toString()),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.businessName,
    required this.id,
    required this.name,
    required this.picture,
  });

  String id;
  String name;
  String picture;
  String businessName;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      picture: json["picture"] ?? "",
      businessName: json["businessName"] ?? "");

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "picture": picture,
        "businessName": businessName,
      };
}
