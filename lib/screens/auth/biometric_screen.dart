import 'package:easypedv3/providers/biometric_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Full-screen gate that prompts for biometric / device-credential auth.
class BiometricScreen extends ConsumerStatefulWidget {
  const BiometricScreen({super.key});

  @override
  ConsumerState<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends ConsumerState<BiometricScreen> {
  bool _isAuthenticating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Trigger auth prompt as soon as the screen appears.
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    final service = ref.read(biometricServiceProvider);
    final success = await service.authenticate();

    if (!mounted) return;

    if (success) {
      ref.read(biometricAuthenticatedProvider.notifier).state = true;
      context.go('/');
    } else {
      setState(() {
        _isAuthenticating = false;
        _errorMessage = 'Autenticação falhada. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(height: 24),
                Text(
                  'easyPed',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Autenticação necessária',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onPrimary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 32),
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onPrimary.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (!_isAuthenticating)
                  ElevatedButton.icon(
                    onPressed: _authenticate,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Autenticar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                  ),
                if (_isAuthenticating)
                  const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
