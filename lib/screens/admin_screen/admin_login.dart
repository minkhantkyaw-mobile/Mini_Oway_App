import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/admin_screen/admin_home_screen.dart';
import 'package:project_one/theme/theme.dart';
import 'package:project_one/widgets/custom_scaffold.dart';

import '../../viewModels/admin_controller/admin_login_controller.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  bool _obsurePassword = true;
  bool rememberPassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AdminLoginController controller = Get.put(AdminLoginController());
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Image.network(
              "https://framerusercontent.com/images/r4bqA98NZdxraufAO0IxKjxH6U.png?scale-down-to=512",
              height: 130,
            ),
            SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 220.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),

                  child: Form(
                    key: _formSignupKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Sign In to continue with your customer...',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please Enter Email';
                          //   } else if (!value.contains('@gmail.com')) {
                          //     return 'Invaild Email (missing @)';
                          //   }
                          //   return null;
                          // },
                          decoration: InputDecoration(
                            label: Text(
                              'Email',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obsurePassword,
                          obscuringCharacter: '*',

                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please Enter Password';
                          //   } else if (value.length > 6) {
                          //     return 'Password must be at least 6 characters';
                          //   }
                          //
                          //   final hasUppercase = value.contains(
                          //     RegExp(r'[A-Z]'),
                          //   );
                          //   final hasLowercase = value.contains(
                          //     RegExp(r'[a-z]'),
                          //   );
                          //   final hasDigit = value.contains(RegExp(r'\d'));
                          //   final hasSpecialChar = value.contains(
                          //     RegExp(r'[!@#\$%^&*(),.?":{}|<>]'),
                          //   );
                          //
                          //   if (!hasUppercase ||
                          //       !hasLowercase ||
                          //       !hasDigit ||
                          //       !hasSpecialChar) {
                          //     return 'Password must contain at least one uppercase,lowercase,number and special character';
                          //   }
                          //
                          //   return null;
                          // },
                          decoration: InputDecoration(
                            label: Text(
                              'Password',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorMaxLines: 2,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obsurePassword = !_obsurePassword;
                                });
                              },
                              icon: _obsurePassword
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberPassword,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberPassword = value!;
                                    });
                                  },
                                  activeColor: lightColorScheme.primary,
                                ),
                                Text(
                                  'Remember me',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: Text(
                                'Forget Password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formSignupKey.currentState!.validate() &&
                                  agreePersonalData) {
                                final email = emailController.text.trim();
                                final password = passwordController.text.trim();
                                controller.login(email, password);
                              } else if (!agreePersonalData) {
                                Get.snackbar(
                                  "Notice",
                                  "Please agree to the terms first.",
                                  backgroundColor: Colors.orange,
                                );
                              }
                            },
                            child: Text(
                              'LogIn',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
