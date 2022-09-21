import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferencesInitializationStatus { initialized, uninitialized }

class SharedPreferencesProvider with ChangeNotifier {
  late SharedPreferences sharedPreferences;

  SharedPreferencesInitializationStatus _status =
      SharedPreferencesInitializationStatus.uninitialized;

  late String _userId;
  late bool _isUserLoggedIn;
  //late bool _viewedSplashPage;
  late bool _onboardingImages;

  SharedPreferencesProvider() {
    initialize();
  }

  initialize() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _status = SharedPreferencesInitializationStatus.initialized;
    _userId = sharedPreferences.getString("id") ?? "NA";
    _isUserLoggedIn = sharedPreferences.getBool("isUserLoggedIn") ?? false;
    // _viewedSplashPage = sharedPreferences.getBool("viewedSplashPage") ?? false;
    _onboardingImages = sharedPreferences.getBool("onboardingImages") ?? false;
    notifyListeners();
  }

  String get profileuserId => _userId;
  bool get isUserLoggedIn => _isUserLoggedIn;

  // bool get viewedSplashPage => _viewedSplashPage;
  bool get Onboarding => _onboardingImages;

  set isUserLoggedIn(bool value) {
    sharedPreferences.setBool("isUserLoggedIn", value);
    notifyListeners();
  }

  Future<String> getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userId') ?? "NA";
  }

  set userId(String value) {
    sharedPreferences.setString("id", value);
    notifyListeners();
  }

  SharedPreferencesInitializationStatus get status => _status;
}
