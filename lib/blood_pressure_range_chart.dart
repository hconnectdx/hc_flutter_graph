import 'package:flutter/material.dart';

class BloodPressureRangeChart extends StatefulWidget {
  final String chartTitle;
  final List<PressureRange> ranges;
  final double currentValue;
  final String currentValueLabel;

  const BloodPressureRangeChart({
    Key? key,
    required this.ranges,
    required this.currentValue,
    this.chartTitle = '',
    this.currentValueLabel = '나의 건강상태',
  }) : super(key: key);

  @override
  State<BloodPressureRangeChart> createState() =>
      _BloodPressureRangeChartState();
}

class _BloodPressureRangeChartState extends State<BloodPressureRangeChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.chartTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              widget.chartTitle,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        AspectRatio(
          aspectRatio: 2.0,
          child: CustomPaint(
            painter: BloodPressureRangePainter(
              ranges: widget.ranges,
              currentValue: widget.currentValue,
              currentValueLabel: widget.currentValueLabel,
            ),
          ),
        ),
      ],
    );
  }
}

class BloodPressureRangePainter extends CustomPainter {
  final List<PressureRange> ranges;
  final double currentValue;
  final String currentValueLabel;

  BloodPressureRangePainter({
    required this.ranges,
    required this.currentValue,
    required this.currentValueLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 범위가 없으면 그리지 않음
    if (ranges.isEmpty) return;

    final double chartHeight = size.height * 0.7;
    final double chartTop = size.height * 0.15;
    final double chartBottom = chartTop + chartHeight;

    // y축 범위 설정
    final double minYValue = 40.0;
    final double maxYValue = 120.0;
    final double yValueRange = maxYValue - minYValue;

    // x축 범위 설정
    final double minXValue = 20.0;
    final double maxXValue = 200.0;
    final double xValueRange = maxXValue - minXValue;

    // 차트 왼쪽 여백 (최저 텍스트 공간)
    const double leftPadding = 60;
    // 차트 오른쪽 여백 (최고 텍스트 공간)
    const double rightPadding = 60;

    // 차트 그리기 영역 계산
    final double chartLeft = leftPadding;
    final double chartRight = size.width - rightPadding;
    final double chartWidth = chartRight - chartLeft;

    // 전체 차트 영역에 16 radius 적용된 배경 그리기
    final Paint chartBackgroundPaint =
        Paint()
          ..color =
              Colors
                  .grey
                  .shade200 // 배경색
          ..style = PaintingStyle.fill;

    final RRect chartBackgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(chartLeft, chartTop, chartWidth, chartHeight),
      const Radius.circular(16), // 전체 차트에 16 radius 적용
    );

    canvas.drawRRect(chartBackgroundRect, chartBackgroundPaint);

    // 계단 높이 계산 (혈압 범위별 높이 차이)
    final double stepHeight = chartHeight / ranges.length;

    // 클리핑 패스 생성 (전체 차트 영역을 16 radius로 클리핑)
    canvas.save();
    final Path clipPath = Path()..addRRect(chartBackgroundRect);
    canvas.clipPath(clipPath);

    // 범위 막대 그리기 - 큰 값부터 작은 값까지 역순으로 그림
    for (int i = 0; i < ranges.length; i++) {
      final range = ranges[i];

      // 범위의 상대적 위치 계산
      final double rangeEnd = (range.maxValue - minXValue) / xValueRange;

      // 범위의 픽셀 위치 계산
      final double rangeEndX = chartLeft + (rangeEnd * chartWidth);
      final double rangeWidth = rangeEndX - chartLeft;

      // 이 범위의 높이와 시작 위치 계산 (계단식으로)
      final double thisRangeTop = chartTop + (stepHeight * i);
      final double thisRangeHeight = chartHeight - (stepHeight * i);

      // 범위 막대 그리기
      final Paint rangePaint =
          Paint()
            ..color = range.color
            ..style = PaintingStyle.fill;

      // 우측 상단 모서리에만 radius 적용
      final RRect rangeRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(chartLeft, thisRangeTop, rangeWidth, thisRangeHeight),
        topRight: const Radius.circular(12),
      );
      canvas.drawRRect(rangeRect, rangePaint);
    }

    // 클리핑 해제
    canvas.restore();

    // 라벨 텍스트 그리기 (그래프 내에 겹쳐서)
    _drawLabelsInsideChart(
      canvas,
      chartLeft,
      chartTop,
      chartWidth,
      chartHeight,
      minYValue,
      maxYValue,
    );

    // 현재 값 표시
    final double currentX =
        chartLeft + (((currentValue - minXValue) / xValueRange) * chartWidth);

    // 원의 중심 위치와 반지름
    final double circleCenterY = chartTop + chartHeight / 2;
    final double circleRadius = 20.0;

    // 말풍선 위치 계산 - 원 위 6dp 간격 유지
    final double bubbleBottomY =
        circleCenterY - circleRadius - 25; // 원 상단에서 6dp 위
    final double bubbleY = bubbleBottomY - 32; // 말풍선 중심 (높이의 절반)

    // 현재 값 라벨 말풍선 그리기 (원 위에 배치)
    _drawBubbleWithText(
      canvas,
      text: currentValueLabel,
      position: Offset(currentX, bubbleY),
      bubbleWidth: 290,
      bubbleHeight: 80,
      fontSize: 36,
      triangleHeight: 10, // 삼각형 높이
    );

    // 그림자 효과 그리기
    final Paint shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    // 바깥 원에만 그림자 효과 적용 (구멍이 없는 완전한 원)
    canvas.drawCircle(
      Offset(currentX + 3, chartTop + chartHeight / 2 + 3),
      20,
      shadowPaint,
    );

    // 흰색 원과 구멍 그리기 (그림자 없음)
    final Paint currentPointPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    // SaveLayer를 사용하여 정확히 구멍을 뚫기
    final Rect circleRect = Rect.fromCircle(
      center: Offset(currentX, chartTop + chartHeight / 2),
      radius: 25, // 약간 더 큰 영역을 확보
    );

    canvas.saveLayer(circleRect, Paint());

    // 바깥 원 그리기
    canvas.drawCircle(
      Offset(currentX, chartTop + chartHeight / 2),
      20,
      currentPointPaint,
    );

    // 구멍을 뚫기 위한 Paint
    final Paint holePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.clear;

    // 중앙에 구멍 뚫기
    canvas.drawCircle(
      Offset(currentX, chartTop + chartHeight / 2),
      7,
      holePaint,
    );

    canvas.restore();

    // 테두리 그리기
    final Paint currentPointBorderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    canvas.drawCircle(
      Offset(currentX, chartTop + chartHeight / 2),
      20,
      currentPointBorderPaint,
    );

    // 현재 값 숫자 그리기 - 상태 확인 위치 계산
    _drawText(
      canvas: canvas,
      text: currentValue.toInt().toString(),
      position: Offset(currentX, chartBottom + 80),
      fontSize: 25,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  // 라벨 텍스트를 그래프 내에 그리는 메서드
  void _drawLabelsInsideChart(
    Canvas canvas,
    double chartLeft,
    double chartTop,
    double chartWidth,
    double chartHeight,
    double minYValue,
    double maxYValue,
  ) {
    // 라벨 텍스트 위치 (높이)
    final List<PressureRange> reversedRanges = List.from(ranges.reversed);
    // Y축 범위(60-120)에 맞는 높이 값으로 변경
    final List<double> heights = [47, 60, 73.5, 87.5, 100.5, 113.5];
    final double yValueRange = maxYValue - minYValue;

    for (int i = 0; i < heights.length && i < reversedRanges.length; i++) {
      final range = reversedRanges[i];
      final height = heights[i];

      // 높이 위치 계산 (60~120 범위로 정규화)
      final double normalizedHeight = (height - minYValue) / yValueRange;
      final double y = chartTop + chartHeight * (1 - normalizedHeight);

      _drawText(
        canvas: canvas,
        text: range.label,
        position: Offset(chartLeft + 20, y),
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        alignment: Alignment.centerLeft,
      );
    }
  }

  // 하단 값들 그리기
  void _drawBottomValues(
    Canvas canvas,
    double chartLeft,
    double chartRight,
    double chartBottom,
    double chartWidth,
    double maxXValue,
  ) {
    final List<int> values = [40, 80, 120, 160, 200];
    final double minXValue = 40.0;
    final double xValueRange = maxXValue - minXValue;

    for (int value in values) {
      final double x =
          chartLeft + ((value - minXValue) / xValueRange) * chartWidth;

      _drawText(
        canvas: canvas,
        text: value.toString(),
        position: Offset(x, chartBottom + 80),
        fontSize: 25,
        color: Colors.grey,
      );
    }
  }

  void _drawText({
    required Canvas canvas,
    required String text,
    required Offset position,
    required double fontSize,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.center,
    Alignment alignment = Alignment.center,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    );

    textPainter.layout();

    // 정렬 방식에 따라 위치 조정
    double dx = position.dx;
    double dy = position.dy;

    if (alignment == Alignment.center) {
      dx -= (textPainter.width / 2);
      dy -= (textPainter.height / 2);
    } else if (alignment == Alignment.centerLeft) {
      dy -= (textPainter.height / 2);
    }

    textPainter.paint(canvas, Offset(dx, dy));
  }

  void _drawBubbleWithText(
    Canvas canvas, {
    required String text,
    required Offset position,
    required double bubbleWidth,
    required double bubbleHeight,
    required double fontSize,
    double triangleHeight = 10,
  }) {
    // 말풍선 그리기
    final bubblePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    // 말풍선 몸체 - 둥근 모서리 직사각형 (radius 60으로 변경)
    final RRect bubbleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        position.dx - bubbleWidth / 2,
        position.dy - bubbleHeight / 2,
        bubbleWidth,
        bubbleHeight,
      ),
      const Radius.circular(60), // 30에서 60으로 변경
    );

    // 말풍선 전체 경로 (몸체 + 삼각형)
    final Path bubblePath = Path();

    // 몸체 추가
    bubblePath.addRRect(bubbleRect);

    // 삼각형 부분 추가
    final double triangleWidth = 20.0; // 삼각형 너비
    final double triangleTop = position.dy + bubbleHeight / 2;
    final double triangleBottom = triangleTop + triangleHeight;

    // 삼각형 경로
    bubblePath.moveTo(position.dx - triangleWidth / 2, triangleTop);
    bubblePath.lineTo(position.dx, triangleBottom);
    bubblePath.lineTo(position.dx + triangleWidth / 2, triangleTop);

    // 말풍선 배경 그리기
    canvas.drawPath(bubblePath, bubblePaint);

    // 테두리 제거 (주석 처리)
    // canvas.drawPath(bubblePath, bubbleBorderPaint);

    // 텍스트 그리기 - 색상을 #666666으로 변경
    _drawText(
      canvas: canvas,
      text: text,
      position: Offset(position.dx, position.dy),
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF666666), // #666666 색상으로 변경
    );
  }

  // Y축 눈금 및 격자선 그리기
  void _drawYAxisGrids(
    Canvas canvas,
    double chartLeft,
    double chartRight,
    double chartTop,
    double chartHeight,
    double minYValue,
    double maxYValue,
  ) {
    final List<double> yValues = [60, 80, 100, 120];
    final Paint gridPaint =
        Paint()
          ..color = Colors.grey.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    for (double value in yValues) {
      // 값의 상대적 위치 계산 (60~120 범위로 정규화)
      final double normalizedValue =
          (value - minYValue) / (maxYValue - minYValue);
      final double y = chartTop + chartHeight * (1 - normalizedValue);

      // 격자선 그리기
      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), gridPaint);

      // 눈금 값 그리기 (왼쪽 여백에)
      _drawText(
        canvas: canvas,
        text: value.toInt().toString(),
        position: Offset(chartLeft - 20, y),
        fontSize: 15,
        color: Colors.grey,
        alignment: Alignment.centerRight,
      );
    }
  }

  @override
  bool shouldRepaint(BloodPressureRangePainter oldDelegate) {
    return oldDelegate.ranges != ranges ||
        oldDelegate.currentValue != currentValue ||
        oldDelegate.currentValueLabel != currentValueLabel;
  }
}

class PressureRange {
  final double minValue;
  final double maxValue;
  final String label;
  final Color color;

  PressureRange({
    required this.minValue,
    required this.maxValue,
    required this.label,
    required this.color,
  });

  // 예제 데이터 생성
  static List<PressureRange> getSampleRanges() {
    return [
      PressureRange(
        minValue: 0,
        maxValue: 200,
        label: '제2기 고혈압',
        color: const Color(0xFFF44336), // 빨간색
      ),
      PressureRange(
        minValue: 0,
        maxValue: 180,
        label: '제1기 고혈압',
        color: const Color(0xFFFF9800), // 주황색
      ),
      PressureRange(
        minValue: 0,
        maxValue: 160,
        label: '고혈압 전단계',
        color: const Color(0xFFFFEB3B), // 노란색
      ),
      PressureRange(
        minValue: 0,
        maxValue: 140,
        label: '주의혈압',
        color: const Color(0xFF8BC34A), // 연두색
      ),
      PressureRange(
        minValue: 0,
        maxValue: 120,
        label: '정상',
        color: const Color(0xFF4CAF50), // 초록색
      ),
      PressureRange(
        minValue: 0,
        maxValue: 90,
        label: '저혈압',
        color: const Color(0xFF2196F3), // 파란색
      ),
    ];
  }
}
