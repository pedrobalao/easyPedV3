import 'package:easypedv3/services/app_info_service.dart';
import 'package:easypedv3/utils/app_styles.dart';
import 'package:easypedv3/widgets/signin.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EPSignScreen extends StatelessWidget {
  const EPSignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double elementsOpacity = 1;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
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
                          'easyPed',
                          style: Styles.title(context),
                        ),
                        Text(
                          '#makinghealthcareeasier',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(150),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [SignIn()],
                      ),
                    ),
                    const SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                          child: Text(
                        'Made with ❤️ in Porto',
                        textAlign: TextAlign.center,
                        style: Styles.noteStyle(context),
                      )),
                    ),
                    const Gap(10),
                    Center(
                        child: Text(
                            'v${AppInfoService.packageInfo!.version} build ${AppInfoService.packageInfo!.buildNumber}',
                            style: Styles.normalText(context))),
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
