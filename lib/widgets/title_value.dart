import 'package:flutter/material.dart';

class TitleValue extends StatelessWidget {
  const TitleValue({Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

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
                  style: Theme.of(context).textTheme.headline6),
              Text(value,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyText1),
              // Expanded(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Colors.deepPurpleAccent,
              //     ),
              //   ),
              // ),
            ]));
  }
}
