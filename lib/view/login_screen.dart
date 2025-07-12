import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/theme_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String? username, password;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      ref.read(LoginController.isLoading.notifier).state = true;
      await LoginController.login(username!, password!, ref);
      ref.read(LoginController.isLoading.notifier).state = false;
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool canShow = ref.watch(LoginController.canShowPassword);
    bool isLoading = ref.watch(LoginController.isLoading);
    bool isChecked = ref.watch(LoginController.isChecked);
    Size size = MediaQuery.of(context).size;
    double flexWidth = size.width > 500
        ? size.width > 800
            ? size.width > 1000
                ? size.width * 0.3
                : size.width * 0.1
            : size.width * 0.04
        : 10;

    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: SweepGradient(colors: [
            baseColor,
            const Color.fromARGB(255, 189, 0, 157),
            const Color.fromARGB(255, 137, 0, 179),
            baseColor
          ])),
          child: SingleChildScrollView(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: flexWidth),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading) LinearProgressIndicator(),
                      SizedBox(height: 15),
                      Image.asset('assets/images/logo.png',
                          height: 120, width: 120, fit: BoxFit.cover),
                      SizedBox(height: 15),
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Please login to continue..'),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            prefixIcon: Icon(
                              TablerIcons.user,
                              color: Colors.grey,
                            )),
                        onChanged: (value) => username = value,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter username!'
                            : null,
                        onSaved: (newValue) => username = newValue,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            prefixIcon:
                                Icon(TablerIcons.lock, color: Colors.grey),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                ref
                                    .read(LoginController
                                        .canShowPassword.notifier)
                                    .state = !canShow;
                              },
                              child: Icon(
                                  canShow
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey),
                            )),
                        obscureText: !canShow,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter password!'
                            : null,
                        onChanged: (value) => password = value,
                        onSaved: (newValue) => password = newValue,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (val) {
                              ref
                                  .read(LoginController.isChecked.notifier)
                                  .state = val ?? false;
                            },
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text.rich(
                              TextSpan(text: 'I agreed to the ', children: [
                                TextSpan(
                                    text: 'Privacy Policy ',
                                    style: TextStyle(color: Colors.blue)),
                                TextSpan(text: 'and '),
                                TextSpan(
                                    text: 'Terms & Conditions.',
                                    style: TextStyle(color: Colors.blue)),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading || !isChecked ? null : login,
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: isLoading || !isChecked
                                    ? Colors.black54
                                    : null),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
