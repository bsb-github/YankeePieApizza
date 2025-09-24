enum RouteTypeEnum { address, appbar, checkout }

extension RouteTypeEnumExtension on RouteTypeEnum {
  static const Map<String, RouteTypeEnum> _lookupMap = {
    'address': RouteTypeEnum.address,
    'appbar': RouteTypeEnum.appbar,
    'checkout': RouteTypeEnum.checkout,
  };

  static RouteTypeEnum fromString(String name) {
    return _lookupMap[name] ?? RouteTypeEnum.address; // Default value if not found
  }
}