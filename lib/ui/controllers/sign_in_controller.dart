import 'package:get/get.dart';

import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import 'auth_controller.dart';

class SignInController extends GetxController{
  bool _signInProgressing = false;
  String _errorMessage = '';
  bool get signInApiInProgress => _signInProgressing;
  String get errorMessage => _errorMessage;
  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _signInProgressing = true;
    update();

    Map<String, dynamic> requestData = {
      "email": email,
      "password": password,
    };
    final NetworkResponse response =
    await NetworkCaller.postRequest(Urls.login, body: requestData);

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);
      isSuccess = true;
    }else {
      _errorMessage = response.errorMassage ?? 'login failed';
    isSuccess = false;
    }
    _signInProgressing = false;
    update();

    return isSuccess;
  }
}