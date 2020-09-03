import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:magento2_app/apis/CatalogAPI.dart';
import 'package:magento2_app/models/catalog.dart';
import 'package:magento2_app/pages/productDetailsPage.dart';
import 'package:magento2_app/pages/productsPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _newestProducts = List<Product>();
  List<Category> _categories = List<Category>();
  CancelableOperation fetchingCategoriesOperation;
  CancelableOperation fetchingProductsOperation;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    if(fetchingCategoriesOperation != null) fetchingCategoriesOperation.cancel();
    if(fetchingProductsOperation != null) fetchingProductsOperation.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(itemCount: 2, itemBuilder: _buildItemsForListView),
    );
  }

  void _loadData() {
    fetchingCategoriesOperation = CancelableOperation.fromFuture(CatalogAPI().getCategoryList().then((categoryList) => {
          setState(() => {_categories = categoryList})
        }));
    fetchingProductsOperation = CancelableOperation.fromFuture(CatalogAPI().getNewestProducts().then((products) => {
          setState(() => {_newestProducts = products})
        }));
  }

  Widget _buildItemsForListView(BuildContext context, int index) {
    if (index == 0) {
      if (_categories.length > 0) {
        return Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          height: 320,
          child: ListView.builder(
            itemCount: _categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Container(
                  width: 2 * MediaQuery
                      .of(context)
                      .size
                      .width / 3,
                  height: 320,
                  child: CachedNetworkImage(
                    imageUrl: category.imageURL,
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.white, null)),
                          ),
                        ),
                    placeholder: (context, url) =>
                        Image.asset('assets/ic_hat.png'),
                  ));
            },
          ),
        );
      } else {
        return Center(child: CircularProgressIndicator(),);
      }
    } else if (index == 1) {
      if (_newestProducts.length > 0) {
        return Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            height: 364,
            child: Column(children: <Widget>[
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 44,
                color: Colors.blue,
                padding: EdgeInsets.only(left: 8),
                child: Align(
                  child: Text("Newest products", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
                  alignment: Alignment.centerLeft,
                ),
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 320,
                child: ListView.builder(
                    itemCount: _newestProducts.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final product = _newestProducts[index];
                      return Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2,
                          height: 320,
                          child: ProductView(product, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(sku: product.sku,)));
                          }));
                    }),
              )
            ]));
      } else {
        return Center(child: CircularProgressIndicator(),);
      }
    }
  }
}
