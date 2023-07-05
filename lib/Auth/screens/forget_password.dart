import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/Auth/services/auth_methods.dart';

import '../../../core/utils/widgets/custom_button.dart';
import '../../core/utils/widgets/clipper.dart';
import '../widgets/input_feild.dart';
import '../widgets/waveClipperScreen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void passwordRest() async {
    await FirebaseAuthMethods(FirebaseAuth.instance)
        .sendPasswordResetEmail(email: emailController.text, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                WaveClipperScreen(widgetHeight: screenHeight * .5),
                Opacity(
                  opacity: 0.1,
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        color: Colors.black,
                        height: screenHeight * 0.507,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * .1),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * .1,
                    ),
                    const Text(
                      'Enter Your Email',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
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
                  ],
                ),
              ),
            ),
            BottomSheetContainer(
              buttonText: 'Reset Password',
              onPressed: () {
                passwordRest();
              },
            )
          ],
        ),
      ),
    );
  }
}
