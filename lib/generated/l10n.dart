// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign in to your profile`
  String get sign_in_to_profile {
    return Intl.message(
      'Sign in to your profile',
      name: 'sign_in_to_profile',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email_address {
    return Intl.message(
      'Email Address',
      name: 'email_address',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgot_password {
    return Intl.message(
      'Forgot your password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `SIGN IN`
  String get sign_in {
    return Intl.message(
      'SIGN IN',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Create your Basic Profile`
  String get create_basic_profile {
    return Intl.message(
      'Create your Basic Profile',
      name: 'create_basic_profile',
      desc: '',
      args: [],
    );
  }

  /// `SIGN UP`
  String get sign_up {
    return Intl.message(
      'SIGN UP',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email`
  String get enter_email {
    return Intl.message(
      'Enter Your Email',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `The password provided is too weak.`
  String get weak_password {
    return Intl.message(
      'The password provided is too weak.',
      name: 'weak_password',
      desc: '',
      args: [],
    );
  }

  /// `The account already exists for that email.`
  String get account_already_exists {
    return Intl.message(
      'The account already exists for that email.',
      name: 'account_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Email verification sent!`
  String get email_verification_sent {
    return Intl.message(
      'Email verification sent!',
      name: 'email_verification_sent',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign-In: No user selected`
  String get google_signin_no_user {
    return Intl.message(
      'Google Sign-In: No user selected',
      name: 'google_signin_no_user',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign-In: Failed to authenticate user`
  String get google_signin_failed {
    return Intl.message(
      'Google Sign-In: Failed to authenticate user',
      name: 'google_signin_failed',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign-In: Unexpected error occurred`
  String get google_signin_unexpected_error {
    return Intl.message(
      'Google Sign-In: Unexpected error occurred',
      name: 'google_signin_unexpected_error',
      desc: '',
      args: [],
    );
  }

  /// `Password reset email sent`
  String get password_reset_email_sent {
    return Intl.message(
      'Password reset email sent',
      name: 'password_reset_email_sent',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send password reset email`
  String get failed_send_password_reset_email {
    return Intl.message(
      'Failed to send password reset email',
      name: 'failed_send_password_reset_email',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Create Your Profile`
  String get onboarding_header1 {
    return Intl.message(
      'Create Your Profile',
      name: 'onboarding_header1',
      desc: '',
      args: [],
    );
  }

  /// `Court Booking`
  String get onboarding_header2 {
    return Intl.message(
      'Court Booking',
      name: 'onboarding_header2',
      desc: '',
      args: [],
    );
  }

  /// `Match Making`
  String get onboarding_header3 {
    return Intl.message(
      'Match Making',
      name: 'onboarding_header3',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get onboarding_header4 {
    return Intl.message(
      'Notifications',
      name: 'onboarding_header4',
      desc: '',
      args: [],
    );
  }

  /// `Each club member can create an\nindividual profile and include\ninformation about their strength \n and playing type.`
  String get onboarding_detail1 {
    return Intl.message(
      'Each club member can create an\nindividual profile and include\ninformation about their strength \n and playing type.',
      name: 'onboarding_detail1',
      desc: '',
      args: [],
    );
  }

  /// `This feature allows club members to\nreserve tennis courts. They can\nview free times and make \nbookings easily.`
  String get onboarding_detail2 {
    return Intl.message(
      'This feature allows club members to\nreserve tennis courts. They can\nview free times and make \nbookings easily.',
      name: 'onboarding_detail2',
      desc: '',
      args: [],
    );
  }

  /// `You can find players who are interested\nin playing at a specific time or\nhave a similar skill level\n as you.`
  String get onboarding_detail3 {
    return Intl.message(
      'You can find players who are interested\nin playing at a specific time or\nhave a similar skill level\n as you.',
      name: 'onboarding_detail3',
      desc: '',
      args: [],
    );
  }

  /// `You can access information regarding\nupcoming tournaments, events,\ngame updates, or important\nclub announcements.`
  String get onboarding_detail4 {
    return Intl.message(
      'You can access information regarding\nupcoming tournaments, events,\ngame updates, or important\nclub announcements.',
      name: 'onboarding_detail4',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de', countryCode: 'DE'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
