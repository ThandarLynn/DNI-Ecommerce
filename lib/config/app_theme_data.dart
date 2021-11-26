import 'package:dni_ecommerce/config/app_config.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData themeData(ThemeData baseTheme) {
  //final baseTheme = ThemeData.light();

  if (baseTheme.brightness == Brightness.dark) {
    AppColors.loadColor2(false);

    // Dark Theme
    return baseTheme.copyWith(
      primaryColor: AppColors.mainColor,
      primaryColorDark: AppColors.mainDarkColor,
      primaryColorLight: AppColors.mainLightColor,
      textTheme: TextTheme(
        headline1: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family),
        headline2: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family),
        headline3: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family),
        headline4: TextStyle(
          color: AppColors.textPrimaryColor,
          fontFamily: AppConfig.app_default_font_family,
        ),
        headline5: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family,
            fontWeight: FontWeight.bold),
        headline6: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family),
        subtitle1: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family,
            fontWeight: FontWeight.bold),
        subtitle2: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family,
            fontWeight: FontWeight.bold),
        bodyText1: TextStyle(
          color: AppColors.textPrimaryColor,
          fontFamily: AppConfig.app_default_font_family,
        ),
        bodyText2: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family,
            fontWeight: FontWeight.bold),
        button: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family),
        caption: TextStyle(
            color: AppColors.textPrimaryLightColor,
            fontFamily: AppConfig.app_default_font_family),
        overline: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family),
      ),
      iconTheme: IconThemeData(color: AppColors.iconColor),
      appBarTheme: AppBarTheme(color: AppColors.coreBackgroundColor),
    );
  } else {
    AppColors.loadColor2(true);
    // White Theme
    return baseTheme.copyWith(
        primaryColor: AppColors.mainColor,
        primaryColorDark: AppColors.mainDarkColor,
        primaryColorLight: AppColors.mainLightColor,
        textTheme: TextTheme(
          headline1: TextStyle(
              color: AppColors.textPrimaryColor,
              fontFamily: AppConfig.app_default_font_family),
          headline2: TextStyle(
              color: AppColors.textPrimaryColor,
              fontFamily: AppConfig.app_default_font_family),
          headline3: TextStyle(
              color: AppColors.textPrimaryColor,
              fontFamily: AppConfig.app_default_font_family),
          headline4: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family,
          ),
          headline5: TextStyle(
              color: AppColors.textPrimaryColor,
              fontFamily: AppConfig.app_default_font_family,
              fontWeight: FontWeight.bold),
          headline6: TextStyle(
              color: AppColors.textPrimaryColor,
              fontFamily: AppConfig.app_default_font_family),
          subtitle1: TextStyle(
              color: AppColors.textPrimaryColor,
              fontFamily: AppConfig.app_default_font_family,
              fontWeight: FontWeight.bold),
          subtitle2: TextStyle(
              color: AppColors.textPrimaryColor,
              fontFamily: AppConfig.app_default_font_family,
              fontWeight: FontWeight.bold),
          bodyText1: TextStyle(
            color: AppColors.textPrimaryColor,
            fontFamily: AppConfig.app_default_font_family,
          ),
          bodyText2: TextStyle(
              color: AppColors.textPrimaryColor,
              fontFamily: AppConfig.app_default_font_family,
              fontWeight: FontWeight.bold),
          button: TextStyle(
              color: AppColors.textPrimaryColor,
              fontFamily: AppConfig.app_default_font_family),
          caption: TextStyle(
              color: AppColors.textPrimaryLightColor,
              fontFamily: AppConfig.app_default_font_family),
          overline: TextStyle(
              color: AppColors.textPrimaryColor,
              fontFamily: AppConfig.app_default_font_family),
        ),
        iconTheme: IconThemeData(color: AppColors.iconColor),
        appBarTheme: AppBarTheme(color: AppColors.coreBackgroundColor));
  }
}
