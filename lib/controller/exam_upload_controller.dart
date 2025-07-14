import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/exam_upload_details_model.dart';

class ExamUploadController {
  static final examUploadData = FutureProvider.family
      .autoDispose<ExamUploadDetailsModel, int>((ref, id) async {
    final str = await AppController.fetch('exam-upload-details/$id');
    return examUploadDetailsModelFromJson(str);
  });
}
