import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/profile/model/faqsModel.dart';

import '../apiHandler.dart';
import '../apiRoutes.dart';

class ContactRepo {
  static Future adminContact({
    required String helpText,
  }) async {
    var responseBody = await API.apiHandler(
        url: APIRoutes.contactAdmin,
        body: {"message": helpText},
        header: {"Authorization": userController.userToken});
    if (responseBody != null)
      return responseBody;
    else
      return null;
  }

  static Future aboutTheApp() async {
    var responseBody =
        await API.apiHandler(url: APIRoutes.appData, showLoader: false);
    if (responseBody != null)
      return responseBody;
    else
      return null;
  }

  static Future<FaqsModel?> fetchFaqs(int page) async {
    var responseBody = await API.apiHandler(
        url: APIRoutes.faqs,
        showLoader: false,
        body: jsonEncode({"page": page}));
    // debugPrint(responseBody);
    print("============="
        "3");
    return FaqsModel.fromJson(responseBody);
  }
}
