import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:reports/home.dart';
import 'package:reports/report.dart';
import 'package:provider/provider.dart';
import 'package:reports/serviceprovider.dart';

void main() async { WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null); 
  runApp(  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChartDataProvider()),
        ChangeNotifierProvider(create: (_) => Serviceprovider()),
      ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0; 

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ReportsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screens[_selectedIndex], 
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red[700],
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'التقارير',
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}




