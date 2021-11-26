import 'package:dni_ecommerce/ui/common/app_dropdown_base_widget.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageView extends StatefulWidget {
  @override
  _LanguageViewState createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  AppValueHolder valueHolder;
  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<AppValueHolder>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppDropdownBaseWidget(
              title: 'Language',
              selectedText: Utils.getString('language_selection__select'),
              onTap: () async {
                final dynamic result =
                    await Navigator.pushNamed(context, RoutePaths.languageList);
                if (result != null && result is Language) {
                  // await data.changeLocale(result.toLocale());
                  // await provider.addLanguage(result);

                  // widget.languageIsChanged();
                  // await provider.addLanguage(result);
                  EasyLocalization.of(context).locale =
                      Locale(result.languageCode, result.countryCode);
                }
                print(result.toString());
              }),
        ],
      ),
    );
  }
}
