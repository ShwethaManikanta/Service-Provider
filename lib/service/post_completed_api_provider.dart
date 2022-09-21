import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/post_complete_model.dart';
import 'package:serviceprovider/service/api_service.dart';


class PostCompletedAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  PostCompletedModel? _postCompletedModel;

  PostCompletedModel? get postCompletedModel => _postCompletedModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _postCompletedModel == null;

  Future<void> getPostCompletedJobList() async {
    final uri = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/post_completed_job_list");
    final response = await post(uri, body: {"user_id": APIService.userId});

    print("---------------------------");
    print("Fetching _postedJobListModel uri");
    print("---------------------------");

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _postCompletedModel = PostCompletedModel.fromJson(jsonResponse);
        print("Fetching _postedJobListModel uri success");
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _postCompletedModel = null;
        print("Fetching _postedJobListModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      _postCompletedModel = null;
      print("Fetching _postedJobListModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _postCompletedModel = null;
  }
}
