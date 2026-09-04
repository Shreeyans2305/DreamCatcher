import 'package:flutter/material.dart';
import '../core/widgets/floating_bottom_nav.dart';
import '../l10n/app_localizations.dart';
import 'chat/chat_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'opportunities/opportunity_finder_screen.dart';
import 'profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  final int initialTab;

  const MainShell({super.key, this.initialTab = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screens = [
      DashboardScreen(
        onNavigateToOpportunities: () => _onTabSelected(1),
        onNavigateToChat: () => _onTabSelected(2),
        onNavigateToProfile: () => _onTabSelected(3),
      ),
      const OpportunityFinderScreen(),
      const ChatScreen(),
      const ProfileScreen(),
    ];

    final navItems = [
      FloatingNavItem(icon: Icons.home_rounded, label: l10n.navDashboard),
      FloatingNavItem(icon: Icons.explore_rounded, label: l10n.navOpportunities),
      FloatingNavItem(icon: Icons.chat_bubble_rounded, label: l10n.navChat),
      FloatingNavItem(icon: Icons.person_rounded, label: l10n.navProfile),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingBottomNav(
              currentIndex: _currentIndex,
              onTap: _onTabSelected,
              items: navItems,
            ),
          ),
        ],
      ),
    );
  }
}
