import 'package:get/get.dart';
import 'package:grebooo/core/service/repo/contactRepo.dart';

class AboutUsController extends GetxController {
  String? aboutUs;
  String? tc;
  String? privacyPolicy;

  bool isFetched() {
    if (aboutUs != null && tc != null && privacyPolicy != null) {
      return true;
    } else
      return false;
  }

  Future aboutTheApp() async {
    var response = await ContactRepo.aboutTheApp();
    if (response != null) {
      aboutUs = response["data"]["aboutUs"];
      tc = response["data"]["termsAndConditions"];
      privacyPolicy = response["data"]["privacyPolicy"];
      update();
    }
  }
}
