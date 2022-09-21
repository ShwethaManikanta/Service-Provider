import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/profile_model.dart';
import 'package:serviceprovider/service/api_service.dart';

class ProfileAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  ProfileModel? _profileModel;

  ProfileModel? get profileModel => _profileModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _profileModel == null;

  Future<void> getProfile() async {
    final uri =
        Uri.parse("https://chillkrt.in/service_provider/index.php/Api/profile");
    final response = await post(uri, body: {"user_id": APIService.userId});

    print("---------------------------");
    print("Fetching ProfileModel uri");
    print("---------------------------");

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _profileModel = ProfileModel.fromJson(jsonResponse);
        print("Fetching ProfileModel uri success");
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _profileModel = null;
        print("Fetching ProfileModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      _profileModel = null;
      print("Fetching ProfileModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _profileModel = null;
  }
}
