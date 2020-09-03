import 'package:magento2_app/entities/requests.dart';
import 'package:magento2_app/network_layer/http_request.dart';

class ProductsService extends HttpRequestProtocol {
  final ProductsRequest request;

  ProductsService(this.request);

  @override
  ContentEncoding get contentEncoding => ContentEncoding.url;

  @override
  Map<String, dynamic> get parameters => this.request.toJson();

  @override
  String get path => '/products/category/$request.categoryId';
}