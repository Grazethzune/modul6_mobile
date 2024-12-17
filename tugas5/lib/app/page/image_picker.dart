import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_1/app/modules/home/controllers/home_controller.dart';

class ImagePickerPage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  ImagePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.toNamed('/logout');
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display profile image
              Obx(() {
                return controller.selectedImagePath.value.isEmpty
                    ? CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person,
                            size: 80, color: Colors.white),
                      )
                    : CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            FileImage(File(controller.selectedImagePath.value)),
                      );
              }),
              const SizedBox(height: 20),
              Text(
                "Update Your Profile Picture",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  controller.getImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text("Take a Photo"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  controller.getImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo_library, color: Colors.white),
                label: const Text("Choose from Gallery"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
