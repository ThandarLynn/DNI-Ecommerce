abstract class AppHolder<T> {
  T fromMap(dynamic dynamicData);

  Map<dynamic, dynamic> toMap();

  String getParamKey();
}
