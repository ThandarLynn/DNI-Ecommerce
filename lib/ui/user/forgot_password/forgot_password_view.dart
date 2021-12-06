import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
import 'package:dni_ecommerce/ui/common/dialog/warning_dialog_view.dart';
import 'package:dni_ecommerce/ui/common/app_button_widget.dart';
import 'package:dni_ecommerce/utils/app_progress_dialog.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/forgot_password_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({
    Key key,
    this.animationController,
    this.goToLoginSelected,
  }) : super(key: key);
  final AnimationController animationController;
  final Function goToLoginSelected;
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with SingleTickerProviderStateMixin {
  final TextEditingController userEmailController = TextEditingController();
  UserRepository repo1;
  AppValueHolder psValueHolder;
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: AppConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();
    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<AppValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          final UserProvider provider =
              UserProvider(repo: repo1, psValueHolder: psValueHolder);
          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget child) {
          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: AnimatedBuilder(
                      animation: animationController,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _HeaderIconAndTextWidget(),
                          _CardWidget(
                            userEmailController: userEmailController,
                          ),
                          const SizedBox(
                            height: AppDimens.space8,
                          ),
                          _SendButtonWidget(
                            provider: provider,
                            userEmailController: userEmailController,
                          ),
                          const SizedBox(
                            height: AppDimens.space16,
                          ),
                          _TextWidget(
                              goToLoginSelected: widget.goToLoginSelected),
                        ],
                      ),
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0, 100 * (1.0 - animation.value), 0.0),
                              child: child),
                        );
                      }))
            ],
          );
        }),
      ),
    );
  }
}

class _TextWidget extends StatefulWidget {
  const _TextWidget({this.goToLoginSelected});
  final Function goToLoginSelected;
  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        Utils.getString('forgot_psw__login'),
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: AppColors.mainColor),
      ),
      onTap: () {
        if (widget.goToLoginSelected != null) {
          widget.goToLoginSelected();
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.login_container,
          );
        }
      },
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(Utils.getString('app_name'),
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(color: AppColors.mainColor));

    final Widget _imageWidget = Container(
      width: 90,
      height: 90,
      child: Image.asset(
        'assets/images/app_logo.png',
      ),
    );
    return Column(
      children: <Widget>[
        const SizedBox(
          height: AppDimens.space32,
        ),
        _imageWidget,
        const SizedBox(
          height: AppDimens.space8,
        ),
        _textWidget,
        const SizedBox(
          height: AppDimens.space52,
        ),
      ],
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({
    @required this.userEmailController,
  });

  final TextEditingController userEmailController;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(
          left: AppDimens.space32, right: AppDimens.space32),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
                left: AppDimens.space16,
                right: AppDimens.space16,
                top: AppDimens.space4,
                bottom: AppDimens.space4),
            child: TextField(
              controller: userEmailController,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString('forgot_psw__email'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: AppColors.textPrimaryLightColor),
                  icon: Icon(Icons.email,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendButtonWidget extends StatefulWidget {
  const _SendButtonWidget({
    @required this.provider,
    @required this.userEmailController,
  });
  final UserProvider provider;
  final TextEditingController userEmailController;

  @override
  __SendButtonWidgetState createState() => __SendButtonWidgetState();
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(text),
          onPressed: () {},
        );
      });
}

class __SendButtonWidgetState extends State<_SendButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: AppDimens.space32, right: AppDimens.space32),
      child: AppButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString('forgot_psw__send'),
          onPressed: () async {
            if (widget.userEmailController.text.isEmpty) {
              callWarningDialog(
                  context, Utils.getString('warning_dialog__input_email'));
            } else {
              if (Utils.checkEmailFormat(
                  widget.userEmailController.text.trim())) {
                if (await Utils.checkInternetConnectivity()) {
                  final ForgotPasswordParameterHolder
                      forgotPasswordParameterHolder =
                      ForgotPasswordParameterHolder(
                    userEmail: widget.userEmailController.text.trim(),
                  );

                  await AppProgressDialog.showDialog(context);

                  final AppResource<ApiStatus> _apiStatus =
                      await widget.provider.postForgotPassword(
                          forgotPasswordParameterHolder.toMap());
                  AppProgressDialog.dismissDialog();

                  if (_apiStatus.data != null) {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.reset_password,
                    );
                    // showDialog<dynamic>(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return SuccessDialog(
                    //         message: _apiStatus.data.message,
                    //       );
                    //     });
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
                callWarningDialog(
                    context, Utils.getString('warning_dialog__email_format'));
              }
            }
          }),
    );
  }
}
