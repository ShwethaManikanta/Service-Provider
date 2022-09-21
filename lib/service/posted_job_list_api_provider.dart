import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/posted_list_model.dart';
import 'package:serviceprovider/service/api_service.dart';


class PostedJobAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  PostJobListModel? _postedJobListModel;

  PostJobListModel? get postedJobListModel => _postedJobListModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _postedJobListModel == null;

  Future<void> getPostedJobList() async {
    final uri = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/post_job_list");
    final response = await post(uri, body: {"user_id": APIService.userId});

    print("---------------------------");
    print("Fetching _postedJobListModel uri");
    print("---------------------------");

    print("Response from Posted Job List -------" + response.body);

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _postedJobListModel = PostJobListModel.fromJson(jsonResponse);
        print("Fetching _postedJobListModel uri success" + response.body);
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _postedJobListModel = null;
        print("Fetching _postedJobListModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      _postedJobListModel = null;
      print("Fetching _postedJobListModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _postedJobListModel = null;
  }
}
