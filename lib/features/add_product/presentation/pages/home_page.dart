import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentBottomSheetController? _bottomSheetController;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to GehnaMall',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        actions: [
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginSuccess) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(loginData: state.login),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.blueAccent),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text(
                'Welcome to the Home Screen!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Explore, shop, and manage your products with ease.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Handle navigation or other side effects on state change
          }
        },
        builder: (context, state) {
          return BottomNavigationBar(
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add, color: Colors.green),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Others',
              ),
            ],
            onTap: (index) {
              // Close the bottom sheet if it is already open
              if (_bottomSheetController != null) {
                _bottomSheetController!.close();
                _bottomSheetController = null;
              }

              if (index == 1) {
                // Open bottom sheet
                _bottomSheetController = showBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Add'),
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet
                            Navigator.pushNamed(context, '/add_product');
                            print('Add selected');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.attach_file),
                          title: const Text('Lightweight'),
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet
                            Navigator.pushNamed(context, '/light_weight');
                            print('Lightweight selected');
                          },
                        ),
                      ],
                    );
                  },
                );
              } else if (index == 3) {
                // Navigate to Profile when the Profile tab is tapped
                if (state is LoginSuccess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        loginData: state.login, // Pass the login data
                      ),
                    ),
                  );
                }
              } 
              _bottomSheetController = showBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Banner & Testinomial'),
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet
                            Navigator.pushNamed(context, '/others');
                            print('Add selected');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.attach_file),
                          title: const Text('Lightweight'),
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet
                            Navigator.pushNamed(context, '/light_weight');
                            print('Lightweight selected');
                          },
                        ),
                      ],
                    );
                  },
                );
            },
          );
        },
      ),
    );
  }
}
