import 'package:dni_ecommerce/viewobject/top_rated_product.dart';
import 'package:sembast/sembast.dart';

import 'common/app_dao.dart';

class TopRatedProductDao extends AppDao<TopRatedProduct> {
  TopRatedProductDao._() {
    init(TopRatedProduct());
  }
  static const String STORE_NAME = 'TopRatedProduct';
  final String _primaryKey = 'id';

  // Singleton instance
  static final TopRatedProductDao _singleton = TopRatedProductDao._();

  // Singleton accessor
  static TopRatedProductDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(TopRatedProduct object) {
    return object.id;
  }

  @override
  Filter getFilter(TopRatedProduct object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
