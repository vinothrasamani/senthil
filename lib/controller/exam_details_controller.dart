import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/exam_details_model.dart';

class ExamDetailsController extends StateNotifier<AsyncValue<List<Examinfo>>> {
  ExamDetailsController() : super(AsyncLoading()) {
    fetchItems();
  }

  Future<void> fetchItems() async {
    final res = await AppController.fetch('exam-details');
    final data = examDetailsModelFromJson(res);
    if (data.success) {
      state = AsyncData(data.data);
    }
    try {} catch (e, st) {
      state = AsyncError(e, st);
      AppController.toastMessage('Error', 'Something went wrong!',
          purpose: Purpose.fail);
    }
  }
}

final examDetailsProvider =
    StateNotifierProvider<ExamDetailsController, AsyncValue<List<Examinfo>>>(
        (ref) {
  return ExamDetailsController();
});
