import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/student_feedback_controller.dart';
import 'package:senthil/model/feedback_form_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/widgets/student_feedback/error_message.dart';
import 'package:senthil/widgets/student_feedback/subject_rating_card.dart';

class RatingFeedbackScreen extends ConsumerStatefulWidget {
  const RatingFeedbackScreen({
    super.key,
    required this.info,
    required this.isDark,
    required this.userId,
  });
  final Map<String, dynamic> info;
  final bool isDark;
  final int userId;

  @override
  ConsumerState<RatingFeedbackScreen> createState() =>
      _RatingFeedbackScreenState();
}

class _RatingFeedbackScreenState extends ConsumerState<RatingFeedbackScreen> {
  Map<String, double> starRatings = {};
  final int maxLength = 255;
  Map<String, String> textFeedback = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StudentFeedbackController.startFeedback(ref, widget.info);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feedData = ref.watch(StudentFeedbackController.feedData);
    final isLoading = ref.watch(StudentFeedbackController.fetching);
    final sub = ref.watch(StudentFeedbackController.subject);

    return Scaffold(
      appBar: _buildAppBar(context),
      bottomNavigationBar:
          sub == null || sub.isEmpty ? null : _buildExcludedSubject(sub),
      body: isLoading
          ? _buildLoadingState()
          : feedData == null
              ? _buildErrorState('Unable to fetch feedback questions!')
              : feedData.success
                  ? feedData.data.questType == 'Subject'
                      ? _buildFeedbackForm(feedData.data)
                      : _buildRatingForm(feedData.data)
                  : _buildErrorState(feedData.message),
    );
  }

  Widget _buildExcludedSubject(String sub) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => showClass(sub),
        child: Container(
          height: 45,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purpleAccent,
                Colors.deepPurple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Text(
            'Excluded Subject : $sub',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  void showClass(String sub) {
    final isDark = widget.isDark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.subject),
              title: Text(
                'Excluded Subjects',
                style:
                    TextStyle(color: isDark ? Colors.white : Colors.grey[850]),
              ),
              trailing: IconButton.filledTonal(
                onPressed: () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                },
                icon: Icon(Icons.close),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  for (var s in sub.split(','))
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppController.headColor,
                      ),
                      child: Text(
                        s,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackForm(FeedbackFormData info) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    double size;

    if (isSmallScreen) {
      size = double.infinity;
    } else if (screenWidth < 800) {
      size = screenWidth * 0.8;
    } else if (screenWidth < 1000) {
      size = screenWidth * 0.7;
    } else {
      size = screenWidth * 0.6;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.grey.withAlpha(50),
          child: Text(
            'Share your feedback about each teacher\n($maxLength characters allowed per subject)',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                for (var subject in info.subject)
                  Container(
                    width: size,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(
                                    '${info.subject.indexOf(subject) + 1}',
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        subject.fullname,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (subject.staffName != null)
                                        Text(
                                          '(${subject.staffName})',
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              maxLength: maxLength,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText:
                                    'What do you like or dislike about this teacher?',
                                hintStyle: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          144, 224, 224, 224)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2),
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                counterText: '',
                              ),
                              onChanged: (value) {
                                textFeedback['${subject.id}'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  width: isSmallScreen ? double.infinity : screenWidth * 0.5,
                  child: ElevatedButton(
                    onPressed: () => submitFeedback(info),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 32 : 48,
                        vertical: isSmallScreen ? 16 : 20,
                      ),
                    ),
                    child: Text(
                      'Submit Feedback',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void submitFeedback(FeedbackFormData feed) {
    Map<String, dynamic> body = {
      ...widget.info,
      'StudOid': feed.studOid,
      'questype': feed.questType,
      'Quesid': feed.feedQues?.id,
      'sub': textFeedback
    };
    StudentFeedbackController.submitFeedback(ref, body);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final classIs = widget.info['classname'];
    final sec = widget.info['section'];

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      title: Text(
        'Student Feedback - Class : $classIs / $sec',
        style: TextStyle(
            fontSize: isSmallScreen ? 18 : 22, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingForm(FeedbackFormData feedData) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;
    final isLargeScreen = screenWidth >= 900;
    final isOverLargeScreen = screenWidth >= 1100;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildLegendCard(isSmallScreen, screenWidth),
          _buildQuestionHeader(feedData, screenWidth),
          SizedBox(height: 10),
          _buildSubjectsWrap(feedData, screenWidth, isSmallScreen,
              isMediumScreen, isLargeScreen, isOverLargeScreen),
          SizedBox(height: 24),
          _buildSubmitButton(feedData, screenWidth, isSmallScreen),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLegendCard(bool isSmallScreen, double screenWidth) {
    return Container(
      margin: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: widget.isDark
            ? null
            : LinearGradient(
                colors: [Color(0xFFFFF8DC), Color(0xFFFFFAF0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: widget.isDark ? Colors.grey.withAlpha(70) : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 24,
          vertical: isSmallScreen ? 12 : 16,
        ),
        child: Column(
          children: [
            Text(
              'Rating Guide',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: widget.isDark
                    ? const Color.fromARGB(255, 160, 126, 255)
                    : Colors.deepPurple,
              ),
            ),
            SizedBox(height: 8),
            _buildRatingLegend(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingLegend(bool isSmallScreen) {
    final type = widget.info['schooltype'];
    if (type == "CBSE") {
      return Wrap(
        spacing: isSmallScreen ? 8 : 16,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _buildLegendItem('★☆☆', 'To Be Improved', isSmallScreen),
          _buildLegendItem('★★☆', 'Average', isSmallScreen),
          _buildLegendItem('★★★', 'Good', isSmallScreen),
        ],
      );
    } else {
      return Wrap(
        spacing: isSmallScreen ? 6 : 12,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _buildLegendItem('★☆☆☆', 'Average', isSmallScreen),
          _buildLegendItem('★★☆☆', 'Satisfied', isSmallScreen),
          _buildLegendItem('★★★☆', 'Good', isSmallScreen),
          _buildLegendItem('★★★★', 'Very Good', isSmallScreen),
        ],
      );
    }
  }

  Widget _buildLegendItem(String stars, String label, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFFF7429).withAlpha(110)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stars,
            style: TextStyle(
                color: Color(0xFFFF7429),
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: widget.isDark ? Colors.white : Colors.black,
              fontSize: isSmallScreen ? 11 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(FeedbackFormData feedData, double screenWidth) {
    final isSmallScreen = screenWidth < 600;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple,
        radius: 20,
        child: Text(
          '${feedData.feedQues?.ord ?? '?'}',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      title: Text(
        feedData.feedQues?.subject ?? 'Unknown',
        style: TextStyle(
          fontSize: isSmallScreen ? 16 : 20,
          color: widget.isDark
              ? const Color.fromARGB(255, 160, 126, 255)
              : Colors.deepPurple,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildSubjectsWrap(
      FeedbackFormData feedData,
      double screenWidth,
      bool isSmallScreen,
      bool isMediumScreen,
      bool isLargeScreen,
      bool isOverLargeScreen) {
    double cardWidth;
    double horizontalPadding;
    double spacing;

    if (isOverLargeScreen) {
      cardWidth = (screenWidth - 80 - (4 * 16)) / 5;
      horizontalPadding = 40;
      spacing = 16;
    } else if (isLargeScreen) {
      cardWidth = (screenWidth - 64 - (3 * 16)) / 4;
      horizontalPadding = 32;
      spacing = 16;
    } else if (isMediumScreen) {
      cardWidth = (screenWidth - 48 - (2 * 16)) / 3;
      horizontalPadding = 24;
      spacing = 16;
    } else if (screenWidth < 400) {
      cardWidth = screenWidth - 32;
      horizontalPadding = 16;
      spacing = 12;
    } else {
      cardWidth = (screenWidth - 32 - 12) / 2;
      horizontalPadding = 16;
      spacing = 12;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: WrapAlignment.start,
        children: feedData.subject.map((subject) {
          return SizedBox(
            width: cardWidth,
            child: _buildSubjectRatingCard(subject, isSmallScreen),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubjectRatingCard(FeedFormSubject subject, bool isSmallScreen) {
    final currentRating = starRatings['${subject.id}'] ?? 0;
    final hasRating = currentRating > 0;
    final type = widget.info['schooltype'];
    return SubjectRatingCard(
        hasRating: hasRating,
        isSmallScreen: isSmallScreen,
        subject: subject,
        type: type,
        isDark: widget.isDark,
        onRate: (val) {
          starRatings['${subject.id}'] = val;
          setState(() {});
        },
        currentRating: currentRating);
  }

  Widget _buildSubmitButton(
    FeedbackFormData feed,
    double screenWidth,
    bool isSmallScreen,
  ) {
    final allRated = feed.subject.every(
      (subject) =>
          starRatings.containsKey('${subject.id}') &&
          starRatings['${subject.id}']! > 0,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: isSmallScreen ? double.infinity : screenWidth * 0.5,
      child: ElevatedButton(
        onPressed: () => _submitStarRatings(feed),
        style: ElevatedButton.styleFrom(
          backgroundColor: allRated ? Colors.green : Colors.green.shade300,
          foregroundColor: Colors.white,
          elevation: allRated ? 6 : 2,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 32 : 48,
            vertical: isSmallScreen ? 16 : 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadowColor:
              allRated ? Colors.green.withAlpha(110) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (allRated)
              Icon(Icons.check_circle_outline, size: isSmallScreen ? 20 : 24),
            if (allRated) SizedBox(width: 8),
            Text(
              'Next Feedback',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: isSmallScreen ? 20 : 24),
          ],
        ),
      ),
    );
  }

  void _submitStarRatings(FeedbackFormData feed) {
    for (var subject in feed.subject) {
      if (!starRatings.containsKey('${subject.id}') ||
          starRatings['${subject.id}'] == 0) {
        AppController.toastMessage(
          'Rating Required!',
          'Please rate ${subject.fullname} before proceeding',
          purpose: Purpose.fail,
        );
        return;
      }
    }
    Map<String, dynamic> body = {
      ...widget.info,
      'StudOid': feed.studOid,
      'questype': feed.questType,
      'Quesid': feed.feedQues?.id,
      'sub': starRatings
    };
    StudentFeedbackController.nextFeedback(ref, widget.userId, body, () {
      starRatings.clear();
    });
  }

  Widget _buildErrorState(String msg) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return ErrorMessage(
        msg: msg, info: widget.info, isSmallScreen: isSmallScreen);
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            strokeWidth: 3,
          ),
          SizedBox(height: 24),
          Text(
            'Loading feedback questions...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
