import 'package:flutter/material.dart';
import 'package:hc_flutter_graph/grip_strength_chart.dart';

class GripStrengthExample extends StatelessWidget {
  const GripStrengthExample({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GripStrengthData> data = [
      GripStrengthData(date: "24.12.01", strength: 35),
      GripStrengthData(date: "24.12.01", strength: 35.4),
      GripStrengthData(date: "24.12.01", strength: 30),
      GripStrengthData(date: "24.12.01", strength: 32),
      GripStrengthData(date: "24.12.01", strength: 35),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('악력 차트 예제'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GripStrengthChart(data: data, legendLabel: "평균 값"),
      ),
    );
  }
}
