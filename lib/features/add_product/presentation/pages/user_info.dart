import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  List<dynamic> _userResponses = [];
  bool _isLoading = true;
  String _errorMessage = "";

  // Fetch user responses from the API
  Future<void> _fetchUserResponses() async {
    final dio = Dio();
    const String url = 'https://api.gehnamall.com/admin/allUserResponse';

    try {
      final loginState = context.read<LoginBloc>().state;
      if (loginState is LoginSuccess) {
        final String token = loginState.login.token;

        final response = await dio.post(
          url,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        setState(() {
          _userResponses = response.data; // Assuming response is a JSON array
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Unauthorized: Please login again.";
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.message}';
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _fetchUserDetail(String userId) async {
    final dio = Dio();
    final String url = "https://api.gehnamall.com/auth/getUserDetail/$userId";

    try {
      final loginState = context.read<LoginBloc>().state;
      if (loginState is LoginSuccess) {
        final String token = loginState.login.token;

        final response = await dio.get(
          url,
          options: Options(
            headers: {
              'Authorization':
                  'Bearer $token', // Include the Authorization header
              'Content-Type': 'application/json', // Include Content-Type header
            },
          ),
        );

        if (response.statusCode == 200) {
          return response.data; // Assuming this returns the user details
        } else {
          print("Error: ${response.statusCode} - ${response.statusMessage}");
        }
      } else {
        print("User not logged in or invalid login state.");
      }
    } catch (e) {
      print("Error fetching user detail: $e");
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _fetchUserResponses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Responses'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _userResponses.length,
                  itemBuilder: (context, index) {
                    final response = _userResponses[index];
                    final product = response['product'];
                    final userId = response['userId'].toString();

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${response['name']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Mobile: ${response['mobileNumber']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Product: ${product['productName']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            if (product['categoryName'] != null)
                              Text(
                                'Category: ${product['categoryName']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Text(
                              'Weight: ${product['weight']}g',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Karat: ${product['karat']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final userDetails =
                                    await _fetchUserDetail(userId);
                                if (userDetails != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(userDetails['name'] ??
                                            "User Details"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (userDetails['email'] != null)
                                                Text(
                                                    "Email: ${userDetails['email']}"),
                                              if (userDetails['dateOfBirth'] !=
                                                  null)
                                                Text(
                                                    "DOB: ${userDetails['dateOfBirth']}"),
                                              if (userDetails['spouseDob'] !=
                                                  null)
                                                Text(
                                                    "Spouse Date: ${userDetails['spouseDob']}"),
                                              if (userDetails['address'] !=
                                                  null)
                                                Text(
                                                    "Address: ${userDetails['address']}"),
                                              if (userDetails['pincode'] !=
                                                  null)
                                                Text(
                                                    "Pincode: ${userDetails['pincode']}"),
                                              if (userDetails['anniversary'] !=
                                                  null)
                                                Text(
                                                    "Anniversary: ${userDetails['anniversary']}"),
                                              if (userDetails['image'] != null)
                                                Image.network(
                                                    userDetails['image']),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Close"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  print('userid not found');
                                }
                              },
                              child: const Text("View More Detail"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
