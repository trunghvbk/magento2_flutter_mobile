import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:magento2_app/apis/catalogAPI.dart';
import 'package:magento2_app/models/catalog.dart';
import 'package:magento2_app/pages/productsPage.dart';

typedef CategoryPageListItemOnTap = void Function(Category);

class CategoryPage extends StatefulWidget {
  static const routeName = "category";
  Category category;

  CategoryPage({Key key, this.category}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  _CategoryPageState();

  @override
  void initState() {
    super.initState();
    if (widget.category == null) {
      _loadCategory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.category == null ? Text("Category") : Text(widget.category.name),
      ),
      body: (widget.category == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _loadListView(),
    );
  }

  void _loadCategory() {
    CatalogAPI().getRootCategory().then((category) => {
          setState(() => {widget.category = category})
        });
  }

  ListView _loadListView() {
    final productCount = widget.category.productCount;
    final List<Category> children = widget.category.childrenData;
    return ListView.builder(
      itemBuilder: (context, index) {
        if (productCount > 0 && index == 0) {
          return _loadTitleView("All products", () => {
            this._onAllProductsTapped(widget.category)
          });
        } else {
          final theIndex = productCount > 0 ? index - 1 : index;
          final cate = children.elementAt(theIndex);
          return _loadTitleView(cate.name, () => {
            this._onCategoryTapped(cate)
          });
        }
      },
      itemCount: productCount > 0
          ? children.length + 1
          : children.length,
      scrollDirection: Axis.vertical,
    );
  }

  void _onCategoryTapped(Category category) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryPage(
                  category: category,
                )));
  }

  void _onAllProductsTapped(Category category) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsPage(
              category: category,
            )));
  }

  ListTile _loadTitleView(String title, Function onTap) {
    return ListTile(
      title: Container(
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(fontSize: 16),
            )),
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
