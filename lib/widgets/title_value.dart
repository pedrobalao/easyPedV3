import 'package:flutter/material.dart';

class TitleValue extends StatelessWidget {
  const TitleValue({required this.title, super.key, this.value});

  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.titleLarge),
              if (value != null) Text(value!,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodyLarge) else Container(),
            ]));
  }
}

class SubTitleValue extends StatelessWidget {
  const SubTitleValue({required this.title, super.key, this.value});

  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.displaySmall),
              if (value != null) Text(value!,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodyLarge) else Container(),
            ]));
  }
}
