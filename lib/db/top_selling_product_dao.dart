import 'package:dni_ecommerce/viewobject/top_selling_product.dart';
import 'package:sembast/sembast.dart';

import 'common/app_dao.dart';

class TopSellingProductDao extends AppDao<TopSellingProduct> {
  TopSellingProductDao._() {
    init(TopSellingProduct());
  }
  static const String STORE_NAME = 'TopSellingProduct';
  final String _primaryKey = 'id';

  // Singleton instance
  static final TopSellingProductDao _singleton = TopSellingProductDao._();

  // Singleton accessor
  static TopSellingProductDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(TopSellingProduct object) {
    return object.id;
  }

  @override
  Filter getFilter(TopSellingProduct object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
