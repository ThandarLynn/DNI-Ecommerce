import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
// import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
import 'package:dni_ecommerce/ui/common/dialog/warning_dialog_view.dart';
import 'package:dni_ecommerce/ui/common/app_dropdown_base_with_controller_widget.dart';
import 'package:dni_ecommerce/ui/common/app_textfield_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/shipping_city.dart';
import 'package:dni_ecommerce/viewobject/shipping_country.dart';
import 'package:dni_ecommerce/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Checkout1View extends StatefulWidget {
  const Checkout1View(this.updateCheckout1ViewState);
  final Function updateCheckout1ViewState;

  @override
  _Checkout1ViewState createState() {
    final _Checkout1ViewState _state = _Checkout1ViewState();
    updateCheckout1ViewState(_state);
    return _state;
  }
}

class _Checkout1ViewState extends State<Checkout1View> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController shippingFirstNameController = TextEditingController();
  TextEditingController shippingLastNameController = TextEditingController();
  TextEditingController shippingEmailController = TextEditingController();
  TextEditingController shippingPhoneController = TextEditingController();
  TextEditingController shippingCompanyController = TextEditingController();
  TextEditingController shippingAddress1Controller = TextEditingController();
  TextEditingController shippingAddress2Controller = TextEditingController();
  TextEditingController shippingCountryController = TextEditingController();
  TextEditingController shippingStateController = TextEditingController();
  TextEditingController shippingCityController = TextEditingController();
  TextEditingController shippingPostalCodeController = TextEditingController();

  TextEditingController billingFirstNameController = TextEditingController();
  TextEditingController billingLastNameController = TextEditingController();
  TextEditingController billingEmailController = TextEditingController();
  TextEditingController billingPhoneController = TextEditingController();
  TextEditingController billingCompanyController = TextEditingController();
  TextEditingController billingAddress1Controller = TextEditingController();
  TextEditingController billingAddress2Controller = TextEditingController();
  TextEditingController billingCountryController = TextEditingController();
  TextEditingController billingStateController = TextEditingController();
  TextEditingController billingCityController = TextEditingController();
  TextEditingController billingPostalCodeController = TextEditingController();

  bool isSwitchOn = false;
  UserRepository userRepository;
  UserProvider userProvider;
  AppValueHolder valueHolder;
  String countryId;

  bool bindDataFirstTime = true;

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<AppValueHolder>(context);
    return Consumer<UserProvider>(builder:
        (BuildContext context, UserProvider userProvider, Widget child) {
      if (userProvider.user != null && userProvider.user.data != null) {
        if (bindDataFirstTime) {
          /// Shipping Data
          userEmailController.text = userProvider.user.data.userEmail;
          userPhoneController.text = userProvider.user.data.userPhone;
          shippingFirstNameController.text =
              userProvider.user.data.shippingFirstName;
          shippingLastNameController.text =
              userProvider.user.data.shippingLastName;
          shippingCompanyController.text =
              userProvider.user.data.shippingCompany;
          shippingAddress1Controller.text =
              userProvider.user.data.shippingAddress_1;
          shippingAddress2Controller.text =
              userProvider.user.data.shippingAddress_2;
          shippingCountryController.text = '';

          shippingStateController.text = userProvider.user.data.shippingState;
          shippingCityController.text = '';

          shippingPostalCodeController.text =
              userProvider.user.data.shippingPostalCode;
          shippingEmailController.text = userProvider.user.data.shippingEmail;
          shippingPhoneController.text = userProvider.user.data.shippingPhone;

          /// Billing Data
          billingFirstNameController.text =
              userProvider.user.data.billingFirstName;
          billingLastNameController.text =
              userProvider.user.data.billingLastName;
          billingEmailController.text = userProvider.user.data.billingEmail;
          billingPhoneController.text = userProvider.user.data.billingPhone;
          billingCompanyController.text = userProvider.user.data.billingCompany;
          billingAddress1Controller.text =
              userProvider.user.data.billingAddress_1;
          billingAddress2Controller.text =
              userProvider.user.data.billingAddress_2;
          billingCountryController.text = userProvider.user.data.billingCountry;
          billingStateController.text = userProvider.user.data.billingState;
          billingCityController.text = userProvider.user.data.billingCity;
          billingPostalCodeController.text =
              userProvider.user.data.billingPostalCode;
          bindDataFirstTime = false;
        }
        return SingleChildScrollView(
          child: Container(
            color: AppColors.backgroundColor,
            padding: const EdgeInsets.only(
                left: AppDimens.space16, right: AppDimens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: AppDimens.space16,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: AppDimens.space12,
                      right: AppDimens.space12,
                      top: AppDimens.space16),
                  child: Text(
                    Utils.getString('checkout1__contact_info'),
                    style: Theme.of(context).textTheme.subtitle2.copyWith(),
                  ),
                ),
                const SizedBox(
                  height: AppDimens.space16,
                ),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__email'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__email'),
                    textEditingController: userEmailController,
                    isMandatory: true),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__phone'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__phone'),
                    textEditingController: userPhoneController),
                const SizedBox(
                  height: AppDimens.space16,
                ),
                Container(
                    margin: const EdgeInsets.only(
                        left: AppDimens.space12,
                        right: AppDimens.space12,
                        top: AppDimens.space16),
                    child: Text(
                      Utils.getString('checkout1__shipping_address'),
                      style: Theme.of(context).textTheme.subtitle2.copyWith(),
                    )),
                const SizedBox(
                  height: AppDimens.space16,
                ),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__first_name'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__first_name'),
                    textEditingController: shippingFirstNameController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__last_name'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__last_name'),
                    textEditingController: shippingLastNameController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__email'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__email'),
                    textEditingController: shippingEmailController,
                    isMandatory: true),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__phone'),
                    textAboutMe: false,
                    phoneInputType: true,
                    hintText: Utils.getString('edit_profile__phone'),
                    textEditingController: shippingPhoneController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__company_name'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__company_name'),
                    textEditingController: shippingCompanyController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__address1'),
                    height: AppDimens.space120,
                    textAboutMe: true,
                    hintText: Utils.getString('edit_profile__address1'),
                    keyboardType: TextInputType.multiline,
                    textEditingController: shippingAddress1Controller,
                    isMandatory: true),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__address2'),
                    height: AppDimens.space120,
                    textAboutMe: true,
                    hintText: Utils.getString('edit_profile__address2'),
                    keyboardType: TextInputType.multiline,
                    textEditingController: shippingAddress2Controller),
                AppDropdownBaseWithControllerWidget(
                    title: Utils.getString('edit_profile__country_name'),
                    textEditingController: shippingCountryController,
                    isMandatory: true,
                    onTap: () async {
                      final dynamic result = await Navigator.pushNamed(
                          context, RoutePaths.countryList);

                      if (result != null && result is ShippingCountry) {
                        setState(() {
                          countryId = result.id;
                          shippingCountryController.text = result.name;
                          shippingCityController.text = '';
                          userProvider.selectedCountry = result;
                          userProvider.selectedCity = null;
                        });
                      }
                    }),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__state_name'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__state_name'),
                    textEditingController: shippingStateController),
                AppDropdownBaseWithControllerWidget(
                    title: Utils.getString('edit_profile__city_name'),
                    textEditingController: shippingCityController,
                    isMandatory: true,
                    onTap: () async {
                      if (shippingCountryController.text.isEmpty) {
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return WarningDialog(
                                message: Utils.getString(
                                    'edit_profile__selected_country'),
                                onPressed: () {},
                              );
                            });
                      } else {
                        final dynamic result = await Navigator.pushNamed(
                            context, RoutePaths.cityList,
                            arguments: countryId ?? '');

                        if (result != null && result is ShippingCity) {
                          setState(() {
                            shippingCityController.text = result.name;
                            userProvider.selectedCity = result;
                          });
                        }
                      }
                    }),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__postal_code'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__postal_code'),
                    textEditingController: shippingPostalCodeController),
                const SizedBox(
                  height: AppDimens.space20,
                ),
                const Divider(
                  height: AppDimens.space1,
                ),
                const SizedBox(
                  height: AppDimens.space20,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: AppDimens.space12,
                      right: AppDimens.space12,
                      top: AppDimens.space16),
                  child: Text(
                    Utils.getString('checkout1__billing_address'),
                    style: Theme.of(context).textTheme.subtitle2.copyWith(),
                  ),
                ),
                const SizedBox(
                  height: AppDimens.space16,
                ),
                Row(
                  children: <Widget>[
                    Switch(
                      value: isSwitchOn,
                      onChanged: (bool isOn) {
                        print(isOn);
                        setState(() {
                          isSwitchOn = isOn;

                          billingFirstNameController.text =
                              shippingFirstNameController.text;
                          billingLastNameController.text =
                              shippingLastNameController.text;
                          billingEmailController.text =
                              shippingEmailController.text;
                          billingPhoneController.text =
                              shippingPhoneController.text;
                          billingCompanyController.text =
                              shippingCompanyController.text;
                          billingAddress1Controller.text =
                              shippingAddress1Controller.text;
                          billingAddress2Controller.text =
                              shippingAddress2Controller.text;
                          billingCountryController.text =
                              shippingCountryController.text;
                          billingStateController.text =
                              shippingStateController.text;
                          billingCityController.text =
                              shippingCityController.text;
                          billingPostalCodeController.text =
                              shippingPostalCodeController.text;
                        });
                      },
                      activeTrackColor: AppColors.mainColor,
                      activeColor: AppColors.mainDarkColor,
                    ),
                    Text(Utils.getString('checkout1__same_billing_address')),
                  ],
                ),
                const SizedBox(
                  height: AppDimens.space16,
                ),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__first_name'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__first_name'),
                    textEditingController: billingFirstNameController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__last_name'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__last_name'),
                    textEditingController: billingLastNameController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__email'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__email'),
                    textEditingController: billingEmailController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__phone'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__phone'),
                    textEditingController: billingPhoneController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__company_name'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__company_name'),
                    textEditingController: billingCompanyController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__address1'),
                    height: AppDimens.space120,
                    textAboutMe: true,
                    hintText: Utils.getString('edit_profile__address1'),
                    keyboardType: TextInputType.multiline,
                    textEditingController: billingAddress1Controller,
                    isMandatory: true),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__address2'),
                    height: AppDimens.space120,
                    textAboutMe: true,
                    hintText: Utils.getString('edit_profile__address2'),
                    keyboardType: TextInputType.multiline,
                    textEditingController: billingAddress2Controller),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__country_name'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__country_name'),
                    textEditingController: billingCountryController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__state_name'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__state_name'),
                    textEditingController: billingStateController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__city_name'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__city_name'),
                    textEditingController: billingCityController),
                AppTextFieldWidget(
                    titleText: Utils.getString('edit_profile__postal_code'),
                    textAboutMe: false,
                    hintText: Utils.getString('edit_profile__postal_code'),
                    textEditingController: billingPostalCodeController),
                const SizedBox(
                  height: AppDimens.space16,
                ),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  dynamic checkIsDataChange(UserProvider userProvider) async {
    if (userProvider.user.data.userEmail == userEmailController.text &&
        userProvider.user.data.userPhone == userPhoneController.text &&
        userProvider.user.data.billingFirstName ==
            billingFirstNameController.text &&
        userProvider.user.data.billingLastName ==
            billingLastNameController.text &&
        userProvider.user.data.billingCompany ==
            billingCompanyController.text &&
        userProvider.user.data.billingAddress_1 ==
            billingAddress1Controller.text &&
        userProvider.user.data.billingAddress_2 ==
            billingAddress2Controller.text &&
        userProvider.user.data.billingCountry ==
            billingCountryController.text &&
        userProvider.user.data.billingState == billingStateController.text &&
        userProvider.user.data.billingCity == billingCityController.text &&
        userProvider.user.data.billingPostalCode ==
            billingPostalCodeController.text &&
        userProvider.user.data.billingEmail == billingEmailController.text &&
        userProvider.user.data.billingPhone == billingPhoneController.text &&
        userProvider.user.data.shippingFirstName ==
            shippingFirstNameController.text &&
        userProvider.user.data.shippingLastName ==
            shippingLastNameController.text &&
        userProvider.user.data.shippingCompany ==
            shippingCompanyController.text &&
        userProvider.user.data.shippingAddress_1 ==
            shippingAddress1Controller.text &&
        userProvider.user.data.shippingAddress_2 ==
            shippingAddress2Controller.text &&
        userProvider.user.data.shippingCountry ==
            shippingCountryController.text &&
        userProvider.user.data.shippingState == shippingStateController.text &&
        userProvider.user.data.shippingCity == shippingCityController.text &&
        userProvider.user.data.shippingPostalCode ==
            shippingPostalCodeController.text &&
        userProvider.user.data.shippingEmail == shippingEmailController.text &&
        userProvider.user.data.shippingPhone == shippingPhoneController.text) {
      return true;
    } else {
      return false;
    }
  }

  dynamic callUpdateUserProfile(UserProvider userProvider) async {
    final User userData = User(
      userId: userProvider.appValueHolder.loginUserId,
      userName: userProvider.user.data.userName,
      userEmail: userEmailController.text.trim(),
      userPhone: userPhoneController.text,
      userAboutMe: userProvider.user.data.userAboutMe,
      billingFirstName: billingFirstNameController.text,
      billingLastName: billingLastNameController.text,
      billingCompany: billingCompanyController.text,
      billingAddress_1: billingAddress1Controller.text,
      billingAddress_2: billingAddress2Controller.text,
      billingCountry: billingCountryController.text,
      billingState: billingStateController.text,
      billingCity: billingCityController.text,
      billingPostalCode: billingPostalCodeController.text,
      billingEmail: billingEmailController.text,
      billingPhone: billingPhoneController.text,
      shippingFirstName: shippingFirstNameController.text,
      shippingLastName: shippingLastNameController.text,
      shippingCompany: shippingCompanyController.text,
      shippingAddress_1: shippingAddress1Controller.text,
      shippingAddress_2: shippingAddress2Controller.text,
      shippingCountry: userProvider.selectedCountry.name,
      shippingState: shippingStateController.text,
      shippingCity: userProvider.selectedCity.name,
      shippingPostalCode: shippingPostalCodeController.text,
      shippingEmail: shippingEmailController.text,
      shippingPhone: shippingPhoneController.text,
      // countryId: userProvider.selectedCountry.id,
      // cityId: userProvider.selectedCity.id,
    );

    await userProvider.updateUserDB(userData);
    // await userProvider.getUserFromDB(userProvider.appValueHolder.loginUserId);
  }
}
