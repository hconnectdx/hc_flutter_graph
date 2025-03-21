import 'dart:math';
import 'package:flutter/material.dart';

class GaugeChart extends StatefulWidget {
  /// 차트에 표시할 현재 값
  final double value;

  /// 차트의 최소값
  final double minValue;

  /// 차트의 최대값
  final double maxValue;

  /// 차트에 표시할 구간들
  final List<GaugeSegment> segments;

  /// 차트 크기
  final double size;

  /// 포인터 두께
  final double pointerThickness;

  /// 포인터 길이
  final double pointerLength;

  /// 게이지 두께
  final double thickness;

  /// 값 텍스트 스타일
  final TextStyle? valueTextStyle;

  /// 구간 라벨 텍스트 스타일
  final TextStyle? labelTextStyle;

  /// 중앙 라벨 텍스트 스타일
  final TextStyle? centerLabelTextStyle;

  /// 중앙 단위 텍스트 스타일
  final TextStyle? centerUnitTextStyle;

  /// 중앙 위쪽 라벨
  final String centerLabel;

  /// 값의 단위 (예: kg/m2, %)
  final String unit;

  /// 값의 소수점 자릿수
  final int decimalPlaces;

  /// 값 형식 지정 콜백 (null이면 기본 형식 사용)
  final String Function(double value)? valueFormatter;

  /// 값 표시 여부
  final bool showValue;

  /// 라벨 변경 시 호출되는 콜백
  final Function(String)? onLabelChanged;

  /// 단위 변경 시 호출되는 콜백
  final Function(String)? onUnitChanged;

  /// 소수점 자릿수 변경 시 호출되는 콜백
  final Function(int)? onDecimalPlacesChanged;

  /// UI 컨트롤 표시 여부
  final bool showControls;

  /// 텍스트 위치 Y축 오프셋 (라벨과 값 모두에 적용됨)
  final double textYOffset;

  const GaugeChart({
    Key? key,
    required this.value,
    this.minValue = 0,
    this.maxValue = 300,
    required this.segments,
    this.size = 300,
    this.pointerThickness = 4.5,
    this.pointerLength = 30,
    this.thickness = 70,
    this.valueTextStyle,
    this.labelTextStyle,
    this.centerLabelTextStyle,
    this.centerUnitTextStyle,
    this.centerLabel = "BMI",
    this.unit = "(kg/m²)",
    this.decimalPlaces = 1,
    this.valueFormatter,
    this.showValue = true,
    this.onLabelChanged,
    this.onUnitChanged,
    this.onDecimalPlacesChanged,
    this.showControls = false,
    this.textYOffset = -90,
  }) : super(key: key);

  @override
  State<GaugeChart> createState() => _GaugeChartState();
}

class _GaugeChartState extends State<GaugeChart> {
  late String _centerLabel;
  late String _unit;
  late int _decimalPlaces;
  late double _textYOffset;

  @override
  void initState() {
    super.initState();
    _centerLabel = widget.centerLabel;
    _unit = widget.unit;
    _decimalPlaces = widget.decimalPlaces;
    _textYOffset = widget.textYOffset;
  }

  @override
  void didUpdateWidget(GaugeChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.centerLabel != widget.centerLabel) {
      _centerLabel = widget.centerLabel;
    }
    if (oldWidget.unit != widget.unit) {
      _unit = widget.unit;
    }
    if (oldWidget.decimalPlaces != widget.decimalPlaces) {
      _decimalPlaces = widget.decimalPlaces;
    }
    if (oldWidget.textYOffset != widget.textYOffset) {
      _textYOffset = widget.textYOffset;
    }
  }

  void _updateLabel(String value) {
    setState(() {
      _centerLabel = value;
    });
    if (widget.onLabelChanged != null) {
      widget.onLabelChanged!(value);
    }
  }

  void _updateUnit(String value) {
    setState(() {
      _unit = value;
    });
    if (widget.onUnitChanged != null) {
      widget.onUnitChanged!(value);
    }
  }

  void _updateDecimalPlaces(int value) {
    setState(() {
      _decimalPlaces = value;
    });
    if (widget.onDecimalPlacesChanged != null) {
      widget.onDecimalPlacesChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size / 2 + 80, // 반원 높이 + 라벨 공간
          child: CustomPaint(
            painter: GaugeChartPainter(
              value: widget.value,
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              segments: widget.segments,
              pointerThickness: widget.pointerThickness,
              pointerLength: widget.pointerLength,
              thickness: widget.thickness,
              valueTextStyle:
                  widget.valueTextStyle ??
                  const TextStyle(
                    color: Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
              labelTextStyle:
                  widget.labelTextStyle ??
                  const TextStyle(color: Colors.grey, fontSize: 14),
              centerLabelTextStyle:
                  widget.centerLabelTextStyle ??
                  const TextStyle(color: Colors.black54, fontSize: 16),
              centerUnitTextStyle:
                  widget.centerUnitTextStyle ??
                  const TextStyle(color: Colors.black54, fontSize: 16),
              centerLabel: _centerLabel,
              unit: _unit,
              decimalPlaces: _decimalPlaces,
              valueFormatter: widget.valueFormatter,
              showValue: widget.showValue,
              textYOffset: _textYOffset,
            ),
            foregroundPainter: PointerPainter(
              value: widget.value,
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              pointerThickness: widget.pointerThickness,
              pointerLength: widget.pointerLength,
              thickness: widget.thickness,
            ),
          ),
        ),
        if (widget.showControls) ...[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: '라벨',
                      hintText: 'BMI',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                    ),
                    controller: TextEditingController(text: _centerLabel),
                    onChanged: _updateLabel,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: '단위',
                      hintText: '(kg/m²)',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                    ),
                    controller: TextEditingController(text: _unit),
                    onChanged: _updateUnit,
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: _decimalPlaces,
                  isDense: true,
                  items:
                      [0, 1, 2, 3].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('소수점: $value'),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateDecimalPlaces(value);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class GaugeChartPainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final List<GaugeSegment> segments;
  final double pointerThickness;
  final double pointerLength;
  final double thickness;
  final TextStyle valueTextStyle;
  final TextStyle labelTextStyle;
  final TextStyle centerLabelTextStyle;
  final TextStyle centerUnitTextStyle;
  final String centerLabel;
  final String unit;
  final int decimalPlaces;
  final String Function(double value)? valueFormatter;
  final bool showValue;
  final double textYOffset;

  GaugeChartPainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.segments,
    required this.pointerThickness,
    required this.pointerLength,
    required this.thickness,
    required this.valueTextStyle,
    required this.labelTextStyle,
    required this.centerLabelTextStyle,
    required this.centerUnitTextStyle,
    required this.centerLabel,
    required this.unit,
    required this.decimalPlaces,
    this.valueFormatter,
    required this.showValue,
    required this.textYOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 50);
    final radius = min(size.width, size.height * 2) / 2 - thickness / 2;

    // 텍스트 그리기 (레이블)
    _drawLabels(canvas, center, radius);

    // 게이지 그리기
    _drawGauge(canvas, center, radius);

    // 중앙 텍스트 그리기
    if (showValue) {
      _drawCenterText(canvas, center);
    }
  }

  void _drawGauge(Canvas canvas, Offset center, double radius) {
    // 게이지 배경
    final bgPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.round;

    // 구간별 색상 그리기
    final double totalRange = maxValue - minValue;
    double startAngle = pi;

    for (final segment in segments) {
      final segmentRange = segment.endValue - segment.startValue;
      final sweepAngle = (segmentRange / totalRange) * pi;

      final segmentPaint =
          Paint()
            ..color = segment.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = thickness
            ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        segmentPaint,
      );

      startAngle += sweepAngle;
    }
  }

  void _drawCenterText(Canvas canvas, Offset center) {
    // 값 텍스트 준비 (먼저 계산하지만 나중에 그림)
    final String formattedValue =
        valueFormatter != null
            ? valueFormatter!(value)
            : value.toStringAsFixed(decimalPlaces);

    final valuePainter = TextPainter(
      text: TextSpan(text: formattedValue, style: valueTextStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    valuePainter.layout();

    // 값 텍스트 위치 계산
    final valueOffset = Offset(
      center.dx - valuePainter.width / 2,
      center.dy + textYOffset + 55, // 라벨 아래 고정 간격으로 배치
    );

    // 텍스트 배경에 반투명 사각형 그리기
    final bgPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.7)
          ..style = PaintingStyle.fill;

    // 배경 사각형 그리기
    canvas.drawRect(
      Rect.fromLTWH(
        valueOffset.dx - 2,
        valueOffset.dy - 2,
        valuePainter.width + 4,
        valuePainter.height + 4,
      ),
      bgPaint,
    );

    // 값 텍스트 그리기
    valuePainter.paint(canvas, valueOffset);

    // 중앙 상단 라벨 텍스트 (예: BMI)를 값 텍스트 위에 그리기
    final labelPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: centerLabel,
            style: centerLabelTextStyle.copyWith(fontSize: 42),
          ),
          TextSpan(text: " ${unit}", style: centerUnitTextStyle),
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    labelPainter.layout();
    labelPainter.paint(
      canvas,
      Offset(center.dx - labelPainter.width / 2, center.dy + textYOffset),
    );
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    // 주요 값들 라벨 그리기 (최소값, 최대값, 중간 값들)
    final List<double> labelValues = [
      minValue,
      50,
      100,
      150,
      200,
      250,
      maxValue,
    ];

    for (final labelValue in labelValues) {
      final valueRatio = (labelValue - minValue) / (maxValue - minValue);
      final valueAngle = pi + (valueRatio * pi);

      // 끝 부분 라벨 위치 조정
      double xOffset = 0;
      double yOffset = 0;

      if (labelValue == minValue) {
        // 왼쪽 끝(0) 라벨 오른쪽으로 살짝 이동
        xOffset = 10;
        yOffset = -12;
      } else if (labelValue == maxValue) {
        // 오른쪽 끝(300) 라벨 왼쪽으로 살짝 이동하고 더 떨어뜨림
        xOffset = 10;
        yOffset = -12;
        // 차트에서 더 떨어뜨림
        xOffset -= 5;
      } else if (labelValue == 150) {
        // 중앙(150) 라벨 아래로 살짝 이동
        yOffset = 8;
      } else if (labelValue == 250) {
        // 중앙(150) 라벨 아래로 살짝 이동
        xOffset = 8;
        yOffset = 0;
      }

      final labelOffset = Offset(
        center.dx + (radius + thickness / 2 + 30) * cos(valueAngle) + xOffset,
        center.dy + (radius + thickness / 2 + 30) * sin(valueAngle) + yOffset,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: labelValue.round().toString(),
          style: labelTextStyle.copyWith(fontSize: 30),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          labelOffset.dx - textPainter.width / 2,
          labelOffset.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(GaugeChartPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.segments != segments ||
        oldDelegate.pointerThickness != pointerThickness ||
        oldDelegate.pointerLength != pointerLength ||
        oldDelegate.thickness != thickness ||
        oldDelegate.centerLabel != centerLabel ||
        oldDelegate.unit != unit ||
        oldDelegate.decimalPlaces != decimalPlaces ||
        oldDelegate.showValue != showValue ||
        oldDelegate.textYOffset != textYOffset;
  }
}

// 포인터를 위한 별도의 페인터 클래스 생성 (항상 게이지 위에 그려짐)
class PointerPainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final double pointerThickness;
  final double pointerLength;
  final double thickness;

  PointerPainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.pointerThickness,
    required this.pointerLength,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 50);
    final radius = min(size.width, size.height * 2) / 2 - thickness / 2;

    // 값의 각도 계산
    final valueRatio = (value - minValue) / (maxValue - minValue);
    final valueAngle = pi + (valueRatio * pi);

    // 포인터의 길이를 게이지 두께를 고려하여 중심에 맞게 조정
    final outerExtension = 3.0; // 바깥쪽으로 확장되는 길이 (줄임)
    final innerExtension = 3.0; // 안쪽으로 확장되는 길이 (줄임)

    // 포인터 시작점 (게이지 바깥쪽으로 약간만 확장)
    final pointerStartOffset = Offset(
      center.dx + (radius + thickness / 2 + outerExtension) * cos(valueAngle),
      center.dy + (radius + thickness / 2 + outerExtension) * sin(valueAngle),
    );

    // 포인터 끝점 (게이지 안쪽으로 약간만 확장)
    final pointerEndOffset = Offset(
      center.dx + (radius - thickness / 2 - innerExtension) * cos(valueAngle),
      center.dy + (radius - thickness / 2 - innerExtension) * sin(valueAngle),
    );

    // 포인터 그리기 (파란색 직선으로 변경)
    final pointerPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = pointerThickness
          ..strokeCap = StrokeCap.round;

    canvas.drawLine(pointerStartOffset, pointerEndOffset, pointerPaint);
  }

  @override
  bool shouldRepaint(PointerPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.pointerThickness != pointerThickness ||
        oldDelegate.pointerLength != pointerLength ||
        oldDelegate.thickness != thickness;
  }
}

class GaugeSegment {
  final double startValue;
  final double endValue;
  final Color color;
  final String? label;

  const GaugeSegment({
    required this.startValue,
    required this.endValue,
    required this.color,
    this.label,
  });
}
