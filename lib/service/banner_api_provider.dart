import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/banner_model.dart';


class BannerAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  BannerModel? _bannerModel;

  BannerModel? get bannerModel => _bannerModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _bannerModel == null;

  Future<void> getBanner() async {
    final uri = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/banner_list");
    final response = await get(uri);

    print("---------------------------");
    print("Fetching _bannerModel uri");
    print("---------------------------");

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _bannerModel = BannerModel.fromJson(jsonResponse);
        print("Fetching _bannerModel uri success");
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _bannerModel = null;
        print("Fetching _bannerModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      _bannerModel = null;
      print("Fetching _bannerModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _bannerModel = null;
  }
}
