import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../core/utils/widgets/pop_app_bar.dart';
import '../../../generated/l10n.dart';
import '../../../models/player.dart';
import '../../Featured/create_profile/widgets/profile_image.dart';
import '../widgets/group_player_card.dart';
import 'groups_screen.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<String> selectedMemberIds = [];
  List<Player> members = [];
  String groupName = '';
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();
    fetchClubMembers();
  }

  void fetchClubMembers() async {
    Method method = Method();
    Player player = await method.getCurrentUser();
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('clubs')
        .doc(player.participatedClubId)
        .get();
    if (snapshot.exists) {
      List<String> memberIds = List<String>.from(snapshot.data()!['memberIds']);

      List<Player> fetchedMembers =
          await Future.wait(memberIds.map((memberId) async {
        DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
            await FirebaseFirestore.instance
                .collection('players')
                .doc(memberId)
                .get();
        return Player.fromSnapshot(playerSnapshot);
      }));

      setState(() {
        members = fetchedMembers;
      });
    }
  }

  void _toggleMemberSelection(String memberId) {
    setState(() {
      if (selectedMemberIds.contains(memberId)) {
        selectedMemberIds.remove(memberId);
      } else {
        selectedMemberIds.add(memberId);
      }
    });
  }

  void _createGroupChat() async {
    // Implement the logic to create a group chat
    if (selectedMemberIds.isNotEmpty) {
      Method method = Method();
      Player currentUser = await method.getCurrentUser();

      List<String> participantIds = List.from(selectedMemberIds);
      participantIds
          .add(currentUser.playerId); // Include current user in participants

      // Create a new group chat document in Firestore
      DocumentReference groupChatRef =
          await FirebaseFirestore.instance.collection('group_chats').add({
        'participants': participantIds,
        'createdBy': currentUser.playerId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('group_chats')
          .child(groupChatRef.id)
          .child('group-image.jpg');

      firebase_storage.UploadTask uploadTask =
          storageReference.putData(_selectedImageBytes!);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Update the club document with the image URL
      await groupChatRef.update({'group': imageUrl});
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupChatScreen(groupId: groupChatRef.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PoPAppBarWave(
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
            text: S.of(context).select_players,
            suffixIconPath: '',
          ),
          ProfileImage(
            onImageSelected: (File imageFile) {
              _selectedImageBytes = imageFile.readAsBytesSync();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final isSelected = selectedMemberIds.contains(member.playerId);

                return ListTile(
                  subtitle: GroupPlayerCard(
                    player: member,
                  ),
                  leading: Checkbox(
                    activeColor: const Color.fromARGB(255, 34, 47, 53),
                    value: isSelected,
                    onChanged: (value) =>
                        _toggleMemberSelection(member.playerId),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 34, 47, 53),
        onPressed: _createGroupChat,
        child: Icon(
          Icons.check,
        ),
      ),
    );
  }
}
