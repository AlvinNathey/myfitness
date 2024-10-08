import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfitness/pages/details/details.dart';
import 'package:myfitness/pages/home/home.dart';
import 'package:myfitness/navigation/records.dart';
import 'package:myfitness/navigation/stats.dart';
import 'package:myfitness/navigation/profile.dart';
import 'package:myfitness/auth/login.dart';
import 'package:myfitness/auth/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeCheck(), // Authentication check widget
      routes: {
        '/details': (context) => const DetailsPage(),
        '/records': (context) => const Records(),
        '/stats': (context) => const StatsPage(),
        '/profile': (context) => const ProfilePage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class HomeCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return HomePage(); // Direct to HomePage if logged in
          } else {
            return const LoginPage(); // Go to LoginPage if not logged in
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
