import 'package:get/get.dart';

class AuthController extends GetxController {
  var token = ''.obs;
  var userDetails = {}.obs;

  void setToken(String newToken) {
    token.value = newToken;
  }

  void setUserDetails(Map<String, dynamic> newUserDetails) {
    userDetails.value = newUserDetails;
  }

  void clear() {
    token.value = '';
    userDetails.value = {};
  }
}
