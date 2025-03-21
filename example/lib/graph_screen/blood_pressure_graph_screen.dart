import 'package:flutter/material.dart';
import 'package:hc_flutter_graph/blood_pressure_chart.dart';

class BloodPressureScreen extends StatelessWidget {
  const BloodPressureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BloodPressureData> data = [
      BloodPressureData(
        date: "24.12.01",
        systolic: 122,
        diastolic: 71,
        heartRate: 90,
      ),
      BloodPressureData(
        date: "24.12.01",
        systolic: 100,
        diastolic: 70,
        heartRate: 72,
      ),
      BloodPressureData(
        date: "24.12.01",
        systolic: 140,
        diastolic: 90,
        heartRate: 115,
      ),
      BloodPressureData(
        date: "24.12.01",
        systolic: 120,
        diastolic: 100,
        heartRate: 110,
      ),
      BloodPressureData(
        date: "24.12.01",
        systolic: 140,
        diastolic: 100,
        heartRate: 130,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('혈압 그래프'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BloodPressureChart(
              data: data,
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ],
        ),
      ),
    );
  }
}
