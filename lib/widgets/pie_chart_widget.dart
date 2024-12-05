import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final int completed;
  final int pending;

  PieChartWidget({required this.completed, required this.pending});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: completed.toDouble(),
            color: Colors.green,
            title: 'Done',
            radius: 50,
          ),
          PieChartSectionData(
            value: pending.toDouble(),
            color: Colors.red,
            title: 'Pending',
            radius: 50,
          ),
        ],
      ),
    );
  }
}
