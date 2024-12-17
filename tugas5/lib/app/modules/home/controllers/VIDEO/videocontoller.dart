import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  var selectedVideoPath = ''.obs;
  VideoPlayerController? videoPlayerController;

  Future<void> pickOrRecordVideo(ImageSource source) async {
    final pickedFile = await ImagePicker().pickVideo(source: source);
    if (pickedFile != null) {
      selectedVideoPath.value = pickedFile.path;
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
    }
    videoPlayerController = VideoPlayerController.file(File(selectedVideoPath.value))
      ..setLooping(true)
      ..initialize().then((_) {
        update(); // Notify UI
        videoPlayerController!.play(); // Auto-play
      });
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }
}
