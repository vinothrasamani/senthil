import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/chat_controller.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/user_list_model.dart';
import 'package:senthil/shimmer/list_shimmer.dart';
import 'package:senthil/widgets/message_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.user});
  final UserList user;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final msg = TextEditingController();
  int offset = 0;
  String chatId = '';
  int sender = 0;
  Timer? timer;
  String? storedDate;
  late SharedPreferences preferences;
  String lastDate = DateTime.now().toIso8601String();

  @override
  void initState() {
    load();
    listenMessages();
    super.initState();
  }

  void listenMessages() {
    timer = Timer.periodic(Duration(seconds: 5), (_) {
      ref.read(chatsProvider.notifier).listenForMessage(
        {'lastDate': lastDate, 'chat_id': chatId},
      );
    });
  }

  void load() async {
    preferences = await SharedPreferences.getInstance();
    final user1 = ref.read(LoginController.userProvider)!.data;
    sender = user1.id;
    List<int> ids = [user1.id, widget.user.id];
    ids.sort();
    chatId = 'chat_${ids[0]}.${ids[1]}';
    await ref.read(chatsProvider.notifier).loadMessages({
      'offset': offset,
      'chat_id': chatId,
    });
    ref.read(ChatController.isLoading.notifier).state = false;
    storedDate = preferences.getString('${chatId}_last');
  }

  void addNewMessage() async {
    if (msg.text.isNotEmpty) {
      final filePath = ref.read(ChatController.filePath);
      ref.read(ChatController.sending.notifier).state = true;
      await ref.read(chatsProvider.notifier).addMessages(
        {
          'chat_id': chatId,
          'message': msg.text,
          'sender': sender,
          'receiverId': widget.user.id,
          if (filePath != null) 'file': filePath,
        },
        onSendProgress: (p0, p1) {
          final progress = p1 / p0;
          ref.read(ChatController.progress.notifier).state = progress;
        },
        onDone: () {
          msg.text = '';
          ref.read(ChatController.filePath.notifier).state = null;
          ref.read(ChatController.progress.notifier).state = 0;
          ref.read(ChatController.sending.notifier).state = false;
        },
      );
    } else {
      AppController.toastMessage('Alert!', 'Please enter something..',
          purpose: Purpose.fail);
    }
  }

  @override
  void dispose() {
    preferences.setString('${chatId}_last', DateTime.now().toIso8601String());
    timer?.cancel();
    ChatController().cancel();
    msg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    bool isLoading = ref.watch(ChatController.isLoading);
    final messages = ref.watch(chatsProvider);
    final filePath = ref.watch(ChatController.filePath);
    if (messages.isNotEmpty) {
      lastDate = messages.last.createdAt.toIso8601String();
    }

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
                reverse: true,
                child: isLoading
                    ? ListShimmer(isDark: isDark)
                    : Column(
                        children: [
                          if (messages.isEmpty)
                            SizedBox(
                              height: size.height - 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.filter_list_off,
                                        size: 50, color: Colors.red),
                                    SizedBox(height: 10),
                                    Text(
                                      'No messages found. Send new message!',
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          for (var i = 0; i < messages.length; i++)
                            Builder(builder: (context) {
                              final message = messages[i];
                              if (sender != message.senderId) {
                                if (message.createdAt.isAfter(DateTime.parse(
                                  storedDate ??
                                      DateTime.now().toIso8601String(),
                                ))) {
                                  ChatController.updateMessage(message.id);
                                }
                              }
                              return MessageBox(
                                isYou: message.senderId == sender,
                                isDark: isDark,
                                file: message.file,
                                message: message.message,
                                isReaded: message.isReaded == 1,
                                date: message.createdAt,
                              );
                            }),
                        ],
                      ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (filePath != null)
                  Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withAlpha(60),
                    ),
                    child: ListTile(
                      dense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey)),
                        clipBehavior: Clip.hardEdge,
                        child: Icon(Icons.file_copy),
                      ),
                      title: Text(
                        filePath.split('/').last,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          ref.read(ChatController.filePath.notifier).state =
                              null;
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final files = await ChatController.picFile();
                          if (files.isNotEmpty) {
                            ref.read(ChatController.filePath.notifier).state =
                                files.first;
                          }
                        },
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
                          controller: msg,
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
                      ref.watch(ChatController.sending) && filePath != null
                          ? Builder(builder: (context) {
                              var progress = ref.watch(ChatController.progress);
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(value: progress),
                                    Text(
                                      '${(progress * 100).toInt()}%',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              );
                            })
                          : IconButton(
                              onPressed: ref.watch(ChatController.sending)
                                  ? null
                                  : addNewMessage,
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
          ],
        ),
      ),
    );
  }
}
