import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/language_model.dart';


class LanguageAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  LanguageModel? _languageModel;

  LanguageModel? get languageModel => _languageModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _languageModel == null;

  Future<void> getLanguageList() async {
    final uri = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/language_list");
    final response = await get(uri);

    print("---------------------------");
    print("Fetching _languageModel uri");
    print("---------------------------");

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _languageModel = LanguageModel.fromJson(jsonResponse);
        print("Fetching _languageModel uri success");
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _languageModel = null;
        print("Fetching _languageModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      _languageModel = null;
      print("Fetching _languageModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _languageModel = null;
  }
}
