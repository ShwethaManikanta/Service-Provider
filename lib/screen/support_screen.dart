import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/model/support_model.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  void initState() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
    }
    // TODO: implement initState
    super.initState();
  }

  final titleController = TextEditingController();
  final descriptiomController = TextEditingController();

  SupportModel _supportModel = SupportModel();

  @override
  Widget build(BuildContext context) {
    final translationAPIProvider = Provider.of<TranslationAPIProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "${translationAPIProvider.translationModel!.languageDetails![80]}",
          style: CommonStyles.whiteText16BoldW500(),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                "${translationAPIProvider.translationModel!.languageDetails![94]}",
                style: CommonStyles.blue18900(),
              ),
            ),
            Utils.getSizedBox(height: 20),
            CachedNetworkImage(
              imageUrl:
                  "https://bzolutions.com/wp-content/uploads/2019/07/contactus.gif",
              height: 110,
            ),
            Utils.getSizedBox(height: 20),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Center(
                    child: Text(
                      "${translationAPIProvider.translationModel!.languageDetails![95]}",
                      style: CommonStyles.greeen15900(),
                    ),
                  ),
                  Utils.getSizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      controller: titleController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          label: Text(
                        "${translationAPIProvider.translationModel!.languageDetails![50]}",
                        style: CommonStyles.blue13(),
                      )),
                      style: CommonStyles.black13(),
                    ),
                  ),
                  Utils.getSizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      controller: descriptiomController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          label: Text(
                        "${translationAPIProvider.translationModel!.languageDetails![51]}",
                        style: CommonStyles.blue13(),
                      )),
                      style: CommonStyles.black13(),
                    ),
                  ),
                  Utils.getSizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    child: NeumorphicButton(
                      margin: EdgeInsets.symmetric(horizontal: 80),
                      onPressed: () async {
                        await apiService
                            .getSupport(titleController.text,
                                descriptiomController.text)
                            .then((value) => _supportModel = value!);
                        print("Order Placed ---- " +
                            _supportModel.message.toString() +
                            _supportModel.status.toString());

                        if (_supportModel.status == "1") {
                          Utils.showSnackBar(
                              context: context,
                              text: "${_supportModel.message.toString()}");
                        }
                        if (_supportModel.status == "0") {
                          Navigator.of(context).pop();
                          Utils.showSnackBar(
                              context: context,
                              text: "${_supportModel.message.toString()}");
                        }
                      },
                      style: NeumorphicStyle(),
                      child: Center(
                        child: Text(
                          "${translationAPIProvider.translationModel!.languageDetails![96]}",
                          style: CommonStyles.greeen15900(),
                        ),
                      ),
                    ),
                  ),
                  Utils.getSizedBox(height: 50),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Text(
                              "${translationAPIProvider.translationModel!.languageDetails![71]}",
                              style: CommonStyles.blue14900()),
                          Utils.getSizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.indigo,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "West Cross Road, Veena Complex, Basawaeshwara Nagar, Bangalore",
                                        style: CommonStyles.black13(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      openMap(double.parse("72.67654"),
                                          double.parse("12.4556756"));
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${translationAPIProvider.translationModel!.languageDetails![97]}",
                                        style: CommonStyles.greeen15900(),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      AvatarGlow(
                                        endRadius: 20,
                                        glowColor: Colors.indigo,
                                        child: Icon(
                                          Icons.directions,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Utils.getSizedBox(height: 20),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Text(
                              "${translationAPIProvider.translationModel!.languageDetails![98]}",
                              style: CommonStyles.blue14900()),
                          Utils.getSizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      size: 18,
                                      color: Colors.indigo,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "serviceprovider@gmail.com",
                                      style: CommonStyles.black13(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _launchEmail("service@gmail.com");
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${translationAPIProvider.translationModel!.languageDetails![99]}",
                                        style: CommonStyles.greeen15900(),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      AvatarGlow(
                                        endRadius: 20,
                                        glowColor: Colors.indigo,
                                        child: Icon(
                                          Icons.outgoing_mail,
                                          size: 20,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Utils.getSizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchEmail(String email) async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl) != null) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
