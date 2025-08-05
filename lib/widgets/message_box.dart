import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.isYou,
    required this.isDark,
    required this.message,
    required this.date,
    required this.file,
    required this.isReaded,
  });
  final bool isYou;
  final bool isDark;
  final String message;
  final bool isReaded;
  final String? file;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color color = isYou
        ? isDark
            ? AppController.lightBlue
            : baseColor
        : const Color.fromRGBO(158, 158, 158, 1);

    return Row(
      mainAxisAlignment:
          isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withAlpha(50),
            border: Border.all(color: color.withAlpha(60)),
          ),
          constraints: BoxConstraints(
            maxWidth: size.width > 450 ? 450 : size.width * 0.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (file != null)
                Builder(builder: (context) {
                  bool isImage = ['jpg', 'png', 'jpeg', 'webp']
                      .contains(file!.split('.').last);
                  return GestureDetector(
                    onTap: () async {
                      final url = '${AppController.baseChatImgUrl}/$file';
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      clipBehavior: Clip.hardEdge,
                      child: isImage
                          ? Image.network(
                              '${AppController.baseChatImgUrl}/$file')
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 10),
                              child: Icon(
                                Icons.file_copy_rounded,
                                size: 50,
                                color: Colors.black87,
                              ),
                            ),
                    ),
                  );
                }),
              Text(message),
              SizedBox(height: 2),
              Text(
                '${AppController.formatToSmartDate(date.toUtc().toIso8601String())} ${!isYou ? '📅' : isReaded ? '👍' : '✊'}',
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
