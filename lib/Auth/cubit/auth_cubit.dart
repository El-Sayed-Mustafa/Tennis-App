import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/utils/snackbar.dart';
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
}
