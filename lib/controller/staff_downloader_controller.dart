import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffDownloaderController extends StateNotifier<List<String>> {
  StaffDownloaderController() : super([]);

  void addFile(List<String> file) {
    state = [...state, ...file];
  }

  void removeFile(String file) {
    state = state.where((element) => element != file).toList();
  }

  void clear() {
    state = [];
  }
}

final staffDownloaderControllerProvider =
    StateNotifierProvider.autoDispose<StaffDownloaderController, List<String>>(
        (ref) {
  final controller = StaffDownloaderController();
  ref.onDispose(() {
    controller.clear();
  });
  return controller;
});
