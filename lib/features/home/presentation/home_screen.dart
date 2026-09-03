import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/widgets/sensitivity_notice.dart';
import '../../../l10n/generated/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final simulatorState = ref.watch(networkSimulatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, size: 28),
            tooltip: l10n.navProfile,
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Greeting Header
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.chatInitialGreeting.split('.').first,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.appTagline,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Navigation Hub Cards (Large touch targets)
            _buildNavigationCard(
              context,
              title: l10n.navOpportunities,
              subtitle: l10n.opportunitiesSubtitle,
              icon: Icons.search_rounded,
              color: const Color(0xFF0D47A1),
              onTap: () => context.push('/opportunity_finder'),
            ),
            const SizedBox(height: 12),

            _buildNavigationCard(
              context,
              title: l10n.navChat,
              subtitle: l10n.chatSubtitle,
              icon: Icons.chat_bubble_outline_rounded,
              color: const Color(0xFF2E7D32),
              onTap: () => context.push('/chat'),
            ),
            const SizedBox(height: 12),

            _buildNavigationCard(
              context,
              title: l10n.navProfile,
              subtitle: l10n.profileSubtitle,
              icon: Icons.person_outline_rounded,
              color: const Color(0xFFE65100),
              onTap: () => context.push('/profile'),
            ),
            const SizedBox(height: 20),

            // Sensitivity Trust Notice
            const SensitivityNotice(),
            const SizedBox(height: 16),

            // Poor-Connectivity Simulator Debug Control
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFBDBDBD)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.network_check_rounded, color: Colors.indigo),
                        const SizedBox(width: 8),
                        Text(
                          l10n.networkSimulatorActive,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.networkSimulatorToggle, style: const TextStyle(fontSize: 14)),
                      subtitle: const Text('300 - 1500ms 2G/3G latency simulation', style: TextStyle(fontSize: 12)),
                      value: simulatorState.isEnabled,
                      onChanged: (val) {
                        ref.read(networkSimulatorProvider.notifier).toggleEnabled(val);
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.networkSimulatorFailToggle, style: const TextStyle(fontSize: 14)),
                      subtitle: const Text('Simulates complete internet drop / offline state', style: TextStyle(fontSize: 12)),
                      value: simulatorState.simulateFailure,
                      onChanged: (val) {
                        ref.read(networkSimulatorProvider.notifier).toggleSimulateFailure(val);
                      },
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

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
