import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/controller/topper_list_controller.dart';
import 'package:senthil/model/topper_list_model.dart';
import 'package:senthil/view/pdf_viewer_screen.dart';

class ClassTopperCard extends StatelessWidget {
  const ClassTopperCard({super.key, required this.snap, required this.isDark});
  final TopperListModel snap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget myRow(TopDatum item, int index) => Builder(builder: (context) {
          String link = item.filename;
          TextStyle style1 = TextStyle(
              color: link.isEmpty
                  ? null
                  : isDark
                      ? AppController.lightBlue
                      : baseColor);
          return InkWell(
            onTap: () {
              if (link.isNotEmpty) {
                Get.to(() => PdfViewerScreen(fileName: link),
                    transition: Transition.zoom);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppController.darkGreen,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(item.subjectName, style: style1),
                  SizedBox(width: 8),
                  Spacer(),
                  Text(item.value.toStringAsFixed(1), style: style1)
                ],
              ),
            ),
          );
        });

    return Builder(builder: (context) {
      int len = snap.data.clsToppers.length;
      return DefaultTabController(
        length: len,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  isScrollable: len > 4 ? true : false,
                  tabAlignment: len > 4 ? TabAlignment.start : null,
                  labelStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  labelColor: AppController.headColor,
                  indicatorColor: AppController.darkGreen,
                  dividerColor: Colors.grey.withAlpha(30),
                  tabs: [
                    for (var topper in snap.data.clsToppers)
                      Tab(text: topper.school)
                  ],
                ),
                SizedBox(
                  height: size.height * 0.7,
                  child: TabBarView(children: [
                    for (var topper in snap.data.clsToppers)
                      ListView(
                        children: [
                          Wrap(
                            spacing: 5,
                            children: [
                              for (var data in topper.details)
                                SizedBox(
                                  width: size.width > 900
                                      ? (size.width / 3) - 20
                                      : null,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: baseColor.withAlpha(50)),
                                        child: Text(
                                          'Rank ${data.rank}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      for (var details in data.topper)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 5),
                                          child: ExpansionTileItem.outlined(
                                            title: Text(
                                                details.list[0].studentName),
                                            leading:
                                                Builder(builder: (context) {
                                              String image = details
                                                      .list[0].photo.isEmpty
                                                  ? '${AppController.baseImageUrl}/placeholder.jpg'
                                                  : '${AppController.basefileUrl}/${details.list[0].photo}';
                                              return GestureDetector(
                                                onTap: () =>
                                                    TopperListController
                                                        .openImage(
                                                            context,
                                                            image,
                                                            details.list[0]
                                                                .studentName),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      baseColor.withAlpha(150),
                                                  backgroundImage:
                                                      NetworkImage(image),
                                                ),
                                              );
                                            }),
                                            children: [
                                              for (var item in details.list)
                                                myRow(item,
                                                    details.list.indexOf(item)),
                                              SizedBox(height: 10),
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        color:
                                                            AppController.red)),
                                                child: Text(
                                                  '${details.list[0].subjectTeacher.isEmpty ? '(Total : None)' : details.list[0].subjectTeacher}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppController.red),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                )
                            ],
                          )
                        ],
                      ),
                  ]),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
