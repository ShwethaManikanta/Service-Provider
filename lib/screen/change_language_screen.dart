import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/language_api_provider.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({Key? key}) : super(key: key);

  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String lanKey = "en";

  initialize() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
      print("Language Key --------" + lanKey);
    }
  }

  @override
  void initState() {
    initialize();
    if (context.read<LanguageAPIProvider>().languageModel == null) {
      context.read<LanguageAPIProvider>().getLanguageList();
      print("Language Key --------" + lanKey);
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _languageAPIProvider = Provider.of<LanguageAPIProvider>(context);
    final translationAPIProvider = Provider.of<TranslationAPIProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "${translationAPIProvider.translationModel!.languageDetails![30]}",
            style: CommonStyles.whiteText16BoldW500(),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: CachedNetworkImage(
          height: 150,
          imageUrl:
              "https://cdn.dribbble.com/users/45010/screenshots/2740788/choose_language.gif",
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "${translationAPIProvider.translationModel!.languageDetails![30]}",
                  style: CommonStyles.blue14900(),
                ),
                SizedBox(
                  height: 30,
                ),
                _languageAPIProvider.ifLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      )
                    : GridView.builder(
                        reverse: true,
                        clipBehavior: Clip.antiAlias,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(7),
                        primary: false,
                        itemCount: _languageAPIProvider
                            .languageModel!.languageList!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 15,
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 70),
                        itemBuilder: (context, index) {
                          return NeumorphicButton(
                            onPressed: () async {
                              lanKey = _languageAPIProvider.languageModel!
                                  .languageList![index].languageKey!;
                              APIService.lanKey = "${lanKey}";
                              print(
                                  "Language Key - From Change------" + lanKey);

                              print(
                                  "Api LanKey ----------" + APIService.lanKey);
                              await context
                                  .read<TranslationAPIProvider>()
                                  .getTranslationList();
                            },
                            padding: EdgeInsets.all(10),
                            style: NeumorphicStyle(
                              lightSource: LightSource.topRight,
                              intensity: 30,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                  _languageAPIProvider.languageModel!
                                      .languageList![index].language!,
                                  style: CommonStyles.black13thin()),
                            ),
                          );
                        }),
              ],
            ),
          ),
        ));
  }
}
