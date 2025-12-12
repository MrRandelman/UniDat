import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.grey.shade900,
      child: const Center(
        child: Text('Sidebar', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
