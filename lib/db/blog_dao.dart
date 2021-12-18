import 'package:dni_ecommerce/viewobject/blog.dart';
import 'package:sembast/sembast.dart';
import 'package:dni_ecommerce/db/common/app_dao.dart' show AppDao;

class BlogDao extends AppDao<Blog> {
  BlogDao._() {
    init(Blog());
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
  String getPrimaryKey(Blog object) {
    return object.id;
  }

  @override
  Filter getFilter(Blog object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
