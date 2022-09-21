import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/profile_model.dart';


class ProfileUpdateApiProvder with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  ProfileUpdateResponseModel? _profileUpdateResponseModel;

  Future<void> updateProfileDetails(
      ProfileUpdateRequestModel profileUpdateRequestModel) async {
    print(
        "-------------------------------  >>>>>>>>>> Profile Update Api Provider");
    Uri profileApiUrl = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/profile_update");

    print(
        "-------------------------------  >>>>>>>>>> Profile Update Api Provider" +
            profileUpdateRequestModel.toString());

    final response =
        await post(profileApiUrl, body: profileUpdateRequestModel.toMap());

    print(""
        "Profile Update ----- ${response.body.toString()}");

    if (response.statusCode == 200) {
      try {
        print("Response @ ProfileApi " + response.body);
        final jsonResponse = jsonDecode(response.body);
        print("Json Response @ Profile" + jsonResponse.toString());
        _profileUpdateResponseModel =
            ProfileUpdateResponseModel.fromJson(jsonResponse);
      } catch (e) {
        _error = true;
        _errorMessage = e.toString();
        _profileUpdateResponseModel = null;
      }
    } else {
      _error = true;
      _errorMessage =
          "Error while getting the data from internet ${response.statusCode}";
      _profileUpdateResponseModel = null;
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _profileUpdateResponseModel = null;
  }

  bool get error => _error;
  String get errorMessage => _errorMessage;
  ProfileUpdateResponseModel? get profileUpdateResponse =>
      _profileUpdateResponseModel;

  bool get ifLoading => _error == false && _profileUpdateResponseModel == null;
}
