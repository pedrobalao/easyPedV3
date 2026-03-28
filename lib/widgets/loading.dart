import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

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
  const ScreenLoading({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(title ?? 'Loading...')),
      body: Center(
        child: Lottie.asset('assets/lotties/loading.json'),
      ),
    );
  }
}
