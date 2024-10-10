import 'package:flutter/material.dart';

class EarningsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String earnings;
  final String losses;
  final String net;

  const EarningsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.earnings,
    required this.losses,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side with Earnings, Losses, and Net
              Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      earnings,
                      style: const TextStyle(color: Colors.green, fontSize: 16),
                    ),
                    Text(
                      losses,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: SizedBox(
                        height: 1,
                        width: 50,
                        child: DashedLine(),
                      ),
                    ),
                    Text(
                      net,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Right side with Title, Subtitle, and الاجمالي
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'الاجمالي',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  const DashedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            (constraints.constrainWidth() / 4).floor(),
            (index) => const SizedBox(
              width: 2,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}
