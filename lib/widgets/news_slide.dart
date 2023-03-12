import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';

class NewsSlide extends StatelessWidget {
  const NewsSlide({Key? key, required this.news}) : super(key: key);

  final List<News> news;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        child:
            Row(children: news.map((item) => NewsScreen(news: item)).toList()));
  }
}

class NewsScreen extends StatelessWidget {
  News news;
  NewsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl(url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return GestureDetector(
        onTap: () {
          _launchUrl(Uri.parse(news.url!));
        },
        child: Container(
          width: 300,
          height: 340,
          padding: EdgeInsets.symmetric(
              horizontal: AppLayout.getWidth(10),
              vertical: AppLayout.getHeight(10)),
          margin: EdgeInsets.only(
              right: AppLayout.getWidth(17), top: AppLayout.getHeight(5)),
          decoration: BoxDecoration(
              color: Styles.primaryColor,
              borderRadius: BorderRadius.circular(15),
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
