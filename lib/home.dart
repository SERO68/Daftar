import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reports/earningcard.dart';
import 'package:reports/linechart.dart';
import 'package:reports/serviceprovider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String getFormattedDate(DateTime date) {
    return DateFormat('dd MMMM ', 'ar').format(date); // Example: "12 سبتمبر"
  }

  String getMonthName(DateTime date) {
    return DateFormat('MMMM', 'ar').format(date); // Example: "سبتمبر"
  }

String getWeekNumberOfMonth(DateTime date) {
  int weekOfMonth = ((date.day - 1) / 7).floor() + 1;
  String monthName = DateFormat('MMMM', 'ar').format(date); // Get month name in Arabic
  return 'الأسبوع $weekOfMonth من $monthName'; // "Week X of [Month]" in Arabic
}


  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now(); // Get the current date
    String currentMonth = getMonthName(today); // Get the current month in Arabic

    return Column(
      children: [
        Container(height: 30, color: Colors.red[700], width: double.infinity,),
        Container(
          color: Colors.red[700],
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 1,),
              Text(
                currentMonth, // Display the current month in Arabic
                style: const TextStyle(
                  color: Color.fromARGB(219, 255, 255, 255),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.red[700],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: LineChartSample(),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Consumer<ChartDataProvider>(
            builder: (context, chartDataProvider, child) {
              if (chartDataProvider.isLoading) {
                return Center(
                  child: Image.asset(
                    'assets/loading.gif',
                    width: 100.0,
                    height: 100.0,
                  ),
                );
              }

              String weekSubtitle = getWeekNumberOfMonth(today);

              return Column(
                children: [
                  EarningsCard(
                    title: 'عوائد اليوم',
                    subtitle: getFormattedDate(today),
                    earnings: '+ ${chartDataProvider.paymentsTotal.toStringAsFixed(2)} ج.م',
                    losses: '- ${chartDataProvider.losesTotal.toStringAsFixed(2)} ج.م',
                    net: '+ ${chartDataProvider.profit.toStringAsFixed(2)} ج.م',
                  ),
                  EarningsCard(
                    title: 'عوائد الأسبوع',
                    subtitle: weekSubtitle,
                    earnings: '+ ${chartDataProvider.weekPaymentsTotal.toStringAsFixed(2)} ج.م',
                    losses: '- ${chartDataProvider.weekLosesTotal.toStringAsFixed(2)} ج.م',
                    net: '+ ${chartDataProvider.weekProfit.toStringAsFixed(2)} ج.م',
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
