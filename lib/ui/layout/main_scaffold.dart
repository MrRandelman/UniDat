import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'header.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Row(
              children: const [
                Sidebar(),
                Expanded(child: Center(child: Text('Dashboard Area'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
