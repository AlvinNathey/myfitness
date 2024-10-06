import 'package:flutter/material.dart';
import 'package:myfitness/pages/home/widgets/activity.dart';
import 'package:myfitness/pages/home/widgets/current.dart';
import 'package:myfitness/pages/home/widgets/header.dart';
import 'package:myfitness/widgets/bottom_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),
          const CurrentPrograms(),
          const RecentActivities(),
    
          BottomNavigation(selectedIndex: 0, onItemTapped: (index) {
            switch (index) {
              case 0:
                // Do nothing, already on Home
                break;
              case 1:
                Navigator.of(context).pushReplacementNamed('/records');
                break;
              case 2:
                Navigator.of(context).pushReplacementNamed('/stats');
                break;
              case 3:
                Navigator.of(context).pushReplacementNamed('/profile');
                break;
            }
          }),
        ],
      ),
    );
  }
}
