import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/utils/app_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  final List<String> authors = <String>[
    'Dr. Ruben Rocha - Pediatra',
    'Dra. Ana Reis Melo - Interna de Pediatria',
    'Dra. Claudia Teles Silva - Interna de Pediatria',
    'Dr. João Sarmento - Interno de Cardiologia Pediátrica',
    'Dra. Mariana Adrião - Interna de Pediatria',
    'Dra. Marta Rosário - Interna de Pediatria',
    'Dr. Ruben Pinheiro - Cirurgião Pediátrico',
    'Dra. Sofia Ferreira - Interna de Pediatria',
    'Dra. Sónia Silva - Interna de Pediatria'
  ];

  final List<String> biblio = <String>[
    'European medicines agency database. Acesso online. Ano 2016 - 2017.',
    'Takemoto CK, Hodding JH, Kraus, DM. Pediatric & Neonatal Dosage Handbook, 21st ed. Hudson, Ohio, Lexi-Comp, Inc. 2014.',
    'Prontuário terapêutico. Infarmed. Versão on-line. Acedida no ano 2016 - 2017.',
    'Formulário hospitalar nacional do medicamento. Infarmed. Versão on-line. Acedida no ano 2016 - 2017.',
    'Medscape drug database. Acesso online. Ano 2016 - 2017.',
    'Anjos R, Bandeira T, Marques JG. Formulário de Pediatria. 3 edição.',
  ];

  Widget authorsWdgt() {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: authors.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(authors[index], style: Styles.normalText(context));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider());
  }

  Widget biblioWdgt() {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: biblio.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(biblio[index], style: Styles.normalText(context));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider());
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(isProProvider).value ?? false;
    final customerInfoAsync = ref.watch(customerInfoProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(title: const Text('easyPed')),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Subscription section ──────────────────────────
            ListTile(
              tileColor: colorScheme.secondary,
              title: Text('Subscrição',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            _SubscriptionSection(
              isPro: isPro,
              customerInfoAsync: customerInfoAsync,
              onUpgrade: () => context.push('/subscription'),
              onRestore: _restorePurchases,
              onManage: _openManageSubscription,
            ),
            const Gap(5),

            ListTile(
              tileColor: colorScheme.secondary,
              title: Text('Segue-nos nas redes sociais',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            const Gap(5),
            Center(
                child: IconButton(
              iconSize: 50,
              icon: const Icon(Icons.facebook,
                  color: AppColors.facebookBlue, size: 50),
              onPressed: () {
                _launchUrl(Uri.parse('https://facebook.com/easyped'));
              },
            )),
            const Gap(5),
            ListTile(
              tileColor: colorScheme.secondary,
              title: Text('Autores',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            Padding(padding: const EdgeInsets.all(5), child: authorsWdgt()),
            ListTile(
              tileColor: colorScheme.secondary,
              title: Text('Isenção de Responsabilidade',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            Padding(
                padding: const EdgeInsetsDirectional.all(5),
                child: Column(children: [
                  Text(
                      'Esta aplicação é dirigida a profissionais de saúde. Pretende ser um auxilio à prática da medicina pediátrica. Todos os dados foram inseridos e validados por médicos do corpo clínico do Centro Materno Infantil do Norte e Centro Hospitalar São João. Embora envidemos todos os esforços razoáveis para garantir que as informações contidas na easyPed sejam corretas, esteja ciente de que as informações podem estar incompletas, imprecisas ou desatualizadas e não podem ser garantidas. Assim, está excluída a garantia ou responsabilidade de qualquer tipo. Os autores declinam qualquer responsabilidade na utilização da mesma, devendo qualquer dose ou indicação ser confirmada em documentos de referencia atualizados aquando da prescrição. Qualquer erro detectado pode e deve ser reportado através dos nossos canais de comunicação. Qualquer sugestão de adição de informação ou outra sugestão é bem-vinda.',
                      style: Styles.normalText(context)),
                  const Gap(1),
                ])),
            ListTile(
              tileColor: colorScheme.secondary,
              title: Text('Bibliografia essencial consultada',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            Padding(padding: const EdgeInsets.all(5), child: biblioWdgt()),
            const Gap(5),
            Center(
                child: Text(
                    'v${_packageInfo.version} build ${_packageInfo.buildNumber}',
                    style: Styles.normalText(context))),
            const Gap(5),
          ]),
        ));
  }

  // ── Subscription actions ─────────────────────────────────────────

  Future<void> _restorePurchases() async {
    try {
      final service = ref.read(subscriptionServiceProvider);
      final info = await service.restorePurchases();
      if (!mounted) return;

      final restored = info.entitlements.active.containsKey('pro');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(restored
              ? 'Compras restauradas! easyPed Pro ativo.'
              : 'Nenhuma compra anterior encontrada.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao restaurar compras: $e')),
      );
    }
  }

  Future<void> _openManageSubscription() async {
    final String url;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        url = 'https://apps.apple.com/account/subscriptions';
      case TargetPlatform.android:
        url = 'https://play.google.com/store/account/subscriptions';
      default:
        // Web and desktop: fall back to a generic web account URL.
        url = 'https://play.google.com/store/account/subscriptions';
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir $url')),
        );
      }
    }
  }
}

// ── Subscription section widget ──────────────────────────────────────

class _SubscriptionSection extends StatelessWidget {
  const _SubscriptionSection({
    required this.isPro,
    required this.customerInfoAsync,
    required this.onUpgrade,
    required this.onRestore,
    required this.onManage,
  });

  final bool isPro;
  final AsyncValue<CustomerInfo> customerInfoAsync;
  final VoidCallback onUpgrade;
  final VoidCallback onRestore;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isPro ? Icons.workspace_premium : Icons.person,
                    color: isPro ? colorScheme.primary : colorScheme.onSurface,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPro ? 'easyPed Pro' : 'easyPed Free',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (isPro)
                          _ProDetails(customerInfoAsync: customerInfoAsync),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isPro) ...[
                // Manage subscription
                OutlinedButton.icon(
                  onPressed: onManage,
                  icon: const Icon(Icons.settings, size: 18),
                  label: const Text('Gerir subscrição'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ] else ...[
                // Upgrade button
                FilledButton.icon(
                  onPressed: onUpgrade,
                  icon: const Icon(Icons.workspace_premium, size: 18),
                  label: const Text('Atualizar para Pro'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Restore purchases
                Center(
                  child: TextButton(
                    onPressed: onRestore,
                    child: const Text('Restaurar compras'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pro subscription details ─────────────────────────────────────────

class _ProDetails extends StatelessWidget {
  const _ProDetails({required this.customerInfoAsync});

  final AsyncValue<CustomerInfo> customerInfoAsync;

  @override
  Widget build(BuildContext context) {
    return customerInfoAsync.when(
      data: (info) {
        final proEntitlement = info.entitlements.active['pro'];
        if (proEntitlement == null) return const SizedBox.shrink();

        final expiryDate = proEntitlement.expirationDate;
        final id = (proEntitlement.productPlanIdentifier ??
                proEntitlement.productIdentifier)
            .toLowerCase();
        final planLabel = id.contains('annual') || id.contains('year')
            ? 'Plano Anual'
            : id.contains('month')
                ? 'Plano Mensal'
                : 'Ativo';

        var expiryLabel = '';
        if (expiryDate != null) {
          final date = DateTime.tryParse(expiryDate);
          if (date != null) {
            expiryLabel = ' · Renova a ${date.day}/${date.month}/${date.year}';
          }
        }

        return Text(
          '$planLabel$expiryLabel',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        );
      },
      loading: () => const SizedBox(
        height: 14,
        width: 14,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
