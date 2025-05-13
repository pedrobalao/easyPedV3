import 'package:easypedv3/models/surgery_referral.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../../widgets/base_page_layout.dart';
import '../../widgets/title_value.dart';

class SurgeryReferralScreen extends StatelessWidget {
  final SurgeryReferral surgeryReferral;

  const SurgeryReferralScreen({Key? key, required this.surgeryReferral})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logViewItem(items: [
      AnalyticsEventItem(
          itemCategory: "surgery_referral", itemName: surgeryReferral.scope)
    ]);

    return Scaffold(
        appBar:
            AppBar(centerTitle: true, title: Text(surgeryReferral.scope ?? "")),
        body: BasePageLayout(children: [
          SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleValue(
                  title: "Cirurgia",
                  value: surgeryReferral.scope ?? "Sem informação"),
              Container(
                  padding: const EdgeInsets.all(5.5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Referenciação",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.titleLarge),
                        (surgeryReferral.referral!.isNotEmpty
                            ? ListView.builder(
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: surgeryReferral.referral!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Text(
                                      "- ${surgeryReferral.referral![index]}",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge);
                                })
                            : Text("Sem informação",
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context).textTheme.bodyLarge))
                      ])),
              Container(
                  padding: const EdgeInsets.all(5.5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Observações",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.titleLarge),
                        (surgeryReferral.observations!.isNotEmpty
                            ? ListView.builder(
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: surgeryReferral.observations!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Text(
                                      "- ${surgeryReferral.observations![index]}",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge);
                                })
                            : Text("Sem informação",
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context).textTheme.bodyLarge))
                      ])),
            ],
          ))
        ]));
  }
}
