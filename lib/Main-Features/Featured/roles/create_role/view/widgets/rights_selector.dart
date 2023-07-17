import 'package:flutter/material.dart';

class RightSelector extends StatefulWidget {
  const RightSelector({Key? key}) : super(key: key);

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
    const Color(0x5172B8FF),
    const Color(0x51EE746C),
    const Color(0x51FFA372),
  ];

  List<String> selectedWords = [];
  bool isDropdownVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 2.0, left: screenWidth * .055),
          child: const Text(
            'Rights',
            style: TextStyle(
              color: Color(0xFF525252),
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0x300A557F), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
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
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 4),
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
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF1B262C),
                    size: 30,
                  ),
                  items: words.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
