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
                color: isSelected ? DesignTokens.maroon900 : Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                elevation: 0,
                child: InkWell(
                  onTap: () => onSelected(item.value),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 44.0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                      border: Border.all(
                        color: isSelected
                            ? DesignTokens.maroon900
                            : DesignTokens.border,
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: DesignTokens.maroon900.withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: DesignTokens.maroon900.withValues(alpha: 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
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
                                : DesignTokens.slate600,
                          ),
                          const SizedBox(width: 7),
                        ],
                        Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : DesignTokens.slate600,
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
