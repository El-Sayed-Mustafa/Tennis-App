import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Auth/screens/auth_screen.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/create_profile_screen.dart';
import 'package:tennis_app/Main-Features/Featured/navigation_bar/cubit/navigation_cubit.dart';
import 'package:tennis_app/Main-Features/Featured/navigation_bar/navigation_bar_screen.dart';
import 'package:tennis_app/Main-Features/Featured/onboarding/onboarding_screen.dart';
import 'package:tennis_app/Main-Features/Featured/splash/splash_screen.dart';
import 'package:tennis_app/Main-Features/menu/menu_screen.dart';

import '../../Auth/screens/forget_password.dart';
import '../../Main-Features/Featured/choose_club/choose_club_screen.dart';
import '../../Main-Features/Featured/create_club/view/create_club.dart';
import '../../Main-Features/Featured/create_event/view/create_event.dart';
import '../../Main-Features/Featured/localization/choose_language.dart';
import '../../Main-Features/Featured/roles/create_role/view/create_role_screen.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => NavigationCubit(),
            child: CreateRole(),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'home',
            builder: (BuildContext context, GoRouterState state) {
              return BlocProvider(
                create: (context) => NavigationCubit(),
                child: const NavigationBarScreen(),
              );
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
          GoRoute(
            path: 'createProfile',
            builder: (BuildContext context, GoRouterState state) {
              return CreateProfile();
            },
          ),
          GoRoute(
            path: 'createClub',
            builder: (BuildContext context, GoRouterState state) {
              return CreateClub();
            },
          ),
          GoRoute(
            path: 'createEvent',
            builder: (BuildContext context, GoRouterState state) {
              return CreateEvent();
            },
          ),
          GoRoute(
            path: 'menu',
            builder: (BuildContext context, GoRouterState state) {
              return MenuScreen();
            },
          ),
        ],
      ),
    ],
  );
}
