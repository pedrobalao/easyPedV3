import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── ProFeatureGate ────────────────────────────────────────────────────

/// Wraps a premium feature [child].
///
/// Pro users see [child] directly. Free users see a card with a lock icon,
/// the [featureName] description, and an upgrade button that navigates to
/// `/subscription`.
class ProFeatureGate extends ConsumerWidget {
  const ProFeatureGate({
    required this.child,
    super.key,
    this.featureName,
    this.featureKey,
  });

  /// The premium content shown to Pro users.
  final Widget child;

  /// Display name of the feature shown in the upgrade prompt (optional).
  final String? featureName;

  /// Short snake_case key used for analytics (e.g. `ai_chat`, `growth_charts`).
  final String? featureKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProAsync = ref.watch(isProProvider);

    return isProAsync.when(
      data: (isPro) {
        if (isPro) return child;
        return _UpgradePrompt(featureName: featureName, featureKey: featureKey);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) =>
          _UpgradePrompt(featureName: featureName, featureKey: featureKey),
    );
  }
}

// ── Upgrade prompt ────────────────────────────────────────────────────

class _UpgradePrompt extends StatefulWidget {
  const _UpgradePrompt({this.featureName, this.featureKey});

  final String? featureName;
  final String? featureKey;

  @override
  State<_UpgradePrompt> createState() => _UpgradePromptState();
}

class _UpgradePromptState extends State<_UpgradePrompt> {
  @override
  void initState() {
    super.initState();
    // Log the feature_gate_hit event once when the prompt is first shown.
    if (widget.featureKey != null) {
      AnalyticsService.logFeatureGateHit(feature: widget.featureKey!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 32,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.featureName != null
                    ? '${widget.featureName} é uma funcionalidade Pro'
                    : 'Funcionalidade Pro',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Atualize para easyPed Pro para aceder a esta funcionalidade.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.push('/subscription'),
                icon: const Icon(Icons.workspace_premium, size: 18),
                label: const Text('Atualizar para Pro'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── ProBadge ──────────────────────────────────────────────────────────

/// A small 'PRO' chip used to mark premium features in lists or menus.
class ProBadge extends StatelessWidget {
  const ProBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'PRO',
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── WidgetRef extension ───────────────────────────────────────────────

/// Convenience extension for quick inline pro-status checks.
///
/// ```dart
/// if (ref.isPro) { /* show premium content */ }
/// ```
extension ProRef on WidgetRef {
  /// Returns the current pro-status synchronously from the provider cache.
  /// Defaults to `false` while loading or on error.
  bool get isPro => watch(isProProvider).value ?? false;
}
