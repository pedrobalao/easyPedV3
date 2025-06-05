import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
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
      _Menu(title: "Home", icon: const Icon(Icons.home), route: "/"),
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
          route: "/about"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    print(user);

    var email = "your@email.com";
    var name = "user";
    var photoUrl = "";

    try {
      if (user!.providerData.isNotEmpty) {
        for (var provider in user.providerData) {
          if (provider.displayName != null &&
              provider.displayName!.isNotEmpty) {
            name = provider.displayName!;
          }
          if (provider.photoURL != null && provider.photoURL!.isNotEmpty) {
            photoUrl = provider.photoURL!;
          }
          if (provider.email != null && provider.email!.isNotEmpty) {
            email = provider.email!;
          }
        }
      } else {
        email = user.email!;
        name = user.displayName!;
        photoUrl = user.photoURL!;
      }
    } catch (exc) {}

    if (user == null) {
      return Container();
    }
    var header = UserAccountsDrawerHeader(
      // <-- SEE HERE

      decoration: const BoxDecoration(color: Color(0xFF218838)),
      accountName: Text(
        name, //user.displayName!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        email,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      currentAccountPicture: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(photoUrl),
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

    widgets.add(ListTile(
        leading: const Icon(Icons.logout),
        title: const Text("Sair"),
        onTap: () {
          FirebaseUIAuth.signOut(context: context);
        }));

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: widgets,
      ),
    );
  }
}
