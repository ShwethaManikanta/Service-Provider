import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/signin_model.dart';


class VerifyUserLoginAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  SigninModel? _loginResponse;
  bool get isLoading => _error == false && _loginResponse == null;
  Future<void> getUser(
      {required String deviceToken,
      required String userFirebaseID,
      required String phoneNumber}) async {
    final uri =
        Uri.parse("https://chillkrt.in/service_provider/index.php/Api/signIn");

    final response = await post(uri, body: {
      'user_fid': userFirebaseID,
      'device_token': deviceToken,
      'mobile_no': phoneNumber,
    });
    if (response.statusCode == 200) {
      try {
        print("User fiD ===============" + userFirebaseID);
        print("User device_token ===============" + deviceToken);
        print("User mobile_no ===============" + phoneNumber);

        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse.toString());
        _loginResponse = SigninModel.fromJson(jsonResponse);
        print(_loginResponse!.message);
        print("------------------");
        print("Login Success");
        print("-------------------------------------");
      } catch (e) {
        _error = true;
        _errorMessage =
            "Status code of response " + response.statusCode.toString();
        _loginResponse = null;
        print("------------------");
        print("Login Failed");
        print("-------------------------------------");
      }
    } else {
      _error = true;
      _errorMessage =
          "Status code of response " + response.statusCode.toString();
      _loginResponse = null;
      print("------------------");
      print("Login Failed");
      print("-------------------------------------");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _loginResponse = null;
  }

  bool get error => _error;
  String get errorMessage => _errorMessage;
  SigninModel? get loginResponse => _loginResponse;
}
