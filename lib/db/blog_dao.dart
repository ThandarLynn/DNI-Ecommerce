import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:sembast/sembast.dart';
import 'package:dni_ecommerce/db/common/app_dao.dart' show AppDao;

class BlogDao extends AppDao<Product> {
  BlogDao._() {
    init(Product());
  }
  static const String STORE_NAME = 'Blog';
  final String _primaryKey = 'id';

  // Singleton instance
  static final BlogDao _singleton = BlogDao._();

  // Singleton accessor
  static BlogDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Product object) {
    return object.id;
  }

  @override
  Filter getFilter(Product object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
