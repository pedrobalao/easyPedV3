import 'package:easypedv3/models/surgery_referral.dart';
import 'package:flutter/material.dart';
import '../../widgets/base_page_layout.dart';
import '../../widgets/surgeries_referral.dart';

class SurgeryReferralScreen extends StatefulWidget {
  const SurgeryReferralScreen({Key? key, required this.surgeryReferral})
      : super(key: key);

  final SurgeryReferral surgeryReferral;
  @override
  _SurgeryReferralScreenState createState() => _SurgeryReferralScreenState();
}

class _SurgeryReferralScreenState extends State<SurgeryReferralScreen> {
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true, title: Text(widget.surgeryReferral.scope ?? "")),
      body: BasePageLayout(children: [
        SurgeryReferralWidget(surgeryReferral: widget.surgeryReferral)
      ]),
    );
  }
}
