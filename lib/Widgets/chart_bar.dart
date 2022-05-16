import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double expenditure;
  final double percentExp;
  // final double compPer;
  ChartBar({this.label, this.expenditure, this.percentExp});
  // final compPer = 1 - percentExp;
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text('\$${expenditure.toStringAsFixed(0)}'),
              )),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            width: 10,
            height: constraints.maxHeight * 0.6,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: percentExp,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(height: constraints.maxHeight * 0.15, child: Text(label)),
        ],
      );
    }));
  }
}
