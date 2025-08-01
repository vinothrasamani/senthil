import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/content_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/content_model.dart';
import 'package:senthil/shimmer/list_shimmer.dart';
import 'package:senthil/widgets/my_chip.dart';

class ContentScreen extends ConsumerWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listener = ref.watch(contentProvider);
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

    final style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Content'),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [Tab(text: 'CBSE'), Tab(text: 'Matric')],
          ),
        ),
        body: SafeArea(
          child: listener.when(
            data: (snap) => TabBarView(
              children: [
                for (var i = 0; i < 2; i++)
                  SizedBox(
                    height: size.height - 100,
                    child: Builder(builder: (context) {
                      List<SchoolData> list = [];
                      if (i == 0) {
                        list = snap.cbse;
                      } else {
                        list = snap.matric;
                      }
                      return ListView(
                        padding: EdgeInsets.only(bottom: 80),
                        children: [
                          for (var item in list)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor:
                                            AppController.lightBlue,
                                        child: Text('${list.indexOf(item) + 1}',
                                            style: style),
                                      ),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          ContentController.openEditor(
                                              context, item);
                                        },
                                        color: AppController.yellow,
                                        icon: Icon(TablerIcons.edit),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 10),
                                      MyChip('Order : ${item.ord}',
                                          AppController.headColor),
                                      SizedBox(width: 6),
                                      MyChip('Ref Id : ${item.id}',
                                          AppController.red),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
              ],
            ),
            error: (error, _) {
              return Center(
                child: Text('Something went wrong!'),
              );
            },
            loading: () => ListShimmer(isDark: isDark),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ContentController.openEditor(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
