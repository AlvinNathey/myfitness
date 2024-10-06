import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex; // Track the selected index
  final Function(int) onItemTapped; // Callback function for item taps

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      color: const Color(0xff18b0e8), // Active color for the bottom navigation
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => onItemTapped(0), // Home tapped
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  color: selectedIndex == 0 ? Colors.white : const Color.fromARGB(255, 17, 17, 17),
                ),
                if (selectedIndex == 0)
                  Container(
                    height: 4,
                    width: 20,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onItemTapped(1), // Records tapped
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.library_books,
                  color: selectedIndex == 1 ? Colors.white : const Color.fromARGB(255, 17, 17, 17),
                ),
                if (selectedIndex == 1)
                  Container(
                    height: 4,
                    width: 20,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onItemTapped(2), // Stats tapped
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart,
                  color: selectedIndex == 2 ? Colors.white : const Color.fromARGB(255, 17, 17, 17),
                ),
                if (selectedIndex == 2)
                  Container(
                    height: 4,
                    width: 20,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onItemTapped(3), // Profile tapped
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: selectedIndex == 3 ? Colors.white : const Color.fromARGB(255, 17, 17, 17),
                ),
                if (selectedIndex == 3)
                  Container(
                    height: 4,
                    width: 20,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
