import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/settings_controller.dart';
import 'package:senthil/controller/student_feedback_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/feedback_home_model.dart';
import 'package:senthil/model/login_model.dart';
import 'package:senthil/widgets/popup_menu.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedbackHomeScreen extends ConsumerWidget {
  const FeedbackHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(LoginController.userProvider);
    final size = MediaQuery.of(context).size;
    final credentials =
        ref.watch(StudentFeedbackController.credentials(user!.data!.id));

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[50]
          : null,
      appBar: AppBar(
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.feedback_rounded, size: 24, color: Colors.blue),
        ),
        title: Text('Student Feedback',
            style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          Builder(builder: (context) {
            final isDark =
                ref.watch(ThemeController.themeMode) == ThemeMode.dark;
            return IconButton(
              onPressed: () => SettingsController.changeTheme(ref, !isDark),
              icon: Icon(
                isDark ? TablerIcons.sun : TablerIcons.moon,
                color: Colors.white,
              ),
            );
          }),
          SizedBox(width: 8),
          PopupMenu(user: user),
          SizedBox(width: 8)
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSchoolHeader(context),
              SizedBox(height: 20),
              credentials.when(
                data: (snap) =>
                    _buildForm(context, ref, user.data!, snap.data, size),
                error: (e, _) {
                  debugPrint(e.toString());
                  return _buildErrorState(size);
                },
                loading: () => _buildLoadingState(size),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            color: Colors.blue.withAlpha(120),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text(
          'Senthil Group of Schools',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          'Salem / Dharmapuri / Krishnagiri',
          style: TextStyle(
              fontSize: 14,
              color: Colors.white.withAlpha(220),
              letterSpacing: 0.5),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, WidgetRef ref, Data user,
      FeedbackHome data, Size size) {
    final showNotice = size.width >= 600;

    return Column(
      children: [
        if (showNotice) ...[
          _buildNoticeCard(context, ref, data, size),
          SizedBox(height: 20),
        ],
        _buildFeedbackCard(context, ref, user, data, size),
      ],
    );
  }

  Widget _buildNoticeCard(
      BuildContext context, WidgetRef ref, FeedbackHome data, Size size) {
    final isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(TablerIcons.user, color: Colors.orange, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                data.notice.noticetitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppController.lightBlue : baseColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          data.notice.noticetext,
          style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Icon(TablerIcons.bell_ringing, size: 16, color: Colors.grey),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                data.notice.noticeby,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    final center = Center(
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image:
            'https://senthil.ijessi.com/public/assets/img/illustrations/man-with-laptop.png',
        width: size.width < 700 ? 150 : 200,
        height: size.width < 700 ? 150 : 200,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            color: Colors.grey.withAlpha(100),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(flex: 6, child: column),
          SizedBox(width: 20),
          Expanded(flex: 4, child: center),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(BuildContext context, WidgetRef ref, Data user,
      FeedbackHome data, Size size) {
    final formKey = GlobalKey<FormState>();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            color: Colors.grey.withAlpha(100),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(TablerIcons.clipboard_text,
                    color: Colors.green, size: 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feedback - ${data.title}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data.staff,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Form(
            key: formKey,
            child: _buildFormFields(context, ref, data, user, size),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(BuildContext context, WidgetRef ref,
      FeedbackHome data, Data user, Size size) {
    final clsName = ref.watch(StudentFeedbackController.className);

    final fields = [
      _buildReadOnlyField('Year', data.notice.feedyear, TablerIcons.calendar),
      _buildReadOnlyField(
          'Session', data.notice.feedsession, TablerIcons.timeline),
      _buildDropdownField(
        'Board',
        ref.watch(StudentFeedbackController.board),
        data.schooltype,
        TablerIcons.school,
        (val) {
          ref.read(StudentFeedbackController.board.notifier).state = val;
          StudentFeedbackController.setData(
            ref,
            'feed-home-school',
            user.id,
            {"year": data.notice.feedyear, "type": val},
          );
        },
      ),
      _buildDropdownField(
        'School',
        ref.watch(StudentFeedbackController.school),
        ref.watch(StudentFeedbackController.schoolList),
        TablerIcons.building,
        (val) {
          ref.read(StudentFeedbackController.school.notifier).state = val;
          ref.read(StudentFeedbackController.className.notifier).state = null;
          ref.read(StudentFeedbackController.section.notifier).state = null;
          ref.read(StudentFeedbackController.refGrp.notifier).state = null;
          StudentFeedbackController.setData(
            ref,
            'feed-home-class',
            user.id,
            {
              "year": data.notice.feedyear,
              "school": val,
              "type": ref.read(StudentFeedbackController.board),
            },
          );
        },
      ),
      _buildDropdownField(
        'Class',
        clsName,
        ref.watch(StudentFeedbackController.classList),
        TablerIcons.chalkboard,
        (val) {
          ref.read(StudentFeedbackController.className.notifier).state = val;
          ref.read(StudentFeedbackController.section.notifier).state = null;
          ref.read(StudentFeedbackController.refGrp.notifier).state = null;
          StudentFeedbackController.setData(
            ref,
            'feed-home-section',
            user.id,
            {
              "year": data.notice.feedyear,
              "school": ref.read(StudentFeedbackController.school),
              "cls": val,
              "type": ref.read(StudentFeedbackController.board),
            },
          );
        },
      ),
      _buildDropdownField(
        'Section',
        ref.watch(StudentFeedbackController.section),
        ref.watch(StudentFeedbackController.sectionList),
        TablerIcons.category,
        (val) {
          ref.read(StudentFeedbackController.section.notifier).state = val;
          ref.read(StudentFeedbackController.refGrp.notifier).state = null;
          ref.read(StudentFeedbackController.subject.notifier).state = null;
          StudentFeedbackController.setData(
            ref,
            'feed-home-subject',
            0,
            {
              "year": data.notice.feedyear,
              "school": ref.read(StudentFeedbackController.school),
              "cls": ref.read(StudentFeedbackController.className),
              "type": ref.read(StudentFeedbackController.board),
              "section": val,
            },
          );
        },
      ),
      if (clsName == 'XI' || clsName == 'XII')
        _buildDropdownField(
          'RefGroup',
          ref.watch(StudentFeedbackController.refGrp),
          data.refgrouplist,
          TablerIcons.users_group,
          (val) =>
              ref.read(StudentFeedbackController.refGrp.notifier).state = val,
        ),
      Builder(builder: (context) {
        final c = ref.watch(StudentFeedbackController.subjectList).length;
        return _buildSelectionField(
          c,
          ref.watch(StudentFeedbackController.subject),
          'Exclude Subject',
          Icons.subject_rounded,
          () => StudentFeedbackController.selectSubjects(context),
        );
      }),
    ];

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            int columns = constraints.maxWidth < 600
                ? 1
                : constraints.maxWidth < 1024
                    ? 2
                    : 3;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: fields.map((child) {
                double width = (constraints.maxWidth / columns) -
                    (16 * (columns - 1) / columns);
                return SizedBox(width: width, child: child);
              }).toList(),
            );
          },
        ),
        SizedBox(height: 24),
        _buildSubmitButton(context, ref, data, user),
      ],
    );
  }

  Widget _buildSelectionField(int count, String? value, String label,
      IconData icon, VoidCallback onTap) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.withAlpha(20),
        prefixIcon: Icon(icon, color: Colors.teal.shade400, size: 20),
        suffixIcon:
            count > 0 ? Icon(Icons.check_circle_outline_outlined) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withAlpha(60)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withAlpha(60)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade300, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.withAlpha(20),
        prefixIcon: Icon(icon, color: Colors.blue.shade400, size: 20),
        suffixIcon: Icon(Icons.lock_outline, size: 18, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withAlpha(60)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withAlpha(60)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String? value,
    List<String> items,
    IconData icon,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e, style: TextStyle(fontSize: 14)),
              ))
          .toList(),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.withAlpha(20),
        prefixIcon: Icon(icon, color: Colors.purple.shade400, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withAlpha(60)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withAlpha(60)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple.shade300, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, WidgetRef ref, FeedbackHome data, Data user) {
    final isLoading = ref.watch(StudentFeedbackController.loading);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                final board = ref.read(StudentFeedbackController.board);
                final school = ref.read(StudentFeedbackController.school);
                final className = ref.read(StudentFeedbackController.className);
                final section = ref.read(StudentFeedbackController.section);
                final subject = ref.read(StudentFeedbackController.subject);
                final refGrp = ref.read(StudentFeedbackController.refGrp);
                var addRef = className == "XI" || className == "XII";

                if (board != null &&
                    school != null &&
                    (addRef ? refGrp != null : true) &&
                    className != null &&
                    section != null) {
                  final info = {
                    'academic_year': data.notice.feedyear,
                    'session': data.notice.feedsession,
                    'schooltype': board,
                    'school': school,
                    'classname': className,
                    'section': section,
                    'subject':
                        subject == null || subject.isEmpty ? '-' : subject,
                    'refgroup': refGrp ?? "None",
                  };
                  StudentFeedbackController.chackSubjectAvailability(ref, info);
                } else {
                  AppController.toastMessage(
                    "Warning!",
                    'Please fill all required fields',
                    purpose: Purpose.fail,
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade500,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.green.withAlpha(160),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(TablerIcons.send, size: 20),
            SizedBox(width: 12),
            Text(
              isLoading ? 'Processing...' : 'Start Feedback',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Size size) {
    return Container(
      height: size.height * 0.6,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(TablerIcons.alert_circle, color: Colors.red, size: 48),
            SizedBox(height: 12),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please try again later',
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(Size size) {
    return SizedBox(
      height: size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 16),
            Text(
              'Loading form...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
