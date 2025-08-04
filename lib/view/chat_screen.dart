import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/user_list_model.dart';
import 'package:senthil/widgets/message_box.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.user});
  final UserList user;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name.trim()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    for (var i = 0; i < 10; i++)
                      MessageBox(isYou: i % 2 == 0, isDark: isDark),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: baseColor,
                      foregroundColor: Colors.white,
                    ),
                    icon: Icon(Icons.attach_file, size: 25),
                  ),
                  SizedBox(width: 2),
                  Expanded(
                    child: TextField(
                      maxLines: 4,
                      minLines: 1,
                      style: TextStyle(color: Colors.white),
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.only(left: 15, right: 5),
                      ),
                    ),
                  ),
                  SizedBox(width: 2),
                  IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: baseColor,
                      foregroundColor: Colors.white,
                    ),
                    icon: Icon(Icons.send_rounded, size: 25),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
