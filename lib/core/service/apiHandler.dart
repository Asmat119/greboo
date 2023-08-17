import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/ui/shared/loader.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as mimeee;
import 'package:mime_type/mime_type.dart';

enum RequestType { Get, Post }

class API {
  static late http.Response response;

  static Future apiHandler({
    required String url,
    RequestType requestType = RequestType.Post,
    Map<String, String>? header,
    bool showLoader = true,
    bool showToast = true,
    dynamic body,
  }) async {
    try {
      if (await checkConnection()) {
        if (showLoader) LoadingOverlay.of().show();

        log("URl ===> $url");
        log("HEADER ===> $header");
        log("BODY ===> $body");
        if (requestType == RequestType.Get) {
          response = await http.get(
            Uri.parse(url),
            headers: header,
          );
        } else {
          response =
              await http.post(Uri.parse(url), headers: header, body: body);
        }
        log("RETURN RESPONSE BODY CREATE ====== ${response.body}");
        if (response.body.isNotEmpty) {
          var res = jsonDecode(response.body);

          if (showLoader) LoadingOverlay.of().hide();

          if (res["code"] == 100) {
            return res;
          } else if (res["code"] == 401) {
            UserRepo.userLogout();
          } else {
            if (showToast) {
              flutterToast(res["message"]);
            }
            return null;
          }
        } else {
          if (showLoader) LoadingOverlay.of().hide();

          return null;
        }
      } else {
        flutterToast('check_your_connection'.tr);
        return null;
      }
    } catch (e) {
      debugPrint("ERROR FROM API CLASS $e");
    }
  }

  static Future multiPartAPIHandler(
      {List<File>? fileImage,
      Map<String, String>? field,
      File? thumbnail,
      bool showLoader = true,
      String multiPartImageKeyName = "image",
      Map<String, String>? header,
      required String url}) async {
    try {
      bool connection = await checkConnection();

      if (connection) {
        log("URl ===> $url");
        log("HEADER ===> $header");
        log("BODY ===> $field");

        if (showLoader) LoadingOverlay.of().show();
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );
        if (header != null) request.headers.addAll(header);
        if (field != null) request.fields.addAll(field);

        if (fileImage != null) {
          fileImage.forEach((element) async {
            String? mimeType = mime(element.path);
            debugPrint(mimeType);
            request.files.add(await http.MultipartFile.fromPath(
                multiPartImageKeyName, element.path,
                contentType: mimeee.MediaType(
                    mimeType!.split("/")[0], mimeType.split("/")[1])));
          });
        }
        if (thumbnail != null) {
          request.files.add(await http.MultipartFile.fromPath(
              "thumbnailImage", thumbnail.path));
        }

        http.StreamedResponse response = await request.send();
        var res = await response.stream.bytesToString();

        var resDecode = jsonDecode(res);
        log("RETURN RESPONSE BODY CREATE ====== $resDecode");
        if (resDecode["code"] == 100) {
          if (showLoader) LoadingOverlay.of().hide();

          return resDecode;
        } else if (resDecode["code"] == 401) {
          UserRepo.userLogout();
        } else {
          if (showLoader) LoadingOverlay.of().hide();
          debugPrint("erroe $resDecode");
          flutterToast(resDecode["message"]);

          return null;
        }
      } else {
        flutterToast('check_your_connection'.tr);
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
