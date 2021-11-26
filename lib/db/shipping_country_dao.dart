import 'package:dni_ecommerce/viewobject/shipping_country.dart';
import 'package:sembast/sembast.dart';

import 'common/app_dao.dart';

class ShippingCountryDao extends AppDao<ShippingCountry> {
  ShippingCountryDao._() {
    init(ShippingCountry());
  }
  static const String STORE_NAME = 'ShippingCountry';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ShippingCountryDao _singleton = ShippingCountryDao._();

  // Singleton accessor
  static ShippingCountryDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ShippingCountry object) {
    return object.id;
  }

  @override
  Filter getFilter(ShippingCountry object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
