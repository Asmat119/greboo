class CommentModel {
  CommentModel({
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
  List<CommentsData> data;
  int page;
  int limit;
  int size;
  bool hasMore;
  String format;
  String timestamp;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        code: json["code"],
        message: json["message"],
        data: List<CommentsData>.from(
            json["data"].map((x) => CommentsData.fromJson(x))),
        page: json["page"],
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
        "page": page,
        "limit": limit,
        "size": size,
        "hasMore": hasMore,
        "format": format,
        "timestamp": timestamp,
      };
}

class CommentsData {
  CommentsData({
    this.id = "",
    this.name = "",
    this.picture = "",
    this.isMine = false,
    this.postRef = "",
    this.text = "",
    this.deleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String name;
  String picture;
  bool isMine;
  String postRef;
  String text;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;

  factory CommentsData.fromJson(Map<String, dynamic> json) => CommentsData(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        picture: json["picture"] ?? "",
        isMine: json["isMine"] ?? false,
        postRef: json["postRef"] ?? "",
        text: json["text"] ?? "",
        deleted: json["deleted"] ?? false,
        createdAt: DateTime.parse(json["createdAt"]).toLocal(),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "picture": picture,
        "isMine": isMine,
        "postRef": postRef,
        "text": text,
        "deleted": deleted,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
