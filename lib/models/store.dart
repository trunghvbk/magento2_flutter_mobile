import 'dart:core';

class StoreConfig {
  int id;
  String code;
  int websiteId;
  String locale;
  String baseCurrencyCode;
  String defaultDisplayCurrencyCode;
  String timezone;
  String weightUnit;
  String baseURL;
  String baseLinkURL;
  String baseStaticURL;
  String baseMediaURL;
  String secureBaseURL;
  String secureBaseLinkURL;
  String secureBaseStaticURL;
  String secureBaseMediaURL;

  StoreConfig({
    this.id, this.code, this.websiteId, this.locale, this.baseCurrencyCode, this.defaultDisplayCurrencyCode, this.timezone, this.weightUnit, this.baseURL, this.baseLinkURL,
    this.baseStaticURL, this.baseMediaURL, this.secureBaseURL, this.secureBaseLinkURL, this.secureBaseStaticURL, this.secureBaseMediaURL
});

  factory StoreConfig.fromJson(Map<String, dynamic> map) {
    return new StoreConfig(
        id: map['id'],
        code: map['code'],
        websiteId: map['website_id'],
        locale: map['locale'],
        baseCurrencyCode: map["base_currency_code"],
        defaultDisplayCurrencyCode: map["default_display_currency_code"],
        timezone: map["timezone"],
        weightUnit: map["weight_unit"],
        baseURL: map["base_url"],
        baseLinkURL: map["base_link_url"],
        baseStaticURL: map["base_static_url"],
        baseMediaURL: map["base_media_url"],
        secureBaseURL: map["secure_base_url"],
        secureBaseLinkURL: map["secure_base_link_url"],
        secureBaseStaticURL: map["secure_base_static_url"],
        secureBaseMediaURL: map["secure_base_media_url"]
    );
  }
}