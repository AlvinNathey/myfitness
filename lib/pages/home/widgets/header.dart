import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Stack(
        children: [
          CustomPaint(
            painter: HeaderPainter(),
            size: const Size(double.infinity, 200),
          ),
          Positioned(
            top: 2,
            left: 10,
            child: Image.asset(
              'assets/logo.png', // Replace with your logo image path
              width: 170, // Adjust width as needed for scaling
              height: 100, // Adjust height as needed for scaling
            ),
          ),
          const Positioned(
            top: 20,
            right: 90,
            child: CircleAvatar(
              minRadius: 25,
              maxRadius: 25,
              foregroundImage: AssetImage('assets/profile.jpg'), // Replace with user's profile image if available
            ),
          ),
          Positioned(
            right: 20,
            top: 16,
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid) // Fetch user document
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator while waiting for data
                }
                if (snapshot.hasError) {
                  return const Text('Error fetching user data'); // Handle error
                }
                if (snapshot.hasData && snapshot.data!.exists) {
                  String firstName = snapshot.data!['first_name'] ?? 'User'; // Retrieve first name
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        firstName, // Display first name
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                }
                return const Text('User'); // Default text if no user data
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint backColor = Paint()..color = const Color(0xff18b0e8);
    Paint circles = Paint()..color = Colors.white.withAlpha(40);

    canvas.drawRect(
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(size.width, size.height),
      ),
      backColor,
    );

    canvas.drawCircle(Offset(size.width * .65, 10), 30, circles);
    canvas.drawCircle(Offset(size.width * .60, 130), 10, circles);
    canvas.drawCircle(Offset(size.width - 10, size.height - 10), 20, circles);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
