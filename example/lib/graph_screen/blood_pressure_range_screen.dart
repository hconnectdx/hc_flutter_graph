import 'package:flutter/material.dart';
import 'package:hc_flutter_graph/blood_pressure_range_chart.dart';

class BloodPressureRangeScreen extends StatefulWidget {
  const BloodPressureRangeScreen({Key? key}) : super(key: key);

  @override
  State<BloodPressureRangeScreen> createState() =>
      _BloodPressureRangeScreenState();
}

class _BloodPressureRangeScreenState extends State<BloodPressureRangeScreen> {
  // Y축 값 표시 여부
  bool _showYAxisValues = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('혈압 범위 차트'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  '기본 높이 설정 (aspectRatio=2.0, chartHeightRatio=0.7)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // 기본 비율 설정 (aspectRatio=2.0, chartHeightRatio=0.7)
                BloodPressureRangeChart.withSampleRanges(
                  chartTitle: '기본 높이',
                  currentValueLabel: '나의 건강상태',
                  pointerXValue: 120,
                  pointerYValue: 60,
                  showYAxisValues: _showYAxisValues, // Y축 값 표시 여부 설정
                  fontFamily: 'SpoqaHanSansNeo',
                ),

                const SizedBox(height: 40),

                const Text(
                  '높은 차트 (aspectRatio=1.5, chartHeightRatio=0.8)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // 높은 차트 - aspectRatio를 낮추고, chartHeightRatio를 높임
                Container(
                  child: BloodPressureRangeChart.withSampleRanges(
                    chartTitle: '높은 차트',
                    currentValueLabel: '나의 건강상태',
                    pointerXValue: 120,
                    pointerYValue: 100,
                    chartHeightRatio: 0.6, // 차트 영역 비율 증가 (더 많은 공간 차지)
                    aspectRatio: 3,
                    yOffset: 0,
                    hideSpecificYValues: [80, 90],
                    fontFamily: 'SpoqaHanSansNeo',
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  '특정 Y축 값만 숨기는 차트',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // 특정 Y축 값만 숨기는 커스텀 차트
                BloodPressureRangeChart(
                  chartTitle: '특정 Y축 값만 숨기기',
                  currentValueLabel: '나의 건강상태',
                  pointerXValue: 120,
                  pointerYValue: 80,
                  fontFamily: 'SpoqaHanSansNeo',
                  // 커스텀 PressureRange 목록 생성 (일부는 hideYValue = true로 설정)
                  ranges: [
                    PressureRange(
                      minValue: 0,
                      maxValue: 200,
                      yValue: 120,
                      label: '제2기 고혈압',
                      color: const Color(0xFFef193d),
                    ),
                    PressureRange(
                      minValue: 0,
                      maxValue: 160,
                      label: '제1기 고혈압',
                      color: const Color(0xFFf97901),
                      yValue: 100,
                    ),
                    PressureRange(
                      minValue: 0,
                      maxValue: 140,
                      yValue: 90,
                      label: '고혈압 전단계',
                      color: const Color(0xFFffc219),
                    ),
                    PressureRange(
                      minValue: 0,
                      maxValue: 130,
                      yValue: 85,
                      label: '주의혈압',
                      color: const Color(0xFFa5d610),
                    ),
                    PressureRange(
                      minValue: 0,
                      maxValue: 120,
                      yValue: 80,
                      label: '정상',
                      color: const Color(0xFF62ba0b),
                    ),
                    PressureRange(
                      minValue: 0,
                      maxValue: 90,
                      yValue: 60,
                      label: '저혈압',
                      color: const Color(0xFF1e92df),
                    ),
                  ], // Y축 값 전체를 표시 (특정 값만 hideYValue로 숨김)
                ),

                const SizedBox(height: 30),

                // Y축 값 표시 여부 스위치
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Y축 값 표시',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: _showYAxisValues,
                      onChanged: (value) {
                        setState(() {
                          _showYAxisValues = value;
                        });
                      },
                    ),
                  ],
                ),

                Text(
                  _showYAxisValues ? 'Y축 값이 표시됩니다.' : 'Y축 값이 숨겨집니다.',
                  style: TextStyle(
                    fontSize: 14,
                    color: _showYAxisValues ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
