import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/signin_model.dart';


class SigninAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  SigninModel? _signinModel;

  SigninModel? get signinModel => _signinModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _signinModel == null;

  Future<void> getSignin(String mobileNo, String deviceToken) async {
    final uri =
        Uri.parse("https://chillkrt.in/service_provider/index.php/Api/signIn");
    final response = await post(uri,
        body: {"mobile_no": mobileNo, "device_token": deviceToken});

    print("---------------------------");
    print("Fetching _signinModel uri");
    print("---------------------------");

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _signinModel = SigninModel.fromJson(jsonResponse);
        print("Response From _signinModel Job -------" +
            response.body.toString());
        print("Fetching _signinModel uri success");
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _signinModel = null;
        print("Fetching _signinModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      _signinModel = null;
      print("Fetching _signinModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _signinModel = null;
  }
}
