import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_1/app/modules/home/controllers/home_controller.dart';

import 'package:tugas_1/app/page/Scanqrpage.dart';
import 'package:tugas_1/app/page/home.dart';
import 'package:tugas_1/app/page/keranjang_page.dart';


class LandingPage extends GetView {
  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);

  final TextStyle selectedLabelStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          height: 54,
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: landingPageController.changeTabIndex,
            currentIndex: landingPageController.tabIndex.value,
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            unselectedItemColor: Color.fromARGB(255, 156, 151, 151),
            selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            unselectedLabelStyle: unselectedLabelStyle,
            selectedLabelStyle: selectedLabelStyle,
            items: [
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Container(
                      height: 2,
                      width: 20,
                      color: landingPageController.tabIndex.value == 0
                          ? Color.fromARGB(255, 0, 0, 0)
                          : null,
                    ),
                    Icon(Icons.home, size: 20.0),
                  ],
                ),
                label: 'Home',
                backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Container(
                      height: 2,
                      width: 20,
                      color: landingPageController.tabIndex.value == 1
                          ? Color.fromARGB(255, 0, 0, 0)
                          : null,
                    ),
                    Icon(Icons.shopping_cart, size: 20.0),
                  ],
                ),
                label: 'Daftar keranjang',
                backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Container(
                      height: 2,
                      width: 20,
                      color: landingPageController.tabIndex.value == 2
                          ? Color.fromARGB(255, 0, 0, 0)
                          : null,
                    ),
                    Icon(Icons.qr_code, size: 20.0),
                  ],
                ),
                label: 'Scanqr',
                backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              ),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final HomeController landingPageController =
        Get.put(HomeController(), permanent: false);
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar:
          buildBottomNavigationMenu(context, landingPageController),
      body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children: [HomePage(), CartPage(),ScanQRScreen()],
          )),
    ));
  }
}
