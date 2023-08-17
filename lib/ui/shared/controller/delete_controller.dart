import 'package:get/get.dart';
import 'package:grebooo/core/models/successModel.dart';
import 'package:grebooo/core/service/repo/deleteRepo.dart';

class DeleteController extends GetxController {
  SuccessModel _successModel = SuccessModel.fromJson({});

  SuccessModel get successModel => _successModel;

  set successModel(SuccessModel value) {
    _successModel = value;
    update();
  }

  getDelete({required String postRef}) async {
    DeletePost? deletePost = await DeleteRepo.getDelete(postRef: postRef);

    if (deletePost != null) {
      successModel = deletePost.format as SuccessModel;
    }
    return deletePost?.message;
  }
}
