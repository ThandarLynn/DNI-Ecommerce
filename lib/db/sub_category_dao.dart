import 'package:sembast/sembast.dart';
import 'package:dni_ecommerce/db/common/app_dao.dart';
import 'package:dni_ecommerce/viewobject/sub_category.dart';

class SubCategoryDao extends AppDao<SubCategory> {
  SubCategoryDao() {
    init(SubCategory());
  }

  static const String STORE_NAME = 'SubCategory';
  final String _primaryKey = 'id';

  @override
  String getPrimaryKey(SubCategory object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(SubCategory object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
