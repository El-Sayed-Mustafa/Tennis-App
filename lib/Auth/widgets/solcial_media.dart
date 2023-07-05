import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Auth/services/auth_methods.dart';

class SocialMedia extends StatefulWidget {
  const SocialMedia({super.key});

  @override
  State<SocialMedia> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            iconSize: 70,
            onPressed: () {},
            icon: const Icon(
              Icons.facebook_rounded,
              color: Colors.blue,
            )),
        IconButton(
            iconSize: 70,
            onPressed: () {
              FirebaseAuthMethods(FirebaseAuth.instance)
                  .signInWithGoogle(context);
            },
            icon: Container(
              child: SvgPicture.asset(
                'assets/images/google.svg',
                height: 55,
              ),
            ))
      ],
    );
  }
}
