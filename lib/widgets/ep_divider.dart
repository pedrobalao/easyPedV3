import 'package:flutter/material.dart';

class EpDivider extends StatelessWidget {
  const EpDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.primary,
      thickness: 1,
      endIndent: 0,
    );
  }
}
