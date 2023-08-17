class PostModel {
  PostModel({
    required this.code,
    required this.message,
    required this.postData,
    required this.page,
    required this.limit,
    required this.size,
    required this.hasMore,
    required this.format,
    required this.timestamp,
  });

  int code;
  String message;
  List<PostData> postData;
  dynamic page;
  int limit;
  int size;
  bool hasMore;
  String format;
  String timestamp;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        postData:
            List<PostData>.from(json["data"].map((x) => PostData.fromJson(x))),
        page: json["page"] ?? "",
        limit: json["limit"] ?? 0,
        size: json["size"] ?? 0,
        hasMore: json["hasMore"] ?? false,
        format: json["format"],
        timestamp: json["timestamp"],
      );
}

class PostData {
  PostData({
    this.id = "",
    this.deleted = false,
    this.userRef = "",
    this.text = "",
    this.thumbnail = "",
    this.video = "",
    this.image = "",
    required this.createdAt,
    this.updatedAt,
    postUserDetail,
    this.comment = 0,
    this.like = 0,
    this.isLike = false,
    this.isVideo = false,
  }) : this.postUserDetail = postUserDetail ?? PostUserDetail();

  String id;
  bool deleted;
  String userRef;
  String text;
  String thumbnail;
  String image;

  String video;
  DateTime createdAt;
  DateTime? updatedAt;
  PostUserDetail postUserDetail;
  int comment;
  int like;
  bool isLike;
  bool isVideo;


  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
        id: json["_id"] ?? "",
        deleted: json["deleted"] ?? false,
        userRef: json["userRef"] ?? "",
        image: json["image"] ?? "",
        text: json["text"] ?? "",
        thumbnail: json["thumbnail"] ?? "",
        video: json["video"] ?? "",
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        postUserDetail: PostUserDetail.fromJson(json["user"]),
        comment: json["comment"] ?? 0,
        like: json["like"] ?? 0,
        isLike: json["isLike"] ?? false,
         isVideo: json["isVideo"] ?? false,
      );
}

class PostUserDetail {
  PostUserDetail({
    this.id = "",
    this.name = "",
    this.businessName = "",
    this.picture = "",
    this.verifiedByAdmin = false,
  });

  String id;
  String name;
  String picture;
  String businessName;
  bool verifiedByAdmin;

  factory PostUserDetail.fromJson(Map<String, dynamic> json) => PostUserDetail(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        businessName: json["businessName"] ?? "",
        picture: json["picture"] ?? "",
        verifiedByAdmin: json["verifiedByAdmin"] ?? false,
      );
}
