import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/translation_modell.dart';
import 'package:serviceprovider/service/api_service.dart';


class TranslationAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  TranslationModel? _translationModel;

  TranslationModel? get translationModel => _translationModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _translationModel == null;

  Future<void> getTranslationList() async {
    final uri = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/transalation");
    final response = await post(uri, body: {"lan_key": APIService.lanKey});

    print("---------------------------");
    print("Fetching _translationModel uri");
    print("---------------------------");

    print("response" + response.statusCode.toString());
    print("response Body " + response.body.toString());

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _translationModel = TranslationModel.fromJson(jsonResponse);
        print("Fetching _translationModel uri success");
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _translationModel = null;
        print("Fetching _translationModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      print("Error with response code " + _errorMessage.toString());

      _translationModel = null;
      print("Fetching _transactionModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _translationModel = null;
  }
}
