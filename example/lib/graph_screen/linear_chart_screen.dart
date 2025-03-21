import 'package:flutter/material.dart';
import 'package:hc_flutter_graph/linear_chart.dart';

class GripStrengthExample extends StatelessWidget {
  const GripStrengthExample({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LinearChartData> data = [
      LinearChartData(date: "24.12.01", strength: 15),
      LinearChartData(date: "24.12.01", strength: 35.4),
      LinearChartData(date: "24.12.01", strength: 21),
      LinearChartData(date: "24.12.01", strength: 42),
      LinearChartData(date: "24.12.01", strength: 35),
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
