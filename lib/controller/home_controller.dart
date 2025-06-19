import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/notice_model.dart';
import 'package:senthil/model/school_model.dart';

class HomeController {
  static final noticeData =
      FutureProvider.family<NoticeModel, int>((ref, id) async {
    final res = await AppController.fetch('notice/$id');
    return noticeModelFromJson(res);
  });

  static final bannerData = FutureProvider((ref) async {
    final res = await AppController.fetch('schools');
    return schoolModelFromJson(res);
  });
}
