import 'package:flutter/material.dart';
import 'package:hc_flutter_graph/linear_chart.dart';

class GripStrengthExample extends StatelessWidget {
  const GripStrengthExample({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LinearChartData> data = [
      // LinearChartData(date: "24.12.01", value: 15),
      // LinearChartData(date: "24.12.01", value: 35.4),
      LinearChartData(date: "24.12.01", value: 21.0),
      LinearChartData(date: "24.12.01", value: 42.0),
      LinearChartData(date: "24.12.01", value: 35.220),
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
                leftPadding: 100,
                rightPadding: 100,
                legendLabel: "평균 값",
                secondLegendLabel: "고혈압",
                thirdLegendLabel: "asdasd",
                averageValue: 30,
                height:
                    MediaQuery.of(context).size.height * 0.15, // 화면 높이의 60%로 설정
                fontFamily: 'SpoqaHanSansNeo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
