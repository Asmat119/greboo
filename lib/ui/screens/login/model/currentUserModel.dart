class CurrentUserModel {
  CurrentUserModel({
    required this.code,
    required this.message,
    required this.data,
    required this.format,
    required this.timestamp,
  });

  int code;
  String message;
  Datum data;
  String format;
  String timestamp;

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) =>
      CurrentUserModel(
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        data: Datum.fromJson(json["data"] ?? DateTime.now()),
        format: json["format"] ?? "",
        timestamp: json["timestamp"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
        "format": format,
        "timestamp": timestamp,
      };
}

class Datum {
  Datum({
    required this.accessToken,
    required this.user,
  });

  String accessToken;
  UserModel user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        accessToken: json["accessToken"] ?? "",
        user: UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "user": user.toJson(),
      };
}

class UserModel {
  UserModel({
    location,
    this.followers = 0,
    this.following = 0,
    this.rating = 0.0,
    this.warningByAdmin = "",
    this.userType = 0,
    this.verifiedByAdmin = false,
    this.images = const [],
    this.websites = const [],
    this.workingDays = const [],
    this.verified = false,
    this.blocked = false,
    this.deleted = false,
    this.firstAfterVerification = false,
    this.profileCompleted = false,
    this.id = "",
    this.isFollow = false,
    this.email = "",
    this.picture = "",
    this.categories = const [],
    createdOn,
    updatedOn,
    this.businessName = "",
    this.description = "",
    this.endTime = "",
    this.name = "",
    this.phoneCode = "",
    this.phoneNumber = "",
    this.startTime = "",
    this.services = const [],
  })  : this.location = location ?? LocData(),
        this.createdOn = DateTime.now(),
        this.updatedOn = DateTime.now();

  LocData location;
  List<Category> categories;
  int userType;
  bool verifiedByAdmin;
  List<String> images;
  bool profileCompleted;
  List<String> websites;
  List<int> workingDays;
  bool verified;
  bool blocked;
  bool firstAfterVerification;
  bool deleted;
  String id;
  int followers;
  int following;
  String email;
  String picture;
  DateTime createdOn;
  DateTime updatedOn;
  String businessName;
  String description;
  String endTime;
  String name;
  String phoneCode;
  String warningByAdmin;
  String phoneNumber;
  bool isFollow;
  String startTime;
  double rating;
  List<ServiceList> services;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      categories: List<Category>.from(
          (json["categories"] ?? []).map((x) => Category.fromJson(x))),
      location: LocData.fromJson(json["location"] ?? {}),
      userType: json["userType"] ?? 0,
      followers: json["followers"] ?? 0,
      following: json["following"] ?? 0,
      warningByAdmin: json["warningByAdmin"] ?? "",
      verifiedByAdmin: json["verifiedByAdmin"] ?? false,
      images: List<String>.from((json["images"] ?? []).map((x) => x)),
      websites: List<String>.from((json["websites"] ?? []).map((x) => x)),
      workingDays: List<int>.from((json["workingDays"] ?? []).map((x) => x)),
      verified: json["verified"] ?? false,
      profileCompleted: json["profileCompleted"] ?? false,
      blocked: json["blocked"] ?? false,
      deleted: json["deleted"] ?? false,
      firstAfterVerification: json["firstAfterVerification"] ?? false,
      id: json["_id"] ?? "",
      email: json["email"] ?? "",
      picture: json["picture"] ?? "",
      createdOn: DateTime.parse(json["createdOn"] ?? DateTime.now()),
      updatedOn: DateTime.parse(json["updatedOn"] ?? DateTime.now()),
      businessName: json["businessName"] ?? "",
      description: json["description"] ?? "",
      endTime: json["endTime"] ?? "",
      name: json["name"] ?? "",
      rating: double.parse((json["rating"] ?? 0.0).toString()),
      phoneCode: json["phoneCode"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      isFollow: json["isFollow"] ?? false,
      startTime: json["startTime"] ?? "",
      services: List<ServiceList>.from(
          (json["services"] ?? []).map((x) => ServiceList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "location": location.toJson(),
      "userType": userType,
      "warningByAdmin": warningByAdmin,
      "isFollow": isFollow,
      "followers": followers,
      "following": following,
      "firstAfterVerification": firstAfterVerification,
      "verifiedByAdmin": verifiedByAdmin,
      "images": List<dynamic>.from(images.map((x) => x)),
      "websites": List<dynamic>.from(websites.map((x) => x)),
      "workingDays": List<dynamic>.from(workingDays.map((x) => x)),
      "categories": List<dynamic>.from(categories.map((e) => e.toJson())),
      "services": List<dynamic>.from(services.map((x) => x.toJson())),
      "verified": verified,
      "rating": rating,
      "blocked": blocked,
      "deleted": deleted,
      "_id": id,
      "profileCompleted": profileCompleted,
      "email": email,
      "picture": picture,
      "createdOn": createdOn.toIso8601String(),
      "updatedOn": updatedOn.toIso8601String(),
      "businessName": businessName,
      "description": description,
      "endTime": endTime,
      "name": name,
      "phoneCode": phoneCode,
      "phoneNumber": phoneNumber,
      "startTime": startTime,
    };
  }
}

class ServiceList {
  ServiceList({
    this.image = "",
    this.name = "",
  });

  String image;
  String name;

  factory ServiceList.fromJson(Map<String, dynamic> json) => ServiceList(
        image: json["image"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
      };
}

class Category {
  Category({
    this.id = "",
    this.name = "",
    this.categoryRef = "",
  });

  String id;
  String name;
  String categoryRef;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        categoryRef: json["categoryRef"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "categoryRef": categoryRef,
      };
}

class LocData {
  LocData({
    this.address = "",
    this.type = "",
    this.coordinates = const [0.0, 0.0],
  });

  String address;
  String type;
  List<double> coordinates;

  factory LocData.fromJson(Map<String, dynamic> json) => LocData(
        address: json["address"] ?? "",
        type: json["type"] ?? "",
        coordinates: List<double>.from((json["coordinates"] ?? [0.0, 0.0])
            .map((x) => double.parse(x.toString()))),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "type": type,
        "coordinates": List<double>.from(coordinates.map((x) => x)),
      };
}
