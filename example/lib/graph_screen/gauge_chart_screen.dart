import 'package:flutter/material.dart';
import 'package:hc_flutter_graph/gauge_chart.dart';

class GaugeChartScreen extends StatelessWidget {
  const GaugeChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double _value = 13;
    final double _minValue = 0;
    final double _maxValue = 300;
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
              minValue: _minValue,
              maxValue: _maxValue,
              segments: [
                GaugeSegment(startValue: 0, endValue: 50, color: Colors.blue),
                GaugeSegment(
                  startValue: 50,
                  endValue: 100,
                  color: Colors.green,
                ),
                GaugeSegment(
                  startValue: 100,
                  endValue: 150,
                  color: Colors.lime,
                ),
                GaugeSegment(
                  startValue: 150,
                  endValue: 200,
                  color: Colors.amber,
                ),
                GaugeSegment(
                  startValue: 200,
                  endValue: 250,
                  color: Colors.orange,
                ),
                GaugeSegment(startValue: 250, endValue: 300, color: Colors.red),
              ],

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
              textYOffset: -140,
              fontFamily: 'SpoqaHanSansNeo',
            ),
          ],
        ),
      ),
    );
  }
}
