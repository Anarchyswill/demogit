import 'package:flutter/material.dart';

void main() {
  runApp(const CardApp());
}

class CardApp extends StatelessWidget {
  const CardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Card',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        primarySwatch: Colors.blue,
      ),
      home: const ResponsiveCardPage(),
    );
  }
}

class ResponsiveCardPage extends StatelessWidget {
  const ResponsiveCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // The LayoutBuilder is the key to creating a responsive layout.
        child: LayoutBuilder(
          builder: (context, constraints) {
            // We can check the max width of the current screen to decide the layout.
            // This is how your portfolio app handles different screen sizes.
            if (constraints.maxWidth > 600) {
              // This is the desktop layout. The Card is centered with a fixed width.
              return SizedBox(
                width: 500, // A fixed width for larger screens.
                child: _buildCard('Desktop Layout'),
              );
            } else {
              // This is the mobile layout. The Card fills the available width with padding.
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildCard('Mobile Layout'),
              );
            }
          },
        ),
      ),
    );
  }

  // A helper method to build the Card widget with its content.
  Widget _buildCard(String title) {
    return Card(
      elevation: 8.0, // Adds the elevated shadow.
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Makes the column wrap its content.
          children: [
            Text(
              'This is a responsive card!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 16.0, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
