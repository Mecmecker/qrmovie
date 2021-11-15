import 'package:flutter/material.dart';
import 'package:qrmovie/models/butaca_model.dart';

class bottomRow extends StatelessWidget {
  const bottomRow({Key? key, required this.butaca}) : super(key: key);

  final List<Butaca> butaca;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 26, right: 26, bottom: 20),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Buy Ticket',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 2,
              height: 5,
            ),
            Text(
              '${(9.9 * butaca.length).toStringAsFixed(2)}€',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
