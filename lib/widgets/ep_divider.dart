import 'package:flutter/material.dart';

class EpDivider extends StatelessWidget {
  const EpDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Color(0xFF2963C8),
      thickness: 1,
      endIndent: 0,
    );
  }
}
