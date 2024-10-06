import 'package:flutter/material.dart';
import 'package:myfitness/pages/home/widgets/header.dart';
import 'package:myfitness/widgets/bottom_navigation.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: Center(
              child: const Text('Stats Page Content'),
            ),
          ),
          BottomNavigation(
            selectedIndex: 2, // Set index for Stats page
            onItemTapped: (index) {
              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacementNamed('/');
                  break;
                case 1:
                  Navigator.of(context).pushReplacementNamed('/records');
                  break;
                case 2:
                  // Do nothing, already on Stats
                  break;
                case 3:
                  Navigator.of(context).pushReplacementNamed('/profile');
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
