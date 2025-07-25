import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/user_list_model.dart';

class UserListController {
  static final filteredUsers =
      StateProvider.autoDispose<List<UserList>>((ref) => []);

  static final getUsers =
      FutureProvider.autoDispose<List<UserList>>((ref) async {
    final str = await AppController.fetch('fetch-users');
    final data = userListtModelFromJson(str);
    if (data.success) {
      return data.data;
    } else {
      return [];
    }
  });

  static void filter(String val, WidgetRef ref, List<UserList> users) async {
    if (val.isEmpty) {
      ref.read(filteredUsers.notifier).state = users;
    } else {
      ref.read(filteredUsers.notifier).state = users
          .where((user) =>
              user.name.toLowerCase().contains(val.toLowerCase()) ||
              user.school.toLowerCase().contains(val.toLowerCase()))
          .toList();
    }
  }
}
