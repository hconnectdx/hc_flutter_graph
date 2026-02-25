import 'dart:math';

import 'package:flutter/material.dart';

class GaugeChart extends StatefulWidget {
  /// 차트에 표시할 현재 값
  final double value;

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

  /// 구간 의미 텍스트 스타일 (예: 정상, 과체중) - null이면 labelTextStyle 사용
  final TextStyle? segmentLabelTextStyle;

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

  /// 텍스트에 적용할 폰트 패밀리 (null이면 기본 시스템 폰트 사용)
  final String? fontFamily;

  /// 게이지 하단에 표시할 라벨 값들 (null이면 segments 기반으로 자동 생성)
  final List<double>? labelValues;

  const GaugeChart({
    Key? key,
    required this.value,
    required this.segments,
    this.size = 300,
    this.pointerThickness = 4.5,
    this.pointerLength = 30,
    this.thickness = 70,
    this.valueTextStyle,
    this.labelTextStyle,
    this.segmentLabelTextStyle,
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
    this.fontFamily,
    this.labelValues,
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
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: widget.size,
            height: widget.size / 2 + 80, // 반원 높이 + 라벨 공간
            child: CustomPaint(
              painter: GaugeChartPainter(
                value: widget.value,
                segments: widget.segments,
                labelValues: widget.labelValues,
                pointerThickness: widget.pointerThickness,
                pointerLength: widget.pointerLength,
                thickness: widget.thickness,
                valueTextStyle: (widget.valueTextStyle ??
                        const TextStyle(
                          color: Colors.black,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ))
                    .copyWith(fontFamily: widget.fontFamily),
                labelTextStyle: (widget.labelTextStyle ??
                        const TextStyle(color: Colors.grey, fontSize: 14))
                    .copyWith(fontFamily: widget.fontFamily),
                segmentLabelTextStyle: (widget.segmentLabelTextStyle ??
                        widget.labelTextStyle ??
                        const TextStyle(color: Colors.grey, fontSize: 14))
                    .copyWith(fontFamily: widget.fontFamily),
                centerLabelTextStyle: (widget.centerLabelTextStyle ??
                        const TextStyle(color: Colors.black54, fontSize: 16))
                    .copyWith(fontFamily: widget.fontFamily),
                centerUnitTextStyle: (widget.centerUnitTextStyle ??
                        const TextStyle(color: Colors.black54, fontSize: 16))
                    .copyWith(fontFamily: widget.fontFamily),
                centerLabel: _centerLabel,
                unit: _unit,
                decimalPlaces: _decimalPlaces,
                valueFormatter: widget.valueFormatter,
                showValue: widget.showValue,
                textYOffset: _textYOffset,
              ),
              foregroundPainter: PointerPainter(
                value: widget.value,
                segments: widget.segments,
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
      ),
    );
  }
}

class GaugeChartPainter extends CustomPainter {
  final double value;
  final List<GaugeSegment> segments;
  final List<double>? labelValues;
  final double pointerThickness;
  final double pointerLength;
  final double thickness;
  final TextStyle valueTextStyle;
  final TextStyle labelTextStyle;
  final TextStyle segmentLabelTextStyle;
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
    required this.segments,
    this.labelValues,
    required this.pointerThickness,
    required this.pointerLength,
    required this.thickness,
    required this.valueTextStyle,
    required this.labelTextStyle,
    required this.segmentLabelTextStyle,
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

    // 텍스트 그리기 (숫자 라벨)
    _drawLabels(canvas, center, radius);

    // 게이지 그리기
    _drawGauge(canvas, center, radius);

    // 구간 의미 텍스트 그리기 (예: 정상, 과체중)
    _drawSegmentLabels(canvas, center, radius);

    // 중앙 텍스트 그리기
    if (showValue) {
      _drawCenterText(canvas, center);
    }
  }

  double get _minValue => segments.first.startValue;
  double get _maxValue => segments.last.endValue;

  void _drawGauge(Canvas canvas, Offset center, double radius) {
    // 게이지 배경
    final bgPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.round;

    // 구간별 색상 그리기
    final double totalRange = _maxValue - _minValue;
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
    String formattedValue;
    if (valueFormatter != null) {
      formattedValue = valueFormatter!(value);
    } else {
      // 소수점 뒤가 정확히 '.0'인 경우에만 정수로 표시
      formattedValue = value.toStringAsFixed(decimalPlaces);
      if (formattedValue.endsWith(".0")) {
        formattedValue = value.toInt().toString();
      }
    }

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
    // 외부에서 전달받은 labelValues 사용, 없으면 segments 기반으로 자동 생성
    final List<double> values = labelValues ??
        List.generate(
          7,
          (i) => _minValue + (_maxValue - _minValue) * i / 6,
        );

    for (final labelValue in values) {
      final valueRatio = (labelValue - _minValue) / (_maxValue - _minValue);
      final valueAngle = pi + (valueRatio * pi);

      // 끝 부분 라벨 위치 조정
      double xOffset = 0;
      double yOffset = 0;

      if (labelValue == _minValue) {
        // 왼쪽 끝 라벨 오른쪽으로 살짝 이동
        xOffset = 10;
        yOffset = -12;
      } else if (labelValue == _maxValue) {
        // 오른쪽 끝 라벨 왼쪽으로 살짝 이동
        xOffset = 5;
        yOffset = -12;
      } else if (labelValue == values[values.length ~/ 2]) {
        // 중앙 라벨 아래로 살짝 이동
        yOffset = 8;
      }

      final labelOffset = Offset(
        center.dx + (radius + thickness / 2 + 30) * cos(valueAngle) + xOffset,
        center.dy + (radius + thickness / 2 + 30) * sin(valueAngle) + yOffset,
      );

      // 소수점 이하 모두 표시 (23.0 → "23.0", 18.4 → "18.4")
      final labelText = labelValue == labelValue.truncateToDouble()
          ? labelValue.toStringAsFixed(1)
          : labelValue.toString();

      final textPainter = TextPainter(
        text: TextSpan(
          text: labelText,
          style: labelTextStyle.copyWith(fontSize: 18),
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

  void _drawSegmentLabels(Canvas canvas, Offset center, double radius) {
    final double totalRange = _maxValue - _minValue;

    for (final segment in segments) {
      final segmentLabel = segment.label;
      if (segmentLabel == null || segmentLabel.isEmpty) continue;

      // 구간 중앙 값으로 각도 계산
      final centerValue =
          segment.startValue + (segment.endValue - segment.startValue) / 2;
      final valueRatio = (centerValue - _minValue) / totalRange;
      final valueAngle = pi + (valueRatio * pi);

      // 구간 텍스트를 숫자 라벨 바깥쪽에 배치하여 그래프와 겹치지 않게
      final labelDistance = radius + thickness / 2 + 55;
      final labelOffset = Offset(
        center.dx + labelDistance * cos(valueAngle),
        center.dy + labelDistance * sin(valueAngle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: segmentLabel,
          style: segmentLabelTextStyle.copyWith(fontSize: 24),
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
        oldDelegate.segments != segments ||
        oldDelegate.labelValues != labelValues ||
        oldDelegate.segmentLabelTextStyle != segmentLabelTextStyle ||
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
  final List<GaugeSegment> segments;
  final double pointerThickness;
  final double pointerLength;
  final double thickness;

  PointerPainter({
    required this.value,
    required this.segments,
    required this.pointerThickness,
    required this.pointerLength,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 50);
    final radius = min(size.width, size.height * 2) / 2 - thickness / 2;

    // 값의 각도 계산
    final minValue = segments.first.startValue;
    final maxValue = segments.last.endValue;
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
        oldDelegate.segments != segments ||
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
