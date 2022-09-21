import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/common/image_picker_service.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/screen/country_language.dart';
import 'package:serviceprovider/screen/home_screen.dart';
import 'package:serviceprovider/service/accepted_job_api_provider.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/banner_api_provider.dart';
import 'package:serviceprovider/service/classic_job_api_provider.dart';
import 'package:serviceprovider/service/firebaseAuthService/firebase_auth_service.dart';
import 'package:serviceprovider/service/firebase_auth_services.dart';
import 'package:serviceprovider/service/language_api_provider.dart';
import 'package:serviceprovider/service/login_api_provider.dart';
import 'package:serviceprovider/service/post_completed_api_provider.dart';
import 'package:serviceprovider/service/post_view_API_Provider.dart';
import 'package:serviceprovider/service/posted_job_list_api_provider.dart';
import 'package:serviceprovider/service/primary_job_api_provider.dart';
import 'package:serviceprovider/service/profile_api_provider.dart';
import 'package:serviceprovider/service/profile_update_api_provide.dart';
import 'package:serviceprovider/service/shared_preferences.dart';
import 'package:serviceprovider/service/signin_api_provider.dart';
import 'package:serviceprovider/service/transaction_api_provider.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
        Provider<ImagePickerService>(create: (_) => ImagePickerService()),
        ChangeNotifierProvider<BannerAPIProvider>(
            create: (_) => BannerAPIProvider()),
        ChangeNotifierProvider<ClassicJobAPIProvider>(
            create: (_) => ClassicJobAPIProvider()),
        ChangeNotifierProvider<PrimaryJobAPIProvider>(
            create: (_) => PrimaryJobAPIProvider()),
        ChangeNotifierProvider<ProfileAPIProvider>(
            create: (_) => ProfileAPIProvider()),
        ChangeNotifierProvider<PostViewAPIProvider>(
            create: (_) => PostViewAPIProvider()),
        ChangeNotifierProvider<ProfileUpdateApiProvder>(
            create: (context) => ProfileUpdateApiProvder()),
        ChangeNotifierProvider<PostedJobAPIProvider>(
            create: (context) => PostedJobAPIProvider()),
        ChangeNotifierProvider<TransactionListAPIProvider>(
            create: (context) => TransactionListAPIProvider()),
        ChangeNotifierProvider<PostCompletedAPIProvider>(
            create: (context) => PostCompletedAPIProvider()),
        ChangeNotifierProvider<SigninAPIProvider>(
            create: (context) => SigninAPIProvider()),
        ChangeNotifierProvider<TranslationAPIProvider>(
            create: (context) => TranslationAPIProvider()),
        ChangeNotifierProvider<AcceptedJobAPIProvider>(
            create: (context) => AcceptedJobAPIProvider()),
        ChangeNotifierProvider<LanguageAPIProvider>(
            create: (context) => LanguageAPIProvider()),
        ChangeNotifierProvider<VerifyUserLoginAPIProvider>(
            create: (_) => VerifyUserLoginAPIProvider()),
        ChangeNotifierProvider<SharedPreferencesProvider>(
            create: (_) => SharedPreferencesProvider()),
      ],
      child: AuthWidgetBuilder(
          builder: (context, AsyncSnapshot<LoggedInUser?> loggedInUser) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              // home: CountryLanguageScreen(),
              home: LoginCheck(loginSnapshot: loggedInUser),
            );
          }),
    );
  }
}

class LoginCheck extends StatefulWidget {
  const LoginCheck({Key? key, required this.loginSnapshot}) : super(key: key);

  final AsyncSnapshot<LoggedInUser?> loginSnapshot;

  @override
  State<LoginCheck> createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  @override
  void initState() {
    super.initState();
    // ApiServices.userId="1";
  }

  @override
  Widget build(BuildContext context) {
    print("the is logged in +++++   " + widget.loginSnapshot.toString());

    if (widget.loginSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 0.5,
                color: Colors.blue,
              ),
              Text(
                'Loading',
                style: CommonStyles.black13(),
              )
            ],
          ),
        ),
      );
    } else {
      if (widget.loginSnapshot.data != null) {
        final sharedPreferencesProvider =
        Provider.of<SharedPreferencesProvider>(context, listen: false);
        return const LoginUsingUserId();
      }
      return const CountryLanguageScreen();
    }
  }
}

class LoginUsingUserId extends StatefulWidget {
  const LoginUsingUserId({Key? key}) : super(key: key);

  @override
  _LoginUsingUserIdState createState() => _LoginUsingUserIdState();
}

class _LoginUsingUserIdState extends State<LoginUsingUserId> {
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    final loggedInUser = Provider.of<LoggedInUser>(context, listen: false);
    final firebaseToken = await _firebaseMessaging.getToken();

    print("the firebase token is - ----- " + firebaseToken.toString());
    print("Ph No " +
        loggedInUser.phoneNo.substring(3, loggedInUser.phoneNo.length));
    if (context.read<VerifyUserLoginAPIProvider>().loginResponse == null) {
      context
          .read<VerifyUserLoginAPIProvider>()
          .getUser(
        deviceToken: firebaseToken.toString(),
        userFirebaseID: context.read<LoggedInUser>().uid,
        //  phoneNumber: context.read<LoggedInUser>().phoneNo
        phoneNumber:
        loggedInUser.phoneNo.substring(3, loggedInUser.phoneNo.length),
      )
          .whenComplete(() {
        setUserID();
        print("User id assigned for user  - - -- - - " +
            context
                .read<VerifyUserLoginAPIProvider>()
                .loginResponse!
                .userDetails!
                .id!);
      });
    }
  }

  setUserID() async {
    print(context
        .read<VerifyUserLoginAPIProvider>()
        .loginResponse!
        .userDetails!
        .id!
        .toString() +
        "----------------------API USRID");
    APIService.userId = context
        .read<VerifyUserLoginAPIProvider>()
        .loginResponse!
        .userDetails!
        .id;
  }

  @override
  Widget build(BuildContext context) {
    final verifyLoginApi = Provider.of<VerifyUserLoginAPIProvider>(context);
    return Scaffold(
      body: Center(
          child: verifyLoginApi.isLoading
              ? ifLoading()
          //     : verifyLoginApi.error
          //         ? Utils.showErrorDialog(context, verifyLoginApi.errorMessage)
          //         : verifyLoginApi.loginResponse!.status == "0"
          //             ? Utils.showErrorDialog(
          //                 context, verifyLoginApi.loginResponse!.message)
              : HomeScreen()),
    );
  }

  ifLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          strokeWidth: 0.5,
          color: Colors.blue,
        ),
        Utils.getSizedBox(height: 10),
        Text(
          'Loading',
          style: CommonStyles.white12(),
        )
      ],
    );
  }
}
