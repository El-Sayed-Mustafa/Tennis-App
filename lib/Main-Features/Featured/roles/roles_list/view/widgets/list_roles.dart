import 'package:flutter/material.dart';

class ListRoles extends StatelessWidget {
  const ListRoles({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      'Item 1',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 2',
      'Item 3',
      'Item 4',
    ];

    final List<Color> colors = [
      Color(0x5172B8FF),
      Color(0x51EE746C),
      Color(0x51FFA372),
    ];

    final List<IconData> icons = [
      Icons.person_add_alt,
      Icons.personal_injury_outlined,
      Icons.switch_access_shortcut_add_outlined,
      Icons.add_task_sharp,
      Icons.transfer_within_a_station_sharp,
      Icons.transcribe_sharp,
      Icons.change_circle_rounded,
    ];

    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final color = colors[index % colors.length];
          final icon = icons[index % icons.length];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Container(
              decoration: ShapeDecoration(
                color: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      icon,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    items[index],
                    style: TextStyle(
                      color: Color(0xFF15324F),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
