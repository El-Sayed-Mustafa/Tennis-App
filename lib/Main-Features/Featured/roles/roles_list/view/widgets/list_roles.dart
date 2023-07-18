import 'package:flutter/material.dart';

class ListRoles extends StatelessWidget {
  const ListRoles({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.blue, // Replace with your desired color
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                items[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
