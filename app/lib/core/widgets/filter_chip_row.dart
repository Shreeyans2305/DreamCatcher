import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_tokens.dart';

class FilterChipItem<T> {
  final String label;
  final T value;
  final IconData? icon;

  const FilterChipItem({
    required this.label,
    required this.value,
    this.icon,
  });
}

class FilterChipRow<T> extends StatelessWidget {
  final List<FilterChipItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onSelected;
  final EdgeInsetsGeometry padding;

  const FilterChipRow({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: items.map((item) {
          final isSelected = item.value == selectedValue;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: item.label,
              child: Material(
                color: isSelected ? DesignTokens.navDarkSurface : Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                child: InkWell(
                  onTap: () => onSelected(item.value),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: DesignTokens.minTouchTarget,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                      border: Border.all(
                        color: isSelected
                            ? DesignTokens.navDarkSurface
                            : DesignTokens.border,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.icon != null) ...[
                          Icon(
                            item.icon,
                            size: 18,
                            color: isSelected
                                ? Colors.white
                                : DesignTokens.textSecondary,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : DesignTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
