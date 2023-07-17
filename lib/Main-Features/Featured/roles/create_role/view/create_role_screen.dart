import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/Featured/roles/create_role/view/widgets/rights_selector.dart';

class CreateRole extends StatelessWidget {
  const CreateRole({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RightSelector(),
    );
  }
}
