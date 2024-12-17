import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userSalaryController = TextEditingController();

  late DatabaseReference dbRef;
  File? _image;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instanceFor(
      app: FirebaseDatabase.instance.app,
      databaseURL:
          'https://test-7b9c2-default-rtdb.asia-southeast1.firebasedatabase.app',
    ).ref().child('Students');
  }

  Future<void> _pickImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    print('${pickedFile?.path}');
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      // Membuat nama file unik menggunakan timestamp
      final uniqueFileName =
          'student_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Buat referensi di Firebase Storage dengan path dan nama unik
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('students_images/$uniqueFileName');

      // Mulai unggah gambar
      final uploadTask = await storageRef.putFile(_image!);

      // Dapatkan URL unduhan
      _imageUrl = await storageRef.getDownloadURL();
      print('Image URL: $_imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _insertData() async {
    if (_imageUrl == null) {
      await _uploadImage();
    }

    Map<String, String> studentData = {
      'name': userNameController.text,
      'age': userAgeController.text,
      'salary': userSalaryController.text,
      'imageUrl': _imageUrl ?? '',
    };

    await dbRef.push().set(studentData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tambahkan Baju'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Inserting data in Firebase Realtime Database',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: userNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter Your Name',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: userAgeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Age',
                      hintText: 'Enter Your Age',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: userSalaryController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Salary',
                      hintText: 'Enter Your Salary',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _image == null
                      ? Text('No image selected.')
                      : Image.file(
                          _image!,
                          height: 150,
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                    color: Colors.green,
                    textColor: Colors.white,
                    minWidth: 300,
                    height: 40,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await _insertData();
                    },
                    child: const Text('Insert Data'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    minWidth: 300,
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
