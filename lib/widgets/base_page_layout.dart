import 'package:flutter/material.dart';

class BasePageLayout extends StatelessWidget {
  const BasePageLayout({Key? key, required this.children}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children)));
  }
}
