import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:serviceprovider/model/transaction_model.dart';
import 'package:serviceprovider/service/api_service.dart';


class TransactionListAPIProvider with ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  TransactionModel? _transactionModel;

  TransactionModel? get transactionModel => _transactionModel;

  bool get error => _error;

  String get errorMessage => _errorMessage;

  bool get ifLoading => _error == false && _transactionModel == null;

  Future<void> getTransactionList() async {
    final uri = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/my_trasanction_list");
    final response = await post(uri, body: {"user_id": APIService.userId});

    print("---------------------------");
    print("Fetching _transactionModel uri");
    print("---------------------------");

    print("response" + response.statusCode.toString());
    print("response Body " + response.body.toString());

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        _transactionModel = TransactionModel.fromJson(jsonResponse);
        print("Fetching _transactionModel uri success");
      } catch (e) {
        _error = false;
        _errorMessage = e.toString();
        _transactionModel = null;
        print("Fetching _transactionModel uri fail");
      }
    } else {
      _error = false;
      _errorMessage =
          "Error with response code " + response.statusCode.toString();
      print("Error with response code " + _errorMessage.toString());

      _transactionModel = null;
      print("Fetching _transactionModel uri fail");
    }
    notifyListeners();
  }

  initialize() {
    _error = false;
    _errorMessage = "";
    _transactionModel = null;
  }
}
