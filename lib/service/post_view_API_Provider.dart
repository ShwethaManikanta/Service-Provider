import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:serviceprovider/model/post_view_model.dart';
import 'package:http/http.dart';

class PostViewAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  PostViewModel? _postViewModel;

  PostViewModel? get postViewModel => _postViewModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _postViewModel == null;

  Future<void> getPostView(String orderID) async {
    final uri = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/order_details");
    final response = await post(uri, body: {"order_id": orderID});

    print("---------------------------");
    print("Fetching _postViewModel uri");
    print(
        "------------RESPONSE---------------" + response.statusCode.toString());

    print("------------RESPONSE-----Body----------" + response.body.toString());

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _postViewModel = PostViewModel.fromJson(jsonResponse);
        print("Fetching _postViewModel uri success" + response.body.toString());
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _postViewModel = null;
        print("Fetching _postViewModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      _postViewModel = null;
      print("Fetching _postViewModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _postViewModel = null;
  }
}
