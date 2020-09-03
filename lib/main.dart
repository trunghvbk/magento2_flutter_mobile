import 'package:flutter/material.dart';
import 'package:magento2_app/pages/cartPage.dart';
import 'package:magento2_app/pages/checkoutPage.dart';
import 'package:magento2_app/pages/homePage.dart';
import 'package:magento2_app/pages/loadingPage.dart';
import 'package:magento2_app/pages/loginPage.dart';
import 'package:magento2_app/pages/categoryPage.dart';
import 'package:magento2_app/pages/mainPage.dart';
import 'package:path/path.dart';

import 'apis/catalogAPI.dart';

void main() {
  runApp(MaterialApp(
    title: 'Magento 2 App',
    initialRoute: LoadingPage.routeName,
    routes: {
      LoadingPage.routeName: (context) => LoadingPage(),
      MainPage.routeName: (context) => MainPage(),
      HomePage.routeName: (context) => HomePage(),
      CategoryPage.routeName: (context) => CategoryPage(),
      CartPage.routeName: (context) => CartPage(),
      CheckoutPage.routeName: (context) => CheckoutPage(),
      LoginPage.routeName: (context) => LoginPage()
    },
  ));
}
