import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/calssic_job_model.dart';
import 'package:serviceprovider/service/api_service.dart';


class ClassicJobAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  ClasssicJobModel? _classsicJobModel;

  ClasssicJobModel? get classsicJobModel => _classsicJobModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _classsicJobModel == null;

  Future<void> getClassicJobs() async {
    final uri = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/classical_job_list");
    final response = await post(uri, body: {"user_id": APIService.userId});

    print("Usser ID ---------" + APIService.userId!);

    print("---------------------------");
    print("Fetching ClasssicJobModel uri");
    print("---------------------------");

    print("response" + response.statusCode.toString());
    print("response  Body " + response.body.toString());

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _classsicJobModel = ClasssicJobModel.fromJson(jsonResponse);
        print("Fetching ClasssicJobModel uri success");
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _classsicJobModel = null;
        print("Fetching ClasssicJobModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      print("Error with response code " + _errorMessage.toString());

      _classsicJobModel = null;
      print("Fetching ClasssicJobModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _classsicJobModel = null;
  }
}
