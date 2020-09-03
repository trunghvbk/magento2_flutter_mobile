import 'package:magento2_app/models/catalog.dart';
import 'package:magento2_app/network_layer/network_mappers.dart';

class Products extends ListMappable {
  List<Product> products;

  @override
  Mappable fromJsonList(List json) {
    products = json.map((i) => Product.fromJson(i)).toList();
    return this;
  }
}
