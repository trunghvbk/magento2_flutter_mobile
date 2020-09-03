import 'package:magento2_app/network_layer/network_mappers.dart';

class ProductsRequest extends RequestMappable {
  final int offset;
  final int limit;
  final int categoryId;

  ProductsRequest(this.offset, this.limit, this.categoryId);

  @override
  Map<String, dynamic> toJson() => {
    "searchCriteria[pageSize]": limit,
    "searchCriteria[currentPage]": offset
  };
}