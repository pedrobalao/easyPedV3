import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/screens/drugs/drugs_screen.dart';
import 'package:easypedv3/widgets/congresses_slide.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:easypedv3/widgets/menu.dart';
import 'package:easypedv3/widgets/news_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'A informação presente no easyPed pode conter erros e destina-se exclusivamente para fins educacionais. Não nos responsabilizamos por qualquer consequência do uso da mesma. Toda a informação deve ser validada pelo médico.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Li e Concordo'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showedDisclaimer = ref.watch(showedDisclaimerProvider);

    if (!showedDisclaimer) {
      Future.delayed(Duration.zero, () => _showMyDialog(context));
      ref.read(showedDisclaimerProvider.notifier).state = true;
    }

    final newsAsync = ref.watch(newsProvider);
    final congressesAsync = ref.watch(congressProvider);

    return newsAsync.when(
      loading: () => const ScreenLoading(title: 'easyPed'),
      error: (_, __) => const ConnectionError(),
      data: (news) => congressesAsync.when(
        loading: () => const ScreenLoading(title: 'easyPed'),
        error: (_, __) => const ConnectionError(),
        data: (congresses) => Scaffold(
            appBar: AppBar(title: const Text('easyPed'), actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: DrugSearchDelegate(),
                    );
                  })
            ]),
            drawer: const Menu(),
            body: SingleChildScrollView(
              child: Column(children: [
                ListTile(
                  tileColor: const Color(0xFF28a745),
                  title: Text('Congressos',
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
                const Gap(5),
                CongressesSlide(congresses: congresses),
                const Gap(10),
                ListTile(
                  tileColor: const Color(0xFF28a745),
                  title: Text('Novidades',
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
                const Gap(5),
                NewsSlide(news: news),
                const Gap(10),
              ]),
            )),
      ),
    );
  }
}
