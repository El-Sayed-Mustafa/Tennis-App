import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/utils/snackbar.dart';
import '../../generated/l10n.dart';
import '../services/auth_methods.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      emit(AuthLoadingState());
      await FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
        email: email,
        password: password,
        context: context,
      );
      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      emit(AuthErrorState(e.message.toString()));
    }
  }

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      emit(AuthLoadingState());

      // await sendEmailVerification(context);

      await FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmail(
        email: email,
        password: password,
        context: context,
      );
      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        showSnackBar(context, S.of(context).weak_password);
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, S.of(context).account_already_exists);
      }
      showSnackBar(
          context, e.message!); // Displaying the usual firebase error message
      emit(AuthErrorState(e.message.toString()));
    }
  }
}
