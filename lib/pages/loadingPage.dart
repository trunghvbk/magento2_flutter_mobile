import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:magento2_app/apis/catalogAPI.dart';
import 'package:magento2_app/apis/storeApi.dart';
import 'package:magento2_app/configurations/clientConfig.dart';
import 'package:magento2_app/models/store.dart';
import 'package:magento2_app/pages/homePage.dart';
import 'package:magento2_app/pages/mainPage.dart';
import 'dart:math' as math;

class LoadingPage extends StatefulWidget {
  static const routeName = '/';

  _LoadingPageState createState() => _LoadingPageState();

//  @override
//  Widget build(BuildContext context) {
//
//    return FutureBuilder<StoreConfig>(
//      future: this.storeConfig,
//      builder: (context, snapshot) {
//        if (snapshot.hasData) {
//          globalStoreConfig = snapshot.data;
//          ClientConfigs.baseURL = globalStoreConfig.baseURL;
//          return MainPage();
//        } else {
//          return LoadingWidget();
//        }
//      },
//    );
//  }

}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  CancelableOperation _fetchLoadingOperation;
  StoreConfig _storeConfig;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _fetchLoadingOperation = CancelableOperation.fromFuture(
        StoreAPI().getStoreConfig().then((storeConfig) {
      globalStoreConfig = storeConfig;
      ClientConfigs.baseURL = globalStoreConfig.baseURL;
      setState(() {
        this._storeConfig = storeConfig;
      });
    }));
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    if (_fetchLoadingOperation != null) _fetchLoadingOperation.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_storeConfig != null)
        ? MainPage()
        : Container(
            color: Colors.white,
            child: AnimatedBuilder(
              animation: _controller,
                child: Image.asset(
                  'assets/mage-mobile.png',
                  alignment: Alignment.center,
                ),
              builder: (BuildContext context, Widget child) {
                return Transform.rotate(
                  angle: _controller.value * 2.0 * math.pi,
                  child: child,
                );
              },
            ));
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/mage-mobile.png',
                alignment: Alignment.center,
              ),
            ),
//            Align(
//              child: CircularProgressIndicator(backgroundColor: Colors.amber,),
//              alignment: Alignment.center,
//            )
          ],
        ));
  }
}
