import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
import 'package:dni_ecommerce/ui/common/dialog/warning_dialog_view.dart';
import 'package:dni_ecommerce/utils/app_progress_dialog.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/user_login_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/shipping_city.dart';
import 'package:dni_ecommerce/viewobject/shipping_country.dart';
import 'package:dni_ecommerce/viewobject/user.dart';
import 'package:dni_ecommerce/viewobject/user_register_parameter_holder.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class UserProvider extends AppProvider {
  UserProvider(
      {@required UserRepository repo,
      @required this.appValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('User Provider: $hashCode');
    userListStream = StreamController<AppResource<User>>.broadcast();
    subscription = userListStream.stream.listen((AppResource<User> resource) {
      if (resource != null && resource.data != null) {
        _user = resource;
        holderUser = resource.data;
      }

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  UserRepository _repo;
  AppValueHolder appValueHolder;
  User holderUser;
  bool isCheckBoxSelect = true;
  ShippingCountry selectedCountry;
  ShippingCity selectedCity;

  AppResource<User> _user = AppResource<User>(AppStatus.NOACTION, '', null);
  AppResource<User> _holderUser =
      AppResource<User>(AppStatus.NOACTION, '', null);
  AppResource<User> get user => _user;

  AppResource<ApiStatus> _apiStatus =
      AppResource<ApiStatus>(AppStatus.NOACTION, '', null);
  AppResource<ApiStatus> get apiStatus => _apiStatus;

  StreamSubscription<AppResource<User>> subscription;
  StreamController<AppResource<User>> userListStream;
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('User Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postUserRegister(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserRegister(
        jsonMap, isConnectedToInternet, AppStatus.PROGRESS_LOADING);

    return _user;
  }

  // Future<dynamic> postUserEmailVerify(
  //   Map<dynamic, dynamic> jsonMap,
  // ) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();

  //   _user = await _repo.postUserEmailVerify(
  //       jsonMap, isConnectedToInternet, AppStatus.PROGRESS_LOADING);

  //   return _user;
  // }

  // Future<dynamic> postImageUpload(
  //   String userId,
  //   String platformName,
  //   File imageFile,
  // ) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();

  //   _user = await _repo.postImageUpload(userId, platformName, imageFile,
  //       isConnectedToInternet, AppStatus.PROGRESS_LOADING);

  //   return _user;
  // }

  Future<dynamic> postUserLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserLogin(
        jsonMap, isConnectedToInternet, AppStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postForgotPassword(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postForgotPassword(
        jsonMap, isConnectedToInternet, AppStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postChangePassword(
      Map<dynamic, dynamic> jsonMap, String userToken) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postChangePassword(
        jsonMap, userToken, isConnectedToInternet, AppStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postProfileUpdate(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _holderUser = await _repo.postProfileUpdate(
        jsonMap, isConnectedToInternet, AppStatus.SUCCESS);
    if (_holderUser.status == AppStatus.SUCCESS) {
      _user = _holderUser;
      return _holderUser;
    } else {
      return _holderUser;
    }
  }

  Future<dynamic> postResendCode(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postResendCode(
        jsonMap, isConnectedToInternet, AppStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> getUser(String loginUserId, String userToken) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getUser(userListStream, loginUserId, userToken,
        isConnectedToInternet, AppStatus.PROGRESS_LOADING);
  }

  Future<dynamic> updateUserDB(User user) async {
    isLoading = true;

    await _repo.updateUserDB(user, userListStream, AppStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getUserFromDB(String loginUserId) async {
    isLoading = true;

    await _repo.getUserFromDB(
        loginUserId, userListStream, AppStatus.PROGRESS_LOADING);
  }

  ///
  /// Firebase Auth
  ///
  Future<fb_auth.User> getCurrentFirebaseUser() async {
    final fb_auth.FirebaseAuth auth = fb_auth.FirebaseAuth.instance;
    final fb_auth.User currentUser = auth.currentUser;
    return currentUser;
  }

  Future<void> handleFirebaseAuthError(BuildContext context, String email,
      {bool ignoreEmail = false}) async {
    if (email.isEmpty) {
      return;
    }

    final List<String> providers =
        await _firebaseAuth.fetchSignInMethodsForEmail(email);

    final String provider = providers.single;
    print('provider : $provider');
    // Registered With Email
    if (provider.contains(AppConst.emailAuthProvider) && !ignoreEmail) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: '[ $email ]\n' + Utils.getString('auth__email_provider'),
              onPressed: () {},
            );
          });
    }
  }

  ///
  /// Email Login Related
  ///
  Future<void> loginWithEmailId(BuildContext context, String email,
      String password, Function onProfileSelected) async {
    ///
    /// Check Connection
    ///
    if (await Utils.checkInternetConnectivity()) {
      ///
      /// Get Firebase User with Email Id Login
      ///

      // await signInWithEmailAndPassword(context, email, email);

      ///
      /// Show Progress Dialog
      ///
      await AppProgressDialog.showDialog(context);

      ///
      /// Submit to backend
      ///
      final AppResource<User> resourceUser =
          await _submitLoginWithEmailId(email, password);

      ///
      /// Close Progress Dialog
      ///
      AppProgressDialog.dismissDialog();

      if (resourceUser != null && resourceUser.data != null) {
        ///
        /// Success
        ///
        if (onProfileSelected != null) {
          onProfileSelected(resourceUser.data.userId);
        } else {
          Navigator.pop(context, resourceUser.data);
        }
      } else {
        ///
        /// Error from server
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              if (resourceUser != null && resourceUser.message != null) {
                return ErrorDialog(
                  message: resourceUser.message ?? '',
                );
              } else {
                return ErrorDialog(
                  message: Utils.getString('login__error_signin'),
                );
              }
            });
      }
    } else {
      ///
      /// No Internet Connection
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString('error_dialog__no_internet'),
            );
          });
    }
  }

  Future<fb_auth.User> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    fb_auth.UserCredential result;
    fb_auth.User user;

    try {
      result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } on Exception catch (e1) {
      print(e1);

      final fb_auth.User _user = await createUserWithEmailAndPassword(
          context, email, password,
          ignoreHandleFirebaseAuthError: true);

      // Sign In as Dummy User
      if (_user == null) {
        try {
          result = await _firebaseAuth.signInWithEmailAndPassword(
              email: AppConst.defaultEmail, password: AppConst.defaultPassword);
          user = result.user;
        } on PlatformException catch (e) {
          print(e);
          final fb_auth.User _user2 = await createUserWithEmailAndPassword(
              context, AppConst.defaultEmail, AppConst.defaultPassword,
              ignoreHandleFirebaseAuthError: true);

          if (_user2 != null) {
            user = _user2;
          }
        }
      } else {
        user = _user;
      }
    }

    print('signInEmail succeeded: $user');

    return user;
  }

  Future<AppResource<User>> _submitLoginWithEmailId(
      String email, String password) async {
    final UserLoginParameterHolder userLoginParameterHolder =
        UserLoginParameterHolder(
      userEmail: email,
      userPassword: password,
      // deviceToken: appValueHolder.deviceToken,
    );

    final AppResource<User> _apiStatus =
        await postUserLogin(userLoginParameterHolder.toMap());

    if (_apiStatus.data != null) {
      await replaceVerifyUserData('', '', '', '');
      await replaceLoginUserId(
          _apiStatus.data.userId, _apiStatus.data.deviceToken);
    }
    return _apiStatus;
  }

  ///
  /// Email Register Related
  ///
  Future<void> signUpWithEmailId(
      BuildContext context,
      Function onRegisterSelected,
      String name,
      String email,
      String password) async {
    ///
    /// Check User is Accept Terms and Conditions
    ///
    if (isCheckBoxSelect) {
      ///
      /// Check Connection
      ///
      if (await Utils.checkInternetConnectivity()) {
        ///
        /// Get Firebase User with Email Id Login
        ///
        final fb_auth.User firebaseUser =
            await createUserWithEmailAndPassword(context, email, email);

        if (firebaseUser != null) {
          ///
          /// Show Progress Dialog
          ///
          await AppProgressDialog.showDialog(context);

          ///
          /// Submit to backend
          ///
          final AppResource<User> resourceUser = await _submitSignUpWithEmailId(
              context, onRegisterSelected, name, email, password);

          ///
          /// Close Progress Dialog
          ///
          AppProgressDialog.dismissDialog();

          if (resourceUser != null && resourceUser.data != null) {
            ///
            /// Success
            ///
            // final User user = resourceUser.data;
            // if (user.status == AppConst.ONE) {
            // Approval Off
            await replaceVerifyUserData('', '', '', '');
            await replaceLoginUserId(
                resourceUser.data.userId, resourceUser.data.deviceToken);

            if (onRegisterSelected != null) {
              onRegisterSelected(resourceUser.data);
            } else {
              // Register Screen Pop
              Navigator.pop(context, resourceUser.data);
            }
            //delete code from here
          } else {
            ///
            /// Error from server
            ///
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  if (resourceUser != null && resourceUser.message != null) {
                    return ErrorDialog(
                      message: resourceUser.message ?? '',
                    );
                  } else {
                    return ErrorDialog(
                      message: Utils.getString('login__error_signin'),
                    );
                  }
                });
          }
        }
      } else {
        ///
        /// No Internet Connection
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString('error_dialog__no_internet'),
              );
            });
      }
    } else {
      ///
      /// Not yet agree on Privacy Policy
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString('login__warning_agree_privacy'),
              onPressed: () {},
            );
          });
    }
  }

  Future<fb_auth.User> createUserWithEmailAndPassword(
      BuildContext context, String email, String password,
      {bool ignoreHandleFirebaseAuthError = false}) async {
    fb_auth.UserCredential result;
    try {
      result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on Exception catch (e) {
      print(e);

      final List<String> providers =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      final String provider = providers.single;
      print('provider : $provider');
      // Registered With Email
      if (provider.contains(AppConst.emailAuthProvider)) {
        final fb_auth.User user =
            await signInWithEmailAndPassword(context, email, email);
        if (user == null) {
          if (!ignoreHandleFirebaseAuthError) {
            handleFirebaseAuthError(context, email, ignoreEmail: true);
          }

          // Fail to Login to Firebase, must return null;
          return null;
        } else {
          return user;
        }
      } else {
        if (!ignoreHandleFirebaseAuthError) {
          handleFirebaseAuthError(context, email, ignoreEmail: true);
        }
        return null;
      }
    }

    final fb_auth.User user = result.user;

    return user;
  }

  Future<AppResource<User>> _submitSignUpWithEmailId(
      BuildContext context,
      Function onRegisterSelected,
      String name,
      String email,
      String password) async {
    final UserRegisterParameterHolder userRegisterParameterHolder =
        UserRegisterParameterHolder(
      userId: '',
      userName: name,
      userEmail: email,
      userPassword: password,
      passwordConfirmation: password,
      deviceToken: appValueHolder.deviceToken,
    );

    final AppResource<User> _apiStatus =
        await postUserRegister(userRegisterParameterHolder.toMap());

    if (_apiStatus.data != null) {
      final User user = _apiStatus.data;

      //for change email
      await replaceVerifyUserData(_apiStatus.data.userId,
          _apiStatus.data.userName, _apiStatus.data.userEmail, password);

      appValueHolder.userIdToVerify = user.userId;
      appValueHolder.userNameToVerify = user.userName;
      appValueHolder.userEmailToVerify = user.userEmail;
      appValueHolder.userPasswordToVerify = user.userPassword;
    }

    return _apiStatus;
  }
}
