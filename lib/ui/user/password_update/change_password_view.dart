import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
import 'package:dni_ecommerce/ui/common/dialog/success_dialog.dart';
import 'package:dni_ecommerce/ui/common/app_button_widget.dart';
import 'package:dni_ecommerce/ui/common/app_textfield_widget.dart';
import 'package:dni_ecommerce/ui/common/app_widget_with_appbar.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/change_password_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  UserRepository userRepo;
  AppValueHolder psValueHolder;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    userRepo = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<AppValueHolder>(context);
    const Widget _largeSpacingWidget = SizedBox(
      height: AppDimens.space8,
    );
    return AppWidgetWithAppBar<UserProvider>(
        appBarTitle: Utils.getString('change_password__title') ?? '',
        initProvider: () {
          return UserProvider(repo: userRepo, psValueHolder: psValueHolder);
        },
        onProviderReady: (UserProvider provider) {
          return provider;
        },
        builder: (BuildContext context, UserProvider provider, Widget child) {
          return SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(AppDimens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppTextFieldWidget(
                    titleText: Utils.getString('change_password__password'),
                    textAboutMe: false,
                    hintText: Utils.getString('change_password__password'),
                    textEditingController: passwordController),
                AppTextFieldWidget(
                    titleText:
                        Utils.getString('change_password__confirm_password'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString('change_password__confirm_password'),
                    textEditingController: confirmPasswordController),
                Container(
                  margin: const EdgeInsets.all(AppDimens.space16),
                  child: PsButtonWidget(
                    provider: provider,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),
                ),
                _largeSpacingWidget,
              ],
            ),
          ));
        });
  }
}

class PsButtonWidget extends StatelessWidget {
  const PsButtonWidget({
    @required this.passwordController,
    @required this.confirmPasswordController,
    @required this.provider,
  });

  final TextEditingController passwordController, confirmPasswordController;
  final UserProvider provider;

  @override
  Widget build(BuildContext context) {
    return AppButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString('edit_profile__save'),
        onPressed: () async {
          if (passwordController.text != '' &&
              confirmPasswordController.text != '') {
            if (passwordController.text == confirmPasswordController.text) {
              if (await Utils.checkInternetConnectivity()) {
                final ChangePasswordParameterHolder contactUsParameterHolder =
                    ChangePasswordParameterHolder(
                        userId: provider.psValueHolder.loginUserId,
                        userPassword: passwordController.text);

                final AppResource<ApiStatus> _apiStatus = await provider
                    .postChangePassword(contactUsParameterHolder.toMap());

                if (_apiStatus.data != null) {
                  passwordController.clear();
                  confirmPasswordController.clear();

                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return SuccessDialog(
                          message: _apiStatus.data.status,
                        );
                      });
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: _apiStatus.message,
                        );
                      });
                }
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString('error_dialog__no_internet'),
                      );
                    });
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: Utils.getString('change_password__not_equal'),
                    );
                  });
            }
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: Utils.getString('change_password__error'),
                  );
                });
          }
        });
  }
}
