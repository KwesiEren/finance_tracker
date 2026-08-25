import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FusedBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  const FusedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      height: 72,
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primaryContainer,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      animationDuration: const Duration(milliseconds: 300),
      destinations: destinations.map((dest) {
        return NavigationDestination(
          icon: IconTheme(
            data: IconThemeData(
              size: 24,
              color: colorScheme.onSurfaceVariant,
            ),
            child: dest.icon,
          ),
          selectedIcon: IconTheme(
            data: IconThemeData(
              size: 24,
              color: colorScheme.primary,
            ),
            child: dest.icon,
          ),
          label: dest.label,
          tooltip: dest.tooltip ?? '',
        );
      }).toList(),
    );
  }
}