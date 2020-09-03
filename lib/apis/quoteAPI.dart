import 'package:magento2_app/DataStorage/KeyValueStorage.dart';
import 'package:magento2_app/configurations/clientConfig.dart';
import 'package:magento2_app/models/catalog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuoteAPI {
  Future<bool> addSimpleProductToGuestCart(Product product, String quoteID) async {
    if(quoteID != null) {
      final params = {
        "cartItem": {
          "sku": product.sku,
          "qty": '1',
          "quote_id": quoteID,
          "price": product.price
        }
      };
//      final body = jsonEncode(params);
      var uri = Uri.parse(ClientConfigs.loadBasicURL()+APIPath.guestCartsPath+quoteID+"/items");
      final response = await http.post(uri, headers: {'Authorization': 'Bearer ' + ClientConfigs.accessToken, "Content-Type": "application/json"}, body: json.encode(params));
      print(response);
      if(response.statusCode == ResponseStatus.RESPONSE_SUCCESS) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }

  }

  Future<String> createAnEmptyGuestCart() async {
    var uri = Uri.parse(ClientConfigs.loadBasicURL()+APIPath.guestCartsPath);
    final response =
    await http.post(uri, headers: {'Authorization': 'Bearer ' + ClientConfigs.accessToken});
    print(response);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return json.decode(response.body) as String;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to create a guest cart');
    }
  }
}