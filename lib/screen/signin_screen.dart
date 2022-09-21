import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/common/text_styles.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/main.dart';
import 'package:serviceprovider/model/mobile_verification_model.dart';
import 'package:serviceprovider/screen/otp_screen.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/firebase_auth_services.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';
import 'package:provider/provider.dart';

enum MobileVerificationState {
  // ignore: constant_identifier_names
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class SignInScreen extends StatefulWidget {
  final String countryCode;
  final String lanKey;
  const SignInScreen(
      {Key? key, required this.countryCode, required this.lanKey})
      : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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

  final mobileController = TextEditingController();

  bool checkBoxValue = false;

  initialize() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
      print("Language Key --------" + widget.lanKey);
    }
  }

  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  verifyPhone(BuildContext context) async {
    final firebaseAuthServiceProvider =
        Provider.of<FirebaseAuthService>(context, listen: false);

    print("The phone number is  - -- - " + mobileController.text);

    try {
      Utils.showSendingOTP(context);

      await firebaseAuthServiceProvider
          .signInWithPhoneNumber(
              "+91", "+91" + mobileController.text.toString(), context,
              pushWidget: const LoginUsingUserId())
          .then((value) => () {})
          .catchError((e) {
        print("eroor" + e.toString());
        String errorMsg = 'Cant Authenticate you, Try Again Later';
        if (e.toString().contains(
            'We have blocked all requests from this device due to unusual activity. Try again later.')) {
          errorMsg = 'Please wait as you have used limited number request';
        }
        Utils.showErrorDialog(context, errorMsg);
      });
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OTPScreen(
                countryCode: widget.countryCode,
                lanKey: APIService.lanKey,
                phNo: mobileController.text,
              )));
    } catch (e) {
      Utils.showErrorDialog(context, e.toString());
    }
  }

  @override
  void initState() {
    initialize();
    // TODO: implement initState
    super.initState();
  }

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
          translationAPIProvider.translationModel!.languageDetails![81],
          style: CommonStyles.whiteText16BoldW500(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                    height: 20,
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
                          '${translationAPIProvider.translationModel!.languageDetails![78]}',
                          textStyle: CommonStyles.green9(),
                          textAlign: TextAlign.right,
                          colors: silverColors)
                    ],
                  ),
                ],
              ),
              Utils.getSizedBox(height: 200),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                          translationAPIProvider
                              .translationModel!.languageDetails![5],
                          textStyle: CommonStyles.black57S18(),
                          textAlign: TextAlign.right,
                          colors: silverColors)
                    ],
                  ),
                  /*    Text(
                    translationAPIProvider
                        .translationModel!.languageDetails![5],
                    style: CommonStyles.black1654thin(),
                  ),*/
                  Utils.getSizedBox(height: 20),
                  Neumorphic(
                    margin:
                        EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                    style: NeumorphicStyle(
                      intensity: 30,
                      shadowLightColor: Colors.lightBlueAccent.shade100,
                      depth: NeumorphicTheme.embossDepth(context),
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    child: TextFormField(
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      // onChanged: this.widget.onChanged,
                      controller: mobileController,
                      decoration: InputDecoration(
                        //   enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        //       disabledBorder: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.blue,
                          size: 20,
                        ),
                        prefixText: widget.countryCode,
                        counterText: "",
                        hintText:
                            "   ${translationAPIProvider.translationModel!.languageDetails![6]}",
                      ),
                      style: CommonStyles.black13thin(),
                    ),
                  ),
                  Utils.getSizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            activeColor: Colors.green,
                            value: checkBoxValue,
                            onChanged: (value) {
                              setState(() {
                                checkBoxValue = value!;
                                print(checkBoxValue);
                              });
                            }),
                        FittedBox(
                          child: RichText(
                            text: TextSpan(
                                text: "I have ",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text: "Accept",
                                    style: CommonStyles.whiteText12BoldW500(),
                                  ),
                                  TextSpan(
                                    text: " the ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Terms",
                                    style: CommonStyles.whiteText12BoldW500(),
                                  ),
                                  TextSpan(
                                    text: " and ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Conditions",
                                    style: CommonStyles.whiteText12BoldW500(),
                                  ),
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Utils.getSizedBox(height: 150),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: InkWell(
                    onTap: () {
                      if (mobileController.text.isNotEmpty &&
                          checkBoxValue == true) {
                        verifyPhone(context);
                        APIService.userId = "1";
                      }
                    },
                    child: Card(
                      color: checkBoxValue == true
                          ? Colors.lightBlue
                          : Colors.white,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                              translationAPIProvider
                                  .translationModel!.languageDetails![3],
                              style: checkBoxValue == false
                                  ? CommonTextSyles.textHeaderBlack16()
                                  : CommonStyles.whiteText16BoldW500()),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  MobileOTPModel _mobileOTPModel = MobileOTPModel();

/*  intensity: 30),
  onPressed: () {
  if (mobileController.text.isNotEmpty &&
  checkBoxValue == true) {
  verifyPhone(context);
  APIService.userId = "1";
  }
  },*/
}
