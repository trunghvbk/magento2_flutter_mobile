import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:magento2_app/configurations/clientConfig.dart';
import 'package:magento2_app/models/catalog.dart';
import 'package:http/http.dart' as http;

class CatalogAPI {
  Future<List<Product>> fetchProducts() async {
    final params = <String, String>{
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'in',
      'searchCriteria[filter_groups][0][filters][0][field]': 'type_id',
      'searchCriteria[pageSize]': '100',
      'searchCriteria[filter_groups][0][filters][0][value]': 'simple,configurable,bundle',
      'searchCriteria[currentPage]': '1',
      'searchCriteria[sortOrders][0][field]': 'created_at',
      'searchCriteria[sortOrders][0][direction]': 'DESC'
    };
    var uri = Uri.parse(ClientConfigs.baseURL+ClientConfigs.requestType+ClientConfigs.storeID+ClientConfigs.version+APIPath.getProductsPath);
    uri = uri.replace(queryParameters: params);


    final response =
    await http.get(uri, headers: {'Authorization': 'Bearer ' + ClientConfigs.accessToken});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      final data = json.decode(response.body);
      print(data);
      final products = data["items"] as List;
      return products.map<Product>((json) => Product.fromJson(json)).toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Category>> getCategoryList() async {
    final params = <String, String> {
      'searchCriteria[filterGroups][0][filters][0][field]': 'level',
      'searchCriteria[filterGroups][0][filters][0][value]': '2',
      'searchCriteria[filterGroups][0][filters][0][conditionType]': 'eq',
      'searchCriteria[pageSize]': '20',
      'searchCriteria[currentPage]': '0'
    };
    var uri = Uri.parse(ClientConfigs.baseURL+ClientConfigs.requestType+ClientConfigs.storeID+ClientConfigs.version+APIPath.getCategoryListPath);
    uri = uri.replace(queryParameters: params);

    final response =
    await http.get(uri, headers: {'Authorization': 'Bearer ' + ClientConfigs.accessToken});

    if (response.statusCode == ResponseStatus.RESPONSE_SUCCESS) {
      // If the call to the server was successful, parse the JSON.
      final data = json.decode(response.body);
      print(data);
      final catgegories = data["items"] as List;
      return catgegories.map<Category>((json) => Category.fromJson(json)).toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Product>> getNewestProducts() async {
    final params = <String, String> {
      "searchCriteria[currentPage]": "1",
      "searchCriteria[filter_groups][0][filters][0][condition_type]": "in",
      "searchCriteria[pageSize]": "20",
      "searchCriteria[filter_groups][0][filters][0][field]": "type_id",
      "searchCriteria[filter_groups][0][filters][0][value]": "simple,configurable,bundle",
      "searchCriteria[sortOrders][0][direction]": "DESC",
      "searchCriteria[sortOrders][0][field]": "created_at"
    };
    var uri = Uri.parse(ClientConfigs.baseURL+ClientConfigs.requestType+ClientConfigs.storeID+ClientConfigs.version+APIPath.getProductsPath);
    uri = uri.replace(queryParameters: params);

    print(uri.toString());

    final response =
    await http.get(uri, headers: {'Authorization': 'Bearer ' + ClientConfigs.accessToken});

    if (response.statusCode == ResponseStatus.RESPONSE_SUCCESS) {
      // If the call to the server was successful, parse the JSON.
      final data = json.decode(response.body);
      print(data);
      final products = data["items"] as List;
      return products.map<Product>((json) => Product.fromJson(json)).toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load categories');
    }
  }

  Future<Category> getRootCategory() async {
    var uri = Uri.parse(ClientConfigs.baseURL+ClientConfigs.requestType+ClientConfigs.storeID+ClientConfigs.version+APIPath.getAllCategories);

    final response =
    await http.get(uri, headers: {'Authorization': 'Bearer ' + ClientConfigs.accessToken});

    if (response.statusCode == ResponseStatus.RESPONSE_SUCCESS) {
      // If the call to the server was successful, parse the JSON.
      final data = json.decode(response.body);
      return Category.fromJson(data);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load categories');
    }
  }

  Future<ProductsResponse> getProductsOfCategory(int cateId, int page) async {
    final pageSize = 20;
    final params = <String, String> {
      'fields': 'sku'
    };
    var uri = Uri.parse(ClientConfigs.baseURL+ClientConfigs.requestType+ClientConfigs.storeID+ClientConfigs.version+'categories/$cateId/products');
    uri = uri.replace(queryParameters: params);


    final response1 =
    await http.get(uri, headers: {'Authorization': 'Bearer ' + ClientConfigs.accessToken});

    if (response1.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      final data = json.decode(response1.body) as List;
      final skus = data.map<String>((json) => json["sku"]).toList();
      return getProductsWithSKUs(skus, pageSize, page);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<Product> getProduct(String sku) async {
    var uri = Uri.parse(ClientConfigs.baseURL+ClientConfigs.requestType+ClientConfigs.storeID+ClientConfigs.version+APIPath.getProductsPath+sku);
    final response = await http.get(uri, headers: {'Authorization': 'Bearer ' + ClientConfigs.accessToken});

    if(response.statusCode == ResponseStatus.RESPONSE_SUCCESS) {
      final data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<ProductsResponse> getRelatedProduct(String sku) async {
    var uri = Uri.parse(ClientConfigs.baseURL+ClientConfigs.requestType+ClientConfigs.storeID+ClientConfigs.version+APIPath.getProductsPath+sku+"/link/related");
    final response = await http.get(uri, headers: {'Authorization': 'Bearer ' + ClientConfigs.accessToken});

    if(response.statusCode == ResponseStatus.RESPONSE_SUCCESS) {
      final data = json.decode(response.body) as List;
      final List<String> skus = data.map((json) => json["linked_product_sku"]);
      return getProductsWithSKUs(skus, skus.length, 1);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<ProductsResponse> getProductsWithSKUs(List<String> skus, int pageSize, int page) async {
    final skuList = skus.join(",");
    final params = <String, String> {
      'searchCriteria[pageSize]': '$pageSize',
      'searchCriteria[currentPage]': '$page',
      'searchCriteria[sortOrders][0][field]': 'created_at',
      'searchCriteria[sortOrders][0][direction]': 'DESC',
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'in',
      'searchCriteria[filter_groups][0][filters][0][field]': 'type_id',
      'searchCriteria[filter_groups][0][filters][0][value]': 'simple,configurable,bundle',
      'searchCriteria[filter_groups][1][filters][0][field]': 'sku',
      'searchCriteria[filter_groups][1][filters][0][condition_type]': 'in',
      'searchCriteria[filter_groups][1][filters][0][value]': skuList,
    };

    var uri = Uri.parse(ClientConfigs.baseURL+ClientConfigs.requestType+ClientConfigs.storeID+ClientConfigs.version+APIPath.getProductsPath);
    uri = uri.replace(queryParameters: params);

    print(uri);
    final response2 =
        await http.get(uri, headers: {'Authorization': 'Bearer ' + ClientConfigs.accessToken});

    if (response2.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      final data = json.decode(response2.body);
      return ProductsResponse.fromJson(data);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
