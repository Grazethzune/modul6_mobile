import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../home_controller.dart'; // Pastikan path ini sesuai dengan struktur folder Anda.

class VoiceController extends GetxController {
  // Instance Speech to Text
  late stt.SpeechToText _speech;

  // State observables
  var isListening = false.obs; // Apakah sedang mendengarkan
  var recognizedText = ''.obs; // Teks hasil pengenalan suara
  var isPermissionGranted = false.obs; // Status izin mikrofon

  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
    _checkPermissions();
  }

  /// Memeriksa izin mikrofon
  Future<void> _checkPermissions() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      isPermissionGranted.value = true;
    } else {
      await Permission.microphone.request();
      isPermissionGranted.value = await Permission.microphone.isGranted;
    }
  }

  /// Mulai mendengarkan
  Future<void> startListening() async {
    if (!isPermissionGranted.value) {
      Get.snackbar(
        'Permission Denied',
        'Please enable microphone permission in settings.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!_speech.isAvailable) {
      bool isAvailable = await _speech.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
        },
        onError: (error) {
          debugPrint('Speech error: $error');
          stopListening();
        },
      );

      if (!isAvailable) {
        Get.snackbar(
          'Error',
          'Speech recognition not available on this device.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    isListening.value = true;
    _speech.listen(
      onResult: (result) {
        recognizedText.value = result.recognizedWords;
      },
      listenFor: Duration(seconds: 10), // Durasi maksimum mendengarkan
      pauseFor: Duration(seconds: 3), // Waktu jeda otomatis berhenti
      partialResults: true, // Mendukung hasil parsial
    );
  }

  /// Berhenti mendengarkan
  void stopListening() {
    if (_speech.isListening) {
      _speech.stop();
    }
    isListening.value = false;

    // Panggil HomeController untuk pencarian berdasarkan teks suara
    final HomeController homeController = Get.find<HomeController>();
    homeController.searchProduct(recognizedText.value);
  }

  /// Bersihkan teks pengenalan suara
  void clearRecognizedText() {
    recognizedText.value = '';
  }
}
