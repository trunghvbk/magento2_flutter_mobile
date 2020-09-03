//import 'package:json_annotation/json_annotation.dart';
//import 'catalog.g.dart';

//@JsonSerializable(explicitToJson: false)
import 'package:magento2_app/configurations/clientConfig.dart';

class Product {
  int id;
  String name;
  String sku;
  int price;
  String imageURL;
  List<CustomAttribute> customAttributes = [];
  List<String> imageURLs = [];
  String description;
  String shortDescription;

  Product({
    this.id,
    this.name,
    this.sku,
    this.price,
    this.description,
    this.shortDescription,
    this.imageURL,
    this.imageURLs,
    this.customAttributes
  });

//  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
//  Map<String, dynamic> toJson() => _$ProductToJson(this);

  factory Product.fromJson(Map<String, dynamic> json) {
    final customAttributesData = json['custom_attributes'] as List;
    final customAttributes = customAttributesData.map<CustomAttribute>((json) => CustomAttribute.fromJson(json)).toList();
    final array = customAttributes.where((attr) => attr.code == 'image');
    String imageURLPath = "";
    if (array.length > 0) {
      imageURLPath = array.first?.value;
    }
    final imageURL = (imageURLPath != "") ? globalStoreConfig.baseMediaURL + MediaPath.productImagePath + imageURLPath : "";
    final imageURLs = <String>[];
    final mediaGalleryEntriesData = json["media_gallery_entries"] as List;
    if(mediaGalleryEntriesData != null) {
      imageURLs.addAll(mediaGalleryEntriesData.map((json) {
        final file = json["file"] as String;
        return globalStoreConfig.baseMediaURL + MediaPath.productImagePath + file;
      }));
    }
    final shortDesArray = customAttributes.where((attr) => attr.code == 'short_description').toList();
    final desArray = customAttributes.where((attr) => attr.code == 'description').toList();
    final shortDescription = shortDesArray.length > 0 ? shortDesArray.first.value : "";
    final description = desArray.length > 0 ? desArray.first.value : "";
    return new Product(
      id: json['id'],
      name: json['name'],
      sku: json['sku'],
      price: json['price'],
      description: description,
      shortDescription: shortDescription,
      imageURL: imageURL,
      imageURLs: imageURLs,
      customAttributes: customAttributes
    );
  }

//  Map<String, dynamic> toJson() =>
//      {
//        'name': name,
//        'id': id,
//        'sku': sku,
//        'price': price
//      };
}

class Category {
  int id;
  String name;
  int productCount;
  List<CustomAttribute> customAttributes;
  String imageURL;
  List<Category> childrenData;

  Category({
    this.id, this.name, this.productCount, this.customAttributes, this.imageURL, this.childrenData
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final customAttributesData = json['custom_attributes'] as List;
    String imageURLPath = "";
    List<CustomAttribute> customAttributes;
    if (customAttributesData != null) {
      customAttributes = customAttributesData.map<CustomAttribute>((
          json) => CustomAttribute.fromJson(json)).toList();
      final array = customAttributes.where((attr) => attr.code == 'image');
      if (array.length > 0) {
        imageURLPath = array.first?.value;
      }
    }
    final imageURL = (imageURLPath != "") ? globalStoreConfig.baseMediaURL + MediaPath.categoryImagePath + imageURLPath : "";
    final childrenData = json["children_data"] as List;
    List<Category> children;
    if (childrenData != null) {
      children = childrenData.map<Category>((json) =>
          Category.fromJson(json)).toList();
    }
    final productCountData = json["product_count"];
    final int productCount = productCountData ?? 0;
    return new Category(
      id: json['id'],
      name: json['name'],
      productCount: productCount,
      customAttributes: customAttributes,
      imageURL: imageURL,
      childrenData: children
    );
  }
}

class ProductsResponse {
  List<Product> products;
  int totalCount;

  ProductsResponse({this.products, this.totalCount});

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    final totalCount = json["total_count"];
    final items = json["items"] as List;
    final products = items.map<Product>((json) => Product.fromJson(json)).toList();

    return ProductsResponse(products: products, totalCount: totalCount);
  }
}

class CustomAttribute {
  String code;
  dynamic value;

  CustomAttribute({
    this.code, this.value
  });

  factory CustomAttribute.fromJson(Map<String, dynamic> json) {
    return new CustomAttribute(
        code: json['attribute_code'],
        value: json['value'],
    );
  }
}
