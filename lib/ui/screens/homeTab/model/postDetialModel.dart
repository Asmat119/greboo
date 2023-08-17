import 'package:grebooo/ui/screens/homeTab/model/postModel.dart';

class PostDetailModel {
  PostDetailModel({
    required this.code,
    required this.message,
    required this.postData,
    required this.format,
    required this.timestamp,
  });

  int code;
  String message;
  PostData postData;
  String format;
  String timestamp;

  factory PostDetailModel.fromJson(Map<String, dynamic> json) => PostDetailModel(
    code: json["code"],
    message: json["message"],
    postData: PostData.fromJson(json["data"] ?? {}),
    format: json["format"],
    timestamp: json["timestamp"],
  );
}
