import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:tennis_app/core/methodes/roles_manager.dart';
import 'package:tennis_app/core/utils/widgets/photot_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tennis_app/core/utils/widgets/single_result_dialog.dart';
import 'package:tennis_app/generated/l10n.dart';
import '../../../models/single_match.dart';
import '../../../models/player.dart';
import '../../methodes/firebase_methodes.dart';

class SingleMatchCard extends StatefulWidget {
  final SingleMatch match;
  final String? tournamentId;

  SingleMatchCard({Key? key, required this.match, this.tournamentId})
      : super(key: key);

  @override
  State<SingleMatchCard> createState() => _SingleMatchCardState();
}

class _SingleMatchCardState extends State<SingleMatchCard> {
  Method method = Method();
  String? _selectedWinner1;

  Future<Player?> fetchPlayer(String playerId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(playerId)
              .get();
      if (playerSnapshot.exists) {
        return Player.fromSnapshot(playerSnapshot);
      }
    } catch (e) {
      SnackBar(
          content: Text('${S.of(context).Error_fetching_player_data}: $e'));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<List<Player?>>(
      future: Future.wait([
        fetchPlayer(widget.match.player1Id),
        fetchPlayer(widget.match.player2Id)
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.length < 2) {
          return Text(S.of(context).ErrorLoadingPlayerData);
        } else {
          final player1 = snapshot.data![0]!;
          final player2 = snapshot.data![1]!;

          // Format date and time
          final formattedTime =
              DateFormat('hh:mm a').format(widget.match.startTime);
          final formattedDate =
              DateFormat('dd/MM/yyyy').format(widget.match.startTime);
          String result =
              widget.match.result; // Use an empty string if result is null
          List<String> lines = result.split('\n');

// Initialize variables to store the score values
          List<String> teamAScores = ['', '', '', '', ''];
          List<String> teamBScores = ['', '', '', '', ''];

          for (int i = 0; i < lines.length && i < 5; i++) {
            List<String> parts = lines[i].trim().split(':');
            if (parts.length == 2) {
              teamAScores[i] = parts[0].trim();
              teamBScores[i] = parts[1].trim();
            }
          }
          return GestureDetector(
            onTap: () async {
              bool hasRight = await RolesManager.instance
                  .doesPlayerHaveRight('Enter Results');
              if (hasRight) {
                // ignore: use_build_context_synchronously
                showWinnerDialog(
                    method, context, widget.match, widget.tournamentId);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight * .3,
                  padding: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF3ADAB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(31),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(S.of(context).PlayerA,
                                    style: TextStyle(
                                      color: const Color(0xFF2A2A2A),
                                      fontSize: 16.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    )),
                                const SizedBox(height: 10),
                                PhotoPlayer(url: player1.photoURL!),
                                const SizedBox(height: 7),
                                SizedBox(
                                  width: screenWidth * 0.18,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      player1.playerName,
                                      style: const TextStyle(
                                        color: Color(0xFF2A2A2A),
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ), // Display player1's name
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedWinner1 ?? widget.match.winner,
                                  style: TextStyle(
                                    color: const Color(0xFF00344E),
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(6.0.h),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child:
                                        Image.asset('assets/images/versus.png'),
                                  ),
                                ),
                                Text(
                                  '$formattedTime\n$formattedDate',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF00344E),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(S.of(context).PlayerB,
                                    style: const TextStyle(
                                      color: Color(0xFF2A2A2A),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    )),
                                const SizedBox(height: 10),
                                PhotoPlayer(url: player2.photoURL!),
                                const SizedBox(height: 7),
                                SizedBox(
                                  width: screenWidth * 0.18,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      player2.playerName,
                                      style: const TextStyle(
                                        color: Color(0xFF2A2A2A),
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ), // Display player2's name
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 50,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.33,
                            enableInfiniteScroll: false,
                            initialPage: 1,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: List.generate(
                            5,
                            (index) {
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color:
                                        const Color.fromARGB(255, 34, 47, 53),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          ' ${S.of(context).Shot} ${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              teamAScores[index],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Text(
                                              '  :  ',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              teamBScores[index],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
