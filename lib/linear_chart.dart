import 'package:flutter/material.dart';

class LinearChart extends StatefulWidget {
  final List<LinearChartData> data;
  final double spacingFactor;
  final String legendLabel;
  final String chartTitle;
  final double height;
  final bool isDarkMode;
  final double leftPadding;
  final double rightPadding;
  final double? averageValue;
  // 추가 레전드 타이틀 파라미터
  final String? secondLegendLabel;
  final String? thirdLegendLabel;
  // gone 처리 옵션
  final bool showFirstLegend;
  final bool showSecondLegend;
  final bool showThirdLegend;

  const LinearChart({
    super.key,
    required this.data,
    this.spacingFactor = 0.85,
    this.legendLabel = "레전드를 입력하세요",
    this.chartTitle = "타이틀을 입력하세요",
    this.height = 300,
    this.isDarkMode = false,
    this.leftPadding = 40.0,
    this.rightPadding = 40.0,
    this.averageValue,
    this.secondLegendLabel, // 두 번째 레전드 라벨 (null이면 표시되지 않음)
    this.thirdLegendLabel, // 세 번째 레전드 라벨 (null이면 표시되지 않음)
    this.showFirstLegend = true,
    this.showSecondLegend = true,
    this.showThirdLegend = true,
  });

  @override
  State<LinearChart> createState() => _LinearChartState();
}

class _LinearChartState extends State<LinearChart> {
  late bool _showFirstLegend;
  late bool _showSecondLegend;
  late bool _showThirdLegend;

  @override
  void initState() {
    super.initState();
    // 초기값을 위젯 파라미터에서 설정
    _showFirstLegend = widget.showFirstLegend;
    _showSecondLegend = widget.showSecondLegend;
    _showThirdLegend = widget.showThirdLegend;
  }

  @override
  void didUpdateWidget(covariant LinearChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 위젯이 업데이트될 때 속성값 갱신
    if (oldWidget.showFirstLegend != widget.showFirstLegend) {
      _showFirstLegend = widget.showFirstLegend;
    }
    if (oldWidget.showSecondLegend != widget.showSecondLegend) {
      _showSecondLegend = widget.showSecondLegend;
    }
    if (oldWidget.showThirdLegend != widget.showThirdLegend) {
      _showThirdLegend = widget.showThirdLegend;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use dark mode dependent colors
    Color titleColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.chartTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              widget.chartTitle,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ),
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: CustomPaint(
            painter: GripStrengthChartPainter(
              widget.data,
              showGridValues: false,
              spacingFactor: widget.spacingFactor,
              showMyStrength: true,
              showAverageStrength: _showFirstLegend,
              isDarkMode: widget.isDarkMode,
              leftPadding: widget.leftPadding,
              rightPadding: widget.rightPadding,
              averageValue: widget.averageValue,
            ),
          ),
        ),
        const SizedBox(height: 80),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    // Use dark mode dependent colors for legend text
    Color legendTextColor = widget.isDarkMode ? Colors.white : Colors.black;
    // 레전드 사각형 색상 - 다크모드일때 4A4F5A로 수정
    Color legendBoxColor =
        widget.isDarkMode ? const Color(0xFF4A4F5A) : Colors.black;
    // 추가 레전드 색상
    Color secondLegendColor = const Color(0xFFEF193D);
    Color thirdLegendColor = const Color(0xFF1E92DF);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 두 번째 레전드 (secondLegendLabel이 제공된 경우에만 표시)
        if (widget.secondLegendLabel != null)
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Opacity(
              opacity: _showSecondLegend ? 1.0 : 0.5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showSecondLegend = !_showSecondLegend;
                  });
                },
                child: _legendItem(
                  secondLegendColor,
                  widget.secondLegendLabel!,
                  legendTextColor,
                ),
              ),
            ),
          ),

        // 세 번째 레전드 (thirdLegendLabel이 제공된 경우에만 표시)
        if (widget.thirdLegendLabel != null)
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Opacity(
              opacity: _showThirdLegend ? 1.0 : 0.5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showThirdLegend = !_showThirdLegend;
                  });
                },
                child: _legendItem(
                  thirdLegendColor,
                  widget.thirdLegendLabel!,
                  legendTextColor,
                ),
              ),
            ),
          ),

        // 첫 번째 레전드 (항상 표시)
        const SizedBox(width: 36),
        Opacity(
          opacity: _showFirstLegend ? 1.0 : 0.5,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showFirstLegend = !_showFirstLegend;
              });
            },
            child: _legendItem(
              legendBoxColor,
              widget.legendLabel,
              legendTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _legendItem(Color boxColor, String label, Color textColor) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Container(width: 24, height: 24, color: boxColor),
        ),
        const SizedBox(width: 9),
        Text(label, style: TextStyle(fontSize: 30, color: textColor)),
      ],
    );
  }
}

class GripStrengthChartPainter extends CustomPainter {
  final List<LinearChartData> data;
  final bool showGridValues;
  final double spacingFactor;
  final bool showMyStrength;
  final bool showAverageStrength;
  final bool isDarkMode;
  final double leftPadding;
  final double rightPadding;
  final double? averageValue;

  // Colors for dark mode
  late final Color _referenceLineColor;
  late final Color _dateColor;
  late final Color _gridLineColor;

  GripStrengthChartPainter(
    this.data, {
    this.showGridValues = false,
    this.spacingFactor = 0.85,
    this.showMyStrength = true,
    this.showAverageStrength = true,
    this.isDarkMode = false,
    this.leftPadding = 40.0,
    this.rightPadding = 40.0,
    this.averageValue,
  }) {
    // Initialize colors based on mode
    _referenceLineColor = isDarkMode ? const Color(0xFF4A4F5A) : Colors.black;
    _dateColor = isDarkMode ? const Color(0xFF999999) : const Color(0xFF666666);
    _gridLineColor =
        isDarkMode ? const Color(0xFF2C3036) : const Color(0xFFF4F4F4);
  }

  // 평균값은 외부에서 주입받습니다.

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double height = size.height;
    final double chartHeight = height;

    // 최대 값 계산 (10의 배수로 올림)
    const double defaultMaxValue = 50.0;
    final double maxStrength = data
        .map((d) => d.value)
        .reduce((a, b) => a > b ? a : b);
    final double maxValue =
        maxStrength > defaultMaxValue
            ? ((maxStrength * 1.2).round() + 9) ~/
                10 *
                10.0 // 10의 배수로 올림
            : defaultMaxValue;
    const double minValue = 0.0;
    final double valueRange = maxValue - minValue;

    // 배경 그리드 라인 그리기
    _drawGridLines(canvas, size, chartHeight);

    // 최대 5개의 점 기준으로 간격 계산하여 왼쪽부터 배치
    const int maxSlots = 5;
    final int visibleCount = data.length < maxSlots ? data.length : maxSlots;
    final double effectiveWidth = size.width - leftPadding - rightPadding;
    final double pointSpacing =
        visibleCount > 1 ? (effectiveWidth / (maxSlots - 1)) : 0;
    const double firstGapExtra = 0.0; // 1번째와 2번째 점 사이 여분 간격
    final double startX = leftPadding;

    // 내 약력 선 그리기 (설정에 따라)
    if (showMyStrength) {
      _drawValueLine(
        canvas,
        pointSpacing,
        chartHeight,
        startX,
        maxValue,
        minValue,
        valueRange,
        visibleCount,
        firstGapExtra,
      );
    }

    // 평균값 선 그리기 (차트선 위에 그려지도록 순서 변경, 설정에 따라)
    if (showAverageStrength && averageValue != null) {
      _drawReferenceLine(
        canvas,
        size,
        maxValue,
        minValue,
        valueRange,
        startX,
        pointSpacing,
      );
    }

    // 내 약력 값 표시 (설정에 따라)
    if (showMyStrength) {
      _drawValues(
        canvas,
        size,
        pointSpacing,
        startX,
        maxValue,
        minValue,
        valueRange,
        visibleCount,
        firstGapExtra,
      );
    }

    // Draw dates
    _drawDates(
      canvas,
      pointSpacing,
      height,
      startX,
      visibleCount,
      firstGapExtra,
    );
  }

  void _drawGridLines(Canvas canvas, Size size, double chartHeight) {
    final paint =
        Paint()
          ..color = _gridLineColor
          ..strokeWidth = 1;

    // 최대 값 계산 (10의 배수로 올림)
    const double defaultMaxValue = 50.0;
    final double maxStrength = data
        .map((d) => d.value)
        .reduce((a, b) => a > b ? a : b);
    final double maxValue =
        maxStrength > defaultMaxValue
            ? ((maxStrength * 1.2).round() + 9) ~/
                10 *
                10.0 // 10의 배수로 올림
            : defaultMaxValue;
    const double minValue = 0.0;
    final double valueRange = maxValue - minValue;

    // 텍스트 스타일 설정
    final textStyle = TextStyle(
      color: isDarkMode ? Colors.grey[400] : Colors.grey,
      fontSize: 12,
    );
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // 6개의 그리드 라인 그리기
    const numLines = 6;
    final step = valueRange / (numLines - 1); // 간격 계산

    for (int i = 0; i < numLines; i++) {
      final value = maxValue - (i * step);
      final y = i * chartHeight / (numLines - 1);

      // 그리드 라인 그리기
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

      // 그리드 값 표시 옵션이 true일 때만 값 표시
      if (showGridValues) {
        final text = "${value.round()}";
        textPainter.text = TextSpan(text: text, style: textStyle);
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(-textPainter.width - 5, y - textPainter.height / 2),
        );
      }
    }
  }

  void _drawReferenceLine(
    Canvas canvas,
    Size size,
    double maxValue,
    double minValue,
    double valueRange,
    double startX,
    double pointSpacing,
  ) {
    // 평균값이 차트 내에 올바르게 위치하도록 계산
    final normalizedAverage = ((averageValue ?? 0) - minValue) / valueRange;
    final y = size.height * (1 - normalizedAverage);

    // Draw dashed line
    final paint =
        Paint()
          ..color = _referenceLineColor
          ..strokeWidth =
              3.5 // 선 두께 증가
          ..style = PaintingStyle.stroke;

    // 평균값 표시 (소수점 첫째 자리까지)
    final double avgVal = averageValue ?? 0;
    String avgText =
        avgVal % 1 == 0 ? "${avgVal.toInt()}" : "${avgVal.toStringAsFixed(1)}";

    // 값 표시 텍스트 준비
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(text: avgText, style: textStyle);
    textPainter.layout();

    // 상자 크기 설정 (고정된 크기)
    final boxWidth = 101.0;
    final boxHeight = 42.0;

    // 오른쪽 여백 계산 (점선과 값 박스 사이 간격)
    final rightMargin = 12.0;

    // Draw dashed line - 오른쪽 끝 제한
    final dashWidth = 8.0; // 점선 길이 설정
    final dashSpace = 10.0; // 점선 간격 설정
    double lineStartX = 0;
    final lineEndX = size.width - boxWidth - rightMargin; // 평균값 표시 직전에 선 종료

    while (lineStartX < lineEndX) {
      // 다음 점선이 끝 경계를 넘지 않도록 조절
      final currentDashWidth =
          lineStartX + dashWidth > lineEndX ? lineEndX - lineStartX : dashWidth;

      if (currentDashWidth > 0) {
        canvas.drawLine(
          Offset(lineStartX, y),
          Offset(lineStartX + currentDashWidth, y),
          paint,
        );
      }
      lineStartX += dashWidth + dashSpace;
    }

    // Draw reference value background
    final backgroundPaint =
        Paint()
          ..color = _referenceLineColor
          ..style = PaintingStyle.fill;

    // 사각형 그리기 (radius 없음)
    canvas.drawRect(
      Rect.fromLTWH(
        size.width - boxWidth - 5, // 오른쪽 끝에서 위치 조정
        y, // 상단을 점선에 맞춤 (점선 아래로 배치)
        boxWidth,
        boxHeight,
      ),
      backgroundPaint,
    );

    // Draw reference value text
    textPainter.paint(
      canvas,
      Offset(
        size.width - boxWidth / 2 - textPainter.width / 2 - 5, // 박스 내 중앙 정렬
        y + (boxHeight - textPainter.height) / 2, // 수직 중앙 정렬 조정
      ),
    );
  }

  void _drawValueLine(
    Canvas canvas,
    double pointSpacing,
    double chartHeight,
    double startX,
    double maxValue,
    double minValue,
    double valueRange,
    int visibleCount,
    double firstGapExtra,
  ) {
    final linePaint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    final circlePaint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;

    // Calculate points
    List<Offset> points = [];
    for (int i = 0; i < visibleCount; i++) {
      final x = startX + i * pointSpacing + (i >= 1 ? firstGapExtra : 0);
      // Use strength value for line chart
      final normalizedValue = (data[i].value - minValue) / valueRange;
      final y =
          chartHeight * (1 - normalizedValue); // Scale to 100% of chart height
      points.add(Offset(x, y));
    }

    // Draw lines
    if (points.length > 1) {
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], linePaint);
      }
    }

    // Draw points
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 8, circlePaint);
    }
  }

  void _drawValues(
    Canvas canvas,
    Size size,
    double pointSpacing,
    double startX,
    double maxValue,
    double minValue,
    double valueRange,
    int visibleCount,
    double firstGapExtra,
  ) {
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < visibleCount; i++) {
      final x = startX + i * pointSpacing + (i >= 1 ? firstGapExtra : 0);
      final normalizedValue = (data[i].value - minValue) / valueRange;
      final y =
          size.height * (1 - normalizedValue); // Scale to 100% of chart height

      // 가장 오른쪽(마지막) 데이터 포인트일 경우 빨간색으로, 그 외에는 파란색으로 설정
      final rectPaint =
          Paint()
            ..color = (i == visibleCount - 1) ? Colors.red : Colors.blue
            ..style = PaintingStyle.fill;

      // 직사각형 그리기 (더 아래로 이동: y-40에서 y-25로 변경)
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(x, y - 33), width: 72, height: 38),
        const Radius.circular(40),
      );
      canvas.drawRRect(rect, rectPaint);

      // 값 표시 (소수점 첫째 자리까지 표시)
      String displayText =
          data[i].value % 1 == 0
              ? "${data[i].value.toInt()}"
              : "${data[i].value.toStringAsFixed(1)}";

      textPainter.text = TextSpan(text: displayText, style: textStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - 35 - textPainter.height / 2),
      );
    }
  }

  void _drawDates(
    Canvas canvas,
    double pointSpacing,
    double height,
    double startX,
    int visibleCount,
    double firstGapExtra,
  ) {
    final textStyle = TextStyle(color: _dateColor, fontSize: 30);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < visibleCount; i++) {
      final x = startX + i * pointSpacing + (i >= 1 ? firstGapExtra : 0);

      textPainter.text = TextSpan(text: data[i].date, style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, height + 10));
    }
  }

  @override
  bool shouldRepaint(GripStrengthChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.showGridValues != showGridValues ||
        oldDelegate.spacingFactor != spacingFactor ||
        oldDelegate.showMyStrength != showMyStrength ||
        oldDelegate.showAverageStrength != showAverageStrength ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}

class LinearChartData {
  final String date;
  final double value;

  LinearChartData({required this.date, required this.value});
}
