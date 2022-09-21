import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/screen/my_job_Provided_screen.dart';
import 'package:serviceprovider/screen/my_worked_job_screen.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';
import 'package:provider/provider.dart';

class MyJobSelectScreen extends StatefulWidget {
  const MyJobSelectScreen({Key? key}) : super(key: key);

  @override
  _MyJobSelectScreenState createState() => _MyJobSelectScreenState();
}

class _MyJobSelectScreenState extends State<MyJobSelectScreen> {
  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
    }
  }

  @override
  void initState() {
    initializeLanKey();
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translationAPIProvider = Provider.of<TranslationAPIProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "${translationAPIProvider.translationModel!.languageDetails![80]}",
          style: CommonStyles.whiteText16BoldW500(),
        ),
        centerTitle: true,
      ),
      body: translationAPIProvider.ifLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 0.5,
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: NeumorphicButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (Context) => MyJobProvided()));
                      },
                      child: Center(
                        child: Text(
                          "${translationAPIProvider.translationModel!.languageDetails![61]}",
                          style: CommonStyles.blue18900(),
                        ),
                      ),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 30,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: NeumorphicButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (Context) => MyWorkedJobScreen()));
                      },
                      child: Center(
                        child: Text(
                          "${translationAPIProvider.translationModel!.languageDetails![62]}",
                          style: CommonStyles.blue18900(),
                        ),
                      ),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 30,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(10))),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
