import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/ui/common/dialog/warning_dialog_view.dart';
import 'package:dni_ecommerce/ui/common/app_button_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView(
      {Key key,
      this.animationController,
      this.onRegisterSelected,
      this.goToLoginSelected})
      : super(key: key);
  final AnimationController animationController;
  final Function onRegisterSelected, goToLoginSelected;
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  UserRepository repo1;
  AppValueHolder valueHolder;
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController passwordController;

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
    valueHolder = Provider.of<AppValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          final UserProvider provider =
              UserProvider(repo: repo1, appValueHolder: valueHolder);

          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget child) {
          nameController = TextEditingController(
              text: provider.appValueHolder.userNameToVerify);
          emailController = TextEditingController(
              text: provider.appValueHolder.userEmailToVerify);
          passwordController = TextEditingController(
              text: provider.appValueHolder.userPasswordToVerify);

          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: AnimatedBuilder(
                      animation: animationController,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _HeaderIconAndTextWidget(),
                          _TextFieldWidget(
                            nameText: nameController,
                            emailText: emailController,
                            passwordText: passwordController,
                          ),
                          const SizedBox(
                            height: AppDimens.space8,
                          ),
                          _TermsAndConCheckbox(
                            provider: provider,
                            nameTextEditingController: nameController,
                            emailTextEditingController: emailController,
                            passwordTextEditingController: passwordController,
                          ),
                          const SizedBox(
                            height: AppDimens.space8,
                          ),
                          _SignInButtonWidget(
                            provider: provider,
                            nameTextEditingController: nameController,
                            emailTextEditingController: emailController,
                            passwordTextEditingController: passwordController,
                            onRegisterSelected: widget.onRegisterSelected,
                          ),
                          const SizedBox(
                            height: AppDimens.space16,
                          ),
                          _TextWidget(
                            goToLoginSelected: widget.goToLoginSelected,
                          ),
                          const SizedBox(
                            height: AppDimens.space64,
                          ),
                        ],
                      ),
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                            opacity: animation,
                            child: Transform(
                                transform: Matrix4.translationValues(
                                    0.0, 100 * (1.0 - animation.value), 0.0),
                                child: child));
                      }))
            ],
          );
        }),
      ),
    );
  }
}

class _TermsAndConCheckbox extends StatefulWidget {
  const _TermsAndConCheckbox({
    @required this.provider,
    @required this.nameTextEditingController,
    @required this.emailTextEditingController,
    @required this.passwordTextEditingController,
  });

  final UserProvider provider;
  final TextEditingController nameTextEditingController,
      emailTextEditingController,
      passwordTextEditingController;
  @override
  __TermsAndConCheckboxState createState() => __TermsAndConCheckboxState();
}

class __TermsAndConCheckboxState extends State<_TermsAndConCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: AppDimens.space20,
        ),
        Checkbox(
          activeColor: AppColors.mainColor,
          value: widget.provider.isCheckBoxSelect,
          onChanged: (bool value) {
            setState(() {
              updateCheckBox(
                  widget.provider.isCheckBoxSelect,
                  context,
                  widget.provider,
                  widget.nameTextEditingController,
                  widget.emailTextEditingController,
                  widget.passwordTextEditingController);
            });
          },
        ),
        Expanded(
          child: InkWell(
            child: Text(
              Utils.getString('login__agree_privacy'),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onTap: () {
              setState(() {
                updateCheckBox(
                    widget.provider.isCheckBoxSelect,
                    context,
                    widget.provider,
                    widget.nameTextEditingController,
                    widget.emailTextEditingController,
                    widget.passwordTextEditingController);
              });
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(
    bool isCheckBoxSelect,
    BuildContext context,
    UserProvider provider,
    TextEditingController nameTextEditingController,
    TextEditingController emailTextEditingController,
    TextEditingController passwordTextEditingController) {
  if (isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
  } else {
    provider.isCheckBoxSelect = true;
    //it is for holder
    provider.appValueHolder.userNameToVerify = nameTextEditingController.text;
    provider.appValueHolder.userEmailToVerify = emailTextEditingController.text;
    provider.appValueHolder.userPasswordToVerify =
        passwordTextEditingController.text;
    Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
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
        Utils.getString('register__login'),
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

class _TextFieldWidget extends StatefulWidget {
  const _TextFieldWidget({
    @required this.nameText,
    @required this.emailText,
    @required this.passwordText,
  });

  final TextEditingController nameText, emailText, passwordText;
  @override
  __TextFieldWidgetState createState() => __TextFieldWidgetState();
}

class __TextFieldWidgetState extends State<_TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetWidget = EdgeInsets.only(
        left: AppDimens.space16,
        right: AppDimens.space16,
        top: AppDimens.space4,
        bottom: AppDimens.space4);

    const Widget _dividerWidget = Divider(
      height: AppDimens.space1,
    );
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(
          left: AppDimens.space32, right: AppDimens.space32),
      child: Column(
        children: <Widget>[
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.nameText,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString('register__user_name'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: AppColors.textPrimaryLightColor),
                  icon: Icon(Icons.people,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          _dividerWidget,
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.emailText,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString('register__email'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: AppColors.textPrimaryLightColor),
                  icon: Icon(Icons.email,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          _dividerWidget,
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.passwordText,
              obscureText: true,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString('register__password'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: AppColors.textPrimaryLightColor),
                  icon: Icon(Icons.lock,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: AppDimens.space32,
        ),
        Container(
          width: 90,
          height: 90,
          child: Image.asset(
            'assets/images/app_logo.png',
          ),
        ),
        const SizedBox(
          height: AppDimens.space8,
        ),
        Text(Utils.getString('app_name'),
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: AppColors.mainColor)),
        const SizedBox(
          height: AppDimens.space52,
        ),
      ],
    );
  }
}

class _SignInButtonWidget extends StatefulWidget {
  const _SignInButtonWidget(
      {@required this.provider,
      @required this.nameTextEditingController,
      @required this.emailTextEditingController,
      @required this.passwordTextEditingController,
      this.onRegisterSelected});
  final UserProvider provider;
  final Function onRegisterSelected;
  final TextEditingController nameTextEditingController,
      emailTextEditingController,
      passwordTextEditingController;

  @override
  __SignInButtonWidgetState createState() => __SignInButtonWidgetState();
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

class __SignInButtonWidgetState extends State<_SignInButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: AppDimens.space32, right: AppDimens.space32),
      child: AppButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString('register__register'),
        onPressed: () async {
          // if (widget.provider.isCheckBoxSelect) {
          if (widget.nameTextEditingController.text.isEmpty) {
            callWarningDialog(
                context, Utils.getString('warning_dialog__input_name'));
          } else if (widget.emailTextEditingController.text.isEmpty) {
            callWarningDialog(
                context, Utils.getString('warning_dialog__input_email'));
          } else if (widget.passwordTextEditingController.text.isEmpty) {
            callWarningDialog(
                context, Utils.getString('warning_dialog__input_password'));
          } else {
            if (Utils.checkEmailFormat(
                widget.emailTextEditingController.text.trim())) {
              await widget.provider.signUpWithEmailId(
                  context,
                  widget.onRegisterSelected,
                  widget.nameTextEditingController.text,
                  widget.emailTextEditingController.text.trim(),
                  widget.passwordTextEditingController.text);
            } else {
              callWarningDialog(
                  context, Utils.getString('warning_dialog__email_format'));
            }
            // else {
            //   if (await Utils.checkInternetConnectivity()) {
            //     final UserRegisterParameterHolder userRegisterParameterHolder =
            //         UserRegisterParameterHolder(
            //       userId: '',
            //       userName: widget.nameTextEditingController.text,
            //       userEmail: widget.emailTextEditingController.text,
            //       userPassword: widget.passwordTextEditingController.text,
            //       userPhone: '',
            //       deviceToken: widget.provider.appValueHolder.deviceToken,
            //     );

            //     final AppResource<User> _apiStatus = await widget.provider
            //         .postUserRegister(userRegisterParameterHolder.toMap());

            //     if (_apiStatus.data != null) {
            //       final User user = _apiStatus.data;

            //       await widget.provider.replaceVerifyUserData(
            //           _apiStatus.data.userId,
            //           _apiStatus.data.userName,
            //           _apiStatus.data.userEmail,
            //           widget.passwordTextEditingController.text);

            //       widget.provider.appValueHolder.userIdToVerify = user.userId;
            //       widget.provider.appValueHolder.userNameToVerify =
            //           user.userName;
            //       widget.provider.appValueHolder.userEmailToVerify =
            //           user.userEmail;
            //       widget.provider.appValueHolder.userPasswordToVerify =
            //           user.userPassword;

            //       //
            //       if (widget.onRegisterSelected != null) {
            //         await widget.onRegisterSelected(_apiStatus.data.userId);
            //       } else {
            //         final dynamic returnData = await Navigator.pushNamed(
            //             context, RoutePaths.user_verify_email_container,
            //             arguments: _apiStatus.data.userId);

            //         if (returnData != null && returnData is User) {
            //           final User user = returnData;
            //           if (Provider != null && Provider.of != null) {
            //             widget.provider.appValueHolder =
            //                 Provider.of<AppValueHolder>(context, listen: false);
            //           }
            //           widget.provider.appValueHolder.loginUserId = user.userId;
            //           widget.provider.appValueHolder.userIdToVerify = '';
            //           widget.provider.appValueHolder.userNameToVerify = '';
            //           widget.provider.appValueHolder.userEmailToVerify = '';
            //           widget.provider.appValueHolder.userPasswordToVerify = '';
            //           print(user.userId);
            //           Navigator.of(context).pop();
            //         }
            //       }
            //     } else {
            //       showDialog<dynamic>(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return ErrorDialog(
            //               message: _apiStatus.message,
            //             );
            //           });
            //     }
            //   } else {
            //     showDialog<dynamic>(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return ErrorDialog(
            //             message: Utils.getString(
            //                 context, 'error_dialog__no_internet'),
            //           );
            //         });
            //   }
            // }
            // } else {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message: Utils.getString(
            //               context, 'login__warning_agree_privacy'),
            //         );
            //       });
            // }
          }
        },
      ),
    );
  }
}
