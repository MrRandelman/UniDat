import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.grey.shade800,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Text(
        'UniDat',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
