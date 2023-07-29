import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tennis_app/Auth/cubit/auth_cubit.dart';
import 'package:tennis_app/core/utils/app_router.dart';
import 'package:tennis_app/core/utils/widgets/input_date.dart';

import 'Main-Features/Featured/create_club/view/widgets/Age_restriction.dart';
import 'Main-Features/Featured/create_club/view/widgets/club_type.dart';
import 'Main-Features/Featured/create_event/cubit/create_event_cubit.dart';
import 'Main-Features/Featured/create_event/view/widgets/player_level.dart';
import 'Main-Features/Featured/create_profile/cubits/Gender_Cubit.dart';
import 'Main-Features/Featured/create_profile/cubits/player_type_cubit.dart';
import 'Main-Features/Featured/create_profile/cubits/time_cubit.dart';
import 'core/utils/widgets/input_date_and_time.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // Default locale

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<GenderCubit>(
          create: (context) => GenderCubit(),
        ),
        BlocProvider(
          create: (context) => TimeCubit(),
        ),
        BlocProvider(
          create: (context) => DateCubit(),
        ),
        BlocProvider(
          create: (context) => PlayerTypeCubit(),
        ),
        BlocProvider(
          create: (context) => ClubTypeCubit(),
        ),
        BlocProvider(
          create: (context) => AgeRestrictionCubit(),
        ),
        BlocProvider(
          create: (context) => DateTimeCubit(),
        ),
        BlocProvider(
          create: (context) => CreateEventCubit(context),
        ),
        BlocProvider<SliderCubit>(create: (_) => SliderCubit()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        locale: _locale,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Color(0xFFF8F8F8),
        ),
      ),
    );
  }
}
