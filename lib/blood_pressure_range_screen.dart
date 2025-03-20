import 'package:flutter/material.dart';
import 'blood_pressure_range_chart.dart';

class BloodPressureRangeScreen extends StatefulWidget {
  const BloodPressureRangeScreen({Key? key}) : super(key: key);

  @override
  State<BloodPressureRangeScreen> createState() =>
      _BloodPressureRangeScreenState();
}

class _BloodPressureRangeScreenState extends State<BloodPressureRangeScreen> {
  // 현재 혈압 값 (기본값 130으로 설정)
  final double _currentValue = 130.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('혈압 수치 범위'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // 혈압 범위 차트
              Expanded(
                flex: 3,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BloodPressureRangeChart(
                      ranges: PressureRange.getSampleRanges(),
                      currentValue: _currentValue,
                      currentValueLabel: '나의 건강상태',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 혈압 상태 설명
              Expanded(flex: 2, child: _buildStatusDescription()),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 혈압 값에 따른 색상 반환
  Color _getColorForValue(double value) {
    final ranges = PressureRange.getSampleRanges();
    for (final range in ranges) {
      if (value >= range.minValue && value < range.maxValue) {
        return range.color;
      }
    }
    return Colors.red;
  }

  // 혈압 상태 설명 위젯
  Widget _buildStatusDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '혈압 상태: ${_getStatusForValue(_currentValue)}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _getColorForValue(_currentValue),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _getDescriptionForValue(_currentValue),
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),
        ],
      ),
    );
  }

  // 혈압 값에 따른 상태 문자열 반환
  String _getStatusForValue(double value) {
    final ranges = PressureRange.getSampleRanges();
    for (final range in ranges) {
      if (value >= range.minValue && value < range.maxValue) {
        return range.label;
      }
    }
    return '매우 높음';
  }

  // 혈압 값에 따른 설명 문자열 반환
  String _getDescriptionForValue(double value) {
    if (value < 90) {
      return '혈압이 낮은 상태입니다. 어지러움이나 피로감이 있다면 의사와 상담하세요.';
    } else if (value < 120) {
      return '정상 혈압 범위입니다. 건강한 생활 습관을 유지하세요.';
    } else if (value < 130) {
      return '약간 높은 수치입니다. 생활 습관 개선이 필요할 수 있습니다.';
    } else if (value < 140) {
      return '고혈압 전단계입니다. 식습관 개선과 운동이 필요합니다.';
    } else if (value < 160) {
      return '1기 고혈압입니다. 의사와 상담하고 적절한 조치를 취하세요.';
    } else {
      return '2기 고혈압입니다. 빠른 시일 내에 의사의 진료를 받으세요.';
    }
  }
}
