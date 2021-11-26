import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/ui/common/dialog/warning_dialog_view.dart';
import 'package:dni_ecommerce/ui/common/app_button_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key key,
    this.animationController,
    this.animation,
    this.onProfileSelected,
    this.onForgotPasswordSelected,
    this.onSignInSelected,
    this.onPhoneSignInSelected,
    this.onFbSignInSelected,
    this.onGoogleSignInSelected,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final Function onProfileSelected,
      onForgotPasswordSelected,
      onSignInSelected,
      onPhoneSignInSelected,
      onFbSignInSelected,
      onGoogleSignInSelected;
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserRepository repo1;
  AppValueHolder psValueHolder;

  void updateCheckBox(BuildContext context, UserProvider provider) {
    if (provider.isCheckBoxSelect) {
      provider.isCheckBoxSelect = false;
    } else {
      provider.isCheckBoxSelect = true;

      Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    const Widget _spacingWidget = SizedBox(
      height: AppDimens.space28,
    );

    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<AppValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<UserProvider>(
      lazy: false,
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: psValueHolder);
        print(provider.getCurrentFirebaseUser());
        return provider;
      },
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget child) {
        return AnimatedBuilder(
          animation: widget.animationController,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _HeaderIconAndTextWidget(),
                _TextFieldAndSignInButtonWidget(
                  provider: provider,
                  text: Utils.getString('login__submit'),
                  onProfileSelected: widget.onProfileSelected,
                ),
                _spacingWidget,
                _DividerORWidget(),
                const SizedBox(
                  height: AppDimens.space12,
                ),
                _TermsAndConCheckbox(
                  provider: provider,
                  onCheckBoxClick: () {
                    setState(() {
                      updateCheckBox(context, provider);
                    });
                  },
                ),
                const SizedBox(
                  height: AppDimens.space8,
                ),
                // if (AppConfig.showPhoneLogin)
                //   _LoginWithPhoneWidget(
                //     onPhoneSignInSelected: widget.onPhoneSignInSelected,
                //     provider: provider,
                //   ),
                // if (AppConfig.showFacebookLogin)
                //   _LoginWithFbWidget(
                //       userProvider: provider,
                //       onFbSignInSelected: widget.onFbSignInSelected),
                // if (AppConfig.showGoogleLogin)
                //   _LoginWithGoogleWidget(
                //       userProvider: provider,
                //       onGoogleSignInSelected: widget.onGoogleSignInSelected),
                // if (Utils.isAppleSignInAvailable == 1 && Platform.isIOS)
                //   _LoginWithAppleIdWidget(
                //       onAppleIdSignInSelected: widget.onGoogleSignInSelected),

                _spacingWidget,
                _ForgotPasswordAndRegisterWidget(
                  provider: provider,
                  animationController: widget.animationController,
                  onForgotPasswordSelected: widget.onForgotPasswordSelected,
                  onSignInSelected: widget.onSignInSelected,
                ),
                _spacingWidget,
              ],
            ),
          ),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          },
        );
      }),
    ));
  }
}

class _TermsAndConCheckbox extends StatefulWidget {
  const _TermsAndConCheckbox(
      {@required this.provider, @required this.onCheckBoxClick});

  final UserProvider provider;
  final Function onCheckBoxClick;

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
            widget.onCheckBoxClick();
          },
        ),
        Expanded(
          child: InkWell(
            child: Text(
              Utils.getString('login__agree_privacy'),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onTap: () {
              widget.onCheckBoxClick();
            },
          ),
        ),
      ],
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

class _TextFieldAndSignInButtonWidget extends StatefulWidget {
  const _TextFieldAndSignInButtonWidget({
    @required this.provider,
    @required this.text,
    this.onProfileSelected,
  });

  final UserProvider provider;
  final String text;
  final Function onProfileSelected;

  @override
  __CardWidgetState createState() => __CardWidgetState();
}

class __CardWidgetState extends State<_TextFieldAndSignInButtonWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: AppDimens.space16,
        right: AppDimens.space16,
        top: AppDimens.space4,
        bottom: AppDimens.space4);
    return Column(
      children: <Widget>[
        Card(
          elevation: 0.3,
          margin: const EdgeInsets.only(
              left: AppDimens.space32, right: AppDimens.space32),
          child: Column(
            children: <Widget>[
              Container(
                margin: _marginEdgeInsetsforCard,
                child: TextField(
                  controller: emailController,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Utils.getString('login__email'),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: AppColors.textPrimaryLightColor),
                      icon: Icon(Icons.email,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              const Divider(
                height: AppDimens.space1,
              ),
              Container(
                margin: _marginEdgeInsetsforCard,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: Theme.of(context).textTheme.button.copyWith(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Utils.getString('login__password'),
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
        ),
        const SizedBox(
          height: AppDimens.space8,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: AppDimens.space32, right: AppDimens.space32),
          child: AppButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString('login__sign_in'),
            onPressed: () async {
              if (emailController.text.isEmpty) {
                callWarningDialog(
                    context, Utils.getString('warning_dialog__input_email'));
              } else if (passwordController.text.isEmpty) {
                callWarningDialog(
                    context, Utils.getString('warning_dialog__input_password'));
              } else {
                if (Utils.checkEmailFormat(emailController.text.trim())) {
                  await widget.provider.loginWithEmailId(
                      context,
                      emailController.text.trim(),
                      passwordController.text,
                      widget.onProfileSelected);
                } else {
                  callWarningDialog(
                      context, Utils.getString('warning_dialog__email_format'));
                }
              }
            },
          ),
        )
      ],
    );
  }
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

class _DividerORWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Expanded(
      child: Divider(
        height: AppDimens.space2,
      ),
    );

    const Widget _spacingWidget = SizedBox(
      width: AppDimens.space8,
    );

    final Widget _textWidget =
        Text('OR', style: Theme.of(context).textTheme.subtitle1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _dividerWidget,
        _spacingWidget,
        _textWidget,
        _spacingWidget,
        _dividerWidget,
      ],
    );
  }
}

class _LoginWithPhoneWidget extends StatefulWidget {
  const _LoginWithPhoneWidget(
      {@required this.onPhoneSignInSelected, @required this.provider});
  final Function onPhoneSignInSelected;
  final UserProvider provider;

  @override
  __LoginWithPhoneWidgetState createState() => __LoginWithPhoneWidgetState();
}

class __LoginWithPhoneWidgetState extends State<_LoginWithPhoneWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: AppDimens.space32, right: AppDimens.space32),
      child: PSButtonWithIconWidget(
        titleText: Utils.getString('login__phone_signin'),
        icon: Icons.phone,
        colorData: widget.provider.isCheckBoxSelect
            ? AppColors.mainColor
            : AppColors.mainColor,
        onPressed: () async {
          if (widget.provider.isCheckBoxSelect) {
            if (widget.onPhoneSignInSelected != null) {
              widget.onPhoneSignInSelected();
            } else {
              Navigator.pushReplacementNamed(
                context,
                RoutePaths.user_phone_signin_container,
              );
            }
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return WarningDialog(
                    message: Utils.getString('login__warning_agree_privacy'),
                    onPressed: () {},
                  );
                });
          }
        },
      ),
    );
  }
}

class _LoginWithFbWidget extends StatefulWidget {
  const _LoginWithFbWidget(
      {@required this.userProvider, @required this.onFbSignInSelected});
  final UserProvider userProvider;
  final Function onFbSignInSelected;

  @override
  __LoginWithFbWidgetState createState() => __LoginWithFbWidgetState();
}

class __LoginWithFbWidgetState extends State<_LoginWithFbWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: AppDimens.space32,
          top: AppDimens.space8,
          right: AppDimens.space32),
      child: PSButtonWithIconWidget(
          titleText: Utils.getString('login__fb_signin'),
          icon: FontAwesome.facebook_official,
          colorData: widget.userProvider.isCheckBoxSelect == false
              ? AppColors.facebookLoginButtonColor
              : AppColors.facebookLoginButtonColor,
          onPressed: () async {
            // await widget.userProvider
            //     .loginWithFacebookId(context, widget.onFbSignInSelected);
          }),
    );
  }
}

class _LoginWithGoogleWidget extends StatefulWidget {
  const _LoginWithGoogleWidget(
      {@required this.userProvider, @required this.onGoogleSignInSelected});
  final UserProvider userProvider;
  final Function onGoogleSignInSelected;

  @override
  __LoginWithGoogleWidgetState createState() => __LoginWithGoogleWidgetState();
}

class __LoginWithGoogleWidgetState extends State<_LoginWithGoogleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: AppDimens.space32,
          top: AppDimens.space8,
          right: AppDimens.space32),
      child: PSButtonWithIconWidget(
        titleText: Utils.getString('login__google_signin'),
        icon: FontAwesome.google,
        colorData: widget.userProvider.isCheckBoxSelect
            ? AppColors.googleLoginButtonColor
            : AppColors.googleLoginButtonColor,
        onPressed: () async {
          // await widget.userProvider
          //     .loginWithGoogleId(context, widget.onGoogleSignInSelected);
        },
      ),
    );
  }
}

// class _LoginWithAppleIdWidget extends StatelessWidget {
//   const _LoginWithAppleIdWidget({@required this.onAppleIdSignInSelected});

//   final Function onAppleIdSignInSelected;

//   @override
//   Widget build(BuildContext context) {
//     final UserProvider _userProvider =
//         Provider.of<UserProvider>(context, listen: false);
//     return Container(
//         margin: const EdgeInsets.only(
//             left: AppDimens.space32,
//             top: AppDimens.space8,
//             right: AppDimens.space32),
//         child: Directionality(
//           // add this
//           textDirection: TextDirection.ltr,
//           child: apple.AppleSignInButton(
//             style: apple.ButtonStyle.black, // style as needed
//             type: apple.ButtonType.signIn, // style as needed

//             onPressed: () async {
//               // await _userProvider.loginWithAppleId(
//               //     context, onAppleIdSignInSelected);
//             },
//           ),
//         ));
//   }
// }

class _ForgotPasswordAndRegisterWidget extends StatefulWidget {
  const _ForgotPasswordAndRegisterWidget(
      {Key key,
      this.provider,
      this.animationController,
      this.onForgotPasswordSelected,
      this.onSignInSelected})
      : super(key: key);

  final AnimationController animationController;
  final Function onForgotPasswordSelected;
  final Function onSignInSelected;
  final UserProvider provider;

  @override
  __ForgotPasswordAndRegisterWidgetState createState() =>
      __ForgotPasswordAndRegisterWidgetState();
}

class __ForgotPasswordAndRegisterWidgetState
    extends State<_ForgotPasswordAndRegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: AppDimens.space40),
      margin: const EdgeInsets.all(AppDimens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: GestureDetector(
              child: Text(
                Utils.getString('login__forgot_password'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                      color: AppColors.mainColor,
                    ),
              ),
              onTap: () {
                if (widget.onForgotPasswordSelected != null) {
                  widget.onForgotPasswordSelected();
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.user_forgot_password_container,
                  );
                }
              },
            ),
          ),
          Flexible(
            child: GestureDetector(
              child: Text(
                Utils.getString('login__sign_up'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                      color: AppColors.mainColor,
                    ),
              ),
              onTap: () async {
                if (widget.onSignInSelected != null) {
                  widget.onSignInSelected();
                } else {
                  final dynamic returnData =
                      await Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.user_register_container,
                  );
                  if (returnData != null && returnData is User) {
                    final User user = returnData;
                    widget.provider.psValueHolder =
                        Provider.of<AppValueHolder>(context, listen: false);
                    widget.provider.psValueHolder.loginUserId = user.userId;
                    widget.provider.psValueHolder.userIdToVerify = '';
                    widget.provider.psValueHolder.userNameToVerify = '';
                    widget.provider.psValueHolder.userEmailToVerify = '';
                    widget.provider.psValueHolder.userPasswordToVerify = '';
                    Navigator.pop(context, user);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
