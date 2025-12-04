import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/controller/topper_list_controller.dart';
import 'package:senthil/model/topper_list_model.dart';
import 'package:senthil/view/pdf_viewer_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SubjectTopperTable extends StatelessWidget {
  const SubjectTopperTable(
      {super.key, required this.snap, required this.isDark});

  final TopperListModel snap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.7,
      child: DataTable2(
        border: TableBorder.all(color: Colors.grey),
        columnSpacing: 12,
        horizontalMargin: 12,
        headingRowColor: WidgetStatePropertyAll(AppController.tableColor),
        fixedColumnsColor: AppController.tableColor,
        fixedLeftColumns: 1,
        fixedTopRows: 1,
        columns: [
          DataColumn2(
              label: Text('Subject'),
              size: ColumnSize.L,
              headingRowAlignment: MainAxisAlignment.center),
          for (var school in snap.data.schools)
            DataColumn2(
                label: Text(school),
                headingRowAlignment: MainAxisAlignment.center),
        ],
        rows: _buildSubjectRows(),
      ),
    );
  }

  List<DataRow> _buildSubjectRows() {
    List<DataRow> rows = [];

    snap.data.subjectToppers.forEach((subject, schoolData) {
      rows.add(DataRow(
        cells: [
          DataCell(Center(
            child: Text(subject == 'Mathematics' ? 'Maths' : subject),
          )),
          for (var school in snap.data.schools)
            _buildSchoolCell(schoolData[school], subject, school),
        ],
      ));
    });

    return rows;
  }

  DataCell _buildSchoolCell(
      SubjectTopperData? data, String subject, String school) {
    if (data == null || data.students.isEmpty) {
      return DataCell(Center(child: Text('-')));
    }

    final hasFiles =
        data.students.any((student) => student.file?.isNotEmpty ?? false);

    return DataCell(
      Center(
        child: InkWell(
          onTap: () => _showStudentList(subject, school, data),
          child: Text(
            '${data.topMark} (${data.count})',
            style: TextStyle(
              color: hasFiles
                  ? isDark
                      ? AppController.lightBlue
                      : baseColor
                  : null,
              decoration:
                  hasFiles ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  void _showStudentList(String subject, String school, SubjectTopperData data) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$subject - $school',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  itemCount: data.students.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final student = data.students[index];
                    String image = student.photo?.isEmpty ?? true
                        ? '${AppController.baseImageUrl}/placeholder.jpg'
                        : '${AppController.basefileUrl}/${student.photo}';

                    return ListTile(
                      leading: GestureDetector(
                        onTap: () => TopperListController.openImage(
                            Get.context!, image, student.name ?? 'Student'),
                        child: CircleAvatar(
                          backgroundColor: baseColor.withAlpha(150),
                          backgroundImage: NetworkImage(image),
                        ),
                      ),
                      title: Text(
                        '${index + 1}. ${student.name ?? "Unknown"}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text('Mark: ${student.mark}'),
                      trailing: student.file?.isNotEmpty ?? false
                          ? IconButton(
                              icon:
                                  Icon(Icons.picture_as_pdf, color: baseColor),
                              onPressed: () async {
                                if (kIsWeb) {
                                  final url =
                                      '${AppController.basefileUrl}/${student.file!}';
                                  if (await canLaunchUrlString(url)) {
                                    await launchUrlString(url);
                                  }
                                } else {
                                  Get.to(
                                    () => PdfViewerScreen(
                                        fileName: student.file!),
                                    transition: Transition.zoom,
                                  );
                                }
                              },
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
