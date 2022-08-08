import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.category,
    required this.taskNo,
    required this.percent,
    Key? key,
  }) : super(key: key);

  final String category;
  final int taskNo;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        child: Container(
          height: 100,
          width: 195,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(2.0, 2.0), //(x,y)
                blurRadius: 4.0,
              ),
            ],
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '$taskNo tasks',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                LinearPercentIndicator(
                  lineHeight: 4.0,
                  percent: percent,
                  progressColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  barRadius: const Radius.circular(10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
