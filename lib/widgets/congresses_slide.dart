import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/congress.dart';
import '../services/drugs_service.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'loading.dart';

class CongressesSlide extends StatelessWidget {
  CongressesSlide({Key? key}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<Congress>> fetchCongresses() async {
    var ret = await _drugService
        .fetchCongresses(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Congress>>(
      future: fetchCongresses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                  children: snapshot.data!
                      .map((item) => CongressScreen(congress: item))
                      .toList()));
        } else {
          return const Loading();
        }
      },
    );
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

    Future<void> _launchUrl(url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return GestureDetector(
        onTap: () {
          print("Container was tapped");
          _launchUrl(Uri.parse(congress.url!));
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
