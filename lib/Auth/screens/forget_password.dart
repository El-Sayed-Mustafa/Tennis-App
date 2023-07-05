import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/Auth/services/auth_methods.dart';

import '../../../core/utils/widgets/custom_button.dart';
import '../../core/utils/widgets/clipper.dart';
import '../../generated/l10n.dart';
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
                    Text(
                      S.of(context).enter_email,
                      style: const TextStyle(
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
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S.of(context).email,
                          style: const TextStyle(
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
                      hintText: S.of(context).email_address,
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
              buttonText: S.of(context).reset_password,
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
