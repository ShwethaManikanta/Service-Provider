import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/primary_job_model.dart';
import 'package:serviceprovider/service/api_service.dart';


class PrimaryJobAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  PrimaryJobModel? _primaryJobModel;

  PrimaryJobModel? get primaryJobModel => _primaryJobModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _primaryJobModel == null;

  Future<void> getPrimaryJobs() async {
    final uri = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/primary_job_list");
    final response = await post(uri, body: {"user_id": APIService.userId});

    print("---------------------------");
    print("Fetching _primaryJobModel uri");
    print("---------------------------");

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _primaryJobModel = PrimaryJobModel.fromJson(jsonResponse);
        print("Response From primary Job -------" + response.body.toString());
        print("Fetching _primaryJobModel uri success");
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _primaryJobModel = null;
        print("Fetching _primaryJobModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      _primaryJobModel = null;
      print("Fetching _primaryJobModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _primaryJobModel = null;
  }
}
