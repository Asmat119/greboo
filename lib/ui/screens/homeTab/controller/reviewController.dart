import 'package:get/get.dart';
import 'package:grebooo/core/service/repo/postRepo.dart';
import 'package:grebooo/ui/screens/homeTab/model/reviewModel.dart';

class ReviewController extends GetxController {
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  int page = 0;

  String selectedBusinessRef = "";

  Future<List<ReviewData>> fetchReviews(int offset) async {
    // if (_isFetching) return [];
    // _isFetching = true;
    // page++;
    // var request = await PostRepo.fetchReview(page, selectedBusinessRef);
    // getReviews.addAll(request!.data.map((e) => e));
    // _hasNext = request.hasMore;
    // _isFetching = false;
    ///
    if (offset == 0) page = 1;
    if (page == -1) return [];
    List<ReviewData> getReviews = [];
    var request = await PostRepo.fetchReview(page, selectedBusinessRef);
    getReviews = request!.data;
    page = request.hasMore ? page + 1 : -1;
    return getReviews;
  }
}
