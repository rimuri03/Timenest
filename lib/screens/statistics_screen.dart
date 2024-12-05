import 'package:flutter/material.dart';
import '../widgets/pie_chart_widget.dart';

class StatisticsScreen extends StatelessWidget {
  final int completed;
  final int pending;

  StatisticsScreen({required this.completed, required this.pending});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Statistics'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PieChartWidget(completed: completed, pending: pending),
        ),
      ),
    );
  }
}
