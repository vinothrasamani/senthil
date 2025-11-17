import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/student_feedback_controller.dart';
import 'package:senthil/model/feedback_home_model.dart';
import 'package:senthil/widgets/popup_menu.dart';

class FeedbackHomeScreen extends ConsumerWidget {
  const FeedbackHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(LoginController.userProvider);
    final credentials =
        ref.watch(StudentFeedbackController.credentials(user!.data!.id));

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.feedback_rounded, size: 25),
        title: Text('Student Feedback'),
        actions: [PopupMenu(user: user), SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.5, 1),
                      color: Colors.grey.withAlpha(160),
                      blurRadius: 4,
                      spreadRadius: 1.5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png',
                        width: 100, height: 100),
                    SizedBox(height: 5),
                    Text(
                      'Senthil Group of Schools',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Salem / Dharmapuri /Krishnagiri',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              credentials.when(
                data: (snap) => form(snap),
                error: (e, _) => SizedBox(
                  height: 200,
                  child: Center(
                      child:
                          Text('Something went wrong! try again later! $e $_')),
                ),
                loading: () => CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget form(FeedbackHomeModel snap) {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Feedback - (${snap.data.title})',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(snap.data.staff),
        ),
        SizedBox(height: 10),
        Form(
          child: Column(
            children: [],
          ),
        ),
      ],
    );
  }
}
