import 'package:flutter/material.dart';

class Others extends StatelessWidget {
  const Others({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Others'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Enhanced Banner Section with Gradient
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    bottom: 40,
                    child: Text(
                      'Welcome to GehnaMall',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add action for the button (e.g., navigate to a page)
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Explore Now'),
                    ),
                  ),
                ],
              ),
            ),

            // Testimonial Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'What Our Customers Say',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  // List of Testimonials
                  Column(
                    children: [
                      _testimonialTile(
                        "John Doe",
                        "Amazing service and quality! Highly recommend.",
                      ),
                      _testimonialTile(
                        "Jane Smith",
                        "Love the designs and fast delivery.",
                      ),
                      _testimonialTile(
                        "Alex Johnson",
                        "Great prices and excellent customer support.",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testimonialTile(String name, String testimonial) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          testimonial,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        
      ),
    );
  }
}
