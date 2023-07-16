import 'package:flutter/material.dart';

class WordSelector extends StatefulWidget {
  @override
  _WordSelectorState createState() => _WordSelectorState();
}

class _WordSelectorState extends State<WordSelector> {
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

  List<String> selectedWords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Selector'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Select words'),
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
                  items: words.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: selectedWords.map<Widget>((String word) {
                return Container(
                  decoration: ShapeDecoration(
                    color: Color(0x51EE746C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text(word),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: WordSelector()));
}
