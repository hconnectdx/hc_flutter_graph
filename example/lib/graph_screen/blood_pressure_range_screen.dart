import 'package:flutter/material.dart';
import 'package:hc_flutter_graph/blood_pressure_range_chart.dart';

class BloodPressureRangeScreen extends StatefulWidget {
  const BloodPressureRangeScreen({Key? key}) : super(key: key);

  @override
  State<BloodPressureRangeScreen> createState() =>
      _BloodPressureRangeScreenState();
}

class _BloodPressureRangeScreenState extends State<BloodPressureRangeScreen> {
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
                  // 기본 설정 사용 (aspectRatio=2.0, chartHeightRatio=0.7)
                ),

                const SizedBox(height: 40),

                const Text(
                  '높은 차트 (aspectRatio=1.5, chartHeightRatio=0.8)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // 높은 차트 - aspectRatio를 낮추고, chartHeightRatio를 높임
                BloodPressureRangeChart.withSampleRanges(
                  chartTitle: '높은 차트',
                  currentValueLabel: '나의 건강상태',
                  pointerXValue: 120,
                  pointerYValue: 100,
                  chartHeightRatio: 0.5, // 차트 영역 비율 증가 (더 많은 공간 차지)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
