import 'package:easypedv3/models/surgery_referral.dart';
import 'package:easypedv3/widgets/title_value.dart';
import 'package:flutter/material.dart';

class SurgeryReferralWidget extends StatelessWidget {
  final SurgeryReferral surgeryReferral;

  const SurgeryReferralWidget({Key? key, required this.surgeryReferral})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      style: Theme.of(context).textTheme.headline6),
                  (surgeryReferral.referral!.isNotEmpty
                      ? ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: surgeryReferral.referral!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text("- " + surgeryReferral.referral![index],
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context).textTheme.bodyText1);
                          })
                      : Text("Sem informação",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.bodyText1))
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
                      style: Theme.of(context).textTheme.headline6),
                  (surgeryReferral.observations!.isNotEmpty
                      ? ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: surgeryReferral.observations!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                                "- " + surgeryReferral.observations![index],
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context).textTheme.bodyText1);
                          })
                      : Text("Sem informação",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.bodyText1))
                ])),

        // Text("Observações",
        //     textAlign: TextAlign.left,
        //     overflow: TextOverflow.clip,
        //     style: Theme.of(context).textTheme.headline6),
        // ListView.builder(
        //     padding: const EdgeInsets.all(8),
        //     itemCount: surgeryReferral.observations!.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return Text(surgeryReferral.observations![index]);
        //       // return Container(
        //       //   height: 50,
        //       //   child:
        //       //       Center(child: Text(surgeryReferral.observations![index])),
        //       // );
        //     }),
      ],
    ));
  }
}
