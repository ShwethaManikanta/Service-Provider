import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';

class FAQScreen extends StatefulWidget {
  final String lanKey;
  const FAQScreen({Key? key, required this.lanKey}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
      print("Language Key --------" + widget.lanKey);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "${translationAPIProvider.translationModel!.languageDetails![80]}",
          style: CommonStyles.whiteText16BoldW500(),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Neumorphic(
                padding: EdgeInsets.all(20),
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                  depth: NeumorphicTheme.embossDepth(context),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              Utils.getSizedBox(height: 30),
              Text(
                "${translationAPIProvider.translationModel!.languageDetails![31]}",
                style: CommonStyles.blackS16Thin(),
              ),
              Utils.getSizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What are the benefits ?",
                      style: CommonStyles.blue13900(),
                    ),
                    Utils.getSizedBox(height: 10),
                    Text(
                      "Benefits are Post Job and Get Job From in this APpliucation ...........................................",
                      maxLines: 10,
                      style: CommonStyles.black12(),
                    ),
                    Utils.getSizedBox(height: 20),
                    Text(
                      "What are the benefits ?",
                      style: CommonStyles.blue13900(),
                    ),
                    Utils.getSizedBox(height: 10),
                    Text(
                      "Benefits are Post Job and Get Job From in this APpliucation ...........................................",
                      maxLines: 10,
                      style: CommonStyles.black12(),
                    ),
                    Utils.getSizedBox(height: 20),
                    Text(
                      "What are the benefits ?",
                      style: CommonStyles.blue13900(),
                    ),
                    Utils.getSizedBox(height: 10),
                    Text(
                      "Benefits are Post Job and Get Job From in this APpliucation ...........................................",
                      maxLines: 10,
                      style: CommonStyles.black12(),
                    ),
                    Utils.getSizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
