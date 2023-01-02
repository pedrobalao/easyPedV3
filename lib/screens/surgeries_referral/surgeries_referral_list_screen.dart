import 'package:flutter/material.dart';

import '../../widgets/base_page_layout.dart';
import '../../widgets/surgeries_referral_list.dart';

class SurgeriesReferralListScreen extends StatefulWidget {
  const SurgeriesReferralListScreen({Key? key}) : super(key: key);

  @override
  _SurgeriesReferralListScreenState createState() =>
      _SurgeriesReferralListScreenState();
}

class _SurgeriesReferralListScreenState
    extends State<SurgeriesReferralListScreen> {
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true, title: const Text("Referenciação Cirúrgica")),
      body: BasePageLayout(children: [SurgeriesReferralListWidget()]),
    );
  }
}
