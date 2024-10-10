


import 'package:flutter/material.dart';
import 'package:reports/reportscreen.dart';

class ReportBox extends StatelessWidget {
  final LinearGradient gradient;
  final Color borderColor;
  final String amount;
  final String label;
  final Color textColor;
  final Color textColor2;
  final String title;
  final String subtitle;
  final String date;
  final String job;
    final List<dynamic> list;

  final DateTime datetime;

  const ReportBox({
    super.key,
    required this.gradient,
    required this.borderColor,
    required this.amount,
    required this.label,
    required this.textColor,
    required this.title,
    required this.subtitle,
    required this.textColor2,
    required this.date,
    required this.job, required this.list, required this.datetime,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Reportscreen(
            title: title,
            subtitle: subtitle,
            textcolor: textColor2,
            date: date,
            job: job, list: list, datetime: datetime,
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
