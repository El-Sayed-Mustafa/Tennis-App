import 'package:flutter/material.dart';

class RightSelector extends StatefulWidget {
  const RightSelector({super.key});

  @override
  _RightSelectorState createState() => _RightSelectorState();
}

class _RightSelectorState extends State<RightSelector> {
  List<String> words = [
    'Apple',
    'Banana',
    'Cherry',
    'Durian',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
    'Jackfruit',
  ];

  List<Color> wordColors = [
    Color(0x5172B8FF),
    Color(0x51EE746C),
    Color(0x51FFA372),
  ];

  List<String> selectedWords = [];
  bool isDropdownVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: selectedWords.map<Widget>((String word) {
                    return Container(
                      decoration: ShapeDecoration(
                        color: wordColors[
                            selectedWords.indexOf(word) % wordColors.length],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: Text(word),
                    );
                  }).toList(),
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: null,
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        if (selectedWords.contains(newValue)) {
                          selectedWords.remove(newValue);
                        } else {
                          selectedWords.add(newValue);
                        }
                      }
                    });
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                    size: 30,
                  ),
                  items: words.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
