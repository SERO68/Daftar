// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Serviceprovider extends ChangeNotifier {
  int selectedindex = 0;
  TextEditingController text = TextEditingController();

  void setselectedindex(int index) {
    selectedindex = index;
    _searchedReport = {};
    text.clear(); 

    hasNoData = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> _reports = [];
  Map<String, dynamic> _dailyReport = {};
  Map<String, dynamic> _previousDayReport = {};
  Map<String, dynamic> _searchedReport = {}; 
  bool hasNoData = false;
  bool _isLoading = false;

  List<Map<String, dynamic>> get reports => _reports;
  Map<String, dynamic> get dailyReport => _dailyReport;
  Map<String, dynamic> get previousDayReport => _previousDayReport;
  Map<String, dynamic> get searchedReport => _searchedReport; 

  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('http://opticofficeapi.runasp.net/api/Reports/all');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _reports =
            data.map((report) => report as Map<String, dynamic>).toList();
        log('Fetched Reports Data: $_reports');
      } else {
        log('Failed to load data with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDataForPreviousDay() async {
    _isLoading = true;
    notifyListeners();

    try {
      final DateTime previousDate =
          DateTime.now().subtract(const Duration(days: 1));
      final String formattedDate = "${previousDate.toIso8601String()}";
      final String apiUrl =
          'http://opticofficeapi.runasp.net/api/Reports/byday?time=$formattedDate';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        _previousDayReport = json.decode(response.body);
        log('Data fetched successfully: $_previousDayReport');
      } else {
        log('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDailyReport() async {
    _isLoading = true;
    notifyListeners();

    try {
      const String apiUrl =
          'http://opticofficeapi.runasp.net/api/Reports/daily';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        _dailyReport = json.decode(response.body);
        log('Data fetched successfully: $_dailyReport');
      } else {
        log('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDatasearch(DateTime date) async {
    _isLoading = true;
    hasNoData = false;

    notifyListeners();
    try {
      final String formattedDate = "${date.toIso8601String()}";

      final String apiUrl =
          'http://opticofficeapi.runasp.net/api/Reports/byday?time=$formattedDate';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 204) {
        hasNoData = true;
        _searchedReport = {}; 
      } else if (response.statusCode == 200) {
        final data = response.body;
        if (data.isEmpty) {
          hasNoData = true; 
          _searchedReport = {};
        } else {
          _searchedReport = json.decode(response.body);
        }
      } else {
        hasNoData = true;
        _searchedReport = {}; 
        log('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      hasNoData = true;
      _searchedReport = {}; 
      log('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class ChartDataProvider with ChangeNotifier {
  List<FlSpot> spots = [];
  bool isLoading = true;
  List<double> profits = [];
  List<double> losses = [];
  List<double> payments = [];

  double losesTotal = 0;
  double paymentsTotal = 0;
  double profit = 0;

  double weekLosesTotal = 0;
  double weekPaymentsTotal = 0;
  double weekProfit = 0;

  ChartDataProvider() {
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    try {
      profits.clear();
      losses.clear();
      payments.clear();

      double tempTotalLoses = 0;
      double tempTotalPayments = 0;

      for (int i = 6; i >= 0; i--) {
        final DateTime date = DateTime.now().subtract(Duration(days: i));
        final String formattedDate =
            date.toIso8601String().split('T')[0] + 'T00:00:00.0000000';
        final String apiUrl =
            'http://opticofficeapi.runasp.net/api/Reports/byday?time=$formattedDate';
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          if (data.isNotEmpty) {
            double dailyPaymentsTotal = data[0]['paymentsTotal'] ?? 0.0;
            double dailyLosesTotal = data[0]['losesTotal'] ?? 0.0;
            double dailyProfit = dailyPaymentsTotal - dailyLosesTotal;

            profits.add(dailyProfit);
            losses.add(dailyLosesTotal);
            payments.add(dailyPaymentsTotal);

            tempTotalLoses += dailyLosesTotal;
            tempTotalPayments += dailyPaymentsTotal;
          } else {
            profits.add(0.0);
            losses.add(0.0);
            payments.add(0.0);
          }
        } else {
          profits.add(0.0);
          losses.add(0.0);
          payments.add(0.0);
        }
      }

      const String todayApiUrl =
          'http://opticofficeapi.runasp.net/api/Reports/daily';
      final responseToday = await http.get(Uri.parse(todayApiUrl));

      if (responseToday.statusCode == 200) {
        final List<dynamic> data = json.decode(responseToday.body);

        if (data.isNotEmpty) {
          double todayPaymentsTotal = data[0]['paymentsTotal'] ?? 0.0;
          double todayLosesTotal = data[0]['losesTotal'] ?? 0.0;
          double todayProfit = todayPaymentsTotal - todayLosesTotal;

          profits.add(todayProfit);
          losses.add(todayLosesTotal);
          payments.add(todayPaymentsTotal);

          paymentsTotal = todayPaymentsTotal;
          losesTotal = todayLosesTotal;
          profit = todayProfit;
        } else {
          profits.add(0.0);
          losses.add(0.0);
          payments.add(0.0);
        }
      } else {
        profits.add(0.0);
        losses.add(0.0);
        payments.add(0.0);
      }

      weekLosesTotal = tempTotalLoses;
      weekPaymentsTotal = tempTotalPayments;
      weekProfit = tempTotalPayments - tempTotalLoses;

      spots = profits
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
          .toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      log('Error fetching data: $e');
      isLoading = false;
      notifyListeners();
    }
  }
}
