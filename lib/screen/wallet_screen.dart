import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/service/profile_api_provider.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAPIProvider = Provider.of<ProfileAPIProvider>(context);
    final translationAPIProvider = Provider.of<TranslationAPIProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "${translationAPIProvider.translationModel!.languageDetails![80]}",
          style: CommonStyles.whiteText16BoldW500(),
        ),
      ),
      body: profileAPIProvider.profileModel!.walletDetails == null ||
              profileAPIProvider.profileModel!.walletAmount!.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "No Transaction History",
                  style: CommonStyles.black13(),
                )
              ],
            ))
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "${translationAPIProvider.translationModel!.languageDetails![29]}",
                      style: CommonStyles.blue18900(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Neumorphic(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${translationAPIProvider.translationModel!.languageDetails![54]}",
                            style: CommonStyles.greeen15(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.currency_rupee,
                                size: 18,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                profileAPIProvider.profileModel!.walletAmount!,
                                style: CommonStyles.greeen15bold(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          NeumorphicButton(
                            onPressed: () {},
                            style:
                                NeumorphicStyle(color: Colors.lightBlueAccent),
                            child: Text(
                              "${translationAPIProvider.translationModel!.languageDetails![56]}",
                              style: CommonStyles.whiteText16BoldW500(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${translationAPIProvider.translationModel!.languageDetails![57]}",
                        style: CommonStyles.blue14900(),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.currency_rupee,
                            size: 18,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "2500",
                            style: CommonStyles.greeen15900(),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${translationAPIProvider.translationModel!.languageDetails![58]}",
                        style: CommonStyles.blue14900(),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.currency_rupee,
                            size: 18,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "25000",
                            style: CommonStyles.greeen15900(),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: NeumorphicButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      onPressed: () {},
                      style: NeumorphicStyle(color: Colors.lightBlueAccent),
                      child: Text(
                        "${translationAPIProvider.translationModel!.languageDetails![59]}",
                        style: CommonStyles.whiteText16BoldW500(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return (Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "12-03-1999",
                                style: CommonStyles.black13(),
                              ),
                              Text(
                                "Job Location",
                                style: CommonStyles.black13(),
                              ),
                              Text(
                                "₹  2457",
                                style: CommonStyles.greeen15900(),
                              )
                            ],
                          ),
                        ));
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
