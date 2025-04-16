import 'package:flutter/material.dart';

/// 혈압 범위를 표시하는 차트 위젯
///
/// 사용 예시:
/// ```dart
/// BloodPressureRangeChart(
///   ranges: PressureRange.getSampleRanges(),
///   pointerXValue: 130, // X축 포인터 위치 지정
///   chartTitle: '혈압 범위 차트',
///   currentValueLabel: '정상',
///   // Y축 포인터 위치 직접 설정 (슬라이더 표시 안됨)
///   pointerYValue: 85,
///   // 커스텀 Y축 범위 설정
///   yAxisRange: [30, 150],
///   // 커스텀 혈압 좌표 설정
///   rangeCoordinates: [30, 50, 70, 90, 110, 130, 150],
/// )
/// ```
class BloodPressureRangeChart extends StatefulWidget {
  final String chartTitle;
  final List<PressureRange> ranges;
  final String currentValueLabel;
  final List<double> yAxisRange; // Y축 범위 추가

  /// X축 포인터 위치를 지정하는 값
  ///
  /// 이 값이 원형 포인터의 X축 위치를 결정합니다.
  final double pointerXValue;

  /// Y축 포인터 위치를 지정하는 값
  ///
  /// 이 값이 제공되면 슬라이더가 표시되지 않고 원형 포인터의 Y축 위치가 이 값으로 고정됩니다.
  /// null인 경우 슬라이더가 표시되고 사용자가 포인터 위치를 조절할 수 있습니다.
  final double? pointerYValue;

  /// 혈압 범위의 좌표 값을 정의하는 리스트
  ///
  /// 이 좌표값들은 차트의 Y축 높이를 동일한 비율로 나누는 데 사용됩니다.
  /// 각 범위(저혈압, 정상, 주의혈압 등)가 동일한 높이를 갖도록 합니다.
  ///
  /// 해당 값은 반드시 오름차순으로 정렬되어야 하며, 최소 2개 이상이어야 합니다.
  /// 기본값은 [40.0, 60.0, 80.0, 85.0, 90.0, 100.0, 120.0]입니다.
  final List<double> rangeCoordinates;

  /// 차트의 가로 세로 비율
  ///
  /// 이 값이 클수록 차트가 넓어집니다. 기본값은 2.0입니다.
  final double aspectRatio;

  /// 차트 영역의 세로 비율
  ///
  /// 전체 위젯 높이 중 차트가 차지하는 비율. 0.0~1.0 사이의 값.
  /// 이 값이 클수록 차트 영역이 높아집니다. 기본값은 0.7입니다.
  final double chartHeightRatio;

  /// Y축 값 표시 여부
  ///
  /// true이면 Y축 값을 표시하고, false이면 숨깁니다.
  /// 기본값은 true입니다.
  final bool showYAxisValues;

  /// Y축 값의 오프셋
  ///
  /// Y축 값 위치를 위아래로 조정합니다. 양수 값은 아래로, 음수 값은 위로 이동합니다.
  /// 기본값은 0.0입니다.
  final double yOffset;

  /// 특정 Y축 값을 숨길 목록
  ///
  /// 이 목록에 포함된 Y축 값들은 차트에 표시되지 않습니다.
  /// 기본값은 빈 리스트입니다.
  final List<double> hideSpecificYValues;

  const BloodPressureRangeChart({
    Key? key,
    required this.ranges,
    required this.pointerXValue,
    this.chartTitle = '',
    this.currentValueLabel = '나의 건강상태',
    this.yAxisRange = const [40, 120], // 기본값 설정
    this.pointerYValue, // Y축 포인터 위치 (null이면 슬라이더 값 사용)
    this.rangeCoordinates = const [
      40.0,
      60.0,
      80.0,
      85.0,
      90.0,
      100.0,
      120.0,
    ], // 기본값 설정
    this.aspectRatio = 2.0, // 기본 가로 세로 비율
    this.chartHeightRatio = 0.7, // 기본 차트 높이 비율
    this.showYAxisValues = true, // Y축 값 표시 여부
    this.yOffset = 0.0, // Y축 값 오프셋 기본값
    this.hideSpecificYValues = const [], // 특정 Y축 값 숨김 기본값
  }) : super(key: key);

  /// 기본 샘플 범위를 사용하여 차트를 생성하는 편의 생성자
  ///
  /// [ranges] 대신 이 생성자를 사용하면 기본 샘플 범위가 자동으로 적용됩니다.
  factory BloodPressureRangeChart.withSampleRanges({
    Key? key,
    required double pointerXValue,
    String chartTitle = '',
    String currentValueLabel = '나의 건강상태',
    List<double> yAxisRange = const [40, 120],
    double? pointerYValue,
    List<double> rangeCoordinates = const [
      40.0,
      60.0,
      80.0,
      85.0,
      90.0,
      100.0,
      120.0,
    ],
    double aspectRatio = 2.0,
    double chartHeightRatio = 0.7,
    bool showYAxisValues = true,
    double yOffset = 0.0,
    List<double> hideSpecificYValues = const [],
  }) {
    return BloodPressureRangeChart(
      key: key,
      ranges: PressureRange.getSampleRanges(),
      pointerXValue: pointerXValue,
      chartTitle: chartTitle,
      currentValueLabel: currentValueLabel,
      yAxisRange: yAxisRange,
      pointerYValue: pointerYValue,
      rangeCoordinates: rangeCoordinates,
      aspectRatio: aspectRatio,
      chartHeightRatio: chartHeightRatio,
      showYAxisValues: showYAxisValues,
      yOffset: yOffset,
      hideSpecificYValues: hideSpecificYValues,
    );
  }

  @override
  State<BloodPressureRangeChart> createState() =>
      _BloodPressureRangeChartState();
}

class _BloodPressureRangeChartState extends State<BloodPressureRangeChart> {
  late double _yAxisValue;
  late double _minYValue;
  late double _maxYValue;

  @override
  void initState() {
    super.initState();
    _minYValue = widget.yAxisRange[0];
    _maxYValue = widget.yAxisRange[1];
    _yAxisValue = (_minYValue + _maxYValue) / 2; // 초기값을 범위의 중간값으로 설정
  }

  @override
  void didUpdateWidget(BloodPressureRangeChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.yAxisRange != widget.yAxisRange) {
      _minYValue = widget.yAxisRange[0];
      _maxYValue = widget.yAxisRange[1];
      _yAxisValue = (_minYValue + _maxYValue) / 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 좌표가 최소 2개 이상인지 확인하고, 오름차순으로 정렬되어 있는지 확인
    assert(
      widget.rangeCoordinates.length >= 2,
      'rangeCoordinates must have at least 2 values',
    );
    assert(() {
      for (int i = 0; i < widget.rangeCoordinates.length - 1; i++) {
        if (widget.rangeCoordinates[i] >= widget.rangeCoordinates[i + 1]) {
          return false;
        }
      }
      return true;
    }(), 'rangeCoordinates must be sorted in ascending order');

    // 포인터 Y값이 제공된 경우 범위 내 값인지 확인
    if (widget.pointerYValue != null) {
      assert(
        widget.pointerYValue! >= widget.rangeCoordinates.first &&
            widget.pointerYValue! <= widget.rangeCoordinates.last,
        'pointerYValue must be within range of rangeCoordinates',
      );
    }

    // 사용할 Y축 값 결정 (pointerYValue가 제공되면 그 값 사용, 아니면 슬라이더 값 사용)
    final double effectiveYAxisValue = widget.pointerYValue ?? _yAxisValue;

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
          aspectRatio: widget.aspectRatio,
          child: CustomPaint(
            painter: BloodPressureRangePainter(
              ranges: widget.ranges,
              pointerXValue: widget.pointerXValue,
              currentValueLabel: widget.currentValueLabel,
              yAxisValue: effectiveYAxisValue,
              minYValue: _minYValue,
              maxYValue: _maxYValue,
              rangeCoordinates: widget.rangeCoordinates,
              chartHeightRatio: widget.chartHeightRatio,
              showYAxisValues: widget.showYAxisValues,
              yOffset: widget.yOffset,
              hideSpecificYValues: widget.hideSpecificYValues,
            ),
          ),
        ),
        // Y축 슬라이더 추가 - pointerYValue가 제공되지 않은 경우에만 표시
        if (widget.pointerYValue == null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: _buildYAxisSlider(),
          ),
      ],
    );
  }

  Widget _buildYAxisSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '나의 건강상태 Y축 위치: ${_yAxisValue.toInt()}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              _minYValue.toInt().toString(),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Expanded(
              child: Slider(
                value: _yAxisValue,
                min: _minYValue,
                max: _maxYValue,
                divisions: (_maxYValue - _minYValue).toInt(),
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    _yAxisValue = value;
                  });
                },
              ),
            ),
            Text(
              _maxYValue.toInt().toString(),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class BloodPressureRangePainter extends CustomPainter {
  final List<PressureRange> ranges;
  final double pointerXValue;
  final String currentValueLabel;
  final double yAxisValue;
  final double minYValue;
  final double maxYValue;
  final List<double> rangeCoordinates; // 혈압 좌표 범위 추가
  final double chartHeightRatio; // 차트 영역 높이 비율
  final bool showYAxisValues; // Y축 값 표시 여부
  final double yOffset; // Y축 값의 오프셋
  final List<double> hideSpecificYValues; // 특정 Y축 값을 숨길 목록

  BloodPressureRangePainter({
    required this.ranges,
    required this.pointerXValue,
    required this.currentValueLabel,
    required this.yAxisValue,
    required this.minYValue,
    required this.maxYValue,
    required this.rangeCoordinates,
    this.chartHeightRatio = 0.7,
    this.showYAxisValues = true,
    this.yOffset = 0.0,
    this.hideSpecificYValues = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 범위가 없으면 그리지 않음
    if (ranges.isEmpty) return;

    final double chartHeight = size.height * chartHeightRatio; // 차트 높이 비율 적용
    final double chartTop =
        size.height * ((1 - chartHeightRatio) / 2); // 중앙 정렬을 위한 상단 여백 계산
    final double chartBottom = chartTop + chartHeight;

    // 혈압 범위를 구분하는 값들 - 외부에서 전달받은 좌표 사용
    final List<double> rangeValues = rangeCoordinates;
    final int totalRanges = rangeValues.length - 1; // 총 구간 개수
    final double heightPerRange = chartHeight / totalRanges; // 각 구간당 동일한 높이

    // Y값을 픽셀 위치로 매핑하는 함수 추가
    double _mapYValueToPixel(double yValue) {
      // 경계값 처리
      if (yValue <= rangeValues.first) return chartBottom;
      if (yValue >= rangeValues.last) return chartBottom - chartHeight;

      // 해당 값이 속한 구간 찾기
      int rangeIndex = 0;
      for (int i = 0; i < rangeValues.length - 1; i++) {
        if (yValue >= rangeValues[i] && yValue <= rangeValues[i + 1]) {
          rangeIndex = i;
          break;
        }
      }

      // 구간 내에서의 비율 계산 (0~1 사이 값)
      double rangeStart = rangeValues[rangeIndex];
      double rangeEnd = rangeValues[rangeIndex + 1];
      double ratioInRange = (yValue - rangeStart) / (rangeEnd - rangeStart);

      // 픽셀 위치 계산 (구간의 시작 위치 + 구간 내 비율에 따른 오프셋)
      double startY = chartBottom - (rangeIndex * heightPerRange);
      double endY = startY - heightPerRange;
      return startY - (ratioInRange * (startY - endY));
    }

    // X값을 픽셀 위치로 매핑하는 함수 추가 (비율 기반)
    double mapXValueToPixel(
      double xValue,
      double chartLeft,
      double chartWidth,
    ) {
      // X축 범위 비율 정의 (저혈압:정상:주의혈압:고혈압 전단계:제1기 고혈압:제2기 고혈압 = 4:1:1:1:1:1)
      final List<int> xRatios = [4, 1, 1, 1, 1, 1]; // 각 구간의 상대적 너비 비율
      final int totalRatio = xRatios.reduce((a, b) => a + b); // 총 비율 합계 (9)

      // ranges를 maxValue 기준으로 정렬
      final sortedRanges = List<PressureRange>.from(ranges)
        ..sort((a, b) => a.maxValue.compareTo(b.maxValue));

      // 각 구간의 경계값 (maxValue) 추출
      final List<double> boundaries =
          sortedRanges.map((r) => r.maxValue).toList();

      // 최소값이 0이 아닌 경우 추가
      final double minXValue = sortedRanges
          .map((r) => r.minValue)
          .reduce((a, b) => a < b ? a : b);
      if (!boundaries.contains(minXValue)) {
        boundaries.insert(0, minXValue);
      }

      // 경계값 처리
      if (xValue <= boundaries.first) return chartLeft;
      if (xValue >= boundaries.last) return chartLeft + chartWidth;

      // 해당 값이 속한 구간 찾기
      int rangeIndex = 0;
      for (int i = 0; i < boundaries.length - 1; i++) {
        if (xValue >= boundaries[i] && xValue <= boundaries[i + 1]) {
          rangeIndex = i;
          break;
        }
      }

      // 각 구간의 너비 계산
      final List<double> segmentWidths = [];
      for (int i = 0; i < xRatios.length; i++) {
        segmentWidths.add((xRatios[i] / totalRatio) * chartWidth);
      }

      // 구간 시작 위치 계산
      double startX = chartLeft;
      for (int i = 0; i < rangeIndex; i++) {
        startX += segmentWidths[i];
      }

      // 구간 내에서의 비율 계산 (0~1 사이 값)
      double rangeStart = boundaries[rangeIndex];
      double rangeEnd = boundaries[rangeIndex + 1];
      double ratioInRange = (xValue - rangeStart) / (rangeEnd - rangeStart);

      // 픽셀 위치 계산
      return startX + (ratioInRange * segmentWidths[rangeIndex]);
    }

    // y축 범위 계산 - PressureRange의 yValue에서 계산
    double minYValue = 40.0; // 항상 40으로 고정
    double maxYValue = 0.0;

    for (var range in ranges) {
      if (range.yValue > maxYValue) maxYValue = range.yValue;
    }

    // y축 범위가 계산되지 않은 경우 기본값 설정
    if (maxYValue == 0.0) maxYValue = 120.0;

    // 여백 추가 (최고값에만 적용)
    maxYValue = maxYValue;

    final double yValueRange = maxYValue - minYValue;

    // x축 범위 계산 - ranges에서 동적으로 계산
    double minXValue = double.infinity;
    double maxXValue = 0.0;

    for (var range in ranges) {
      if (range.minValue < minXValue) minXValue = range.minValue;
      if (range.maxValue > maxXValue) maxXValue = range.maxValue;
    }

    // x축 범위가 계산되지 않은 경우 기본값 설정
    if (minXValue == double.infinity) minXValue = 0.0;
    if (maxXValue == 0.0) maxXValue = 200.0;

    final double xValueRange = maxXValue - minXValue;

    // Y축 값 표시 여부에 따라 좌측 여백 조정
    final double leftPadding =
        showYAxisValues ? 100.0 : 30.0; // Y축 값이 없으면 좌측 여백 줄임
    // 차트 오른쪽 여백 (최고 텍스트 공간)
    const double rightPadding = 10.0; // 최소 여백으로 줄임

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

    // 클리핑 패스 생성 (전체 차트 영역을 16 radius로 클리핑)
    canvas.save();
    final Path clipPath = Path()..addRRect(chartBackgroundRect);
    canvas.clipPath(clipPath);

    // 범위를 yValue 기준으로 정렬 (높은 값부터 낮은 값 순으로)
    final List<PressureRange> sortedRanges = List.from(ranges)
      ..sort((a, b) => b.yValue.compareTo(a.yValue));

    // 범위 막대 그리기 - yValue가 높은 값부터 낮은 값 순으로 그림
    for (int i = 0; i < sortedRanges.length; i++) {
      final range = sortedRanges[i];

      // 범위의 픽셀 위치 계산 (X축) - 수정된 매핑 함수 사용
      double rangeEndX;

      // 가장 높은 값의 범위(제2기 고혈압)는 우측 끝까지 확장
      if (i == 0) {
        rangeEndX = chartRight;
      } else {
        rangeEndX = mapXValueToPixel(range.maxValue, chartLeft, chartWidth);
      }

      final double rangeWidth = rangeEndX - chartLeft;

      // Y값을 기준으로 높이 계산 (Y축) - 수정된 매핑 함수 사용
      final double rangeTop = _mapYValueToPixel(range.yValue);

      // 범위 막대 그리기 (바닥부터 현재 높이까지)
      final Paint rangePaint =
          Paint()
            ..color = range.color
            ..style = PaintingStyle.fill;

      // 우측 상단 모서리에만 radius 적용
      final RRect rangeRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(chartLeft, rangeTop, rangeWidth, chartBottom - rangeTop),
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
      rangeValues,
      totalRanges,
      heightPerRange,
    );

    // X축 값 그리기
    _drawXAxisValues(
      canvas,
      chartLeft,
      chartRight,
      chartBottom,
      chartWidth,
      minXValue,
      maxXValue,
    );

    // Y축 값 그리기 (showYAxisValues가 true인 경우에만)
    if (showYAxisValues) {
      _drawYAxisValues(
        canvas,
        chartTop,
        chartHeight,
        chartLeft,
        minYValue,
        maxYValue,
        rangeValues,
        totalRanges,
        heightPerRange,
        yOffset,
        hideSpecificYValues,
      );
    }

    // 현재 값 표시 - X축 위치 계산 - 수정된 매핑 함수 사용
    final double currentX = mapXValueToPixel(
      pointerXValue,
      chartLeft,
      chartWidth,
    );

    // Y축 슬라이더 값에 따른 Y축 위치 계산 - 수정된 매핑 함수 사용
    final double circleCenterY = _mapYValueToPixel(yAxisValue);
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
    canvas.drawCircle(Offset(currentX + 3, circleCenterY + 3), 20, shadowPaint);

    // 흰색 원과 구멍 그리기 (그림자 없음)
    final Paint currentPointPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    // SaveLayer를 사용하여 정확히 구멍을 뚫기
    final Rect circleRect = Rect.fromCircle(
      center: Offset(currentX, circleCenterY),
      radius: 25, // 약간 더 큰 영역을 확보
    );

    canvas.saveLayer(circleRect, Paint());

    // 바깥 원 그리기
    canvas.drawCircle(Offset(currentX, circleCenterY), 20, currentPointPaint);

    // 구멍을 뚫기 위한 Paint
    final Paint holePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.clear;

    // 중앙에 구멍 뚫기
    canvas.drawCircle(Offset(currentX, circleCenterY), 7, holePaint);

    canvas.restore();

    // 테두리 그리기
    final Paint currentPointBorderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    canvas.drawCircle(
      Offset(currentX, circleCenterY),
      20,
      currentPointBorderPaint,
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
    List<double> rangeValues,
    int totalRanges,
    double heightPerRange,
  ) {
    // Y값을 픽셀 위치로 매핑하는 함수 추가 - 외부 함수에 접근하기 위한 클로저
    double mapYValueToPixel(double yValue) {
      // 경계값 처리
      if (yValue <= rangeValues.first) return chartTop + chartHeight;
      if (yValue >= rangeValues.last) return chartTop;

      // 해당 값이 속한 구간 찾기
      int rangeIndex = 0;
      for (int i = 0; i < rangeValues.length - 1; i++) {
        if (yValue >= rangeValues[i] && yValue <= rangeValues[i + 1]) {
          rangeIndex = i;
          break;
        }
      }

      // 구간 내에서의 비율 계산 (0~1 사이 값)
      double rangeStart = rangeValues[rangeIndex];
      double rangeEnd = rangeValues[rangeIndex + 1];
      double ratioInRange = (yValue - rangeStart) / (rangeEnd - rangeStart);

      // 픽셀 위치 계산 (구간의 시작 위치 + 구간 내 비율에 따른 오프셋)
      double startY = chartTop + chartHeight - (rangeIndex * heightPerRange);
      double endY = startY - heightPerRange;
      return startY - (ratioInRange * (startY - endY));
    }

    // 범위를 yValue 기준으로 정렬 (낮은 값부터 높은 값 순으로)
    final List<PressureRange> sortedRanges = List.from(ranges)
      ..sort((a, b) => a.yValue.compareTo(b.yValue));

    for (int i = 0; i < sortedRanges.length; i++) {
      final range = sortedRanges[i];

      // 각 범위의 중간 위치 계산
      double y;
      if (i == 0) {
        // 첫 번째 범위 (저혈압) - 최저값과 현재 값의 중간
        double midValue = (minYValue + range.yValue) / 2;
        y = mapYValueToPixel(midValue);
      } else {
        // 중간 범위들 - 이전 범위와 현재 범위의 중간
        double midValue = (sortedRanges[i - 1].yValue + range.yValue) / 2;
        y = mapYValueToPixel(midValue);
      }

      // 좌측 패딩을 24픽셀로 변경
      final double textLeftPadding = 24.0;

      _drawText(
        canvas: canvas,
        text: range.label,
        position: Offset(chartLeft + textLeftPadding, y),
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        alignment: Alignment.centerLeft,
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
    // 말풍선 그림자 먼저 그리기
    final bubbleShadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // 그림자용 경로 만들기 (몸체 + 삼각형)
    final Path shadowPath = Path();

    // 그림자 위치 약간 오프셋 적용 (아래로 3픽셀, 오른쪽으로 3픽셀)
    final shadowOffset = 3.0;

    // 그림자 몸체 - 둥근 모서리 직사각형
    final RRect shadowRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        position.dx - bubbleWidth / 2 + shadowOffset,
        position.dy - bubbleHeight / 2 + shadowOffset,
        bubbleWidth,
        bubbleHeight,
      ),
      const Radius.circular(60),
    );

    // 그림자 몸체 추가
    shadowPath.addRRect(shadowRect);

    // 그림자 삼각형 부분 추가
    final double shadowTriangleWidth = 20.0; // 삼각형 너비
    final double shadowTriangleTop =
        position.dy + bubbleHeight / 2 + shadowOffset;
    final double shadowTriangleBottom = shadowTriangleTop + triangleHeight;

    // 삼각형 경로
    shadowPath.moveTo(
      position.dx - shadowTriangleWidth / 2 + shadowOffset,
      shadowTriangleTop,
    );
    shadowPath.lineTo(position.dx + shadowOffset, shadowTriangleBottom);
    shadowPath.lineTo(
      position.dx + shadowTriangleWidth / 2 + shadowOffset,
      shadowTriangleTop,
    );

    // 그림자 그리기
    canvas.drawPath(shadowPath, bubbleShadowPaint);

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
    List<double> rangeValues,
    int totalRanges,
    double heightPerRange,
  ) {
    // Y값을 픽셀 위치로 매핑하는 함수 추가 - 외부 함수에 접근하기 위한 클로저
    double mapYValueToPixel(double yValue) {
      // 경계값 처리
      if (yValue <= rangeValues.first) return chartTop + chartHeight;
      if (yValue >= rangeValues.last) return chartTop;

      // 해당 값이 속한 구간 찾기
      int rangeIndex = 0;
      for (int i = 0; i < rangeValues.length - 1; i++) {
        if (yValue >= rangeValues[i] && yValue <= rangeValues[i + 1]) {
          rangeIndex = i;
          break;
        }
      }

      // 구간 내에서의 비율 계산 (0~1 사이 값)
      double rangeStart = rangeValues[rangeIndex];
      double rangeEnd = rangeValues[rangeIndex + 1];
      double ratioInRange = (yValue - rangeStart) / (rangeEnd - rangeStart);

      // 픽셀 위치 계산 (구간의 시작 위치 + 구간 내 비율에 따른 오프셋)
      double startY = chartTop + chartHeight - (rangeIndex * heightPerRange);
      double endY = startY - heightPerRange;
      return startY - (ratioInRange * (startY - endY));
    }

    final Paint gridPaint =
        Paint()
          ..color = Colors.grey.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    for (double value in rangeValues) {
      // 값의 상대적 위치 계산 - 수정된 매핑 함수 사용
      final double y = mapYValueToPixel(value);

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

  // Y축 값 그리기
  void _drawYAxisValues(
    Canvas canvas,
    double chartTop,
    double chartHeight,
    double chartLeft,
    double minYValue,
    double maxYValue,
    List<double> rangeValues,
    int totalRanges,
    double heightPerRange,
    double yOffset,
    List<double> hideSpecificYValues,
  ) {
    // Y값을 픽셀 위치로 매핑하는 함수 추가 - 외부 함수에 접근하기 위한 클로저
    double mapYValueToPixel(double yValue) {
      // 경계값 처리
      if (yValue <= rangeValues.first) return chartTop + chartHeight;
      if (yValue >= rangeValues.last) return chartTop;

      // 해당 값이 속한 구간 찾기
      int rangeIndex = 0;
      for (int i = 0; i < rangeValues.length - 1; i++) {
        if (yValue >= rangeValues[i] && yValue <= rangeValues[i + 1]) {
          rangeIndex = i;
          break;
        }
      }

      // 구간 내에서의 비율 계산 (0~1 사이 값)
      double rangeStart = rangeValues[rangeIndex];
      double rangeEnd = rangeValues[rangeIndex + 1];
      double ratioInRange = (yValue - rangeStart) / (rangeEnd - rangeStart);

      // 픽셀 위치 계산 (구간의 시작 위치 + 구간 내 비율에 따른 오프셋)
      double startY = chartTop + chartHeight - (rangeIndex * heightPerRange);
      double endY = startY - heightPerRange;
      return startY - (ratioInRange * (startY - endY));
    }

    // 각 범위의 Y값과 hideYValue 상태를 매핑하는 맵 생성
    Map<double, bool> hideValueMap = {};
    for (var range in ranges) {
      hideValueMap[range.yValue] = range.hideYValue;
    }

    // 지정된 값들을 사용
    for (int i = 0; i < rangeValues.length; i++) {
      double value = rangeValues[i];

      // 0 값은 표시하지 않음
      if (value == 0 || value == 40) continue;

      // hideYValue가 true인 값은 표시하지 않음 (해당 값이 맵에 있는 경우)
      if (hideValueMap.containsKey(value) && hideValueMap[value] == true)
        continue;

      // hideSpecificYValues에 포함된 값은 표시하지 않음
      if (hideSpecificYValues.contains(value)) continue;

      // 값의 상대적 위치 계산 - 수정된 매핑 함수 사용
      final double y = mapYValueToPixel(value);

      // yOffset 값 적용 (yOffset 값만큼 위치 조정)
      final double yPos = y + yOffset;

      // 가장 높은 값(마지막 값)인 경우 "최저"로 표시
      String displayText =
          (i == rangeValues.length - 1) ? "최저" : value.toInt().toString();

      // 텍스트와 그래프 사이 간격을 충분히 확보하고, 좌측 여백 제거
      _drawText(
        canvas: canvas,
        text: displayText,
        position: Offset(15, yPos),
        fontSize: 30,
        color: Colors.grey,
        alignment: Alignment.centerRight,
      );
    }
  }

  // X축 값 그리기
  void _drawXAxisValues(
    Canvas canvas,
    double chartLeft,
    double chartRight,
    double chartBottom,
    double chartWidth,
    double minXValue,
    double maxXValue,
  ) {
    // X값을 픽셀 위치로 매핑하는 함수 추가 - 외부 함수에 접근하기 위한 클로저
    double mapXValueToPixel(
      double xValue,
      double chartLeft,
      double chartWidth,
    ) {
      // X축 범위 비율 정의 (저혈압:정상:주의혈압:고혈압 전단계:제1기 고혈압:제2기 고혈압 = 4:1:1:1:1:1)
      final List<int> xRatios = [4, 1, 1, 1, 1, 1]; // 각 구간의 상대적 너비 비율
      final int totalRatio = xRatios.reduce((a, b) => a + b); // 총 비율 합계 (9)

      // ranges를 maxValue 기준으로 정렬
      final sortedRanges = List<PressureRange>.from(ranges)
        ..sort((a, b) => a.maxValue.compareTo(b.maxValue));

      // 각 구간의 경계값 (maxValue) 추출
      final List<double> boundaries =
          sortedRanges.map((r) => r.maxValue).toList();

      // 최소값이 0이 아닌 경우 추가
      final double minXValue = sortedRanges
          .map((r) => r.minValue)
          .reduce((a, b) => a < b ? a : b);
      if (!boundaries.contains(minXValue)) {
        boundaries.insert(0, minXValue);
      }

      // 경계값 처리
      if (xValue <= boundaries.first) return chartLeft;
      if (xValue >= boundaries.last) return chartLeft + chartWidth;

      // 해당 값이 속한 구간 찾기
      int rangeIndex = 0;
      for (int i = 0; i < boundaries.length - 1; i++) {
        if (xValue >= boundaries[i] && xValue <= boundaries[i + 1]) {
          rangeIndex = i;
          break;
        }
      }

      // 각 구간의 너비 계산
      final List<double> segmentWidths = [];
      for (int i = 0; i < xRatios.length; i++) {
        segmentWidths.add((xRatios[i] / totalRatio) * chartWidth);
      }

      // 구간 시작 위치 계산
      double startX = chartLeft;
      for (int i = 0; i < rangeIndex; i++) {
        startX += segmentWidths[i];
      }

      // 구간 내에서의 비율 계산 (0~1 사이 값)
      double rangeStart = boundaries[rangeIndex];
      double rangeEnd = boundaries[rangeIndex + 1];
      double ratioInRange = (xValue - rangeStart) / (rangeEnd - rangeStart);

      // 픽셀 위치 계산
      return startX + (ratioInRange * segmentWidths[rangeIndex]);
    }

    // 범위 maxValue 값들을 X축에 표시
    // 1. maxValue 값들을 정렬하고 중복 제거
    final List<double> xValues = [];

    // 범위 maxValue 정렬
    List<PressureRange> sortedRanges = [...ranges];
    sortedRanges.sort((a, b) => a.maxValue.compareTo(b.maxValue));

    // 중복 없는 maxValue 값들 수집
    for (final range in sortedRanges) {
      if (!xValues.contains(range.maxValue)) {
        xValues.add(range.maxValue);
      }
    }

    // 최소값이 존재하지 않으면 추가
    if (xValues.isEmpty || xValues.first > minXValue) {
      xValues.insert(0, minXValue);
    }

    // 각 값에 대해 라벨 그리기
    for (int i = 0; i < xValues.length; i++) {
      double xValue = xValues[i];

      // 0 값은 표시하지 않음
      if (xValue == 0) continue;

      // 최대값(마지막 값)인 경우 "최고"로 표시
      String displayText =
          (i == xValues.length - 1) ? "최고" : xValue.toStringAsFixed(0);

      // X축 값 위치 계산 및 조정
      double xPos;
      double textOffset = -15.0; // 기본 좌측 오프셋

      if (i == xValues.length - 1) {
        // 마지막 값("최고")은 차트 오른쪽 끝에 배치
        xPos = chartRight;
        textOffset = -30.0; // 최고 텍스트는 더 왼쪽으로 이동
      } else {
        // 나머지 값들은 각 범위의 maxValue 위치에 배치
        xPos = mapXValueToPixel(xValue, chartLeft, chartWidth);
      }

      _drawText(
        canvas: canvas,
        text: displayText,
        position: Offset(xPos + textOffset, chartBottom + 30),
        fontSize: 30,
        color: const Color(0xFF999999),
        fontWeight: FontWeight.normal,
        alignment: Alignment.center,
      );
    }
  }

  @override
  bool shouldRepaint(BloodPressureRangePainter oldDelegate) {
    return oldDelegate.ranges != ranges ||
        oldDelegate.pointerXValue != pointerXValue ||
        oldDelegate.currentValueLabel != currentValueLabel ||
        oldDelegate.yAxisValue != yAxisValue ||
        oldDelegate.minYValue != minYValue ||
        oldDelegate.maxYValue != maxYValue ||
        oldDelegate.rangeCoordinates != rangeCoordinates ||
        oldDelegate.showYAxisValues != showYAxisValues ||
        oldDelegate.yOffset != yOffset ||
        oldDelegate.hideSpecificYValues != hideSpecificYValues;
  }
}

class PressureRange {
  final double minValue;
  final double maxValue;
  final String label;
  final Color color;
  final double yValue; // Y축 값 추가
  final bool hideYValue; // Y축 값을 숨길지 여부

  PressureRange({
    required this.minValue,
    required this.maxValue,
    required this.label,
    required this.color,
    required this.yValue, // Y축 값 필수 파라미터로 추가
    this.hideYValue = false, // 기본값은 false (표시)
  });

  // 예제 데이터 생성
  static List<PressureRange> getSampleRanges() {
    return [
      PressureRange(
        minValue: 0,
        maxValue: 200,
        yValue: 120,
        label: '제2기 고혈압',
        color: const Color(0xFFef193d), // 빨간색
      ),
      PressureRange(
        minValue: 0,
        maxValue: 160,
        label: '제1기 고혈압',
        color: const Color(0xFFf97901), // 주황색
        yValue: 100, // Y축 값 추가
        hideYValue: false, // 이 값은 표시
      ),
      PressureRange(
        minValue: 0,
        maxValue: 140,
        yValue: 90,
        label: '고혈압 전단계',
        color: const Color(0xFFffc219), // 노란색
      ),
      PressureRange(
        minValue: 0,
        maxValue: 130,
        yValue: 85,
        label: '주의혈압',
        color: const Color(0xFFa5d610), // 연두색
        hideYValue: false, // 이 값은 표시되도록 변경
      ),
      PressureRange(
        minValue: 0,
        maxValue: 120,
        yValue: 80, // Y축 값 추가
        label: '정상',
        color: const Color(0xFF62ba0b), // 초록색
      ),
      PressureRange(
        minValue: 0,
        maxValue: 90,
        yValue: 60, // Y축 값 추가
        label: '저혈압',
        color: const Color(0xFF1e92df), // 파란색
      ),
    ];
  }
}
