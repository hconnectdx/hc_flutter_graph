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

              // 혈압 범위 차트
              BloodPressureRangeChart(
                chartTitle: '혈압(mmHg)',
                ranges: PressureRange.getSampleRanges(),
                currentValueLabel: '나의 건강상태',
                pointerXValue: 30, // X축 포인터 위치 지정
                pointerYValue: 100, // Y축 포인터 위치 지정
              ),
            ],
          ),
        ),
      ),
    );
  }
}
