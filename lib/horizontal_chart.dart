import 'package:flutter/material.dart';

/// HorizontalChart renders one or more horizontal value bars with labels
/// on the left and numeric values on the right. It supports light/dark
/// mode color schemes and a configurable maximum value for scaling.
///
/// Example:
/// HorizontalChart(
///   items: [
///     HorizontalBarItem(label: "나", value: 22.0),
///     HorizontalBarItem(label: "20~24세\n여성", value: 20.5),
///   ],
///   unitSuffix: "kg",
///   maxValue: 30,
///   isDarkMode: false,
/// )
class HorizontalChart extends StatelessWidget {
  final List<HorizontalBarItem> items;
  final double maxValue;
  final bool isDarkMode;
  final String unitSuffix;
  final double barHeight;
  final double barRadius;
  final double rowSpacing;
  final double labelWidth;
  final EdgeInsetsGeometry padding;
  final String? fontFamily;

  /// Default color of the first bar if [HorizontalBarItem.barColor] is null.
  final Color? firstBarDefaultColor;

  /// Default color of all non-first bars if [HorizontalBarItem.barColor] is null.
  final Color? otherBarsDefaultColor;

  /// Default color of value texts for non-first bars if [HorizontalBarItem.valueTextColor] is null.
  final Color? otherValuesDefaultColor;

  const HorizontalChart({
    super.key,
    required this.items,
    required this.maxValue,
    this.isDarkMode = false,
    this.unitSuffix = "",
    this.barHeight = 16,
    this.barRadius = 12,
    this.rowSpacing = 12,
    this.labelWidth = 80,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    this.fontFamily,
    this.firstBarDefaultColor,
    this.otherBarsDefaultColor,
    this.otherValuesDefaultColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedFirstBarColor =
        firstBarDefaultColor ??
        (isDarkMode ? const Color(0xFFFBE300) : const Color(0xFF009fb5));
    final Color resolvedOtherBarColor =
        otherBarsDefaultColor ??
        (isDarkMode ? const Color(0xFF535353) : const Color(0xFF535353));
    final Color resolvedLabelColor =
        isDarkMode ? const Color(0xFF999999) : const Color(0xFF666666);
    final Color resolvedOtherValueColor =
        otherValuesDefaultColor ?? (isDarkMode ? Colors.white : Colors.black);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == items.length - 1 ? 0 : rowSpacing,
              ),
              child: _HorizontalBarRow(
                item: items[i],
                index: i,
                maxValue: maxValue,
                barHeight: barHeight,
                barRadius: barRadius,
                labelWidth: labelWidth,
                unitSuffix: unitSuffix,
                labelColor: resolvedLabelColor,
                fontFamily: fontFamily,
                fallbackBarColor:
                    i == 0 ? resolvedFirstBarColor : resolvedOtherBarColor,
                fallbackValueTextColor:
                    i == 0
                        ? (items[i].barColor ?? resolvedFirstBarColor)
                        : resolvedOtherValueColor,
              ),
            ),
        ],
      ),
    );
  }
}

class _HorizontalBarRow extends StatelessWidget {
  final HorizontalBarItem item;
  final int index;
  final double maxValue;
  final double barHeight;
  final double barRadius;
  final double labelWidth;
  final String unitSuffix;
  final Color labelColor;
  final String? fontFamily;
  final Color fallbackBarColor;
  final Color fallbackValueTextColor;

  const _HorizontalBarRow({
    required this.item,
    required this.index,
    required this.maxValue,
    required this.barHeight,
    required this.barRadius,
    required this.labelWidth,
    required this.unitSuffix,
    required this.labelColor,
    required this.fontFamily,
    required this.fallbackBarColor,
    required this.fallbackValueTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color barColor = item.barColor ?? fallbackBarColor;
    final Color valueTextColor = item.valueTextColor ?? fallbackValueTextColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            item.label,
            style: TextStyle(
              fontSize: 42,
              color: labelColor,
              height: 1.2,
              fontFamily: fontFamily,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double trackWidth = constraints.maxWidth;
              final double fraction =
                  maxValue > 0 ? (item.value / maxValue).clamp(0.0, 1.0) : 0.0;
              final double fillWidth = trackWidth * fraction;

              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Background track (subtle)
                  Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(barRadius),
                        bottomRight: Radius.circular(barRadius),
                      ),
                    ),
                  ),
                  // Fill bar
                  Container(
                    width: fillWidth,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(barRadius),
                        bottomRight: Radius.circular(barRadius),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatValue(item.value, unitSuffix),
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w700,
            color: valueTextColor,
            fontFamily: fontFamily,
          ),
        ),
      ],
    );
  }

  static String _formatValue(double value, String unitSuffix) {
    final String numText =
        value % 1 == 0 ? value.toStringAsFixed(1) : value.toStringAsFixed(1);
    return unitSuffix.isEmpty ? numText : "$numText$unitSuffix";
  }
}

class HorizontalBarItem {
  final String label;
  final double value;
  final Color? barColor;
  final Color? valueTextColor;

  const HorizontalBarItem({
    required this.label,
    required this.value,
    this.barColor,
    this.valueTextColor,
  });
}
