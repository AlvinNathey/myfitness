import 'package:flutter/material.dart';
import 'package:myfitness/pages/home/widgets/header.dart';
import 'package:myfitness/widgets/bottom_navigation.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: Center(
              child: const Text('Profile Page Content'),
            ),
          ),
          BottomNavigation(
            selectedIndex: 3, // Set index for Profile page
            onItemTapped: (index) {
              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacementNamed('/');
                  break;
                case 1:
                  Navigator.of(context).pushReplacementNamed('/records');
                  break;
                case 2:
                  Navigator.of(context).pushReplacementNamed('/stats');
                  break;
                case 3:
                  // Do nothing, already on Profile
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
