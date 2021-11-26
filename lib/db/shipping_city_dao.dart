import 'package:dni_ecommerce/viewobject/shipping_city.dart';
import 'package:sembast/sembast.dart';

import 'common/app_dao.dart';

class ShippingCityDao extends AppDao<ShippingCity> {
  ShippingCityDao._() {
    init(ShippingCity());
  }
  static const String STORE_NAME = 'ShippingCity';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ShippingCityDao _singleton = ShippingCityDao._();

  // Singleton accessor
  static ShippingCityDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ShippingCity object) {
    return object.id;
  }

  @override
  Filter getFilter(ShippingCity object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
