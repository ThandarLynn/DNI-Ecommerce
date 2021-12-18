import 'package:dni_ecommerce/db/common/app_dao.dart';
import 'package:dni_ecommerce/viewobject/gallery.dart';
import 'package:sembast/sembast.dart';

class GalleryDao extends AppDao<Gallery> {
  GalleryDao._() {
    init(Gallery());
  }

  static const String STORE_NAME = 'Gallery';
  final String _primaryKey = 'id';
  // Singleton instance
  static final GalleryDao _singleton = GalleryDao._();

  // Singleton accessor
  static GalleryDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Gallery object) {
    return object.imgId;
  }

  @override
  Filter getFilter(Gallery object) {
    return Filter.equals(_primaryKey, object.imgId);
  }
}
