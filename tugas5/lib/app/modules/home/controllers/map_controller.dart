import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class mapsController extends GetxController {
  final MapController mapController = MapController();
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null); // Gunakan Rx untuk observasi
  RxString locationMessage = "Mencari Lat dan Long...".obs;
  RxBool loading = false.obs;

  Future<void> getCurrentLocation() async {
    loading.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception('Location service not enabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied forever');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      locationMessage.value =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      currentLocation.value = LatLng(position.latitude, position.longitude);
      mapController.move(currentLocation.value!, 16.0);
    } catch (e) {
      locationMessage.value = 'Gagal mendapatkan lokasi';
    } finally {
      loading.value = false;
    }
  }

  Future<void> convertAddressToLatLng(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);

      if (locations.isNotEmpty) {
        locationMessage.value =
            'Latitude: ${locations.first.latitude}, Longitude: ${locations.first.longitude}';
        currentLocation.value =
            LatLng(locations.first.latitude, locations.first.longitude);
        // Memindahkan peta ke lokasi baru
        mapController.move(currentLocation.value!, 16.0);
      }
    } catch (e) {
      locationMessage.value = 'Gagal menemukan lokasi: $location';
    }
  }

  void openGoogleMaps() async {
    if (currentLocation != null) {
      final url =
          'https://www.google.com/maps?q=${currentLocation.value?.latitude},${currentLocation.value?.longitude}';
      launchURL(url);
    }
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
