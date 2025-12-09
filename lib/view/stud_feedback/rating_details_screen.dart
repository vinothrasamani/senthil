import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/feedback_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/widgets/common_error_widget.dart';
import 'package:senthil/widgets/no_record_content.dart';

class RatingDetailsScreen extends StatelessWidget {
  const RatingDetailsScreen({
    super.key,
    required this.fId,
    required this.ids,
    required this.sId,
    required this.isDark,
  });
  final List<int> ids;
  final int fId;
  final bool isDark;
  final int sId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardBg = isDark ? Color(0xFF2d2d2d) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    bool isSmall = size.width < 500;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback Rating Details',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: FeedbackController.fetchRating(
                {'ids': ids, 'subId': sId, 'fId': fId}),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return CommonErrorWidget();
              }
              final data = snap.data?.data;
              if (data == null) {
                return NoRecordContent();
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: size.width,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                          width: 0.5,
                          color: Colors.grey.withAlpha(100),
                        )),
                        color: baseColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            if (!isSmall)
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: AppController.lightBlue,
                              ),
                            if (!isSmall) SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                data.question,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              infoCard(
                                  label: "Subject : ", value: data.subject),
                              infoCard(label: "Staff : ", value: data.staff),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Student Feedback',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                    ),
                    SizedBox(height: 12),
                    if (data.providedFeedback.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.providedFeedback.length,
                        itemBuilder: (context, index) {
                          final feedback = data.providedFeedback[index];
                          return feedbackCard(
                            index: index + 1,
                            studentId: feedback.studOid,
                            rating: feedback.star,
                            isDark: isDark,
                            cardBg: cardBg,
                            isSmall: isSmall,
                            textColor: textColor,
                          );
                        },
                      )
                    else
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'No feedback available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget infoCard({required String label, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget feedbackCard(
      {required int index,
      required String studentId,
      required int rating,
      required bool isDark,
      required Color cardBg,
      required Color textColor,
      required bool isSmall}) {
    final starColor = isDark ? Color(0xFFFFA559) : Color(0xFFFF7429);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isSmall ? 35 : 48,
            height: isSmall ? 35 : 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade400],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmall ? 15 : 18,
                ),
              ),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student ID',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  studentId,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: starColor.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 3; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmall ? 1 : 2),
                    child: Icon(i < rating ? Icons.star : Icons.star_border,
                        color: starColor, size: 20),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
