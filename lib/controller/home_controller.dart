import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/home/exam_results_model.dart';
import 'package:senthil/model/notice_model.dart';
import 'package:senthil/model/home/dashboard_model.dart';

class HomeController {
  static final noticeData =
      FutureProvider.family.autoDispose<NoticeModel, int>((ref, id) async {
    final res = await AppController.fetch('notice/$id');
    return noticeModelFromJson(res);
  });

  static final bannerData = FutureProvider.autoDispose((ref) async {
    final res = await AppController.fetch('banner');
    return dashboardModelFromJson(res);
  });

  static Future<List<ExamResult>> fetchResults() async {
    final res = await AppController.fetch('resutls');
    final data = examResultsModelFromJson(res);
    if (data.success) {
      return data.data;
    } else {
      return [];
    }
  }
}
