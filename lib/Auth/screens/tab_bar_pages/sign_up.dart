import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/Auth/services/auth_methods.dart';
import 'package:tennis_app/Auth/widgets/solcial_media.dart';
import 'package:tennis_app/core/utils/widgets/dialog_prograss_indecator.dart';

import '../../../core/utils/widgets/custom_button.dart';
import '../../../generated/l10n.dart';
import '../../widgets/divider.dart';
import '../../widgets/input_feild.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  bool isLoading = false;

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
                    Text(
                      S.of(context).create_basic_profile,
                      style: const TextStyle(
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .05, vertical: 2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S.of(context).password,
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
                      hintText: S.of(context).password,
                      icon: Icons.lock_open_outlined,
                      obscureText: true,
                      controller: passwordController,
                    ),
                    //or continue with
                    const MyDivider(),
                    const SocialMedia(),
                    SizedBox(
                      height: screenHeight * .01,
                    ),
                    Text(
                      S.of(context).forgot_password,
                      style: const TextStyle(
                        color: Color(0xFF1B262C),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomSheetContainer(
              buttonText: S.of(context).sign_up,
              onPressed: () {
                signUserUp();
              },
            )
          ],
        ),
      ),
    );
  }

  void signUserUp() async {
    await FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmail(
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }
}
