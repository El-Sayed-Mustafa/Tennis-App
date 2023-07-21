import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../models/player.dart';
import 'package:intl/intl.dart';

class PlayerScreen extends StatelessWidget {
  final Player player;

  const PlayerScreen({required this.player, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: Column(
          children: [
            AppBarWaveHome(
              prefixIcon: IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              text: '    Management',
              suffixIconPath: '',
            ),
            SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: (screenHeight + screenWidth) * 0.025,
                        right: (screenHeight + screenWidth) * 0.025,
                        top: (screenHeight + screenWidth) * 0.05),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: (screenHeight + screenWidth) * 0.06,
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 0.50, color: Color(0x440D5FC3)),
                            borderRadius: BorderRadius.circular(31),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Text(
                                player.playerName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Skill level',
                                    style: TextStyle(
                                      color: Color(0xFF15324F),
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(player.skillLevel)
                                ],
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Membership',
                                    style: TextStyle(
                                      color: Color(0xFF15324F),
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(player.clubRoles['membership'] ?? '')
                                ],
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Player type',
                                    style: TextStyle(
                                      color: Color(0xFF15324F),
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(player.playerType)
                                ],
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Date',
                                    style: TextStyle(
                                      color: Color(0xFF15324F),
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(DateFormat('MMM d, yyyy')
                                      .format(player.birthDate))
                                ],
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Role',
                                    style: TextStyle(
                                      color: Color(0xFF15324F),
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(player.clubRoles['role'] ?? '')
                                ],
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center, // Center the photo

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          (screenHeight + screenWidth) * 0.08 / 5),
                      child: Container(
                        height: (screenHeight + screenWidth) * 0.1,
                        width: (screenHeight + screenWidth) * 0.08,
                        child: player.photoURL != null
                            ? Image.network(
                                player.photoURL!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/profileimage.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
