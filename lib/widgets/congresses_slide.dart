import 'package:easypedv3/models/congress.dart';
import 'package:easypedv3/utils/app_layout.dart';
import 'package:easypedv3/utils/app_styles.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CongressesSlide extends StatelessWidget {
  const CongressesSlide({required this.congresses, super.key});

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
  CongressScreen({required this.congress, super.key});
  Congress congress;

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    final formatter = DateFormat('yMMMMd');
    //DateFormat('pt_PT');

    Future<void> openCongressUrl(Congress congress) async {
      FirebaseAnalytics.instance.logSelectItem(items: [
        AnalyticsEventItem(
            itemCategory: 'congress_open',
            itemId: congress.id.toString(),
            itemName: congress.title)
      ]);
      if (!await launchUrl(Uri.parse(congress.url!))) {
        throw Exception('Could not launch $congress.url');
      }
    }

    return GestureDetector(
        onTap: () {
          print('Container was tapped');
          openCongressUrl(congress);
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
              Text(
                congress.beginDate == congress.endDate
                    ? formatter.format(congress.beginDate!)
                    : '${formatter.format(congress.beginDate!)} - ${formatter.format(congress.endDate!)}',
                style: Styles.headLineStyle5.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              const Gap(8),
              Container(
                height: AppLayout.getHeight(context, 180),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(congress.coverUrl!))),
              ),
              const Gap(10),
              Text(
                '${congress.city!} - ${congress.country!}',
                style: Styles.headLineStyle4.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              const Gap(5),
              Text(
                congress.title!,
                style: Styles.headLineStyle3.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          ),
        ));
  }
}
