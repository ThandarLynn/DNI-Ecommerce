import 'dart:async';
import 'dart:io';

import 'package:dni_ecommerce/app_provider_dependencies.dart';
import 'package:dni_ecommerce/constant/router.dart' as router;
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/language.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_colors.dart';
import 'config/app_config.dart';
import 'config/app_theme_data.dart';
import 'db/common/app_shared_preferences.dart';

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  // final FirebaseMessaging _fcm = FirebaseMessaging();
  // if (Platform.isIOS) {
  //   _fcm.requestNotificationPermissions(const IosNotificationSettings());
  // }

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('codeC') == null) {
    await prefs.setString('codeC', ''); //null);
    await prefs.setString('codeL', ''); //null);
  }

  await Firebase.initializeApp();
  // NativeAdmob(adUnitID: Utils.getAdAppId());

  if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  //check is apple signin is available
  await Utils.checkAppleSignInAvailable();

  runApp(EasyLocalization(
      path: 'assets/langs',
      saveLocale: true,
      startLocale: AppConfig.defaultLanguage.toLocale(),
      supportedLocales: getSupportedLanguages(),
      child: MainApp()));
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

Future<dynamic> initAds() async {
  if (AppConfig.showAdMob && await Utils.checkInternetConnectivity()) {
    // FirebaseAdMob.instance.initialize(appId: Utils.getAdAppId());
  }
}

class _MainAppState extends State<MainApp> {
  Completer<ThemeData> themeDataCompleter;
  AppSharedPreferencess psSharedPreferences;

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

    // if (psSharedPreferences == null) {
    //   print('init ps shareperferences');
    //   psSharedPreferences = AppSharedPreferencess.instance;
    //   print('get shared');
    //   psSharedPreferences.futureShared.then((SharedPreferences sh) {
    //     psSharedPreferences.shared = sh;

    //     print('init theme provider');
    //     final PsThemeProvider psThemeProvider = PsThemeProvider(
    //         repo: PsThemeRepository(psSharedPreferences: psSharedPreferences));

    //     print('get theme');
    //     final ThemeData themeData = psThemeProvider.getTheme();
    //     themeDataCompleter.complete(themeData);
    //     print('themedata loading completed');
    //   });
    // }

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
    return MultiProvider(
        providers: <SingleChildWidget>[
          ...providers,
        ],
        child: DynamicTheme(
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
                title: 'Panacea-Soft',
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
            }));
  }
}
