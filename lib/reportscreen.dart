import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

class Reportscreen extends StatelessWidget {
  const Reportscreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.textcolor,
    required this.date,
    required this.job,
    required this.list,
    required this.datetime,
  });

  final String title;
  final String date;
  final String job;
  final String subtitle;
  final Color textcolor;
  final List<dynamic> list;
  final DateTime datetime;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Ensure RTL for Arabic
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5), // Light background
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: list.length, // Set itemCount to the length of the list
            itemBuilder: (context, index) {
              final item = list[index]; // Get the current item from the list
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
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
                    // Job Row
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
                        children: [
                          const Icon(Icons.person_4_outlined),
                          const SizedBox(width: 5),
                          Text(
                            job,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'اسم $job',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    item['name'], // Display the name from the list
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    date,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    intl.DateFormat('dd/MM/yyyy').format(datetime),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                          ),
                          const SizedBox(height: 10),
                          // Total Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '+ ${item['price']} ج.م', // Display the price from the list
                                style: TextStyle(
                                  color: textcolor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
