import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taca/config/api_config.dart';
import 'package:taca/controllers/auth_controller.dart';

class AuthService {
  final AuthController _authController = Get.find<AuthController>();

  Future<LoginResult> login(String email, String password) async {
    
    print('objectklahflha $email');
    final response = await http.post(
      Uri.parse('${APIConfig.baseURL}/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,     
      }),
    );


    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print('Response: $json');

      try {
         // Update GetX controller with the new token and user details
        _authController.setToken(json['token']);
        _authController.setUserDetails(json['user']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Store token
        await prefs.setString('jwtToken', json['token']);
        // Store user details (convert user details to JSON string for storage)
        await prefs.setString('userDetails', jsonEncode(json['user']));
       
        print('Token and user details updated successfully');
      } catch (e) {
        print('Failed to update token or user details: $e');
        return LoginResult(success: false, message: 'Failed to update login details');
      }

      return LoginResult(success: true, message: json['message']);
    } else {
      return LoginResult(success: false, message: 'Login failed');
    }
  }

  Future<String?> getToken() async {
    return _authController.token.value;
  }

  Future<Map> getUserDetails() async {
    return _authController.userDetails.value;
  }

  Future<void> logout() async {
    _authController.clear(); // Clear token and user details from GetX
  }
}

class LoginResult {
  final bool success;
  final String? message;

  LoginResult({required this.success, this.message});
}
