import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magento2_app/DataStorage/KeyValueStorage.dart';
import 'package:magento2_app/apis/catalogAPI.dart';
import 'package:magento2_app/apis/quoteAPI.dart';
import 'package:magento2_app/configurations/clientConfig.dart';
import 'package:magento2_app/configurations/uiConfig.dart';
import 'package:magento2_app/models/catalog.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductDetailsPage extends StatefulWidget {
  static const routeName = 'product_details';
  String sku;

  ProductDetailsPage({Key key, this.sku}) : super(key: key);

  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Product product;
  CancelableOperation getProductOperation;
  CancelableOperation addProductToCartOperation;
  CancelableOperation createEmptyCartOperation;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  void _getProduct() {
    setState(() {
      loading = true;
    });
    getProductOperation = CancelableOperation.fromFuture(
        CatalogAPI().getProduct(widget.sku).then((product) {
      setState(() {
        loading = false;
        this.product = product;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: product != null
            ? Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 250,
                                  child: ProductImagesView(
                                    imageURLs: product.imageURLs,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                ),
                                Align(
                                  child: Padding(
                                      child: Text(product.name,
                                          style: AppTextStyle.title),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16)),
                                  alignment: Alignment.centerLeft,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                ),
                                Align(
                                  child: Padding(
                                    child: Text(product.sku,
                                        style: AppTextStyle.normal),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                ),
                                Align(
                                  child: Padding(
                                    child: Text('\$' + product.price.toString(),
                                        style: AppTextStyle.normal),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                                product.shortDescription != ""
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 8),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.all(0),
                                      ),
                                product.shortDescription != ""
                                    ? Align(
                                        child: Padding(
                                          child: Text(product.shortDescription,
                                              style: AppTextStyle.small),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      )
                                    : Padding(
                                        padding: EdgeInsets.all(0),
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                ),
                                Align(
                                  child: Padding(
                                    child: Html(data: product.description),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                  alignment: Alignment.centerLeft,
                                )
                              ],
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: SizedBox(width: double.infinity, child: RaisedButton(
                                colorBrightness: Brightness.light,
                                disabledTextColor: Colors.black,
                                highlightColor: Colors.blue.withAlpha(70),
                                splashColor: Colors.blue[400],
                                textColor: Colors.white,
                                color: Colors.blue,
                                child: Text(
                                  "Add To Cart",
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  _addProductToCart();
                                },
                              ),),
                              height: 44,
                              margin: EdgeInsets.all(16),
                            ))
                      ],
                    ),
                  ),
                  loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center()
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  void _addProductToCart() async {
    setState(() {
      loading = true;
    });
    final quoteID =
        await KeyValueStorage().getValueWithKey(PreferenceKeys.quoteGuestID);
    if (quoteID != null) {
      addProductToCartOperation = CancelableOperation.fromFuture(
              QuoteAPI().addSimpleProductToGuestCart(product, quoteID))
          .then((status) {
            if(status) {
              _settingModalBottomSheet(context);
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Text("Fail"),
                  content: Text("Couldn't add the product to cart"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Done"),
                      onPressed: () {
                      Navigator.pop(context);
                      },
                    )
                  ],
                )
              );
            }
        setState(() {
          loading = false;
        });
      });
    } else {
      createEmptyCartOperation = CancelableOperation.fromFuture(
          QuoteAPI().createAnEmptyGuestCart().then((id) {
        KeyValueStorage().set(id, PreferenceKeys.quoteGuestID);
        addProductToCartOperation = CancelableOperation.fromFuture(
                QuoteAPI().addSimpleProductToGuestCart(product, id))
            .then((status) {
          print(status ? "OK" : "Fail");
          setState(() {
            loading = false;
          });
        });
      }));
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return AddedToCartView(
            product: product,
          );
        });
  }

  @override
  void dispose() {
    if (addProductToCartOperation != null) addProductToCartOperation.cancel();
    if (createEmptyCartOperation != null) createEmptyCartOperation.cancel();
    if (getProductOperation != null) getProductOperation.cancel();
    super.dispose();
  }
}

class ProductImagesView extends StatelessWidget {
  final _controller = PageController(initialPage: 0);
  List<String> imageURLs;

  ProductImagesView({Key key, this.imageURLs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      children: imageURLs
          .map((url) => CachedNetworkImage(
                imageUrl: url,
              ))
          .toList(),
    );
  }
}

class AddedToCartView extends StatelessWidget {
  final Product product;

  AddedToCartView({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: 44,
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 16),
                      child: Text(
                    "Added Product To Cart",
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
                  Flex(
                    direction: Axis.horizontal,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Row(children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.all(8),
                          width: 84,
                          height: 84,
                          child: CachedNetworkImage(
                              imageUrl: product.imageURLs.first))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.name,
                            style: AppTextStyle.title,
                          )),
                      Container(
                        height: 8,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.sku,
                            style: AppTextStyle.normal,
                          )),
                      Container(
                        height: 8,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.price.toString(),
                            style: AppTextStyle.normal,
                          )),
                      Container(
                        height: 8,
                      )
                    ],
                  )
                ])
              ],
            ),
            RaisedButton(
              onPressed: () {

              },
              child: Text("Go To Cart"),
            )
          ],
        )
      ],
    );
  }
}
