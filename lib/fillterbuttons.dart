import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reports/serviceprovider.dart';

class Filtter extends StatefulWidget {
  const Filtter({super.key});

  @override
  State<Filtter> createState() => _FiltterState();
}

class _FiltterState extends State<Filtter> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Serviceprovider>(
      builder: (context, serviceprovider, child) {
        return Row(
          children: [
            ElevatedButton(
              style: serviceprovider.selectedindex == 0
                  ? ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 254, 36, 36))
                  : ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      side: const BorderSide(color: Colors.red),
                    ),
              onPressed: () {
                setState(() {
                  serviceprovider.setselectedindex(0);
                });
                serviceprovider.fetchDailyReport();
              },
              child: Text(
                'اليوم',
                style: TextStyle(
                    color: serviceprovider.selectedindex == 0 ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: serviceprovider.selectedindex == 1
                  ? ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 254, 36, 36))
                  : ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      side: const BorderSide(color: Colors.red),
                    ),
              onPressed: () {
                setState(() {
                  serviceprovider.setselectedindex(1);
                });
                serviceprovider.fetchDataForPreviousDay();
              },
              child: Text(
                'امس',
                style: TextStyle(
                    color: serviceprovider.selectedindex == 1 ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: serviceprovider.selectedindex == 2
                  ? ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 254, 36, 36))
                  : ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      side: const BorderSide(color: Colors.red),
                    ),
              onPressed: () {
                setState(() {
                  serviceprovider.setselectedindex(2);
                });
                serviceprovider.fetchData();
              },
              child: Text(
                'الكل',
                style: TextStyle(
                    color: serviceprovider.selectedindex == 2 ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(width: 10),
          ],
        );
      },
    );
  }
}
