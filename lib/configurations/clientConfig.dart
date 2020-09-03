import 'package:magento2_app/models/store.dart';

class ClientConfigs {
  // Re-check if it can be assigned a new value as a global var
  static String baseURL = "https://demo.mage-mobile.com/";
  static const String accessToken = "qb7157owxy8a29ewgogroa6puwoaf8f3";
  static const String version = "V1/";
  static const String requestType = "rest/";
  static const String storeID = "default/";

  static String loadBasicURL() {
    return ClientConfigs.baseURL+ClientConfigs.requestType+ClientConfigs.storeID+ClientConfigs.version;
  }
}

StoreConfig globalStoreConfig;

class ResponseStatus {
// response status
  static const int RESPONSE_SUCCESS = 200;
}

class MediaPath {
// Image path
  static const String productImagePath = "catalog/product/";
  static const String categoryImagePath = "catalog/category/";
}

class APIPath {
// catalog
  static const String getProductsPath = "products/";
  static const String getCategoryListPath = "categories/list";
  static const String getAllCategories = "categories";
  // guest cart
  static const String guestCartsPath = "guest-carts/";
// store
  static const String getStoreConfigPath = "store/storeConfigs/";
}

class PreferenceKeys {
  static const String quoteGuestID = "quote_guest_id";
}