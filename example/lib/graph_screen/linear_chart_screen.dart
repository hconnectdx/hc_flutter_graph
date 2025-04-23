import 'package:flutter/material.dart';
import 'package:hc_flutter_graph/linear_chart.dart';

class GripStrengthExample extends StatelessWidget {
  const GripStrengthExample({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LinearChartData> data = [
      LinearChartData(date: "24.12.01", value: 15),
      LinearChartData(date: "24.12.01", value: 35.4),
      LinearChartData(date: "24.12.01", value: 21),
      LinearChartData(date: "24.12.01", value: 42),
      LinearChartData(date: "24.12.01", value: 35),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('악력 차트 예제'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: LinearChart(
                isDarkMode: true,
                data: data,
                legendLabel: "평균 값",
                height:
                    MediaQuery.of(context).size.height * 0.6, // 화면 높이의 60%로 설정
              ),
            ),
          ],
        ),
      ),
    );
  }
}
