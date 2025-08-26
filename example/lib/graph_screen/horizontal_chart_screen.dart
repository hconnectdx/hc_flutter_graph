import 'package:flutter/material.dart';
import 'package:hc_flutter_graph/horizontal_chart.dart';

class HorizontalChartScreen extends StatelessWidget {
  const HorizontalChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수평 차트 예제'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '일반 모드',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          HorizontalChart(
            items: const [
              HorizontalBarItem(label: '나', value: 22.0),
              HorizontalBarItem(label: '20~24세\n여성', value: 20.5),
            ],
            labelWidth: 180,
            barHeight: 42,
            unitSuffix: 'cm',
            maxValue: 25,
            barRadius: 21,
            isDarkMode: false,
            fontFamily: 'SpoqaHanSansNeo',
          ),
          const SizedBox(height: 28),
          const Divider(height: 1),
          const SizedBox(height: 28),
          const Text(
            '다크 모드',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HorizontalChart(
              items: const [
                HorizontalBarItem(label: '나', value: 175.0),
                HorizontalBarItem(label: '20~24세\n여성', value: 162.5),
              ],
              labelWidth: 180,
              barHeight: 42,
              unitSuffix: 'cm',
              maxValue: 200,
              barRadius: 21,
              isDarkMode: true,
              fontFamily: 'SpoqaHanSansNeo',
            ),
          ),
        ],
      ),
    );
  }
}
