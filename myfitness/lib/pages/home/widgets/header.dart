import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the left Drawer instead of endDrawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff18b0e8),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Handle profile navigation here
              },
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Add Devices'),
              onTap: () {
                // Handle add devices functionality here
              },
            ),
            ListTile(
              leading: const Icon(Icons.data_usage),
              title: const Text('Data Sources'),
              onTap: () {
                // Handle data sources management here
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: const [
          AppHeader(),
          // You can add other content of your page below this
          Expanded(child: Center(child: Text('Main Content Here')))
        ],
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  const AppHeader({Key? key}) : super(key: key);

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
            top: 20,
            left: 20,
            // Wrapping IconButton in a Builder to access the correct context
            child: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    // Open the left Drawer when the menu icon is pressed
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          const Positioned(
            top: 20,
            right: 120,
            child: CircleAvatar(
              minRadius: 25,
              maxRadius: 25,
              foregroundImage: AssetImage('assets/profile.jpg'),
            ),
          ),
          Positioned(
            right: 20,
            top: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hello',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Nathey',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          )
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
