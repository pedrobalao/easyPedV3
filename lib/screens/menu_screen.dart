import 'package:easypedv3/screens/medical_calculations/medical_calculations_list_screen.dart';
import 'package:flutter/material.dart';

import 'diseases/diseases_list_screen.dart';
import 'drugs/drugs_screen.dart';
import 'surgeries_referral/surgeries_referral_list_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  List<_Menu> _menus(BuildContext context) {
    return [
      _Menu(
          title: "Medicamentos",
          icon: const Icon(Icons.polyline_outlined),
          action: const DrugsScreen()),
      _Menu(
          title: "Doenças",
          icon: const Icon(Icons.coronavirus),
          action: const DiseasesListScreen()),
      _Menu(
          title: "Percentis",
          icon: const Icon(Icons.percent),
          action: const DrugsScreen()),
      _Menu(
          title: "Calculos Médicos",
          icon: const Icon(Icons.calculate),
          action: const MedicalCalculationsListScreen()),
      _Menu(
          title: "Referenciação Cirúrgica",
          icon: const Icon(Icons.meeting_room),
          action: const SurgeriesReferralListScreen()),
      _Menu(
          title: "Sobre",
          icon: const Icon(Icons.app_shortcut),
          action: const DrugsScreen()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      restorationId: 'grid_view_demo_grid_offset',
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 2,
      padding: const EdgeInsets.all(8),
      childAspectRatio: 1,
      children: _menus(context).map<Widget>((menu) {
        return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => menu.action),
              );
            },
            child: Card(
              child: Center(child: Text(menu.title)),
            ));
      }).toList(),
    );
  }
}

class _Menu {
  _Menu({required this.title, required this.icon, required this.action});

  final String title;
  final Icon icon;
  final Widget action;
}
