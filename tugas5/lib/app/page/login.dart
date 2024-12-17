import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_1/app/modules/home/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  // Tambahkan variabel untuk toggle antara Login dan Register
  final RxBool isLogin = true.obs;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 10),
                Text(
                  isLogin.value
                      ? 'Login to naimike.co'
                      : 'Register on naimike.co',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  hintText: 'Email',
                  controller: authController.emailController,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  hintText: 'Password',
                  controller: authController.passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // Tombol Login atau Register
                ElevatedButton(
                  onPressed: () {
                    if (isLogin.value) {
                      authController.loginUser(
                        authController.emailController.text,
                        authController.passwordController.text,
                      );
                    } else {
                      authController.registerUser(
                        authController.emailController.text,
                        authController.passwordController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(isLogin.value ? 'Login' : 'Register'),
                ),
                const SizedBox(height: 10),
                // Tombol untuk login menggunakan Google
                //ElevatedButton.icon(
                //onPressed: authController.signInWithGoogle,
                //icon: Image.asset(
                //'assets/images/google-icon.png',
                //height: 24,
                //),
                //label: Text(isLogin.value ? 'Login with Google' : 'Register with Google'),
                //style: ElevatedButton.styleFrom(
                //minimumSize: const Size(double.infinity, 50),
                //shape: RoundedRectangleBorder(
                //borderRadius: BorderRadius.circular(8),
                //),
                //),
                //),
                const SizedBox(height: 10),
                // Tombol untuk toggle Login/Register
                TextButton(
                  onPressed: () {
                    isLogin.toggle();
                    authController.clearControllers();
                  },
                  child: Text(
                    isLogin.value
                        ? "Don't have an account? Register"
                        : "Already have an account? Login",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
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
      ),
    );
  }
}
