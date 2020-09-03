import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magento2_app/pages/cartPage.dart';
import 'package:magento2_app/pages/homePage.dart';
import 'package:magento2_app/pages/categoryPage.dart';
import 'package:magento2_app/pages/morePage.dart';
import 'package:magento2_app/pages/profilePage.dart';

class MainPage extends StatefulWidget {
  static const String routeName = "main";
  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CategoryPage(category: null,),
    CartPage(),
    ProfilePage(),
    MorePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loadWidget(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black38,
        selectedLabelStyle: TextStyle(fontSize: 10),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('Category'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            title: Text('More'),
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _loadWidget(int index) {
    return _widgetOptions.elementAt(index);
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}