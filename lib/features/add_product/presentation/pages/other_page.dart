import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../bloc/login_bloc.dart'; 

class BannerAndTestimonialPage extends StatefulWidget {
  @override
  _BannerAndTestimonialPageState createState() =>
      _BannerAndTestimonialPageState();
}

class _BannerAndTestimonialPageState extends State<BannerAndTestimonialPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _bannerImages;
  List<XFile>? _testimonialImages;
  TextEditingController _bannerNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _designationController = TextEditingController();

  // Method to pick images for Banner
  Future<void> _pickBannerImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _bannerImages = selectedImages;
      });
    }
  }

  Future<void> _pickTestimonialImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _testimonialImages = selectedImages;
      });
    }
  }

  // Method to upload banner to server
  Future<void> _uploadBanner() async {
    final String bannerName = _bannerNameController.text;
    final String description = _descriptionController.text;

    if (bannerName.isEmpty ||
        description.isEmpty ||
        _bannerImages == null ||
        _bannerImages!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and select images.')),
      );
      return;
    }

    final String url = 'https://api.gehnamall.com/admin/upload/Banner';
    final dio = Dio();
    final loginState = context.read<LoginBloc>().state;
    if (loginState is LoginSuccess) {
      final String identity = loginState.login.identity;
      final String token = loginState.login.token;
      print("Login successful! Identity: $identity, Token: $token");

      try {
        // Prepare form data
        final formData = FormData.fromMap({
          'bannerName': bannerName,
          'description': description,
          for (var image in _bannerImages!)
            'images': await MultipartFile.fromFile(image.path),
        });

        // Sending data to the server
        final response = await dio.post(url,
            data: formData,
            options: Options(
              headers: {
                'Content-Type': 'multipart/form-data',
                'Authorization': 'Bearer $token',
              },
            ));

        if (response.data['status'] == 0) {
          print('Banner uploaded successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Banner uploaded successfully!')),
          );
        } else {
          print('Failed: ${response.data['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${response.data['message']}')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred during upload!')),
        );
      }
    }
  }

  // Method to upload testimonial to server
  Future<void> _uploadTestimonial() async {
    final String name = _nameController.text;
    final String designation = _designationController.text;

    if (name.isEmpty ||
        designation.isEmpty ||
        _testimonialImages == null ||
        _testimonialImages!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and select images.')),
      );
      return;
    }

    final String url = 'https://api.gehnamall.com/admin/upload/testimonial';
    final dio = Dio();
    final loginState = context.read<LoginBloc>().state;
    if (loginState is LoginSuccess) {
      final String identity = loginState.login.identity;
      final String token = loginState.login.token;
      print("Login successful! Identity: $identity, Token: $token");

      try {
        // Prepare form data for the testimonial
        final formData = FormData.fromMap({
          'name': name,
          'designation': designation,
          for (var image in _testimonialImages!)
            'images': await MultipartFile.fromFile(image.path),
        });

        // Sending data to the server
        final response = await dio.post(url,
            data: formData,
            options: Options(
              headers: {
                'Content-Type': 'multipart/form-data',
                'Authorization':  'Bearer $token', 
              },
            ));

        if (response.data['status'] == 0) {
          print('Testimonial uploaded successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Testimonial uploaded successfully!')),
          );
        } else {
          print('Failed: ${response.data['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${response.data['message']}')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred during upload!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banner Upload"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Banner Name",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _bannerNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Banner Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    Text("Description",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),

                    Text("Select Images",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: _pickBannerImages,
                      child: Text("Pick Images"),
                    ),
                    SizedBox(height: 16),

                    _bannerImages == null
                        ? Text("No images selected")
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _bannerImages!
                                .map((image) => Image.file(
                                      File(image.path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ))
                                .toList(),
                          ),
                    SizedBox(height: 16),

                    // Submit Button to Upload Banner
                    ElevatedButton(
                      onPressed: _uploadBanner,
                      child: Text("Upload Banner"),
                    ),

                    SizedBox(height: 100),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Testimonial Name",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter Testimonial Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text("Designation",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            TextField(
                              controller: _designationController,
                              decoration: InputDecoration(
                                hintText: 'Enter Designation',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                            SizedBox(height: 16),
                            Text("Select Images",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            ElevatedButton(
                              onPressed: _pickTestimonialImages,
                              child: Text("Pick Images"),
                            ),
                            SizedBox(height: 16),
                            _testimonialImages == null
                                ? Text("No images selected")
                                : Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _testimonialImages!
                                        .map((image) => Image.file(
                                              File(image.path),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ))
                                        .toList(),
                                  ),
                            SizedBox(height: 16),
                            // Submit Button to Upload Testimonial
                            ElevatedButton(
                              onPressed: _uploadTestimonial,
                              child: Text("Upload Testimonial"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
