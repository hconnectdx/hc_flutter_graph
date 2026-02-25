import 'package:flutter/material.dart';
import 'package:hc_flutter_graph/gauge_chart.dart';

class GaugeChartScreen extends StatelessWidget {
  const GaugeChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double _value = 26;
    return Scaffold(
      appBar: AppBar(
        title: const Text('게이지 차트'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SizedBox(
        child: Column(
          children: [
            GaugeChart(
              value: _value,
              segments: [
                GaugeSegment(
                  startValue: 14.0,
                  endValue: 18.4,
                  color: Colors.blue,
                  label: '저체중',
                ),
                GaugeSegment(
                  startValue: 18.4,
                  endValue: 23.0,
                  color: Colors.green,
                  label: '정상',
                ),
                GaugeSegment(
                  startValue: 23.0,
                  endValue: 25.0,
                  color: Colors.lime,
                  label: '과체중',
                ),
                GaugeSegment(
                  startValue: 25.0,
                  endValue: 29.9,
                  color: Colors.amber,
                  label: '1단계 비만',
                ),
                GaugeSegment(
                  startValue: 30.0,
                  endValue: 34.9,
                  color: Colors.orange,
                  label: '2단계 비만',
                ),
                GaugeSegment(
                  startValue: 35.0,
                  endValue: 40,
                  color: Colors.red,
                  label: '3단계 비만',
                ),
              ],
              labelValues: const [14.0, 18.4, 23.0, 25.0, 29.9, 34.9, 40.0],
              size: 680,
              pointerThickness: 7.5,
              thickness: 120,
              centerLabel: "BMI",
              unit: "(kg/m²)",
              centerLabelTextStyle: const TextStyle(
                fontSize: 42,
                color: Color(0xFF666666),
                letterSpacing: -0.42,
              ),
              centerUnitTextStyle: const TextStyle(
                fontSize: 42,
                color: Color(0xFF666666),
                letterSpacing: -0.42,
              ),
              valueTextStyle: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              labelTextStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              segmentLabelTextStyle: const TextStyle(
                fontSize: 18,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
              textYOffset: -140,
              fontFamily: 'SpoqaHanSansNeo',
            ),
          ],
        ),
      ),
    );
  }
}
