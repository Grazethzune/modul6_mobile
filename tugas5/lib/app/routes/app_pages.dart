import 'package:get/get.dart';
import 'package:tugas_1/app/page/home.dart';
import 'package:tugas_1/app/page/keranjang_page.dart';
import 'package:tugas_1/app/page/login.dart';
import 'package:tugas_1/app/page/logout.dart';
import 'package:tugas_1/app/page/third.dart';

import '../modules/home/bindings/home_binding.dart';
import '../page/landing_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LandingPage(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => LandingPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LOGOUT,
      page: () => LogoutPage(),
    ),
    GetPage(
      name: Routes.ProductList,
      page: () => ProductListLainnyaScreen(),
    ),
    GetPage(
      name: Routes.Cart,
      page: () => CartPage(),
    ),
  ];
}
