import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/provider/contact/contact_us_provider.dart';
import 'package:dni_ecommerce/repository/contact_us_repository.dart';
import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
import 'package:dni_ecommerce/ui/common/dialog/success_dialog.dart';
import 'package:dni_ecommerce/ui/common/app_button_widget.dart';
import 'package:dni_ecommerce/ui/common/app_textfield_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/holder/contact_us_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  ContactUsRepository contactUsRepo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();
    contactUsRepo = Provider.of<ContactUsRepository>(context);
    const Widget _largeSpacingWidget = SizedBox(
      height: AppDimens.space8,
    );
    return ChangeNotifierProvider<ContactUsProvider>(
        lazy: false,
        create: (BuildContext context) {
          final ContactUsProvider contactUsProvide =
              ContactUsProvider(repo: contactUsRepo);
          return contactUsProvide;
        },
        child: Consumer<ContactUsProvider>(
          builder:
              (BuildContext context, ContactUsProvider provider, Widget child) {
            return AnimatedBuilder(
                animation: widget.animationController,
                child: SingleChildScrollView(
                    child: Container(
                  padding: const EdgeInsets.all(AppDimens.space8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppTextFieldWidget(
                          titleText:
                              Utils.getString('contact_us__contact_name'),
                          textAboutMe: false,
                          hintText:
                              Utils.getString('contact_us__contact_name_hint'),
                          textEditingController: nameController),
                      AppTextFieldWidget(
                          titleText:
                              Utils.getString('contact_us__contact_email'),
                          textAboutMe: false,
                          hintText:
                              Utils.getString('contact_us__contact_email_hint'),
                          textEditingController: emailController),
                      AppTextFieldWidget(
                          titleText:
                              Utils.getString('contact_us__contact_phone'),
                          textAboutMe: false,
                          hintText:
                              Utils.getString('contact_us__contact_phone_hint'),
                          keyboardType: TextInputType.phone,
                          phoneInputType: true,
                          textEditingController: phoneController),
                      AppTextFieldWidget(
                          titleText:
                              Utils.getString('contact_us__contact_message'),
                          textAboutMe: false,
                          height: AppDimens.space160,
                          hintText: Utils.getString(
                              'contact_us__contact_message_hint'),
                          textEditingController: messageController),
                      Container(
                        margin: const EdgeInsets.only(
                            left: AppDimens.space16,
                            top: AppDimens.space16,
                            right: AppDimens.space16,
                            bottom: AppDimens.space40),
                        child: ButtonWidget(
                          provider: provider,
                          nameText: nameController,
                          emailText: emailController,
                          messageText: messageController,
                          phoneText: phoneController,
                        ),
                      ),
                      _largeSpacingWidget,
                    ],
                  ),
                )),
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                      opacity: animation,
                      child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 100 * (1.0 - animation.value), 0.0),
                          child: child));
                });
          },
        ));
  }
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    @required this.nameText,
    @required this.emailText,
    @required this.messageText,
    @required this.phoneText,
    @required this.provider,
  });

  final TextEditingController nameText, emailText, messageText, phoneText;
  final ContactUsProvider provider;

  @override
  Widget build(BuildContext context) {
    return AppButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString('contact_us__submit'),
        onPressed: () async {
          if (nameText.text != '' &&
              emailText.text != '' &&
              messageText.text != '' &&
              phoneText.text != '') {
            if (await Utils.checkInternetConnectivity()) {
              final ContactUsParameterHolder contactUsParameterHolder =
                  ContactUsParameterHolder(
                name: nameText.text,
                email: emailText.text,
                message: messageText.text,
                phone: phoneText.text,
              );

              final AppResource<ApiStatus> _apiStatus = await provider
                  .postContactUs(contactUsParameterHolder.toMap());

              if (_apiStatus.data != null) {
                print('Success');
                nameText.clear();
                emailText.clear();
                messageText.clear();
                phoneText.clear();
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      if (_apiStatus.data.status == 'success') {
                        return SuccessDialog(
                          message: _apiStatus.data.status,
                        );
                      } else {
                        return ErrorDialog(
                          message: _apiStatus.data.status,
                        );
                      }
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
            print('Fail');
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: Utils.getString('contact_us__fail'),
                  );
                });
          }
        });
  }
}
