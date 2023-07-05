import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/snackbar.dart';
import '../../../core/utils/widgets/custom_button.dart';
import '../../../core/utils/widgets/dialog_prograss_indecator.dart';
import '../../../generated/l10n.dart';
import '../../cubit/auth_cubit.dart';
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
    final authCubit = context.read<AuthCubit>();
    void signUserIn() async {
      authCubit.loginWithEmail(
          email: emailController.text,
          password: passwordController.text,
          context: context);
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AuthErrorState) {
          showSnackBar(context, state.error); // Displaying the error message
        }
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
                          S.of(context).sign_in_to_profile,
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
                          controller: passwordController,
                          hintText: S.of(context).password,
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
                          child: Text(
                            S.of(context).forgot_password,
                            style: const TextStyle(
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
                  buttonText: S.of(context).sign_in,
                  onPressed: () {
                    signUserIn();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
