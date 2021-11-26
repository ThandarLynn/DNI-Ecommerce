import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/ui/common/dialog/confirm_dialog_view.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';

import 'language_list_item.dart';

class LanguageListView extends StatefulWidget {
  const LanguageListView({Key key}) : super(key: key);

  @override
  _LanguageListViewState createState() => _LanguageListViewState();
}

class _LanguageListViewState extends State<LanguageListView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: AppConfig.animation_duration, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Utils.getBrightnessForAppBar(context),
        iconTheme: IconThemeData(color: AppColors.mainColorWithWhite),
        title: Text('Language',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold)
                .copyWith(color: AppColors.mainColorWithWhite)),
        flexibleSpace: Container(
          height: 200,
        ),
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: AppConfig.appSupportedLanguageList.length,
          itemBuilder: (BuildContext contex, int index) {
            final int count = AppConfig.appSupportedLanguageList.length;
            return LanguageListItem(
                language: AppConfig.appSupportedLanguageList[index],
                animationController: animationController,
                animation:
                    Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * index, 1.0,
                      curve: Curves.fastOutSlowIn),
                )),
                onTap: () {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialogView(
                            description: Utils.getString(
                                'home__language_dialog_description'),
                            leftButtonText:
                                Utils.getString('app_info__cancel_button_name'),
                            rightButtonText: Utils.getString('dialog__ok'),
                            onAgreeTap: () {
                              Navigator.of(context).pop();
                              Navigator.pop(context,
                                  AppConfig.appSupportedLanguageList[index]);
                            });
                      });
                });
          }),
    );
  }
}
