import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:tugas_1/app/page/landing_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  var isAuthenticated = false.obs;
  var isLoading = false.obs;

  // TextEditingController for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Method for login using email and password
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      isAuthenticated.value = userCredential.user != null;
      Get.to(LandingPage());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Method for registration of new user using email and password
  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      isAuthenticated.value = userCredential.user != null;
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Method for login using Google
  //Future<void> signInWithGoogle() async {
  //try {
  //isLoading.value = true;
  //final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //if (googleUser != null) {
  //final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //final AuthCredential credential = GoogleAuthProvider.credential(
  //accessToken: googleAuth.accessToken,
  //idToken: googleAuth.idToken,
  //);
  //UserCredential userCredential = await _auth.signInWithCredential(credential);
  //isAuthenticated.value = userCredential.user != null;
  //Get.offAllNamed('/home');
  //}
  //} catch (e) {
  //Get.snackbar('Error', e.toString());
  //} finally {
  //isLoading.value = false;
  //}
  //}

  // Method for logging out
  void logout() {
    _auth.signOut();
    isAuthenticated.value = false;
    Get.offAllNamed('/login'); // Navigate back to Login page after logout
  }

  // Method to clear the controllers
  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }

  // Ensure to dispose controllers when AuthController is destroyed
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
