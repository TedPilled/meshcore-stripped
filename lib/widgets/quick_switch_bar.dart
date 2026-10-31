import 'dart:ui';

import 'package:flutter/material.dart';
import '../l10n/l10n.dart';
import '../theme/mesh_theme.dart';

class QuickSwitchBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final int contactsUnreadCount;
  final int channelsUnreadCount;
  final bool highContrast;

  const QuickSwitchBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.contactsUnreadCount = 0,
    this.channelsUnreadCount = 0,
    this.highContrast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final labelStyle = theme.textTheme.labelMedium ?? const TextStyle();
    final background = highContrast ? MapPalette.panelDark : Colors.transparent;
    final selectedIconColor = highContrast
        ? MapPalette.textPrimary
        : colorScheme.onPrimary;
    final selectedLabelColor = highContrast
        ? MapPalette.textPrimary
        : colorScheme.onSurface;
    final unselectedColor = highContrast
        ? MapPalette.textSecondary
        : colorScheme.onSurfaceVariant;
    final indicator = highContrast ? MapPalette.selected : colorScheme.primary;

    final destinations = [
      NavigationDestination(
        icon: _buildIconWithBadge(
          context,
          const Icon(Icons.people_outline),
          contactsUnreadCount,
        ),
        selectedIcon: _buildIconWithBadge(
          context,
          const Icon(Icons.people),
          contactsUnreadCount,
        ),
        label: context.l10n.nav_contacts,
      ),
      NavigationDestination(
        icon: const Icon(Icons.cell_tower),
        selectedIcon: const Icon(Icons.cell_tower),
        label: context.l10n.listFilter_repeaters,
      ),
      const NavigationDestination(
        icon: Icon(Icons.meeting_room_outlined),
        selectedIcon: Icon(Icons.meeting_room),
        label: 'Rooms',
      ),
      NavigationDestination(
        icon: const Icon(Icons.sensors),
        selectedIcon: const Icon(Icons.sensors),
        label: context.l10n.repeater_sensors,
      ),
      NavigationDestination(
        icon: _buildIconWithBadge(
          context,
          const Icon(Icons.tag),
          channelsUnreadCount,
        ),
        selectedIcon: _buildIconWithBadge(
          context,
          const Icon(Icons.tag),
          channelsUnreadCount,
        ),
        label: context.l10n.nav_channels,
      ),
      NavigationDestination(
        icon: const Icon(Icons.map_outlined),
        selectedIcon: const Icon(Icons.map),
        label: context.l10n.nav_map,
      ),
    ];

    final safeIndex = selectedIndex.clamp(0, destinations.length - 1);

    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: background,
              border: Border.all(
                color: highContrast
                    ? MapPalette.border
                    : colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                indicatorColor: indicator,
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  final isSelected = states.contains(WidgetState.selected);
                  return labelStyle.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? selectedLabelColor : unselectedColor,
                  );
                }),
                iconTheme: WidgetStateProperty.resolveWith((states) {
                  final isSelected = states.contains(WidgetState.selected);
                  return IconThemeData(
                    color: isSelected ? selectedIconColor : unselectedColor,
                  );
                }),
              ),
              child: NavigationBar(
                height: 60,
                selectedIndex: safeIndex,
                onDestinationSelected: onDestinationSelected,
                destinations: destinations,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithBadge(BuildContext context, Icon icon, int count) {
    if (count <= 0) return icon;
    final label = count > 99 ? '99+' : '$count';
    return Badge(label: Text(label), child: icon);
  }
}
