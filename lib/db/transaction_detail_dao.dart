import 'package:dni_ecommerce/viewobject/transaction_detail.dart';
import 'package:sembast/sembast.dart';

import 'common/app_dao.dart';

class TransactionDetailDao extends AppDao<TransactionDetail> {
  TransactionDetailDao._() {
    init(TransactionDetail());
  }
  static const String STORE_NAME = 'Transaction';
  final String _primaryKey = 'id';

  // Singleton instance
  static final TransactionDetailDao _singleton = TransactionDetailDao._();

  // Singleton accessor
  static TransactionDetailDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(TransactionDetail object) {
    return object.id;
  }

  @override
  Filter getFilter(TransactionDetail object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
