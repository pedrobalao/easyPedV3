import 'package:flutter/material.dart';

class TitleValue extends StatelessWidget {
  const TitleValue({Key? key, required this.title, this.value})
      : super(key: key);

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
              value != null
                  ? Text(value!,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodyLarge)
                  : Container(),
            ]));
  }
}

class SubTitleValue extends StatelessWidget {
  const SubTitleValue({Key? key, required this.title, this.value})
      : super(key: key);

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
              value != null
                  ? Text(value!,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodyLarge)
                  : Container(),
            ]));
  }
}
