import 'package:easypedv3/models/news.dart';
import 'package:easypedv3/utils/app_layout.dart';
import 'package:easypedv3/utils/app_styles.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsSlide extends StatelessWidget {
  const NewsSlide({required this.news, super.key});

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
  NewsScreen({required this.news, super.key});
  News news;

  @override
  Widget build(BuildContext context) {
    Future<void> openNewsUrl(News news) async {
      FirebaseAnalytics.instance.logSelectItem(items: [
        AnalyticsEventItem(
            itemCategory: 'news_open',
            itemId: news.id.toString(),
            itemName: news.title)
      ]);
      if (!await launchUrl(Uri.parse(news.url!))) {
        throw Exception('Could not launch $news.url');
      }
    }

    return GestureDetector(
        onTap: () {
          openNewsUrl(news);
        },
        child: Container(
          width: 300,
          height: 340,
          padding: EdgeInsets.symmetric(
              horizontal: AppLayout.getWidth(context, 10),
              vertical: AppLayout.getHeight(context, 10)),
          margin: EdgeInsets.only(
              right: AppLayout.getWidth(context, 17),
              top: AppLayout.getHeight(context, 5)),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: AppLayout.getHeight(context, 180),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(news.coverUrl!))),
              ),
              const Gap(10),
              Text(
                news.title!,
                style: Styles.headLineStyle3.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              const Gap(5),
              Text(
                news.description!,
                style: Styles.headLineStyle4.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          ),
        ));
  }
}
