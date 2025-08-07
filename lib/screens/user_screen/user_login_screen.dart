import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/city_listview_screen.dart';
import 'package:project_one/screens/main_layout/main_layout_screen.dart';
import 'package:project_one/screens/user_screen/user_signUp_screen.dart';
import 'package:project_one/theme/theme.dart';
import 'package:project_one/viewModels/user/user_login/user_login_controller.dart';
import 'package:project_one/widgets/custom_scaffold.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_one/widgets/logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  bool agreePersonalData = true;
  bool _obsurePassword = true;
  final bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 120.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),

                  child: Form(
                    key: _formSignInKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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

                        Text(
                          'Sign In to continue...',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            } else if (!value.contains('@gmail.com')) {
                              return 'Invaild Email (missing @)';
                            }
                            return null;
                          },
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
                        SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obsurePassword,
                          obscuringCharacter: '*',

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            } else if (value.length > 6) {
                              return 'Password must be at least 6 characters';
                            }

                            final hasUppercase = value.contains(
                              RegExp(r'[A-Z]'),
                            );
                            final hasLowercase = value.contains(
                              RegExp(r'[a-z]'),
                            );
                            final hasDigit = value.contains(RegExp(r'\d'));
                            final hasSpecialChar = value.contains(
                              RegExp(r'[!@#\$%^&*(),.?":{}|<>]'),
                            );

                            if (!hasUppercase ||
                                !hasLowercase ||
                                !hasDigit ||
                                !hasSpecialChar) {
                              return 'Password must contain at least one uppercase,lowercase,number and special character';
                            }

                            return null;
                          },
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
                        SizedBox(height: 10),

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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formSignInKey.currentState!.validate()) {
                                if (!rememberPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please agree to the processing of personal',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                String? userName = await UserLoginController
                                    .instance
                                    .login(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                      context,
                                    );

                                if (userName != null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MainLayoutScreen(),
                                      // CityListviewScreen(
                                      //   userName: userName,
                                      // ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'LogIn',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Text(
                                'Login with',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                //  signUpController.signUpWithGoogle(context),
                              },

                              label: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/4/4a/Logo_2013_Google.png',
                                height: 40,
                                width: 40,
                              ),
                              icon: Image.network(
                                'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png',
                                height: 35,
                                width: 35,
                              ),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white, // Text color
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ), // Optional rounded corners
                                  side: BorderSide.none, // Removes border
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(SignUpScreen());
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
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
