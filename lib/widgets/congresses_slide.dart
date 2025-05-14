import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../models/congress.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class CongressesSlide extends StatelessWidget {
  const CongressesSlide({Key? key, required this.congresses}) : super(key: key);

  final List<Congress> congresses;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
            children: congresses
                .map((item) => CongressScreen(congress: item))
                .toList()));
  }
}

class CongressScreen extends StatelessWidget {
  Congress congress;
  CongressScreen({super.key, required this.congress});

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    final DateFormat formatter = DateFormat('yMMMMd');
    //DateFormat('pt_PT');

    Future<void> _launchUrl(Congress congress) async {
      FirebaseAnalytics.instance.logSelectItem(items: [
        AnalyticsEventItem(
            itemCategory: "congress_open",
            itemId: congress.id.toString(),
            itemName: congress.title)
      ]);
      if (!await launchUrl(Uri.parse(congress.url!))) {
        throw Exception('Could not launch $congress.url');
      }
    }

    return GestureDetector(
        onTap: () {
          print("Container was tapped");
          _launchUrl(congress);
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
              Text(
                congress.beginDate == congress.endDate
                    ? formatter.format(congress.beginDate!)
                    : "${formatter.format(congress.beginDate!)} - ${formatter.format(congress.endDate!)}",
                style: Styles.headLineStyle5.copyWith(color: Colors.white),
              ),
              const Gap(8),
              Container(
                height: AppLayout.getHeight(180),
                decoration: BoxDecoration(
                    color: Styles.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(congress.coverUrl!))),
              ),
              const Gap(10),
              Text(
                "${congress.city!} - ${congress.country!}",
                style: Styles.headLineStyle4.copyWith(color: Colors.white),
              ),
              const Gap(5),
              Text(
                congress.title!,
                style: Styles.headLineStyle3.copyWith(color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
