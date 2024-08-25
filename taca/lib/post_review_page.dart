import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:taca/config/api_config.dart';
import 'package:taca/controllers/auth_controller.dart';

class PostReviewPage extends StatefulWidget {
  final String restaurantName;

   final String restaurantId;
   final String location;  // Add restaurantId as a parameter

  PostReviewPage({
    required this.restaurantName,
    required this.restaurantId, 
    required this.location, // Add restaurantId as a parameter
  });

  @override
  _PostReviewPageState createState() => _PostReviewPageState();
}

class _PostReviewPageState extends State<PostReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Position? _currentPosition;
  String _locationName = '';

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
  }

  Future<void> _getGeoLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });

      // Reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        print("Location: $placemark");
        setState(() {
         _locationName = '${placemark.name}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';
        });
      }
    } catch (e) {
      print(e);
    }
  }

 void _postReview() async {
  if (_formKey.currentState?.validate() ?? false) {
    await _getGeoLocation();

    final AuthController authController = Get.find<AuthController>();
     final userDetails = authController.userDetails.value;

    if (_currentPosition != null && _locationName.isNotEmpty) {
      int status;
      if(_locationName == widget.location){
        status = 1;
      }else{
        status = 0;
      }
      final reviewData = {
        "restaurantId": widget.restaurantId,
        "restaurantName": widget.restaurantName,
        "userName": "${userDetails['name'] ?? 'Unknown'}",
        "reviewText": _reviewController.text,
        "rating": _rating,
        "location": {
          "locationName": _locationName,
          "longitude": _currentPosition?.longitude,
          "latitude": _currentPosition?.latitude,
        },
        "verified":status,
        "userId": "${userDetails['_id'] ?? 'Unknown'}",
        "createdAt": DateTime.now().toIso8601String(),
      };

      try {
        final response = await http.post(
          Uri.parse('${APIConfig.baseURL}/reviews'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reviewData),
        );

        print(' ,${reviewData}');

        if (response.statusCode == 201) {
          Fluttertoast.showToast(
            msg: "Review posted successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pop(context, true);  // Return true to indicate review was posted
        } else {
          print("Failed to post review: ${response.body}");
          Fluttertoast.showToast(
            msg: "Failed to post review.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (e) {
        print("Error posting review: $e");
        Fluttertoast.showToast(
          msg: "An error occurred while posting your review.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to get location. Review not posted.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post Review for ${widget.restaurantName}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write Your Review',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _reviewController,
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your review',
                        hintText: 'Write here...',
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your review';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Rating',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    _imageFile == null
                        ? IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: _pickImage,
                            iconSize: 50,
                            color: Colors.deepOrange,
                          )
                        : Image.file(
                            File(_imageFile!.path),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepOrange, Colors.orangeAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: _postReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Set to transparent to show gradient
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadowColor: Colors.transparent, // Remove shadow
                        ),
                        child: Text(
                          'Post Review',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
