import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/model/register_model.dart';
import 'package:serviceprovider/model/signin_model.dart';
import 'package:serviceprovider/screen/home_screen.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/firebase_auth_services.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPScreen extends StatefulWidget {
  final String phNo;

  final String countryCode;
  final String lanKey;
  const OTPScreen(
      {Key? key,
      required this.phNo,
      required this.lanKey,
      required this.countryCode})
      : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  List<Color> colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  List<Color> silverColors = [
    HexColor("#b8d3fe"),
    HexColor("#aecad6"),
    HexColor("#b8d3fe"),
    HexColor("#aecad6"),
  ];

  String? getOTP;

  late FirebaseMessaging _firebaseMessaging;

  String? deviceToken;

  @override
  void initState() {
    initializeMessage();
    _listenOTP();
    initialize();
    initializeLanKey();
    super.initState();
  }

  final controller = TextEditingController();

  final String _comingSms = 'Unknown';

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  _listenOTP() async {
    await SmsAutoFill().listenForCode();
    // final signature = await SmsAutoFill().getAppSignature;
    // print("The app signature is  - - -- - - - " + signature);
  }

  initializeMessage() async {}

  final key = GlobalKey<FormState>();

  showSnackBar(msg, color, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 3.0,
        backgroundColor: color,
      ),
    );
  }

  String _code = "";
  String signature = "{{ app signature }}";

  Future verifyOTP(BuildContext context) async {
    print("verify otp called");
    try {
      await Provider.of<FirebaseAuthService>(context, listen: false)
          .verifyOTP(controller.text.toString())
          .then((_) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      }).catchError((e) {
        String errorMsg = 'Cant authentiate you Right now, Try again later!';
        if (e.toString().contains("ERROR_SESSION_EXPIRED")) {
          errorMsg = "Session expired, please resend OTP!";
        } else if (e.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {
          errorMsg = "You have entered wrong OTP!";
        }
        Utils.showErrorDialog(context, errorMsg);
      });
    } catch (e) {
      Utils.showErrorDialog(context, e.toString());
    }
  }

  RegisterModel _registerModel = RegisterModel();

  initialize() async {
    print("1-----------");
    _firebaseMessaging = FirebaseMessaging.instance;

    print("2-----------");

    final firebaseToken = await _firebaseMessaging.getToken();
    print("the firebase token is - ----- " + firebaseToken.toString());

    print("3-----------");
    deviceToken = firebaseToken;

    print("the firebase token is - ----- " + deviceToken.toString());
    print("4-----------");
  }

  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
      print("Language Key --------" + widget.lanKey);
    }
  }

  SigninModel _signinModel = SigninModel();

  @override
  Widget build(BuildContext context) {
    final translationAPIProvider = Provider.of<TranslationAPIProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        elevation: 0,
        title: Text(
          "OTP Verification",
          style: CommonStyles.whiteText16BoldW500(),
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          /*decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple,
                Colors.pink,
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),*/
          child: SingleChildScrollView(
            child: Column(children: [
              Column(
                children: [
                  /* ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "assets/images/logo2.png",
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),*/
                  SizedBox(
                    height: 50,
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                          '${translationAPIProvider.translationModel!.languageDetails![80]}'
                              .toUpperCase(),
                          textStyle: CommonStyles.black57S18(),
                          textAlign: TextAlign.right,
                          colors: silverColors)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                          'T${translationAPIProvider.translationModel!.languageDetails![78]}',
                          textStyle: CommonStyles.green9(),
                          textAlign: TextAlign.right,
                          colors: silverColors)
                    ],
                  ),
                ],
              ),
              Utils.getSizedBox(height: 170),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(children: [
                    Text(
                        translationAPIProvider
                            .translationModel!.languageDetails![8],
                        style: CommonStyles.black1654thin()),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "${translationAPIProvider.translationModel!.languageDetails![9]}  ",
                            style: CommonStyles.black13thinW54()),
                        Text(
                          "${widget.countryCode} ${widget.phNo}",
                          style: CommonStyles.black13(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //  Text("OTP is ----- + ${widget.checkOTP}"),
                    SizedBox(
                      height: 20,
                    ),
                    Column(children: [
                      PinFieldAutoFill(
                        // smsCodeRegexPattern: ,
                        decoration: UnderlineDecoration(
                            textStyle: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            colorBuilder: FixedColorBuilder(
                                Colors.black.withOpacity(0.3)),
                            gapSpace: 10),
                        currentCode: _code,

                        onCodeSubmitted: (code) async {
                          print(
                              "Code submittd =++++_---------___- -  - - - -+");
                          verifyOTP(context);
                        },

                        onCodeChanged: (code) {
                          print(code);
                          controller.text = code.toString();
                          print(controller.text);
                          if (code!.length == 6) {
                            // FocusScope.of(context).requestFocus(FocusNode());
                            verifyOTP(context);
                          }
                        },
                      ),
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    ResendOTPTimer(
                      phoneNumber: widget.phNo,
                      lanKey: widget.lanKey,
                    ),

                    SizedBox(
                      height: 100,
                    ),

                    SizedBox(
                      height: 60,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await apiService
                                .getSignin(
                                    "${widget.countryCode}${widget.phNo}",
                                    deviceToken.toString())
                                .then((value) => _signinModel = value!);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      lanKey: widget.lanKey,
                                    )));

                            APIService.userId = _signinModel.userId;
                            APIService.deviceToken = deviceToken;

                            print("User ID ------------" + APIService.userId!);
                            print("Lan Key ------------" + APIService.lanKey);
                            print("Device Token ------------" +
                                APIService.deviceToken!);

                            Utils.showSnackBar(
                                context: context, text: _signinModel.message!);

                            /*  await apiService
                  .register(
                      widget.countryCode,
                      APIService.lanKey,
                      "${widget.countryCode} ${widget.phNo}",
                      APIService.deviceToken!)
                  .then((value) => _registerModel = value!);
              if (_registerModel.status == "1") {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          lanKey: widget.lanKey,
                        )));
                Utils.showSnackBar(
                    context: context, text: _registerModel.message!);
              } else {
                Utils.showSnackBar(
                    context: context, text: _registerModel.message!);
              }*/
                          },
                          child: Card(
                            color: Colors.lightBlue,
                            child: Center(
                              child: Text(
                                  "${translationAPIProvider.translationModel!.languageDetails![4]}",
                                  style: CommonStyles.whiteText16BoldW500()),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]))
            ]),
          )),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: CommonStyles.greeen15900(),
      ),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "OTP Verification",
        style: CommonStyles.black1654thin(),
      ),
      content: Text(
        "Your OTP is not valid",
        style: CommonStyles.red12(),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ResendOTPTimer extends StatefulWidget {
  const ResendOTPTimer(
      {Key? key, required this.phoneNumber, required this.lanKey})
      : super(key: key);
  final String phoneNumber;
  final String lanKey;

  @override
  _ResendOTPTimerState createState() => _ResendOTPTimerState();
}

class _ResendOTPTimerState extends State<ResendOTPTimer> {
  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
      print("Language Key --------" + widget.lanKey);
    }
  }

  @override
  void initState() {
    startTimer();
    initializeLanKey();
  }

  @override
  void dispose() {
    _timer!.cancel();
  }

  Timer? _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final translationAPIProvider = Provider.of<TranslationAPIProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextButton(
              onPressed: _start != 0
                  ? () {
                      /*  context.read<FirebaseAuthService>().signInWithPhoneNumber(
                    "+91", "+91" + widget.phoneNumber, context);*/
                    }
                  : () {
                      Utils.showSnackBar(
                          context: context,
                          text: "Please wait for process to complete.");
                    },
              child: _start != 0
                  ? Text(
                      'Resend OTP in ' + _start.toString(),
                      style: CommonStyles.black13(),
                    )
                  : Text(
                      translationAPIProvider
                          .translationModel!.languageDetails![10],
                      style: CommonStyles.black13(),
                    )),
        )
      ],
    );
  }
}
