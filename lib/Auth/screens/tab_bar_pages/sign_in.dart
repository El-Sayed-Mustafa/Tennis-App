import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/widgets/custom_button.dart';
import '../../../core/utils/widgets/dialog_prograss_indecator.dart';
import '../../services/auth_methods.dart';
import '../../widgets/divider.dart';
import '../../widgets/input_feild.dart';
import '../../widgets/solcial_media.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * .1),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * .022,
                    ),
                    const Text(
                      'Sign in to your profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * .022,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .05, vertical: 2),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: Color(0xFF797979),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    MyInputText(
                      controller: emailController,
                      hintText: "Email Address",
                      icon: Icons.email_outlined,
                      obscureText: false,
                    ),
                    SizedBox(
                      height: screenHeight * .02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .05, vertical: 2),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: Color(0xFF797979),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    MyInputText(
                      controller: passwordController,
                      hintText: "Password",
                      icon: Icons.lock_open_outlined,
                      obscureText: true,
                    ),
                    const MyDivider(),
                    const SocialMedia(),
                    SizedBox(
                      height: screenHeight * .01,
                    ),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).replace('/forgetPassword');
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Color(0xFF1B262C),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomSheetContainer(
              buttonText: 'SIGN IN',
              onPressed: () {
                signUserIn();
              },
            )
          ],
        ),
      ),
    );
  }

  void signUserIn() async {
    //comments
    await FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }
}
