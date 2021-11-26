import 'package:dni_ecommerce/viewobject/category.dart';
import 'package:sembast/sembast.dart';
import 'package:dni_ecommerce/db/common/app_dao.dart' show AppDao;

class CategoryDao extends AppDao<Category> {
  CategoryDao() {
    init(Category());
  }
  static const String STORE_NAME = 'Category';
  final String _primaryKey = 'id';

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Category object) {
    return object.id;
  }

  @override
  Filter getFilter(Category object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
