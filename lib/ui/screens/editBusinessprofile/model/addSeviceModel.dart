import 'dart:io';

class AddServicesModel {
  File? image;
  String? title;
  String? url;
  bool isEdit;

  AddServicesModel({this.image, this.title, this.url, this.isEdit = false});
  Map<String, dynamic> toJson() => {
        "image": image,
        "title": title,
        "url": url,
      };
}
