import 'dart:async';
// import 'dart:io';
import 'package:dni_ecommerce/app_provider_dependencies.dart';
import 'package:dni_ecommerce/constant/router.dart' as router;
// import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/language.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_colors.dart';
import 'config/app_config.dart';
import 'config/app_theme_data.dart';

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('codeC') == null) {
    await prefs.setString('codeC', '');
    await prefs.setString('codeL', '');
  }

  await Firebase.initializeApp();

  // if (Platform.isIOS) {
  //   FirebaseMessaging.instance.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  // }

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  //check is apple signin is available
  // await Utils.checkAppleSignInAvailable();

  runApp(MultiProvider(
      providers: <SingleChildWidget>[
        ...providers,
      ],
      child: EasyLocalization(
          path: 'assets/langs',
          saveLocale: true,
          startLocale: AppConfig.defaultLanguage.toLocale(),
          supportedLocales: getSupportedLanguages(),
          child: MainApp())));
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in AppConfig.appSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

// Future<dynamic> initAds() async {
//   if (AppConfig.showAdMob && await Utils.checkInternetConnectivity()) {
//     // FirebaseAdMob.instance.initialize(appId: Utils.getAdAppId());
//   }
// }

class _MainAppState extends State<MainApp> {
  Completer<ThemeData> themeDataCompleter;

  @override
  void initState() {
    super.initState();
  }

  Future<ThemeData> getSharePerference(
      EasyLocalization provider, dynamic data) {
    print('>> get share perference');
    if (themeDataCompleter == null) {
      print('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    return themeDataCompleter.future;
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in AppConfig.appSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

  @override
  Widget build(BuildContext context) {
    // init Color
    AppColors.loadColor(context);
    print(EasyLocalization.of(context).locale.languageCode);
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (Brightness brightness) {
          if (brightness == Brightness.light) {
            return themeData(ThemeData.light());
          } else {
            return themeData(ThemeData.dark());
          }
        },
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Thandar-Lynn',
            theme: theme,
            initialRoute: '/',
            onGenerateRoute: router.generateRoute,
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              EasyLocalization.of(context).delegate,
              DefaultCupertinoLocalizations.delegate
            ],
            supportedLocales: EasyLocalization.of(context).supportedLocales,
            locale: EasyLocalization.of(context).locale,
          );
        });
  }
}
