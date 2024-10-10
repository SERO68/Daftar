import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reports/serviceprovider.dart';
import 'package:reports/fillterbuttons.dart';
import 'package:reports/reportbox.dart';
import 'package:reports/search.dart';
import 'package:intl/intl.dart' as intl;

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5), 
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'التقارير اليومية',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Search(),
              const SizedBox(height: 20),
              const Filtter(), 
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<Serviceprovider>(
                  builder: (context, serviceprovider, child) {
                         if (serviceprovider.isLoading) {
                      return  Center(child: Center(
                  child: Image.asset(
                    'assets/loading.gif',
                    width: 100.0,
                    height: 100.0,
                  ),
                ));
                    }

                    if (serviceprovider.hasNoData) {
                      return const Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    List<Map<String, dynamic>> reportsToShow = [];
                    if (serviceprovider.reports.isNotEmpty &&
                        serviceprovider.selectedindex == 2) {
                      reportsToShow = serviceprovider.reports;
                    } else if (serviceprovider.dailyReport.isNotEmpty &&
                        serviceprovider.selectedindex == 0) {
                      reportsToShow = [serviceprovider.dailyReport];
                    } else if (serviceprovider.previousDayReport.isNotEmpty &&
                        serviceprovider.selectedindex == 1) {
                      reportsToShow = [serviceprovider.previousDayReport];
                    }

                    if (serviceprovider.searchedReport.isNotEmpty) {
                      reportsToShow = [serviceprovider.searchedReport];
                    }

                    if (reportsToShow.isEmpty) {
                      return const Center(
                        child: Text('No data available',
                            style: TextStyle(fontSize: 16)),
                      );
                    }

                    return ListView.builder(
                      itemCount: reportsToShow.length,
                      itemBuilder: (context, index) {
                        final report = reportsToShow[index];
                        return _buildReportContainer(report);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportContainer(Map<String, dynamic> report) {
    final DateTime reportDate = DateTime.parse(report['reportTime']);
    final List<dynamic> payments = report['payments'] ?? [];
    final List<dynamic> bills = report['bills'] ?? [];
    final List<dynamic> destroyedOptics = report['destroyedOptics'] ?? [];
    final double paymentsTotal = report['paymentsTotal'] ?? 0;
    final double losesTotal = report['losesTotal'] ?? 0;
    final double billsTotal = report['billsTotal'] ?? 0;
    final double profit = paymentsTotal - losesTotal;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromARGB(255, 198, 198, 198),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 198, 198, 198),
                width: 1,
              ),
              color: const Color.fromARGB(255, 198, 198, 198),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تقرير يومي',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  intl.DateFormat('dd/MM/yyyy').format(reportDate),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ReportBox(
                  title: 'المدفوعات',
                  subtitle: 'المبلغ المدفوع',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C853), Color(0xFF64DD17)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderColor: Colors.grey[400]!,
                  amount: '+ ${paymentsTotal} ج.م',
                  label: 'المدفوعات',
                  textColor: Colors.white,
                  textColor2: Colors.green,
                  date: 'تاريخ الدفع',
                  job: 'العميل',  datetime: reportDate, list: payments,
                ),
                const SizedBox(height: 10),
                ReportBox(
                  title: 'الفواتير',
                  subtitle: 'المبلغ المستحق',
                  gradient: const LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderColor: Colors.grey[400]!,
                  amount: '${billsTotal} ج.م',
                  label: 'الفواتير',
                  textColor: Colors.black,
                  textColor2: Colors.black,
                  date: 'تاريخ الفاتورة',
                  job: 'العميل',  datetime: reportDate, list: bills,
                ),
                const SizedBox(height: 10),
                ReportBox(
                  title: 'الخسائر',
                  subtitle: 'الخسارة',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD50000), Color(0xFFFF1744)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderColor: Colors.grey[400]!,
                  amount: '- ${losesTotal} ج.م',
                  label: 'الخسائر',
                  textColor: Colors.white,
                  textColor2: Colors.red,
                  date: 'تاريخ الخسارة',
                  job: 'الموظف',  datetime: reportDate, list: destroyedOptics,
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Colors.grey[400],
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الاجمالي',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      '${profit >= 0 ? '+' : ''} $profit ج.م',
                      style: TextStyle(
                          color: profit >= 0 ? Colors.green : Colors.red,
                          fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
