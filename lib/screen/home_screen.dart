import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/common/loading_widget.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/screen/change_language_screen.dart';
import 'package:serviceprovider/screen/country_language.dart';
import 'package:serviceprovider/screen/faq_screen.dart';
import 'package:serviceprovider/screen/job_view_screen.dart';
import 'package:serviceprovider/screen/job_confirmation_screen.dart';
import 'package:serviceprovider/screen/myjob_selection.dart';
import 'package:serviceprovider/screen/post_job_screen.dart';
import 'package:serviceprovider/screen/profile_screen.dart';
import 'package:serviceprovider/screen/support_screen.dart';
import 'package:serviceprovider/screen/transaction_screen.dart';
import 'package:serviceprovider/screen/wallet_screen.dart';
import 'package:serviceprovider/service/accepted_job_api_provider.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/banner_api_provider.dart';
import 'package:serviceprovider/service/classic_job_api_provider.dart';
import 'package:serviceprovider/service/firebase_auth_services.dart';
import 'package:serviceprovider/service/language_api_provider.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  final String? lanKey;
  HomeScreen({Key? key, this.lanKey}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  int activeIndex = 0;
  final controller = CarouselController();
  late TabController _tabController;

  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
    }
  }

  @override
  void initState() {
    initializeLanKey();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    if (context.read<BannerAPIProvider>().bannerModel == null) {
      context.read<BannerAPIProvider>().getBanner();
    }
    if (context.read<ClassicJobAPIProvider>().classsicJobModel == null) {
      context.read<ClassicJobAPIProvider>().getClassicJobs();
    }
    if (context.read<PrimaryJobAPIProvider>().primaryJobModel == null) {
      context.read<PrimaryJobAPIProvider>().getPrimaryJobs();
    }
    // TODO: implement initState
    super.initState();
  }

  List<Color> colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    final _bannerAPIProvider = Provider.of<BannerAPIProvider>(context);
    final _classicAPIProvider = Provider.of<ClassicJobAPIProvider>(context);
    final _primaryAPIProvider = Provider.of<PrimaryJobAPIProvider>(context);
    final translationAPiProvider = Provider.of<TranslationAPIProvider>(context);
    final sharedPreferencesProvider =
        Provider.of<SharedPreferencesProvider>(context);

    print("LanKey -----" + APIService.lanKey.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      drawer: SideDrawer(lanKey: APIService.lanKey),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
            },
            icon: Icon(Icons.menu)),
        flexibleSpace: Container(
            /*  decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange,
                Colors.red,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.centerRight,
            ),
          ),*/
            ),
        toolbarHeight: 50,
        // backgroundColor: Colors.orange[500],
        title: Text(
          translationAPiProvider.ifLoading
              ? ""
              : "${translationAPiProvider.translationModel!.languageDetails![80]}"
                  .toUpperCase(),
          style: CommonStyles.whiteText16BoldW500(),
        ),
        centerTitle: true,
        /* actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    */ /*   showSearch(
                      context: context,
                      delegate: CustomerSearchDelegate(),
                    );*/ /*
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  )))
        ],*/
      ),
      body: SingleChildScrollView(
        child: translationAPiProvider.ifLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 0.5,
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    buildBanner(_bannerAPIProvider),
                    Utils.getSizedBox(height: 20),
                    Container(
                        child: Column(children: [
                      DefaultTabController(
                          length: 2,
                          initialIndex: 1,
                          child: Column(children: [
                            TabBar(
                              unselectedLabelColor: Colors.orange,
                              labelColor: Colors.red,
                              indicatorColor: Colors.indigo,
                              controller: _tabController,
                              isScrollable: true,
                              tabs: <Widget>[
                                Tab(
                                  child: Neumorphic(
                                    style: const NeumorphicStyle(
                                        intensity: 30, color: Colors.lightBlue),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5),
                                      child: Text(
                                          translationAPiProvider
                                              .translationModel!
                                              .languageDetails![11],
                                          style: CommonStyles
                                              .whiteText16BoldW500()),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Neumorphic(
                                    style: const NeumorphicStyle(
                                        intensity: 30, color: Colors.lightBlue),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5),
                                      child: Text(
                                          "${translationAPiProvider.translationModel!.languageDetails![12]}",
                                          style: CommonStyles
                                              .whiteText16BoldW500()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _classicAPIProvider.ifLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                            ),
                                          )
                                        : buildClassicJob(_classicAPIProvider,
                                            translationAPiProvider),
                                    _primaryAPIProvider.ifLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                            ),
                                          )
                                        : buildPrimaryJob(_primaryAPIProvider,
                                            translationAPiProvider),
                                  ]),
                            )
                          ]))
                    ]))
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildPrimaryJob(PrimaryJobAPIProvider _primaryAPIProvider,
      TranslationAPIProvider translationAPIProvider) {
    return _primaryAPIProvider.primaryJobModel == null ||
            _primaryAPIProvider.primaryJobModel!.primaryJobList == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Utils.showLoaderDialog(context),
              Text(
                _primaryAPIProvider.primaryJobModel!.message!,
                style: CommonStyles.black13(),
              )
            ],
          )
        : RefreshIndicator(
            onRefresh: () async {
              await context.read<PrimaryJobAPIProvider>().getPrimaryJobs();
            },
            child: ListView.builder(
                shrinkWrap: true,
                primary: true,
                padding: EdgeInsets.only(bottom: 40),
                //  physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount:
                    _primaryAPIProvider.primaryJobModel!.primaryJobList!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: NeumorphicButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => JobViewScreen(
                                  lanKey: APIService.lanKey,
                                  orderID: _primaryAPIProvider.primaryJobModel!
                                      .primaryJobList![index].id!,
                                  jobTitle: _primaryAPIProvider.primaryJobModel!
                                      .primaryJobList![index].jobTitle!,
                                )));
                      },
                      style: const NeumorphicStyle(
                          lightSource: LightSource.top, intensity: 30),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              // height: 180,
                              //   width: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Posted ID  : ",
                                        style: CommonStyles.black13thin(),
                                      ),
                                      Text(
                                        "${_primaryAPIProvider.primaryJobModel!.primaryJobList![index].id}",
                                        style: CommonStyles.blue14900(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${translationAPIProvider.translationModel!.languageDetails![14]}   : ",
                                        style: CommonStyles.black11(),
                                      ),
                                      AnimatedTextKit(
                                        animatedTexts: [
                                          ColorizeAnimatedText(
                                              " ₹  ${_primaryAPIProvider.primaryJobModel!.primaryJobList![index].total}",
                                              colors: colorizeColors,
                                              textStyle:
                                                  CommonStyles.blue14900())
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${translationAPIProvider.translationModel!.languageDetails![17]}  : ",
                                        style: CommonStyles.black11(),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${_primaryAPIProvider.primaryJobModel!.primaryJobList![index].dateTime}",
                                          style: CommonStyles.blue14900(),
                                          maxLines: 2,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${translationAPIProvider.translationModel!.languageDetails![15]}         : ",
                                        style: CommonStyles.black11(),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${_primaryAPIProvider.primaryJobModel!.primaryJobList![index].jobTitle}",
                                          style: CommonStyles.blue14900(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (_primaryAPIProvider.primaryJobModel !=
                                      null)
                                    Row(
                                      children: [
                                        Text(
                                          "${translationAPIProvider.translationModel!.languageDetails![16]} : ",
                                          style: CommonStyles.black11(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${_primaryAPIProvider.primaryJobModel!.primaryJobList![index].address}",
                                            style: CommonStyles.blue14900(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CarouselSlider.builder(
                                  carouselController: controller,
                                  itemCount: _primaryAPIProvider
                                      .primaryJobModel!
                                      .primaryJobList![index]
                                      .beforeJobImage!
                                      .length,
                                  itemBuilder: (context, index, beforeImg) {
                                    print(
                                        " Item Count ${_primaryAPIProvider.primaryJobModel!.primaryJobList![index].beforeJobImage!.length}");

                                    print("---------Primary BImg Length" +
                                        _primaryAPIProvider
                                            .primaryJobModel!
                                            .primaryJobList![index]
                                            .beforeJobImage!
                                            .length
                                            .toString());
                                    print("---------Primary BImg Length" +
                                        _primaryAPIProvider
                                            .primaryJobModel!
                                            .primaryJobList!
                                            .first
                                            .beforeJobImage!
                                            .length
                                            .toString());

                                    print(
                                        " -----IMAGE URL----${_primaryAPIProvider.primaryJobModel!.beforeImageUrl}${_primaryAPIProvider.primaryJobModel!.primaryJobList![index].beforeJobImage!}");

                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Colors.blue.shade100,
                                            Colors.white,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${_primaryAPIProvider.primaryJobModel!.beforeImageUrl}${_primaryAPIProvider.primaryJobModel!.primaryJobList![index].beforeJobImage![index]}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    autoPlay: false,
                                    aspectRatio: 1,
                                    pageSnapping: true,
                                    autoPlayCurve: Curves.easeInOut,
                                    enableInfiniteScroll: false,
                                    //  enlargeStrategy: CenterPageEnlargeStrategy.height,
                                    //   viewportFraction: 1,
                                    enlargeCenterPage: true,
                                    //    initialPage: 0,
                                    // aspectRatio: 16/9,
                                    autoPlayInterval: Duration(seconds: 2),
                                    onPageChanged: (index, reason) =>
                                        setState(() => activeIndex = index),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

  Widget buildClassicJob(ClassicJobAPIProvider _classicAPIProvider,
      TranslationAPIProvider translationAPIProvider) {
    return _classicAPIProvider.classsicJobModel == null ||
            _classicAPIProvider.classsicJobModel!.classicalJobList == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //   Utils.showLoaderDialog(context),
              Text(
                _classicAPIProvider.classsicJobModel!.message!,
                style: CommonStyles.black13(),
              )
            ],
          )
        : RefreshIndicator(
            onRefresh: () async {
              await context.read<ClassicJobAPIProvider>().getClassicJobs();
            },
            child: ListView.builder(
                shrinkWrap: true,
                primary: true,
                padding: EdgeInsets.only(bottom: 40),
                //  physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: _classicAPIProvider
                    .classsicJobModel!.classicalJobList!.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10),
                        child: NeumorphicButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            print("Order ID Classical" +
                                _classicAPIProvider.classsicJobModel!
                                    .classicalJobList![index].id! +
                                _classicAPIProvider.classsicJobModel!
                                    .classicalJobList![index].jobType!);

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => JobViewScreen(
                                      lanKey: APIService.lanKey,
                                      orderID: _classicAPIProvider
                                          .classsicJobModel!
                                          .classicalJobList![index]
                                          .id!,
                                      jobTitle: _classicAPIProvider
                                          .classsicJobModel!
                                          .classicalJobList![index]
                                          .jobTitle!,
                                    )));
                          },
                          style: NeumorphicStyle(
                              lightSource: LightSource.top, intensity: 30),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  //  height: 180,
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Posted ID  :   ",
                                            style: CommonStyles.black13thin(),
                                          ),
                                          Text(
                                            "${_classicAPIProvider.classsicJobModel!.classicalJobList![index].id}",
                                            style: CommonStyles.blue14900(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${translationAPIProvider.translationModel!.languageDetails![14]}    : ",
                                            style: CommonStyles.black11(),
                                          ),
                                          AnimatedTextKit(
                                            animatedTexts: [
                                              ColorizeAnimatedText(
                                                  " ₹  ${_classicAPIProvider.classsicJobModel!.classicalJobList![index].total}",
                                                  colors: colorizeColors,
                                                  textStyle:
                                                      CommonStyles.blue14900())
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${translationAPIProvider.translationModel!.languageDetails![17]}  : ",
                                            style: CommonStyles.black11(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${_classicAPIProvider.classsicJobModel!.classicalJobList![index].dateTime}",
                                              style: CommonStyles.blue14900(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${translationAPIProvider.translationModel!.languageDetails![15]}         : ",
                                            style: CommonStyles.black11(),
                                          ),
                                          Text(
                                            "${_classicAPIProvider.classsicJobModel!.classicalJobList![index].jobTitle}",
                                            style: CommonStyles.blue14900(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${translationAPIProvider.translationModel!.languageDetails![16]} : ",
                                            style: CommonStyles.black11(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${_classicAPIProvider.classsicJobModel!.classicalJobList![index].address}",
                                              style: CommonStyles.blue14900(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: CarouselSlider.builder(
                                      carouselController: controller,
                                      itemCount: _classicAPIProvider
                                          .classsicJobModel!
                                          .classicalJobList![index]
                                          .beforeJobImage!
                                          .length,
                                      itemBuilder: (context, index, realIndex) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.blue.shade100,
                                                Colors.white,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            // shape: BoxShape.circle,
                                          ),
                                          /*  child: CachedNetworkImage(
                                        imageUrl:
                                            "${banner_list_api.banner_list!.bannerUrl}/${banner_list_api.banner_list!.bannerList![index].bannerImage}",
                                        fit: BoxFit.contain,
                                      ),*/
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${_classicAPIProvider.classsicJobModel!.beforeImageUrl}${_classicAPIProvider.classsicJobModel!.classicalJobList![index].beforeJobImage![index]}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                      options: CarouselOptions(
                                        //  height: 190,

                                        aspectRatio: 1,
                                        autoPlay: false,
                                        pageSnapping: true,
                                        autoPlayCurve: Curves.easeInOut,
                                        enableInfiniteScroll: false,
                                        //  enlargeStrategy: CenterPageEnlargeStrategy.height,
                                        //   viewportFraction: 1,
                                        enlargeCenterPage: true,
                                        //    initialPage: 0,
                                        // aspectRatio: 16/9,
                                        autoPlayInterval: Duration(seconds: 2),
                                        onPageChanged: (index, reason) =>
                                            setState(() => activeIndex = index),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          );
  }

  Container buildBanner(BannerAPIProvider _bannerAPIProvider) {
    return Container(
        child: Column(children: [
      Center(
        child: Column(children: [
          _bannerAPIProvider.ifLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                )
              : CarouselSlider.builder(
                  carouselController: controller,
                  itemCount: _bannerAPIProvider.bannerModel!.bannerList!.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.blue.shade100,
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.centerRight,
                        ),
                        // shape: BoxShape.circle,
                      ),
                      /*  child: CachedNetworkImage(
                                      imageUrl:
                                          "${banner_list_api.banner_list!.bannerUrl}/${banner_list_api.banner_list!.bannerList![index].bannerImage}",
                                      fit: BoxFit.contain,
                                    ),*/
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl:
                              "${_bannerAPIProvider.bannerModel!.bannerUrl}${_bannerAPIProvider.bannerModel!.bannerList![index].bannerImage}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 190,
                    autoPlay: true,
                    pageSnapping: true,
                    autoPlayCurve: Curves.easeInOut,
                    // enableInfiniteScroll: false,
                    //  enlargeStrategy: CenterPageEnlargeStrategy.height,
                    //   viewportFraction: 1,
                    enlargeCenterPage: true,
                    //    initialPage: 0,
                    // aspectRatio: 16/9,
                    autoPlayInterval: Duration(seconds: 2),
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index),
                  )),

          /*BannerListProviderApi.ifLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : */
          if (_bannerAPIProvider.bannerModel != null)
            AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: _bannerAPIProvider.bannerModel!.bannerList!.length,
              effect: ScrollingDotsEffect(
                dotWidth: 10,
                dotHeight: 10,
                activeDotColor: Colors.pink,
                dotColor: Colors.grey,
              ),
              onDotClicked: animateToSlide,
            ),
        ]),
      ),
    ]));
  }

  animateToSlide(int index) {}
}

class SideDrawer extends StatefulWidget {
  final String lanKey;
  SideDrawer({Key? key, required this.lanKey}) : super(key: key);
  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
      print("Language Key --------" + widget.lanKey);
    }
  }

  @override
  void initState() {
    initializeLanKey();
    if (context.read<ProfileAPIProvider>().profileModel == null) {
      context.read<ProfileAPIProvider>().getProfile();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileAPIProvider = Provider.of<ProfileAPIProvider>(context);
    final translationAPiProvider = Provider.of<TranslationAPIProvider>(context);
    final sharedPreferencesProvider =
        Provider.of<SharedPreferencesProvider>(context);
    return SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height * 1,
            child: Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    profileAPIProvider.profileModel == null
                        ? Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          )
                        : Container(
                            height: 230,
                            child: DrawerHeader(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                  child: Column(
                                children: [
                                  Center(
                                    child: InkWell(
                                      /*  onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Edit()));


                                      },*/
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        /*  child: CachedNetworkImage(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              "${profileAPIProvider.profileModel!.profileBaseurl}${profileAPIProvider.profileModel!.userDetails!.}",
                                        ),*/
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 15,
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.asset(
                                                      "assets/images/logo2.png",
                                                      height: 120,
                                                      width: 150,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 0,
                                                  ),
                                                  Text(
                                                    "${profileAPIProvider.profileModel!.userDetails!.userName}",
                                                    style: CommonStyles
                                                        .whiteText16BoldW500(),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "${profileAPIProvider.profileModel!.userDetails!.mobile}",
                                                    style: CommonStyles
                                                        .whiteText15BoldW500(),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                              decoration: BoxDecoration(color: Colors.blue[800]
                                  /* gradient: LinearGradient(colors: [
                                  Colors.blu,
                                  Colors.lightBlueAccent
                                ]),*/
                                  ),
                            ),
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Neumorphic(
                            style: NeumorphicStyle(intensity: 30),
                            child: ListTile(
                                leading: Icon(
                                  Icons.account_circle,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                title: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![25]}",
                                  style: CommonStyles.black13thinW54(),
                                ),
                                onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreen(
                                                    lanKey: widget.lanKey,
                                                  )))
                                    }),
                          ),
                          Utils.getSizedBox(height: 20),
                          Neumorphic(
                            style: NeumorphicStyle(intensity: 30),
                            child: ListTile(
                                leading: Icon(
                                  Icons.work_outlined,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                title: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![26]}",
                                  style: CommonStyles.black13thinW54(),
                                ),
                                onTap: () => {
                                      print("Profile Update Status-------" +
                                          context
                                              .read<ProfileAPIProvider>()
                                              .profileModel!
                                              .userDetails!
                                              .profileUpdateStatus
                                              .toString()),
                                      context
                                                      .read<
                                                          ProfileAPIProvider>()
                                                      .profileModel!
                                                      .userDetails!
                                                      .profileUpdateStatus ==
                                                  "0" ||
                                              context
                                                      .read<
                                                          ProfileAPIProvider>()
                                                      .profileModel!
                                                      .userDetails!
                                                      .profileUpdateStatus ==
                                                  null
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      JobConfirmationScreen()))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostJobScreen()))
                                    }),
                          ),
                          Utils.getSizedBox(height: 20),
                          Neumorphic(
                            style: NeumorphicStyle(intensity: 30),
                            child: ListTile(
                                leading: Icon(
                                  Icons.work_outlined,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                title: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![27]}",
                                  style: CommonStyles.black13thinW54(),
                                ),
                                onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyJobSelectScreen()))
                                    }),
                          ),
                          Utils.getSizedBox(height: 20),
                          Neumorphic(
                            style: NeumorphicStyle(intensity: 30),
                            child: ListTile(
                                leading: Icon(
                                  Icons.money,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                title: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![28]}",
                                  style: CommonStyles.black13thinW54(),
                                ),
                                onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactionScreen()))
                                    }),
                          ),
                          Utils.getSizedBox(height: 20),
                          Neumorphic(
                            style: NeumorphicStyle(intensity: 30),
                            child: ListTile(
                                leading: Icon(
                                  Icons.language,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                title: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![30]}",
                                  style: CommonStyles.black13thinW54(),
                                ),
                                onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeLanguageScreen()))
                                    }),
                          ),
                          Utils.getSizedBox(height: 20),
                          Neumorphic(
                            style: NeumorphicStyle(intensity: 30),
                            child: ListTile(
                                leading: Icon(
                                  Icons.account_balance_wallet_sharp,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                title: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![29]}",
                                  style: CommonStyles.black13thinW54(),
                                ),
                                onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WalletScreen())),
                                    }),
                          ),
                          /*  Utils.getSizedBox(height: 20),
                          Neumorphic(
                            style: NeumorphicStyle(intensity: 30),
                            child: ListTile(
                                leading: Icon(
                                  Icons.language,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                title: Text(
                                  "Change Language",
                                  style: CommonStyles.black13thinW54(),
                                ),
                                onTap: () => {
                                      */ /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()))*/ /*
                                    }),
                          ),*/
                          Utils.getSizedBox(height: 20),
                          Neumorphic(
                            style: NeumorphicStyle(intensity: 30),
                            child: ListTile(
                                leading: Icon(
                                  Icons.question_answer,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                title: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![31]}",
                                  style: CommonStyles.black13thinW54(),
                                ),
                                onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FAQScreen(
                                                    lanKey: widget.lanKey,
                                                  )))
                                    }),
                          ),
                          Utils.getSizedBox(height: 20),
                          Neumorphic(
                            style: const NeumorphicStyle(intensity: 30),
                            child: ListTile(
                                leading: const Icon(
                                  Icons.contact_support,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                title: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![32]}",
                                  style: CommonStyles.black13thinW54(),
                                ),
                                onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SupportScreen()))
                                    }),
                          ),
                          Utils.getSizedBox(height: 20),
                          Utils.getSizedBox(height: 20),
                          Utils.getSizedBox(height: 20),
                          Utils.getSizedBox(height: 20),
                          Utils.getSizedBox(height: 20),
                          Neumorphic(
                            style: const NeumorphicStyle(
                                intensity: 30, color: Colors.red),
                            child: ListTile(
                                leading: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                title: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![33]}",
                                  style: CommonStyles.whiteText15BoldW500(),
                                ),
                                onTap: () => {
                                      showAlertDialog(
                                          context,
                                          translationAPiProvider,
                                          sharedPreferencesProvider)
                                      /*   Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyJobs()))*/
                                    }),
                          ),
                          Utils.getSizedBox(height: 20),
                          Utils.getSizedBox(height: 20),
                          Utils.getSizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  showAlertDialog(
      BuildContext context,
      TranslationAPIProvider translationAPIProvider,
      SharedPreferencesProvider sharedPreferencesProvider) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        " "
        "",
        style: CommonStyles.black12(),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "${translationAPIProvider.translationModel!.languageDetails![33]}",
        style: CommonStyles.black12(),
      ),
      onPressed: () async {
        showLoadingWithCustomText(context, "Logging out");
        await SharedPreferences.getInstance().then((value) {
          value.setString("USER", "");
        });
        final firebaseAuthProvider =
            context.read<FirebaseAuthService>().signOut(googleSignIn: true);
        APIService.userId = "";
        Navigator.of(context).pop();
        context.read<AcceptedJobAPIProvider>().initialize();
        context.read<BannerAPIProvider>().initialize();
        context.read<ClassicJobAPIProvider>().initialize();
        context.read<LanguageAPIProvider>().initialize();
        context.read<PostCompletedAPIProvider>().initialize();
        context.read<PostViewAPIProvider>().initialize();
        context.read<PostedJobAPIProvider>().initialize();
        context.read<PrimaryJobAPIProvider>().initialize();
        context.read<ProfileAPIProvider>().initialize();
        context.read<ProfileUpdateApiProvder>().initialize();
        context.read<SigninAPIProvider>().initialize();
        context.read<TransactionListAPIProvider>().initialize();
        context.read<TranslationAPIProvider>().initialize();

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const CountryLanguageScreen()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Service Provider",
        style: CommonStyles.blue14900(),
      ),
      content: Text(
        "Do you want to Logout ?",
        style: CommonStyles.black13(),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
