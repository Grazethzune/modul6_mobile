import 'package:get/get.dart';
import 'package:tugas_1/app/modules/home/controllers/connection_controller.dart';

class ConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectionController>(ConnectionController(), permanent: true);
  }
}
