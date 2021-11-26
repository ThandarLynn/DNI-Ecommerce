import 'app_object.dart';

abstract class AppMapObject<T> extends AppObject<T> {
  int sorting;

  List<String> getIdList(List<T> mapList);
}
