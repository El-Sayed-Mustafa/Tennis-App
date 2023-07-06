import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Auth/screens/auth_screen.dart';
import 'package:tennis_app/Featured/home/home.dart';
import 'package:tennis_app/Featured/onboarding/onboarding_screen.dart';
import 'package:tennis_app/Featured/splash/splash_screen.dart';

import '../../Auth/screens/forget_password.dart';
import '../../Featured/choose_club/choose_club_screen.dart';
import '../../Featured/localization/choose_language.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const ChooseClub();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'home',
            builder: (BuildContext context, GoRouterState state) {
              return const HomeScreen();
            },
          ),
          GoRoute(
            path: 'onboarding',
            builder: (BuildContext context, GoRouterState state) {
              return const Onboarding();
            },
          ),
          GoRoute(
            path: 'languages',
            builder: (BuildContext context, GoRouterState state) {
              return const ChooseLanguage();
            },
          ),
          GoRoute(
            path: 'auth',
            builder: (BuildContext context, GoRouterState state) {
              return const AuthScreen();
            },
          ),
          GoRoute(
            path: 'forgetPassword',
            builder: (BuildContext context, GoRouterState state) {
              return const ForgetPassword();
            },
          ),
          GoRoute(
            path: 'chooseClub',
            builder: (BuildContext context, GoRouterState state) {
              return const ChooseClub();
            },
          ),
        ],
      ),
    ],
  );
}
