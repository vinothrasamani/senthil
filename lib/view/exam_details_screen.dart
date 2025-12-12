import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/exam_details_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/simple_list_shimmer.dart';
import 'package:senthil/widgets/common_error_widget.dart';

class ExamDetailsScreen extends ConsumerWidget {
  const ExamDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listener = ref.watch(examDetailsProvider);
    final size = MediaQuery.of(context).size;
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.white,
    );

    var pad = size.width > 500
        ? size.width > 800
            ? size.width > 1000
                ? size.width * 0.20
                : size.width * 0.16
            : size.width * 0.12
        : 2.0;

    return Scaffold(
      appBar: AppBar(title: Text('Exam Details')),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: pad),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              if (size.width > 500)
                BoxShadow(
                  offset: Offset(0, 0.5),
                  color: Colors.grey.withAlpha(100),
                  spreadRadius: 1,
                  blurRadius: 2,
                ),
            ],
          ),
          child: listener.when(
            data: (snap) => ListView(
              padding: EdgeInsets.only(bottom: 80),
              children: [
                for (var item in snap)
                  Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: AppController.lightBlue,
                              child: Text('${snap.indexOf(item) + 1}',
                                  style: style),
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(item.examName ?? 'None'),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:
                                Theme.of(context).appBarTheme.backgroundColor,
                          ),
                          child: Text('${item.ord}', style: style),
                        ),
                        onTap: () {
                          ExamDetailsController.openEditor(context, item);
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10, left: 60),
                        height: 0.5,
                        color: Colors.grey.withAlpha(150),
                      ),
                    ],
                  ),
              ],
            ),
            error: (error, _) => CommonErrorWidget(),
            loading: () => SimpleListShimmer(isDark: isDark),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ExamDetailsController.openEditor(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
