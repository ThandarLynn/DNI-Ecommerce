import 'package:flutter/material.dart';

class Language {
  const Language({this.languageCode, this.countryCode, this.name});
  final String languageCode;
  final String countryCode;
  final String name;

  Locale toLocale() {
    return Locale(languageCode, countryCode);
  }
}
