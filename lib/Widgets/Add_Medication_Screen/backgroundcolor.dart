import 'package:flutter/material.dart';

class backgroundcolor extends StatelessWidget {
  const backgroundcolor({super.key});

  @override
  Widget build(BuildContext context) {
    return    Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff54a7ef), Color(0xff2e2c2c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
