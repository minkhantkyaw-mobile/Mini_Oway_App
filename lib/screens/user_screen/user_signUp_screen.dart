import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/user_screen/user_login_screen.dart';
import 'package:project_one/theme/theme.dart';
import 'package:project_one/viewModels/user/user_signup/user_signup_controller.dart';
import 'package:project_one/widgets/custom_scaffold.dart';
import 'package:project_one/widgets/logo.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final UserSignupController signupController = Get.put(UserSignupController());
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  bool _obsurePassword = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Image.network(
            "https://framerusercontent.com/images/r4bqA98NZdxraufAO0IxKjxH6U.png?scale-down-to=512",
            height: 100,
          ),
          SizedBox(height: 2),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 0.0),
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
                      Text(
                        'Create An Account',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),

                      Text(
                        'Fill in your details to get started',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),

                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            'Date Time: ${DateTime.now().toString().substring(0, 19)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Full Name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Full Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          prefixIcon: Icon(Icons.person),
                          hintText: 'Full Name',
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
                      SizedBox(height: 10),
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
                      SizedBox(height: 10),
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

                          final hasUppercase = value.contains(RegExp(r'[A-Z]'));
                          final hasLowercase = value.contains(RegExp(r'[a-z]'));
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

                      /////////////Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: _obsurePassword,
                        obscuringCharacter: '*',

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Confirm Password';
                          } else if (passwordController.value !=
                              confirmPasswordController.value) {
                            return 'Password do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Confirm Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Confirm Password',
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
                      ///////////For Phone
                      TextFormField(
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Phone Number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Phone Number',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Phone Number',
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
                      SizedBox(height: 10),
                      //////////For Address
                      TextFormField(
                        controller: fullAddressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Full Address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Full Address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          prefixIcon: Icon(Icons.home),
                          hintText: 'Full Address',
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

                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: lightColorScheme.primary,
                          ),
                          Text(
                            'I agree to the processing of ',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          GestureDetector(
                            child: Text(
                              'Personal Data',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formSignupKey.currentState!.validate() &&
                                agreePersonalData) {
                              String fullName = nameController.text.trim();
                              String email = emailController.text.trim();
                              String password = passwordController.text.trim();
                              String phone = phoneController.text.trim();
                              String address = fullAddressController.text
                                  .trim();
                              signupController.register(
                                fullName,
                                email,
                                password,
                                phone,
                                address,
                                context,
                              );
                            }
                          },
                          child: Text(
                            'Sign Up',
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
                              vertical: 0,
                            ),
                            child: Text(
                              'Sign up with',
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(LoginScreen());
                            },
                            child: Text(
                              'Login',

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
    );
  }
}
