import 'package:dni_ecommerce/api/app_api_service.dart';
// import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
// import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/basket/basket_provider.dart';
import 'package:dni_ecommerce/provider/coupon_discount/coupon_discount_provider.dart';
import 'package:dni_ecommerce/provider/shipping_method/shipping_method_provider.dart';
import 'package:dni_ecommerce/provider/token/token_provider.dart';
import 'package:dni_ecommerce/provider/transaction/transaction_detail_provider.dart';
import 'package:dni_ecommerce/provider/transaction/transaction_header_provider.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/basket_repository.dart';
import 'package:dni_ecommerce/repository/coupon_discount_repository.dart';
import 'package:dni_ecommerce/repository/shipping_method_repository.dart';
import 'package:dni_ecommerce/repository/tansaction_detail_repository.dart';
import 'package:dni_ecommerce/repository/token_repository.dart';
import 'package:dni_ecommerce/repository/transaction_header_repository.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/ui/common/dialog/confirm_dialog_view.dart';
import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
// import 'package:dni_ecommerce/ui/common/dialog/warning_dialog_view.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
// import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
// import 'package:dni_ecommerce/viewobject/holder/intent/credit_card_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../ui/checkout/checkout1_view.dart';
import '../../ui/checkout/checkout2_view.dart';
import '../../ui/checkout/checkout3_view.dart';

class CheckoutContainerView extends StatefulWidget {
  const CheckoutContainerView({
    Key key,
    @required this.basketList,
  }) : super(key: key);

  final List<Basket> basketList;

  @override
  _CheckoutContainerViewState createState() => _CheckoutContainerViewState();
}

class _CheckoutContainerViewState extends State<CheckoutContainerView> {
  int viewNo = 1;
  int maxViewNo = 5;
  UserRepository userRepository;
  UserProvider userProvider;
  TokenProvider tokenProvider;
  ShippingMethodProvider shippingMethodProvider;
  ShippingMethodRepository shippingMethodRepository;
  AppValueHolder valueHolder;
  CouponDiscountRepository couponDiscountRepo;
  TransactionHeaderRepository transactionHeaderRepo;
  BasketRepository basketRepository;
  String couponDiscount;
  CouponDiscountProvider couponDiscountProvider;
  BasketProvider basketProvider;
  TransactionHeaderProvider transactionSubmitProvider;
  TransactionDetailProvider transactionDetailProvider;
  TransactionDetailRepository transactionDetailRepository;
  AppApiService appApiService;
  TokenRepository tokenRepository;
  @override
  Widget build(BuildContext context) {
    void _closeCheckoutContainer() {
      Navigator.pop(context);
    }

    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<AppValueHolder>(context);

    couponDiscountRepo = Provider.of<CouponDiscountRepository>(context);
    transactionHeaderRepo = Provider.of<TransactionHeaderRepository>(context);
    transactionDetailRepository =
        Provider.of<TransactionDetailRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    appApiService = Provider.of<AppApiService>(context);
    tokenRepository = Provider.of<TokenRepository>(context);
    shippingMethodRepository = Provider.of<ShippingMethodRepository>(context);
    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<CouponDiscountProvider>(
              lazy: false,
              create: (BuildContext context) {
                couponDiscountProvider =
                    CouponDiscountProvider(repo: couponDiscountRepo);

                return couponDiscountProvider;
              }),
          ChangeNotifierProvider<BasketProvider>(
              lazy: false,
              create: (BuildContext context) {
                basketProvider = BasketProvider(repo: basketRepository);

                return basketProvider;
              }),
          ChangeNotifierProvider<UserProvider>(
              lazy: false,
              create: (BuildContext context) {
                userProvider = UserProvider(
                    repo: userRepository, appValueHolder: valueHolder);
                userProvider
                    .getUserFromDB(userProvider.appValueHolder.loginUserId);
                return userProvider;
              }),
          ChangeNotifierProvider<TransactionHeaderProvider>(
              lazy: false,
              create: (BuildContext context) {
                transactionSubmitProvider = TransactionHeaderProvider(
                    repo: transactionHeaderRepo, appValueHolder: valueHolder);

                return transactionSubmitProvider;
              }),
          ChangeNotifierProvider<TransactionDetailProvider>(
              lazy: false,
              create: (BuildContext context) {
                transactionDetailProvider = TransactionDetailProvider(
                    repo: transactionDetailRepository,
                    appValueHolder: valueHolder);

                return transactionDetailProvider;
              }),
          ChangeNotifierProvider<TokenProvider>(
              lazy: false,
              create: (BuildContext context) {
                tokenProvider = TokenProvider(repo: tokenRepository);
                return tokenProvider;
              }),
          ChangeNotifierProvider<ShippingMethodProvider>(
              lazy: false,
              create: (BuildContext context) {
                shippingMethodProvider = ShippingMethodProvider(
                    repo: shippingMethodRepository,
                    psValueHolder: valueHolder,
                    defaultShippingId: valueHolder.shippingId);
                shippingMethodProvider.loadShippingMethodList();
                return shippingMethodProvider;
              }),
        ],
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: AppDimens.space160,
                child: _TopImageForCheckout(
                  viewNo: viewNo,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              checkForTopImage(),
            ],
          ),
          bottomNavigationBar: checkHideOrShowBackArrowBar(
              _closeCheckoutContainer, tokenProvider),
        ));
  }

  Container checkForTopImage() {
    if (viewNo == 4) {
      return Container(child: checkToShowView());
    } else {
      return Container(
          margin: const EdgeInsets.only(top: AppDimens.space160),
          child: checkToShowView());
    }
  }

  dynamic checkout1ViewState;
  dynamic checkout2ViewState;
  dynamic checkout3ViewState;
  bool isApiSuccess = false;

  void updateCheckout1ViewState(State state) {
    checkout1ViewState = state;
  }

  void updateCheckout2ViewState(State state) {
    checkout2ViewState = state;
  }

  void updateCheckout3ViewState(State state) {
    checkout3ViewState = state;
  }

  dynamic checkToShowView() {
    if (viewNo == 1) {
      return Checkout1View(updateCheckout1ViewState);
    } else if (viewNo == 2) {
      return Container(
        color: AppColors.coreBackgroundColor,
        child: Checkout2View(
          updateCheckout2ViewState: updateCheckout2ViewState,
          basketList: widget.basketList,
          publishKey: valueHolder.publishKey,
        ),
      );
    } else if (viewNo == 3) {
      return Container(
        color: AppColors.coreBackgroundColor,
        child: Checkout3View(
          updateCheckout3ViewState,
          widget.basketList,
        ),
      );
    }
  }

  dynamic checkHideOrShowBackArrowBar(
      Function _closeCheckoutContainer, TokenProvider tokenProvider) {
    if (viewNo == 4) {
      return Container(
        height: 0,
      );
    } else {
      return Container(
          height: 60,
          color: AppColors.mainColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              checkHideOrShowBackArrow(),
              Container(
                  height: 50,
                  color: AppColors.mainColor,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Stack(
                      alignment: const Alignment(0.0, 0.0),
                      children: <Widget>[
                        Container(
                          margin:
                              const EdgeInsets.only(right: AppDimens.space36),
                          child: GestureDetector(
                            child: Text(
                                viewNo == 3
                                    ? Utils.getString(
                                        'basket_list__checkout_button_name')
                                    : Utils.getString(
                                        'checkout_container__next'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: AppColors.white)),
                            onTap: () {
                              clickToNextCheck(userProvider.user.data,
                                  _closeCheckoutContainer, tokenProvider);
                            },
                          ),
                        ),
                        Positioned(
                          right: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.white,
                              size: AppDimens.space16,
                            ),
                            onPressed: () {
                              clickToNextCheck(userProvider.user.data,
                                  _closeCheckoutContainer, tokenProvider);
                            },
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ));
    }
  }

  dynamic clickToNextCheck(User user, Function _closeCheckoutContainer,
      TokenProvider tokenProvider) async {
    if (viewNo < maxViewNo) {
      if (viewNo == 3) {
        checkout3ViewState.checkStatus();
        if (checkout3ViewState.isPaypalClicked) {
          // showDialog<dynamic>(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return ConfirmDialogView(
          //           description:
          //               Utils.getString('checkout_container__confirm_order'),
          //           leftButtonText:
          //               Utils.getString('home__logout_dialog_cancel_button'),
          //           rightButtonText:
          //               Utils.getString('home__logout_dialog_ok_button'),
          //           onAgreeTap: () async {
          //             Navigator.pop(context);
          //             final AppResource<ApiStatus> tokenResource =
          //                 await tokenProvider.loadToken();
          //             final dynamic returnData =
          //                 await checkout3ViewState.payNow(
          //                     tokenResource.data.message,
          //                     userProvider,
          //                     transactionSubmitProvider,
          //                     couponDiscountProvider,
          //                     valueHolder,
          //                     basketProvider);
          //             if (returnData != null && returnData) {
          //               _closeCheckoutContainer();
          //             }
          //           });
          //     });

        } else if (checkout3ViewState.isStripeClicked) {
          // showDialog<dynamic>(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return ConfirmDialogView(
          //           description:
          //               Utils.getString('checkout_container__confirm_order'),
          //           leftButtonText:
          //               Utils.getString('home__logout_dialog_cancel_button'),
          //           rightButtonText:
          //               Utils.getString('home__logout_dialog_ok_button'),
          //           onAgreeTap: () async {
          //             Navigator.pop(context);
          //             final dynamic returnData = await Navigator.pushNamed(
          //                 context, RoutePaths.creditCard,
          //                 arguments: CreditCardIntentHolder(
          //                     basketList: widget.basketList,
          //                     couponDiscount:
          //                         couponDiscountProvider.couponDiscount ??
          //                             '0.0',
          //                     transactionSubmitProvider:
          //                         transactionSubmitProvider,
          //                     userProvider: userProvider,
          //                     basketProvider: basketProvider,
          //                     appValueHolder: valueHolder,
          //                     memoText: checkout3ViewState.memoController.text,
          //                     publishKey: valueHolder.publishKey,
          //                     payStackKey: valueHolder.payStackKey));

          //             if (returnData != null && returnData) {
          //               _closeCheckoutContainer();
          //             }
          //           });
          //     });

        } else if (checkout3ViewState.isPayStackClicked) {
          // showDialog<dynamic>(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return ConfirmDialogView(
          //           description:
          //               Utils.getString('checkout_container__confirm_order'),
          //           leftButtonText:
          //               Utils.getString('home__logout_dialog_cancel_button'),
          //           rightButtonText:
          //               Utils.getString('home__logout_dialog_ok_button'),
          //           onAgreeTap: () async {
          //             Navigator.pop(context);
          //             final dynamic returnData = await Navigator.pushNamed(
          //                 context, RoutePaths.payStack,
          //                 arguments: CreditCardIntentHolder(
          //                     basketList: widget.basketList,
          //                     couponDiscount:
          //                         couponDiscountProvider.couponDiscount ??
          //                             '0.0',
          //                     transactionSubmitProvider:
          //                         transactionSubmitProvider,
          //                     userProvider: userProvider,
          //                     basketProvider: basketProvider,
          //                     appValueHolder: valueHolder,
          //                     memoText: checkout3ViewState.memoController.text,
          //                     publishKey: valueHolder.publishKey,
          //                     payStackKey: valueHolder.payStackKey));

          //             if (returnData != null && returnData) {
          //               _closeCheckoutContainer();
          //             }
          //           });
          //     });

        } else if (checkout3ViewState.isCashClicked) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description:
                        Utils.getString('checkout_container__confirm_order'),
                    leftButtonText:
                        Utils.getString('home__logout_dialog_cancel_button'),
                    rightButtonText:
                        Utils.getString('home__logout_dialog_ok_button'),
                    onAgreeTap: () async {
                      Navigator.pop(context);
                      final dynamic returnData =
                          await checkout3ViewState.callCardNow(
                        basketProvider,
                        userProvider,
                        transactionSubmitProvider,
                      );
                      if (returnData != null && returnData) {
                        _closeCheckoutContainer();
                      }
                    });
              });
        } else if (checkout3ViewState.isBankClicked) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description:
                        Utils.getString('checkout_container__confirm_order'),
                    leftButtonText:
                        Utils.getString('home__logout_dialog_cancel_button'),
                    rightButtonText:
                        Utils.getString('home__logout_dialog_ok_button'),
                    onAgreeTap: () async {
                      Navigator.pop(context);
                      final dynamic returnData =
                          await checkout3ViewState.callBankNow(
                        basketProvider,
                        userProvider,
                        transactionSubmitProvider,
                      );
                      if (returnData != null && returnData) {
                        _closeCheckoutContainer();
                      }
                    });
              });
        } else if (checkout3ViewState.isRazorClicked) {
          // showDialog<dynamic>(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return ConfirmDialogView(
          //           description:
          //               Utils.getString('checkout_container__confirm_order'),
          //           leftButtonText:
          //               Utils.getString('home__logout_dialog_cancel_button'),
          //           rightButtonText:
          //               Utils.getString('home__logout_dialog_ok_button'),
          //           onAgreeTap: () async {
          //             Navigator.pop(context);

          //             final dynamic returnData =
          //                 await checkout3ViewState.payRazorNow(
          //                     userProvider,
          //                     transactionSubmitProvider,
          //                     couponDiscountProvider,
          //                     valueHolder,
          //                     basketProvider);
          //             if (returnData != null && returnData) {
          //               _closeCheckoutContainer();
          //             }
          //           });
          //     });

        } else {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message:
                      Utils.getString('checkout_container__choose_payment'),
                );
              });
        }
      } else if (viewNo == 1) {
        if (checkout1ViewState.userEmailController.text.isEmpty) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: Utils.getString('warning_dialog__input_email'),
                );
              });
        } else if (checkout1ViewState.shippingEmailController.text.isEmpty) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: Utils.getString('warning_dialog__shipping_email'),
                );
              });
        } else if (checkout1ViewState.shippingAddress1Controller.text.isEmpty) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: Utils.getString('warning_dialog__shipping_address'),
                );
              });
        } else if (checkout1ViewState.shippingCountryController.text.isEmpty) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: Utils.getString('edit_profile__selected_country'),
                );
              });
        } else if (checkout1ViewState.shippingCityController.text.isEmpty) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: Utils.getString('error_dialog__select_city'),
                );
              });
        } else if (checkout1ViewState.billingAddress1Controller.text.isEmpty) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: Utils.getString('warning_dialog__billing_address'),
                );
              });
        } else {
          if (!await checkout1ViewState.checkIsDataChange(userProvider)) {
            await checkout1ViewState.callUpdateUserProfile(userProvider);
            // isApiSuccess =
            //     await checkout1ViewState.callUpdateUserProfile(userProvider);
            //change checkout1 data
            // if (isApiSuccess) {
            viewNo++;
            // }
          } else {
            //not change checkout1 data
            viewNo++;
          }
        }
      } else if (viewNo == 2) {
        viewNo++;
      } else {
        viewNo++;
      }
      setState(() {});
    }
  }

  dynamic checkHideOrShowBackArrow() {
    if (viewNo == 1) {
      return const Text('');
    } else {
      return Container(
          height: 50,
          color: AppColors.mainColor,
          child: Align(
            alignment: Alignment.centerRight,
            child: Stack(
              alignment: const Alignment(0.0, 0.0),
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: AppDimens.space36),
                  child: GestureDetector(
                    child: Text(Utils.getString('checkout_container__back'),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: AppColors.white)),
                    onTap: () {
                      goToBackViewCheck();
                    },
                  ),
                ),
                Positioned(
                  left: 1,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.white,
                      size: AppDimens.space16,
                    ),
                    onPressed: () {
                      goToBackViewCheck();
                    },
                  ),
                )
              ],
            ),
          ));
    }
  }

  void goToBackViewCheck() {
    if (viewNo < maxViewNo) {
      viewNo--;

      setState(() {});
    }
  }
}

class _TopImageForCheckout extends StatelessWidget {
  const _TopImageForCheckout({Key key, this.viewNo, this.onTap})
      : super(key: key);

  final int viewNo;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    StatelessWidget checkSecondCircle() {
      return Icon(
        viewNo == 3
            ? MaterialCommunityIcons.checkbox_marked_circle
            : MaterialCommunityIcons.checkbox_blank_circle_outline,
        size: AppDimens.space28,
        color: viewNo != 1 ? AppColors.mainColor : AppColors.grey,
      );
    }

    StatelessWidget checkFirstCircle() {
      return Icon(
        viewNo == 1
            ? MaterialCommunityIcons.checkbox_blank_circle_outline
            : MaterialCommunityIcons.checkbox_marked_circle,
        size: AppDimens.space28,
        color: AppColors.mainColor,
      );
    }

    StatelessWidget checkThirdCircle() {
      return Icon(
        MaterialCommunityIcons.checkbox_blank_circle_outline,
        size: AppDimens.space28,
        color: viewNo == 3 ? AppColors.mainColor : AppColors.grey,
      );
    }

    if (viewNo == 4) {
      return Container();
    } else {
      return Container(
        color: AppColors.coreBackgroundColor,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(
                  height: AppDimens.space32,
                ),
                Text(Utils.getString('checkout_container__checkout'),
                    style: Theme.of(context).textTheme.headline5),
                const SizedBox(
                  height: AppDimens.space16,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: AppDimens.space32, right: AppDimens.space32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          checkFirstCircle(),
                          const SizedBox(
                            height: AppDimens.space12,
                          ),
                          Text(Utils.getString('checkout_container__address'),
                              style: viewNo == 1
                                  ? Theme.of(context).textTheme.bodyText2
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color:
                                              AppColors.textPrimaryDarkColor)),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(bottom: AppDimens.space32),
                          child: Divider(
                            height: 2,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          checkSecondCircle(),
                          const SizedBox(
                            height: AppDimens.space12,
                          ),
                          Text(Utils.getString('checkout_container__confirm'),
                              style: Theme.of(context).textTheme.bodyText2),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(bottom: AppDimens.space32),
                          child: Divider(
                            height: 2,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            checkThirdCircle(),
                            const SizedBox(
                              height: AppDimens.space12,
                            ),
                            Text(Utils.getString('checkout_container__payment'),
                                style: Theme.of(context).textTheme.bodyText2),
                          ]),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: AppDimens.space24, left: AppDimens.space2),
              child: IconButton(
                icon: const Icon(
                  Icons.clear,
                  size: AppDimens.space24,
                ),
                onPressed: onTap,
              ),
            ),
          ],
        ),
      );
    }
  }
}
