import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfitness/pages/details/details.dart';
import 'package:myfitness/navigation/records.dart';
import 'package:myfitness/navigation/stats.dart';
import 'package:myfitness/navigation/profile.dart';
import 'package:myfitness/auth/login.dart';
import 'package:myfitness/auth/signup.dart';
import 'package:myfitness/pages/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // Set immersive mode

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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            return user != null ? const HomePage() : const LoginPage(); // Show Home if logged in, otherwise Login
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      routes: {
        '/details': (context) => const DetailsPage(),
        '/records': (context) => const Records(),
        '/stats': (context) => StatsPage(),
        '/profile': (context) => const ProfilePage(),
        '/signup': (context) => const SignupPage(),
        // Removed '/home' since we are directly using HomePage as a stream in home
      },
    );
  }
}
