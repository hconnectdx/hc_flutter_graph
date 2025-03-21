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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 혈압 범위 차트 - 비선형 스케일(4:1:1:1:1:1 비율) 적용
              BloodPressureRangeChart(
                // chartTitle: '혈압(mmHg)',
                ranges: PressureRange.getSampleRanges(),
                currentValueLabel: '나의 건강상태',
                // X축 값은 0~200 범위이며, 각 구간(저혈압, 정상 등)에 맞게 비선형 비율로 표시됨
                pointerXValue: 120, // 120mmHg의 위치 (주의혈압 구간)
                pointerYValue: 60, // 60의 위치 (저혈압-정상 경계)
                // 사용자 정의 범위 좌표 사용 가능 (기본값: [40, 60, 80, 90, 120])
              ),
            ],
          ),
        ),
      ),
    );
  }
}
