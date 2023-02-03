import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news.dart';
import '../services/drugs_service.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'loading.dart';

class NewsSlide extends StatelessWidget {
  NewsSlide({Key? key}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<News>> fetchNews() async {
    var ret = await _drugService
        .fetchNews(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>>(
      future: fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                  children: snapshot.data!
                      .map((item) => NewsScreen(news: item))
                      .toList()));
        } else {
          return const Loading();
        }
      },
    );
  }
}

class NewsScreen extends StatelessWidget {
  News news;
  NewsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    final DateFormat formatter = DateFormat('yMMMMd');
    //DateFormat('pt_PT');

    Future<void> _launchUrl(url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return GestureDetector(
        onTap: () {
          print("Container was tapped");
          _launchUrl(Uri.parse(news.url!));
        },
        child: Container(
          width: size.width * 0.8,
          height: AppLayout.getHeight(350),
          padding: EdgeInsets.symmetric(
              horizontal: AppLayout.getWidth(15),
              vertical: AppLayout.getHeight(17)),
          margin: EdgeInsets.only(
              right: AppLayout.getWidth(17), top: AppLayout.getHeight(5)),
          decoration: BoxDecoration(
              color: Styles.primaryColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 20,
                    spreadRadius: 5)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: AppLayout.getHeight(180),
                decoration: BoxDecoration(
                    color: Styles.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(news.coverUrl!))),
              ),
              const Gap(10),
              Text(
                news.title!,
                style: Styles.headLineStyle3.copyWith(color: Colors.white),
              ),
              const Gap(5),
              Text(
                news.description!,
                style: Styles.headLineStyle4.copyWith(color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
