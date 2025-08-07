import 'package:flutter/material.dart';
import 'package:project_one/screens/user_screen/user_login_screen.dart';
import 'package:project_one/screens/user_screen/user_signUp_screen.dart';
import 'package:project_one/theme/theme.dart';
import 'package:project_one/widgets/custom_scaffold.dart';
import 'package:project_one/widgets/welcome_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isSignInSelected = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Center(
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome Back! User\n',
                            style: TextStyle(
                              color: Colors.blueAccent.shade400,
                              fontSize: 45.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '\nEnter personal details to your account',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Login',
                      onTap: () {
                        setState(() {
                          isSignInSelected = true;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      color: isSignInSelected
                          ? Colors.white
                          : Colors.transparent,
                      textColor: isSignInSelected
                          ? Colors.blueAccent.shade400
                          : Colors.white,
                      borderRadius: isSignInSelected
                          ? BorderRadius.only(topRight: Radius.circular(50))
                          : BorderRadius.only(topLeft: Radius.circular(50)),
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign Up',
                      onTap: () {
                        setState(() {
                          isSignInSelected = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      color: !isSignInSelected
                          ? Colors.white
                          : Colors.transparent,
                      textColor: !isSignInSelected
                          ? Colors.blueAccent.shade400
                          : Colors.white,
                      borderRadius: isSignInSelected
                          ? BorderRadius.only(topLeft: Radius.circular(50))
                          : BorderRadius.only(topLeft: Radius.circular(50)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
