import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var pad = size.width > 500
        ? size.width > 800
            ? size.width > 1000
                ? size.width * 0.20
                : size.width * 0.16
            : size.width * 0.12
        : 2.0;

    List<String> headers = [
      '1. Introduction',
      '2. Use of the App',
      '3. User Responsibilities',
      '4. Chat Feature Usage',
      '5. Third-Party Services',
      '6. Limitation of Liability',
      '7. Changes to Terms',
      '8. Contact Us'
    ];

    List<List<String>> content = [
      [
        'Welcome to the app Senthil. This app is designed to provide service to the user to fulfil their requirements. By using this App, you agree to comply with these Terms and Conditions. If you do not agree, please discontinue use immediately.'
      ],
      [
        'The App is intended to fulfil user Requirements.',
        'Any misuse and unauthorized access may result in restricted access or legal action.'
      ],
      [
        'Keep your login credentials confidential and not share your account with others.',
        'The provided information should be valid.',
        'Do not attempt to do reverse engineering, hack, or misuse the app in any way.'
      ],
      [
        'Users must not share offensive, harmful, unlawful, or inappropriate content in chats.',
        'The admin reserves the right to monitor chat activity for security and compliance purposes.',
        'Violation of these terms may lead to suspension or termination of the user’s access to the chat feature or the application.'
      ],
      [
        'Our app operates independently and does not integrate with or rely on any third-party services or platforms. All features and content are provided directly through our systems, and no user data is shared with external entities. But we use Google APIs to send push notification to notify the information.'
      ],
      [
        '•	We are not responsible for any loss of information cause of malfunction.',
        'We do not guarantee that the app will be free from errors, uninterrupted service at all times. You use the app at your own risk and are solely responsible for any damage to your device or data loss that may result from using content from the app.'
      ],
      [
        'We reserve the right to update these Terms and Conditions from time to time. Changes will be communicated by the notification, and continued use of the App constitutes acceptance of the updated terms.'
      ],
      [
        'If you have any questions or concerns about these Terms and Conditions, please contact us at:\n 📧 jessisoftwareacc@gmail.com \n 📞 +91 – 8098866533'
      ]
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Terms and Conditions')),
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
          child: ListView(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            children: [
              SizedBox(height: 10),
              Text(
                'Last Updated : 28/08/2025',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              for (var i = 0; i < headers.length; i++)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: i == 4 ? 0 : 20),
                    Text(
                      headers[i],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: i == 4 ? 0 : 5),
                    for (var c in content[i])
                      content[i].length > 1
                          ? Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('➡️'),
                                    SizedBox(width: 10),
                                    Expanded(child: Text(c)),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            )
                          : Text(c),
                  ],
                )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 40,
        color: Theme.of(context).appBarTheme.backgroundColor,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: const Text(
          '© 2025 Senthil Inc. All Rights Reserved.',
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
