// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

List<CountryModel> countryModelFromJson(String str) => List<CountryModel>.from(
    json.decode(str).map((x) => CountryModel.fromJson(x)));

String countryModelToJson(List<CountryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryModel {
  CountryModel({
    this.name,
    this.flag,
    this.code,
    this.dialCode,
  });

  String? name;
  String? flag;
  String? code;
  String? dialCode;

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        name: json["name"],
        flag: json["flag"],
        code: json["code"],
        dialCode: json["dial_code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "flag": flag,
        "code": code,
        "dial_code": dialCode,
      };
}
