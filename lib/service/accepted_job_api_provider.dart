import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/accepted_job_model.dart';
import 'package:serviceprovider/service/api_service.dart';


class AcceptedJobAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  AcceptedJobModel? _acceptedJobModel;

  AcceptedJobModel? get postCompletedModel => _acceptedJobModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _acceptedJobModel == null;

  Future<void> getAcceptedJobList() async {
    final uri = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/accepted_jobs_list");
    final response = await post(uri, body: {"user_id": APIService.userId});

    print("---------------------------");
    print("Fetching _acceptedJobModel uri");
    print("---------------------------");

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _acceptedJobModel = AcceptedJobModel.fromJson(jsonResponse);
        print("Fetching _acceptedJobModel uri success");
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _acceptedJobModel = null;
        print("Fetching _acceptedJobModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      _acceptedJobModel = null;
      print("Fetching _acceptedJobModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _acceptedJobModel = null;
  }
}
