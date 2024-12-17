import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tugas_1/app/page/landing_page.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();

  void register() {
    String email = emailController.text;
    String password = passwordController.text;
    String fullName = fullNameController.text;
    String username = usernameController.text;

    if (email.isNotEmpty &&
        password.isNotEmpty &&
        fullName.isNotEmpty &&
        username.isNotEmpty) {
      Get.to(LandingPage());
    } else {
      Get.snackbar('Error', 'Please fill all fields');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    usernameController.dispose();
    super.onClose();
  }
}
