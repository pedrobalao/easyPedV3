import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/lotties/loading.json'),
      // child: CircularProgressIndicator(
      //   backgroundColor: Colors.white,
      // ),
    );
  }
}

class ScreenLoading extends StatelessWidget {
  const ScreenLoading({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(title ?? "Loading...")),
      body: Center(
        child: Lottie.asset('assets/lotties/loading.json'),
      ),
    );
  }
}
