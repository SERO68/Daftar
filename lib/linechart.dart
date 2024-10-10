import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reports/serviceprovider.dart';
import 'package:intl/intl.dart'; 

class LineChartSample extends StatelessWidget {
  const LineChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartDataProvider>(
        builder: (context, chartDataProvider, child) {
      if (chartDataProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      List<String> daysOfWeek = List.generate(8, (index) {
        DateTime date = DateTime.now().subtract(Duration(days: 7 - index));
        if (index == 7) {
          return 'Today'; 
        } else {
          return DateFormat('EEE').format(date); 
        }
      });

      return LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.2),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value >= 0 && value < daysOfWeek.length) {
                    return Text(daysOfWeek[value.toInt()],
                        style: const TextStyle(color: Colors.white, fontSize: 12));
                  } else {
                    return const Text('');
                  }
                },
                interval: 1,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false), 
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          maxX: 7,
          minY: 0,
          maxY: (chartDataProvider.spots.isEmpty
                  ? 0
                  : chartDataProvider.spots.map((e) => e.y).reduce((a, b) => a > b ? a : b)) +
              1,
          lineBarsData: [
            LineChartBarData(
              spots: chartDataProvider.spots,
              isCurved: true,
              color: Colors.white,
              barWidth: 4,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
              showingIndicators: chartDataProvider.spots.map((spot) => spot.x.toInt()).toList(),
              isStrokeCapRound: true,
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  return LineTooltipItem(
                    '${touchedSpot.y}',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {},
            handleBuiltInTouches: true,
          ),
        ),
      );
    });
  }
}
