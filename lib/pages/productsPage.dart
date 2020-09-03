import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:magento2_app/apis/catalogAPI.dart';
import 'package:magento2_app/models/catalog.dart';
import 'package:magento2_app/pages/productDetailsPage.dart';

enum ProductsLoadMoreStatus  {STABLE, LOADING}

class ProductsPage extends StatefulWidget {
  static const routeName = 'products';
  List<Product> products = <Product>[];
  Category category;
  ProductsPage({Key key, this.category}) : super(key: key);
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductsPage> {
  List<Product> products;
  int currentPage;
  int totalCount;
  CancelableOperation getProductsOperation;
  ProductsLoadMoreStatus loadMoreStatus = ProductsLoadMoreStatus.STABLE;
  bool isLoading = true;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    products = widget.products;
    currentPage = 0;
    _loadProducts();
    super.initState();
  }

  void _loadProducts() {
    getProductsOperation = CancelableOperation.fromFuture(
        CatalogAPI().getProductsOfCategory(
            widget.category.id, currentPage + 1)
            .then((response) {
          currentPage = currentPage + 1;
          loadMoreStatus = ProductsLoadMoreStatus.STABLE;
          setState(() {
            isLoading = false;
            totalCount = response.totalCount;
            this.products.addAll(response.products);
          });
        }));
  }

  @override
  void dispose() {
    scrollController.dispose();
    if (getProductsOperation != null) getProductsOperation.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name),),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : Column(children: <Widget>[
        Container(height: 44, child:
        NavigationToolbar(
          leading: IconButton(
            icon: Icon(Icons.sort),
            onPressed: _sortButtonTapped,
          ),
        ), padding: EdgeInsets.only(left: 8),),
        Expanded(child: Container(
          color: Colors.white,
          child: NotificationListener(
            onNotification: _onNotification,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6
              ),
              itemBuilder: (_, index) {
                final product = products.elementAt(index);
                return ProductView(product, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(sku: product.sku,)));
                });
              },
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: products.length,
              controller: scrollController,
            ),
          ),
        )),
        loadMoreStatus == ProductsLoadMoreStatus.LOADING ? Container(color: Colors.white ,height: 44, child: Center(child: CircularProgressIndicator()),) : Container(height: 1,)
      ],)
    );
  }

  void _sortButtonTapped() {

  }

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              50) {
        if (loadMoreStatus != null &&
            loadMoreStatus == ProductsLoadMoreStatus.STABLE && (products.length < totalCount)) {
          setState(() {
            loadMoreStatus = ProductsLoadMoreStatus.LOADING;
          });
          getProductsOperation = CancelableOperation.fromFuture(
              CatalogAPI().getProductsOfCategory(
                  widget.category.id, currentPage + 1)
                  .then((response) {
                currentPage = currentPage + 1;
                setState(() {
                  loadMoreStatus = ProductsLoadMoreStatus.STABLE;
                  totalCount = response.totalCount;
                  this.products.addAll(response.products);
                });
              }));
        }
      }
    }
    return true;
  }
}

class ProductView extends StatelessWidget {
  final Product product;
  Function onTap;

  ProductView(this.product, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: CachedNetworkImage(
                imageUrl: product.imageURL,
                imageBuilder: (context, imageProvider) =>
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitHeight,
                            colorFilter: ColorFilter.mode(
                                Colors.white, null)),
                      ),
                    ),
                placeholder: (context, url) =>
                    Image.asset('assets/ic_hat.png'),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 8),),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Padding(padding: EdgeInsets.only(top: 4),),
            Text(
              product.sku,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
            Padding(padding: EdgeInsets.only(top: 4),),
            Text(
              '\$' + product.price.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
