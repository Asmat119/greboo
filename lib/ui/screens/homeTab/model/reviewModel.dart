class ReviewModel {
  ReviewModel({
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
  List<ReviewData> data;
  int page;
  int limit;
  int size;
  bool hasMore;
  String format;
  String timestamp;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        code: json["code"],
        message: json["message"],
        data: List<ReviewData>.from(
            json["data"].map((x) => ReviewData.fromJson(x))),
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

class ReviewData {
  ReviewData({
    this.rating = 0.0,
    this.id = "",
    required this.user,
    this.isMine = false,
    this.businessRef = "",
    this.text = "",
    this.image = "",
    this.deleted = false,
    required this.createdAt,
  });

  String id;
  ReviewUser user;
  bool isMine;
  double rating;
  String businessRef;
  String text;
  String image;
  bool deleted;
  DateTime createdAt;

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        id: json["_id"] ?? "",
        user: ReviewUser.fromJson(json["user"]),
        isMine: json["isMine"] ?? "",
        businessRef: json["businessRef"] ?? "",
        rating: double.parse((json["rating"] ?? 0.0).toString()),
        text: json["text"] ?? "",
        image: json["image"] ?? "",
        deleted: json["deleted"] ?? false,
        createdAt: DateTime.parse(
                json["createdAt"] ?? DateTime.now().toIso8601String())
            .toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user.toJson(),
        "isMine": isMine,
        "rating": rating,
        "businessRef": businessRef,
        "text": text,
        "image": image,
        "deleted": deleted,
        "createdAt": createdAt.toIso8601String(),
      };
}

class ReviewUser {
  ReviewUser({
    this.id = "",
    this.name = "",
    this.picture = "",
  });

  String id;
  String name;
  String picture;

  factory ReviewUser.fromJson(Map<String, dynamic> json) => ReviewUser(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        picture: json["picture"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "picture": picture,
      };
}
