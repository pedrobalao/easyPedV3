import 'package:easypedv3/utils/app_styles.dart';
import 'package:easypedv3/widgets/signin.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../services/app_info_service.dart';

class EPSignScreen extends StatelessWidget {
  const EPSignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double elementsOpacity = 1;

    return Scaffold(
      backgroundColor: Styles.primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween(begin: 1, end: elementsOpacity),
                  builder: (_, value, __) => Opacity(
                    opacity: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        Text(
                          "easyPed",
                          style: Styles.title,
                        ),
                        Text(
                          "#makinghealthcareeasier",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(150),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: const [SignIn()],
                      ),
                    ),
                    const SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                          child: Text(
                        'Made with ❤️ in Porto',
                        textAlign: TextAlign.center,
                        style: Styles.noteStyle,
                      )),
                    ),
                    const Gap(10),
                    Center(
                        child: Text(
                            "v${AppInfoService.packageInfo!.version} build ${AppInfoService.packageInfo!.buildNumber}",
                            style: Styles.normalText)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Styles.primaryColor,
//     body: Container(
//         alignment: Alignment.center,
//         child: Column(
//           //fit: StackFit.expand,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               "easyPed",
//               style: Styles.title,
//             ),
//             const SignIn()
//           ],
//         )),
//   );
// }
