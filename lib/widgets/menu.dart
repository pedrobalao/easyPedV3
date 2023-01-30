import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class _Menu {
  _Menu({required this.title, required this.icon, required this.route});

  final String title;
  final Icon icon;
  //final Widget action;
  final String route;
}

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  List<_Menu> _menus() {
    return [
      _Menu(
          title: "Medicamentos",
          icon: const Icon(Icons.polyline_outlined),
          route: "/drugs"),
      _Menu(
          title: "Doenças",
          icon: const Icon(Icons.coronavirus),
          route: "/diseases"),
      _Menu(
          title: "Percentis",
          icon: const Icon(Icons.percent),
          route: "/percentiles"),
      _Menu(
          title: "Calculos Médicos",
          icon: const Icon(Icons.calculate),
          route: "/medical-calculations"),
      _Menu(
          title: "Referenciação Cirúrgica",
          icon: const Icon(Icons.meeting_room),
          route: "/surgeries-referral"),
      _Menu(
          title: "Sobre",
          icon: const Icon(Icons.app_shortcut),
          route: "/drugs"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    var header = UserAccountsDrawerHeader(
      // <-- SEE HERE

      decoration: const BoxDecoration(color: Color(0xFF218838)),
      accountName: Text(
        user!.displayName!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        user.email!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(user.photoURL!),
        backgroundColor: Colors.transparent,
      ),
    );
    var widgets = <Widget>[];
    widgets.add(header);

    for (var item in _menus()) {
      widgets.add(ListTile(
        leading: item.icon,
        title: Text(item.title),
        onTap: () {
          Navigator.pushNamed(context, item.route);
        },
      ));
    }

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: widgets,
      ),
    );
  }
}
