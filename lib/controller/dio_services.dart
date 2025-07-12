import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:senthil/controller/app_controller.dart';

class DioServices {
  static Future<dynamic> download(
    String url,
    String path, {
    required void Function(double progress) onProgress,
  }) async {
    final Dio dio = Dio();
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/downloads');
    if (!folder.existsSync()) {
      await folder.create();
    }
    final file = File('${folder.path}/$path');
    await dio.download(
      url,
      file.path,
      onReceiveProgress: (count, total) async {
        onProgress(count / total);
      },
      options: Options(headers: {"Accept-Encoding": "identity"}),
    ).then((res) {
      AppController.toastMessage('Downloaded', 'File downloaded successfully');
      dio.close();
    }).catchError((err) {
      AppController.toastMessage(
          'Download Error', 'Error happened while downloading a file');
      dio.close();
    });
    dio.close();
  }
}
