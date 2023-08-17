class ServiceListModel {
  ServiceListModel({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Ser> data;

  factory ServiceListModel.fromJson(Map<String, dynamic> json) =>
      ServiceListModel(
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        data: List<Ser>.from((json["data"] ?? []).map((x) => Ser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Ser {
  Ser({
    required this.deleted,
    required this.id,
    required this.name,
    required this.image,
    required this.userRef,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  bool deleted;
  String id;
  String name;
  String image;
  String userRef;
  int v;
  DateTime createdAt;
  DateTime updatedAt;

  factory Ser.fromJson(Map<String, dynamic> json) => Ser(
        deleted: json["deleted"] ?? false,
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        userRef: json["userRef"] ?? "",
        v: json["__v"] ?? 0,
        createdAt:
            DateTime.parse(json["createdAt"] ?? DateTime.now().toString()),
        updatedAt:
            DateTime.parse(json["updatedAt"] ?? DateTime.now().toString()),
      );

  Map<String, dynamic> toJson() => {
        "deleted": deleted,
        "_id": id,
        "name": name,
        "image": image,
        "userRef": userRef,
        "__v": v,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
