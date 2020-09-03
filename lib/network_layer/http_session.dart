import 'package:http/http.dart';
import 'package:magento2_app/entities/errorResponse.dart';
import 'dart:convert';

import 'package:magento2_app/network_layer/http_request.dart';
import 'package:magento2_app/network_layer/network_mappers.dart';

/// 'HttpSessionProtocol' acts as provider to send requests to the Network.
abstract class HttpSessionProtocol<T> {
  Future<Mappable> request({HttpRequestProtocol service, Mappable responseType});
}

class HttpSession implements HttpSessionProtocol {
  final Client _client;

  HttpSession(this._client);

  @override
  Future<Mappable> request(
      {HttpRequestProtocol service, Mappable responseType}) async {
    final request = HttpRequest(service);

    final requestResponse = await _client.send(request);

    if (requestResponse.statusCode >= 200 &&
        requestResponse.statusCode <= 299) {
      final data = await requestResponse.stream.transform(utf8.decoder).join();
      return Mappable(responseType, data);
    } else {
      final Map<String, dynamic> responseError = {
        "error_code": "${requestResponse.statusCode}",
        "description": "Error retrieving data from the Server."
      };

      return ErrorResponse().fromJson(responseError);
    }
  }
}