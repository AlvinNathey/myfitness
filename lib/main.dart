import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfitness/pages/details/details.dart';
import 'package:myfitness/pages/home/home.dart'; // Ensure this is correct
import 'package:myfitness/navigation/records.dart'; // Import RecordsPage
import 'package:myfitness/navigation/stats.dart';   // Import StatsPage
import 'package:myfitness/navigation/profile.dart'; // Import ProfilePage

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // Add routes for Home, Details, Records, Stats, and Profile
      routes: {
        '/': (context) => const HomePage(),         // Default route to Home
        '/home': (context) => const HomePage(),     // Ensure the home route is defined
        '/details': (context) => const DetailsPage(),
        '/records': (context) => RecordsPage(),      // Records Page route
        '/stats': (context) => StatsPage(),          // Stats Page route
        '/profile': (context) => ProfilePage(),      // Profile Page route
      },
      initialRoute: '/', // Initial route
    );
  }
}
