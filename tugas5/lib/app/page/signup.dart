import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_1/app/modules/home/controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In With',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              //Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              //children: [
              //ElevatedButton.icon(
              //onPressed: () {
              // Tambahkan logika untuk sign in dengan Facebook
              //},
              //icon: const Icon(Icons.facebook),
              //label: const Text('Facebook'),
              //style: ElevatedButton.styleFrom(
              //backgroundColor: Color(0xFF3b5998), // Warna biru Facebook
              //minimumSize: const Size(150, 50),
              //),
              //),
              //const SizedBox(width: 10),
              //ElevatedButton.icon(
              //onPressed: authController.signInWithGoogle,
              //icon: Image.asset(
              //'assets/images/google_icon.png',
              //height: 24,
              //),
              //label: const Text('Google'),
              //style: ElevatedButton.styleFrom(
              //backgroundColor: Colors.white,
              //foregroundColor: Colors.black,
              //side: BorderSide(color: Colors.grey),
              //minimumSize: const Size(150, 50),
              //),
              //),
              //],
              //),
              const SizedBox(height: 30),
              _buildTextField(
                hintText: 'Username',
                controller: authController.emailController,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                hintText: 'Password',
                controller: authController.passwordController,
                obscureText: true,
                hasForgotOption: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  authController.registerUser(
                    authController.emailController.text,
                    authController.passwordController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?"),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/register');
                    },
                    child: const Text('Sign up now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    bool hasForgotOption = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffix: hasForgotOption
            ? GestureDetector(
                onTap: () {
                  // Tambahkan logika untuk "Forgot Password"
                },
                child: const Text(
                  'Forgot?',
                  style: TextStyle(color: Colors.blue),
                ),
              )
            : null,
      ),
    );
  }
}
