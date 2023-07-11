import 'package:flutter/material.dart';

class ClubTypeInput extends StatefulWidget {
  const ClubTypeInput({Key? key}) : super(key: key);

  @override
  _ClubTypeInputState createState() => _ClubTypeInputState();
}

class _ClubTypeInputState extends State<ClubTypeInput> {
  String _selectedOption = 'private';
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = _selectedOption;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 2.0, left: screenWidth * .055),
            child: const Text(
              'Club Type',
              style: TextStyle(
                color: Color(0xFF525252),
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: screenWidth * .8,
            height: screenHeight * .05,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0x300A557F)),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 20.0), // Adjust the width as needed
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            controller: _textEditingController,
                            readOnly: true,
                            onTap: () {
                              _showOptionsPopupMenu(context);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeight * .018),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showOptionsPopupMenu(context);
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsPopupMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final List<String> options = ['Private', 'Public'];

    showMenu<String>(
      context: context,
      position: position,
      items: options.map((String option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(
            option,
            style: TextStyle(
              color: Color.fromARGB(255, 82, 82, 82),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedOption = value;
          _textEditingController.text = _selectedOption;
        });
      }
    });
  }
}
