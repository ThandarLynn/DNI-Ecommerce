import 'package:dni_ecommerce/viewobject/product_map.dart';
import 'package:sembast/sembast.dart';

import 'common/app_dao.dart';

class ProductMapDao extends AppDao<ProductMap> {
  ProductMapDao._() {
    init(ProductMap());
  }
  static const String STORE_NAME = 'ProductMap';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ProductMapDao _singleton = ProductMapDao._();

  // Singleton accessor
  static ProductMapDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ProductMap object) {
    return object.id;
  }

  @override
  Filter getFilter(ProductMap object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
