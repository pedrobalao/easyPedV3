import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Paywall / upgrade screen that presents easyPed Pro benefits and allows
/// users to subscribe via RevenueCat.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.source});

  /// Which feature triggered the paywall (used for analytics).
  final String? source;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  Package? _selectedPackage;
  bool _isPurchasing = false;
  bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    // Log paywall_viewed analytics event.
    AnalyticsService.logPaywallViewed(
      source: widget.source ?? 'unknown',
    );
  }

  // ── Purchase flow ──────────────────────────────────────────────────
  Future<void> _subscribe() async {
    if (_selectedPackage == null || _isPurchasing) return;

    final planName = _selectedPackage!.packageType == PackageType.annual
        ? 'yearly'
        : 'monthly';

    // Log purchase_started.
    AnalyticsService.logPurchaseStarted(plan: planName);

    setState(() => _isPurchasing = true);

    try {
      final service = ref.read(subscriptionServiceProvider);
      final customerInfo = await service.purchasePackage(_selectedPackage!);

      if (!mounted) return;

      if (customerInfo != null) {
        // Log purchase_completed.
        AnalyticsService.logPurchaseCompleted(
          plan: planName,
          price: _selectedPackage!.storeProduct.priceString,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscrição ativa com sucesso!')),
        );
        Navigator.of(context).pop();
      } else {
        // null means the user cancelled.
        AnalyticsService.logPurchaseCancelled();
      }
    } catch (e) {
      // Log purchase_failed.
      AnalyticsService.logPurchaseFailed(errorCode: e.toString());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao processar compra: $e')),
      );
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _restorePurchases() async {
    if (_isRestoring) return;

    // Log restore_purchases_tapped.
    AnalyticsService.logRestorePurchasesTapped();

    setState(() => _isRestoring = true);

    try {
      final service = ref.read(subscriptionServiceProvider);
      final customerInfo = await service.restorePurchases();

      if (!mounted) return;

      final isPro = customerInfo.entitlements.active.containsKey('pro');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isPro
                ? 'Compras restauradas! easyPed Pro ativo.'
                : 'Nenhuma compra anterior encontrada.',
          ),
        ),
      );

      if (isPro) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao restaurar compras: $e')),
      );
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir $url')),
        );
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final offeringsAsync = ref.watch(offeringsProvider);

    // Automatically select the annual plan (or monthly) when offerings load.
    ref.listen<AsyncValue<Offerings>>(offeringsProvider, (_, next) {
      if (_selectedPackage == null) {
        final offerings = next.valueOrNull;
        if (offerings != null) {
          final defaultPackage =
              offerings.current?.annual ?? offerings.current?.monthly;
          if (defaultPackage != null && mounted) {
            setState(() => _selectedPackage = defaultPackage);
          }
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('easyPed Pro'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              _Header(colorScheme: colorScheme),
              const SizedBox(height: 32),

              // ── Benefits list ──
              _BenefitsList(colorScheme: colorScheme),
              const SizedBox(height: 32),

              // ── Plan cards ──
              offeringsAsync.when(
                data: (offerings) {
                  final monthly = offerings.current?.monthly;
                  final annual = offerings.current?.annual;

                  if (monthly == null && annual == null) {
                    return const _OfferingsUnavailable();
                  }

                  return Column(
                    children: [
                      if (annual != null)
                        _PlanCard(
                          package: annual,
                          isSelected: _selectedPackage == annual,
                          badge: _annualSavings(monthly, annual),
                          onTap: () {
                            AnalyticsService.logPaywallPlanSelected(
                              plan: 'yearly',
                            );
                            setState(() => _selectedPackage = annual);
                          },
                        ),
                      if (annual != null && monthly != null)
                        const SizedBox(height: 12),
                      if (monthly != null)
                        _PlanCard(
                          package: monthly,
                          isSelected: _selectedPackage == monthly,
                          onTap: () {
                            AnalyticsService.logPaywallPlanSelected(
                              plan: 'monthly',
                            );
                            setState(() => _selectedPackage = monthly);
                          },
                        ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (_, __) => const _OfferingsUnavailable(),
              ),

              const SizedBox(height: 32),

              // ── Subscribe button ──
              FilledButton(
                onPressed: (_selectedPackage != null && !_isPurchasing)
                    ? _subscribe
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isPurchasing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Text(
                        'Subscrever',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              const SizedBox(height: 16),

              // ── Restore purchases ──
              Center(
                child: TextButton(
                  onPressed: _isRestoring ? null : _restorePurchases,
                  child: _isRestoring
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Restaurar compras'),
                ),
              ),

              const SizedBox(height: 8),

              // ── Terms & Privacy ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () =>
                        _launchUrl('https://easypedapp.com/terms'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      'Termos de Utilização',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Text(
                    '·',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        _launchUrl('https://easypedapp.com/privacy'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      'Política de Privacidade',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Calculates the savings label for the annual plan vs monthly.
  String? _annualSavings(Package? monthly, Package annual) {
    try {
      final monthlyPrice = monthly?.storeProduct.price;
      final annualPrice = annual.storeProduct.price;
      if (monthlyPrice == null || monthlyPrice == 0) return 'Melhor valor';

      final savings =
          ((1 - annualPrice / (monthlyPrice * 12)) * 100).round();
      if (savings <= 0) return 'Melhor valor';
      return 'Poupa $savings%';
    } catch (_) {
      return 'Melhor valor';
    }
  }
}

// ── Header ───────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.workspace_premium,
            size: 44,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'easyPed Pro',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'O seu assistente de pediatria sem limites',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Benefits list ─────────────────────────────────────────────────────

class _BenefitsList extends StatelessWidget {
  const _BenefitsList({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _benefits = <({IconData icon, String text})>[
    (icon: Icons.smart_toy_outlined, text: 'Assistente IA (perguntas ilimitadas)'),
    (icon: Icons.calculate_outlined, text: 'Calculador de doses ilimitado'),
    (icon: Icons.note_alt_outlined, text: 'Notas clínicas ilimitadas'),
    (icon: Icons.show_chart_outlined, text: 'Gráficos de crescimento'),
    (icon: Icons.block_outlined, text: 'Sem publicidade'),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incluído no Pro',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ..._benefits.map(
              (b) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(b.icon, size: 20, color: colorScheme.secondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        b.text,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Plan card ─────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.package,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final Package package;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  String get _label {
    switch (package.packageType) {
      case PackageType.annual:
        return 'Plano Anual';
      case PackageType.monthly:
        return 'Plano Mensal';
      case PackageType.weekly:
        return 'Plano Semanal';
      default:
        return package.storeProduct.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerLow,
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Selection indicator
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? colorScheme.primary : colorScheme.outline,
            ),
            const SizedBox(width: 16),

            // Plan name and price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    package.storeProduct.priceString,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),

            // Optional badge (e.g. "Melhor valor")
            if (badge != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    color: colorScheme.onSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Offerings unavailable ─────────────────────────────────────────────

class _OfferingsUnavailable extends StatelessWidget {
  const _OfferingsUnavailable();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'Planos não disponíveis de momento.\nVerifique a sua ligação à internet.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }
}
