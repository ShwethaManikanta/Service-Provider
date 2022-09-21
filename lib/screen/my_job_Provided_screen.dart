import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/model/accept_reject_model.dart';
import 'package:serviceprovider/screen/home_screen.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/posted_job_list_api_provider.dart';
import 'package:serviceprovider/service/profile_api_provider.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';

class MyJobProvided extends StatefulWidget {
  MyJobProvided({Key? key}) : super(key: key);

  @override
  _MyJobProvidedState createState() => _MyJobProvidedState();
}

class _MyJobProvidedState extends State<MyJobProvided>
    with SingleTickerProviderStateMixin {
  List<Color> colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  int activeIndex = 0;
  final controller = CarouselController();
  final afterImageController = CarouselController();
  late TabController _tabController;

  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final postedJobAPIProvider = Provider.of<PostedJobAPIProvider>(context);
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
    await apiService
        .payForJob(
            postedJobAPIProvider.postedJobListModel!.postJobsList!.first.id!,
            response.paymentId!,
            "1")
        .then((value) => _acceptRejectModel = value!);
    print("Order Placed ---- " +
        _acceptRejectModel.message.toString() +
        _acceptRejectModel.status.toString());

    if (_acceptRejectModel.status == "1") {
      Utils.showSnackBar(
          context: context, text: "${_acceptRejectModel.message.toString()}");
      await context.read<PostedJobAPIProvider>().getPostedJobList();
      //   Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    if (_acceptRejectModel.status == "0") {
      Navigator.of(context).pop();
      Utils.showSnackBar(
          context: context, text: "${_acceptRejectModel.message.toString()}");
    }
    // apiServices.orderClearCart();
    // apiServices
    //     .buyProduct(
    //   context,
    //   data.subTotal,
    //   data.deliveryFee,
    //   data.taxes,
    //   data.total.toString(),
    //   data.getAllAddressCustomer.address,
    //   data.retailerDetails.id,
    //   SharedPreference.latitudeValue,
    //   SharedPreference.longitudeValue,
    // )
    //     .then((value) {
    //   setState(() {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => PaymentSuccess()),
    //     );
    //   });
    // });

    // if (value['response'] != null) {
    //   payment_response = value['response']['STATUS'];
    // }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    initializeLanKey();

    if (context.read<PostedJobAPIProvider>().postedJobListModel == null) {
      context.read<PostedJobAPIProvider>().getPostedJobList();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postedJobAPIProvider = Provider.of<PostedJobAPIProvider>(context);
    final translationAPIProvider = Provider.of<TranslationAPIProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "${translationAPIProvider.translationModel!.languageDetails![61]}",
          style: CommonStyles.whiteText16BoldW500(),
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    child: Column(children: [
                  DefaultTabController(
                      length: 3,
                      initialIndex: 1,
                      child: Column(children: [
                        TabBar(
                          unselectedLabelColor: Colors.orange,
                          labelColor: Colors.red,
                          indicatorColor: Colors.indigo,
                          controller: _tabController,
                          isScrollable: true,
                          tabs: <Widget>[
                            /* Tab(
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                    intensity: 30, color: Colors.lightBlue),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Text('New Jobs',
                                      style:
                                          CommonStyles.whiteText16BoldW500()),
                                ),
                              ),
                            ),*/
                            Tab(
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                    intensity: 30, color: Colors.lightBlue),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Text('Pending Jobs',
                                      style:
                                          CommonStyles.whiteText16BoldW500()),
                                ),
                              ),
                            ),
                            Tab(
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                    intensity: 30, color: Colors.lightBlue),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Text('Completed Jobs',
                                      style:
                                          CommonStyles.whiteText16BoldW500()),
                                ),
                              ),
                            ),
                            Tab(
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                    intensity: 30, color: Colors.lightBlue),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Text('Cancelled Jobs',
                                      style:
                                          CommonStyles.whiteText16BoldW500()),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.79,
                          child:
                              TabBarView(controller: _tabController, children: [
                            //
                            /*
                            postedJobAPIProvider.ifLoading
                                ?const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  )
                                : buildRequestedJob(postedJobAPIProvider,
                                    translationAPIProvider),*/

                            // Approved New Jobs

                            postedJobAPIProvider.ifLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  )
                                : buildApprovedJobs(postedJobAPIProvider,
                                    translationAPIProvider),

                            // Completed Jobs

                            postedJobAPIProvider.ifLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  )
                                : buildCompletedJob(postedJobAPIProvider,
                                    translationAPIProvider),

                            // Cancelled Jobs

                            postedJobAPIProvider.ifLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  )
                                : buildCancelledJob(postedJobAPIProvider,
                                    translationAPIProvider),
                          ]),
                        )
                      ]))
                ])),
              ],
            ),
          )),
    );
  }

  // POST JOB LIST

  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  void openCheckout(String toPay) async {
    final profileViewProvider =
        Provider.of<ProfileAPIProvider>(context, listen: false);
    var options = {
      'key': 'rzp_live_fIVSaZU2V05Vpb',
      'amount': (int.parse(toPay) * 100).toString(),
      'name': 'Shiva Kayakave Kailasa',
      'description': 'Service Provider',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': profileViewProvider.profileModel!.userDetails!.mobile,
        'email': profileViewProvider.profileModel!.userDetails!.email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  // Post Job Requested
/*
  Widget buildRequestedJob(PostedJobAPIProvider postedJobAPIProvider,
      TranslationAPIProvider translationAPIProvider) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<PostedJobAPIProvider>().getPostedJobList();
      },
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 40),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount:
              postedJobAPIProvider.postedJobListModel!.postJobsList!.length,
          itemBuilder: (context, index) {
            return postedJobAPIProvider
                        .postedJobListModel!.postJobsList![index].tripStatus ==
                    "Requested"
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 10),
                    child: Neumorphic(
                      padding: EdgeInsets.zero,
                      style: NeumorphicStyle(
                          lightSource: LightSource.top, intensity: 30),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        //  height: 140,
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Posted ID  :   ",
                                  style: CommonStyles.black13thin(),
                                ),
                                Text(
                                  postedJobAPIProvider.postedJobListModel!
                                      .postJobsList![index].id!,
                                  style: CommonStyles.blue14900(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![14]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Expanded(child: Text(":")),
                                Expanded(
                                  flex: 6,
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      ColorizeAnimatedText(
                                          " ₹  ${postedJobAPIProvider.postedJobListModel!.postJobsList![index].total}",
                                          colors: colorizeColors,
                                          textStyle: CommonStyles.blue14900())
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![15]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Expanded(child: Text(":")),
                                Expanded(
                                  flex: 6,
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      ColorizeAnimatedText(
                                          postedJobAPIProvider
                                              .postedJobListModel!
                                              .postJobsList![index]
                                              .jobTitle!,
                                          colors: colorizeColors,
                                          textStyle: CommonStyles.blue14900())
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![34]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Expanded(child: Text(":")),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].dateTime!,
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
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![15]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Expanded(child: Text(":")),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                                .postJobsList![index].jobType ==
                                            "2"
                                        ? "${translationAPIProvider.translationModel!.languageDetails![11]}"
                                        : "Premium Jobs",
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
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![16]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Expanded(child: Text(":")),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].address!,
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
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Job Status",
                                    style: CommonStyles.green12(),
                                  ),
                                ),
                                Expanded(child: Text(":")),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].tripStatus!,
                                    style: CommonStyles.greeen15900(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CarouselSlider.builder(
                                carouselController: controller,
                                itemCount: postedJobAPIProvider
                                    .postedJobListModel!
                                    .postJobsList![index]
                                    .beforeJobImage!
                                    .length,
                                itemBuilder:
                                    (context, currentIndex, realIndex) {
                                  print(
                                      "URL ------${postedJobAPIProvider.postedJobListModel!.beforeImageUrl}${postedJobAPIProvider.postedJobListModel!.postJobsList![index].beforeJobImage}");
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 200,
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
                                      // shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              "${postedJobAPIProvider.postedJobListModel!.beforeImageUrl}${postedJobAPIProvider.postedJobListModel!.postJobsList![index].beforeJobImage![currentIndex]}",
                                        )),
                                  );
                                },
                                options: CarouselOptions(
                                  height: 200,
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
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      "",
                      style: CommonStyles.black13(),
                    ),
                  );
          }),
    );
  }*/

  // Approved JOB TAB

  Widget buildApprovedJobs(PostedJobAPIProvider postedJobAPIProvider,
      TranslationAPIProvider translationAPIProvider) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<PostedJobAPIProvider>().getPostedJobList();
      },
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 40),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount:
              postedJobAPIProvider.postedJobListModel!.postJobsList!.length,
          itemBuilder: (context, index) {
            return postedJobAPIProvider
                        .postedJobListModel!.postJobsList![index].tripStatus ==
                    "Approved"
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 10),
                    child: Neumorphic(
                      padding: EdgeInsets.zero,
                      style: NeumorphicStyle(
                          lightSource: LightSource.top, intensity: 30),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        //  height: 140,
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Posted ID  :   ",
                                  style: CommonStyles.black13thin(),
                                ),
                                Text(
                                  postedJobAPIProvider.postedJobListModel!
                                      .postJobsList![index].id!,
                                  style: CommonStyles.blue14900(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![14]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      ColorizeAnimatedText(
                                          " ₹  ${postedJobAPIProvider.postedJobListModel!.postJobsList![index].total}",
                                          colors: colorizeColors,
                                          textStyle: CommonStyles.blue14900())
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![15]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      ColorizeAnimatedText(
                                          postedJobAPIProvider
                                              .postedJobListModel!
                                              .postJobsList![index]
                                              .jobTitle!,
                                          colors: colorizeColors,
                                          textStyle: CommonStyles.blue14900())
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![34]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].dateTime!,
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
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![15]}         : ",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                                .postJobsList![index].jobType ==
                                            "2"
                                        ? "${translationAPIProvider.translationModel!.languageDetails![11]}"
                                        : "${translationAPIProvider.translationModel!.languageDetails![12]}",
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
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![16]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].address!,
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
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Job Status",
                                    style: CommonStyles.green12(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].tripStatus!,
                                    style: CommonStyles.greeen15900(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Job OTP",
                                    style: CommonStyles.green12(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].postOtp!,
                                    style: CommonStyles.greeen15900(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CarouselSlider.builder(
                                carouselController: controller,
                                itemCount: postedJobAPIProvider
                                    .postedJobListModel!
                                    .postJobsList![index]
                                    .beforeJobImage!
                                    .length,
                                itemBuilder:
                                    (context, currentIndex, realIndex) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue,

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
                                              "${postedJobAPIProvider.postedJobListModel!.beforeImageUrl}${postedJobAPIProvider.postedJobListModel!.postJobsList![index].beforeJobImage![currentIndex]}",
                                          width: 300,
                                          height: 100,
                                        )),
                                  );
                                },
                                options: CarouselOptions(
                                  aspectRatio: 1 / 2,
                                  height: 150,
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
                            /* Center(
                            child: AnimatedSmoothIndicator(
                              activeIndex: activeIndex,
                              count: 5,
                              effect: ScrollingDotsEffect(
                                dotWidth: 10,
                                dotHeight: 10,
                                activeDotColor: Colors.black,
                                dotColor: Colors.grey,
                              ),
                              onDotClicked: animateToSlide,
                            ),
                          ),*/

                            if (postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].tripStatus !=
                                    "Completed" ||
                                postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].tripStatus !=
                                    "Cancelled")
                              Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: NeumorphicButton(
                                          style: NeumorphicStyle(
                                              color: Colors.red),
                                          onPressed: () async {
                                            showAlertDialog(
                                                context,
                                                postedJobAPIProvider,
                                                index,
                                                translationAPIProvider);
                                          },
                                          child: Text("Cancel Job Post",
                                              textAlign: TextAlign.center,
                                              style: CommonStyles
                                                  .whiteText16BoldW500()),
                                        ),
                                      ),
                                      /*  SizedBox(
                                  height: 40,
                                  width: 150,
                                  child: NeumorphicButton(
                                    style: NeumorphicStyle(
                                        color: Colors.green),
                                    onPressed: () async {
                                      openCheckout(postedJobAPIProvider
                                          .postedJobListModel!
                                          .postJobsList![index]
                                          .total!);
                                    },
                                    child: Text(
                                        "${translationAPIProvider.translationModel!.languageDetails![34]}",
                                        textAlign: TextAlign.center,
                                        style: CommonStyles
                                            .whiteText16BoldW500()),
                                  ),
                                )*/
                                    ],
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      "",
                      style: CommonStyles.black13(),
                    ),
                  );
          }),
    );
  }

  // post JOB COMPLETED

  Widget buildCompletedJob(PostedJobAPIProvider postedJobAPIProvider,
      TranslationAPIProvider translationAPIProvider) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<PostedJobAPIProvider>().getPostedJobList();
      },
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 40),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount:
              postedJobAPIProvider.postedJobListModel!.postJobsList!.length,
          itemBuilder: (context, index) {
            return postedJobAPIProvider
                        .postedJobListModel!.postJobsList![index].tripStatus ==
                    "Completed"
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 10),
                    child: Neumorphic(
                      padding: EdgeInsets.zero,
                      style: NeumorphicStyle(
                          lightSource: LightSource.top, intensity: 30),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        //  height: 140,
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Posted ID  :   ",
                                  style: CommonStyles.black13thin(),
                                ),
                                Text(
                                  postedJobAPIProvider.postedJobListModel!
                                      .postJobsList![index].id!,
                                  style: CommonStyles.blue14900(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![14]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      ColorizeAnimatedText(
                                          " ₹  ${postedJobAPIProvider.postedJobListModel!.postJobsList![index].total}",
                                          colors: colorizeColors,
                                          textStyle: CommonStyles.blue14900())
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Job Name",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      ColorizeAnimatedText(
                                          postedJobAPIProvider
                                              .postedJobListModel!
                                              .postJobsList![index]
                                              .jobTitle!,
                                          colors: colorizeColors,
                                          textStyle: CommonStyles.blue14900())
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Date & Time",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].dateTime!,
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
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![15]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                                .postJobsList![index].jobType ==
                                            "2"
                                        ? "${translationAPIProvider.translationModel!.languageDetails![11]}"
                                        : "${translationAPIProvider.translationModel!.languageDetails![12]}",
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
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![16]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].address!,
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
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Job Status",
                                    style: CommonStyles.green12(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].tripStatus!,
                                    style: CommonStyles.greeen15900(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                "Before Image",
                                style: CommonStyles.blue13(),
                              ),
                            ),
                            CarouselSlider.builder(
                                carouselController: controller,
                                itemCount: postedJobAPIProvider
                                    .postedJobListModel!
                                    .postJobsList![index]
                                    .beforeJobImage!
                                    .length,
                                itemBuilder:
                                    (context, currenytIndex, realIndex) {
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
                                      // shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${postedJobAPIProvider.postedJobListModel!.beforeImageUrl}${postedJobAPIProvider.postedJobListModel!.postJobsList![index].beforeJobImage![currenytIndex]}",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  height: 150,
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

                            // After Image Post

                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                "After Image",
                                style: CommonStyles.blue13(),
                              ),
                            ),
                            CarouselSlider.builder(
                                carouselController: afterImageController,
                                itemCount: postedJobAPIProvider
                                    .postedJobListModel!
                                    .postJobsList![index]
                                    .afterJobImage!
                                    .length,
                                itemBuilder: (context, afterIndex, realIndex) {
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
                                      // shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${postedJobAPIProvider.postedJobListModel!.afterImageUrl}${postedJobAPIProvider.postedJobListModel!.postJobsList![index].afterJobImage![afterIndex]}",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  height: 150,
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

                            /* Center(
                              child: AnimatedSmoothIndicator(
                                activeIndex: activeIndex,
                                count: 5,
                                effect: ScrollingDotsEffect(
                                  dotWidth: 10,
                                  dotHeight: 10,
                                  activeDotColor: Colors.black,
                                  dotColor: Colors.grey,
                                ),
                                onDotClicked: animateToSlide,
                              ),
                            ),*/
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    /*   SizedBox(
                                        height: 40,
                                        width: 150,
                                        child: NeumorphicButton(
                                          style:
                                              NeumorphicStyle(color: Colors.red),
                                          onPressed: () async {
                                            showAlertDialog(
                                                context,
                                                postedJobAPIProvider,
                                                index,
                                                translationAPIProvider);
                                          },
                                          child: Text("Payment",
                                              textAlign: TextAlign.center,
                                              style: CommonStyles
                                                  .whiteText16BoldW500()),
                                        ),
                                      ),*/
                                    SizedBox(
                                      height: 40,
                                      //  width: 150,
                                      child: NeumorphicButton(
                                        style: NeumorphicStyle(
                                            color: Colors.green),
                                        onPressed: () async {
                                          openCheckout(postedJobAPIProvider
                                              .postedJobListModel!
                                              .postJobsList![index]
                                              .total!);
                                        },
                                        child: Text("Payment",
                                            textAlign: TextAlign.center,
                                            style: CommonStyles
                                                .whiteText16BoldW500()),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      "",
                      style: CommonStyles.black13(),
                    ),
                  );
          }),
    );
  }

  // Post job Cancelled

  Widget buildCancelledJob(PostedJobAPIProvider postedJobAPIProvider,
      TranslationAPIProvider translationAPIProvider) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<PostedJobAPIProvider>().getPostedJobList();
      },
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 40),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount:
              postedJobAPIProvider.postedJobListModel!.postJobsList!.length,
          itemBuilder: (context, index) {
            return postedJobAPIProvider
                        .postedJobListModel!.postJobsList![index].tripStatus ==
                    "Cancelled"
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 10),
                    child: Neumorphic(
                      padding: EdgeInsets.zero,
                      style: NeumorphicStyle(
                          lightSource: LightSource.top, intensity: 30),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        //  height: 140,
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Posted ID  :   ",
                                  style: CommonStyles.black13thin(),
                                ),
                                Text(
                                  postedJobAPIProvider.postedJobListModel!
                                      .postJobsList![index].id!,
                                  style: CommonStyles.blue14900(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![14]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      ColorizeAnimatedText(
                                          " ₹  ${postedJobAPIProvider.postedJobListModel!.postJobsList![index].total}",
                                          colors: colorizeColors,
                                          textStyle: CommonStyles.blue14900())
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![15]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      ColorizeAnimatedText(
                                          postedJobAPIProvider
                                              .postedJobListModel!
                                              .postJobsList![index]
                                              .jobTitle!,
                                          colors: colorizeColors,
                                          textStyle: CommonStyles.blue14900())
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![34]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].dateTime!,
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
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![15]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                                .postJobsList![index].jobType ==
                                            "2"
                                        ? "${translationAPIProvider.translationModel!.languageDetails![11]}"
                                        : "${translationAPIProvider.translationModel!.languageDetails![12]}",
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
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${translationAPIProvider.translationModel!.languageDetails![16]}",
                                    style: CommonStyles.black11(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].address!,
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
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Job Status    : ",
                                    style: CommonStyles.green12(),
                                  ),
                                ),
                                Text("   :   "),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    postedJobAPIProvider.postedJobListModel!
                                        .postJobsList![index].tripStatus!,
                                    style: CommonStyles.red12(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CarouselSlider.builder(
                                carouselController: controller,
                                itemCount: postedJobAPIProvider
                                    .postedJobListModel!
                                    .postJobsList![index]
                                    .beforeJobImage!
                                    .length,
                                itemBuilder:
                                    (context, currentIndex, realIndex) {
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
                                      // shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${postedJobAPIProvider.postedJobListModel!.beforeImageUrl}${postedJobAPIProvider.postedJobListModel!.postJobsList![index].beforeJobImage![currentIndex]}",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  height: 150,
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
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      "",
                      style: CommonStyles.black13(),
                    ),
                  );
          }),
    );
  }

  animateToSlide(int index) {}

  AcceptRejectModel _acceptRejectModel = AcceptRejectModel();

  showAlertDialog(BuildContext context, postedJobAPIProvider, index,
      TranslationAPIProvider translationAPIProvider) {
    // set up the button
    Widget noButton = TextButton(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.green,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Text(
            "No",
            style: CommonStyles.whiteText12BoldW500(),
          ),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget okButton = TextButton(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Text(
            "Cancel",
            style: CommonStyles.whiteText12BoldW500(),
          ),
        ),
      ),
      onPressed: () async {
        await apiService
            .getApplyJob(
                postedJobAPIProvider
                    .postedJobListModel!.postJobsList![index].id!,
                "4")
            .then((value) => _acceptRejectModel = value!);
        print("Order Placed ---- " +
            _acceptRejectModel.message.toString() +
            _acceptRejectModel.status.toString());

        if (_acceptRejectModel.status == "1") {
          Utils.showSnackBar(
              context: context,
              text: "${_acceptRejectModel.message.toString()}");

          await context.read<PostedJobAPIProvider>().getPostedJobList();
          Navigator.of(context).pop();
        }
        if (_acceptRejectModel.status == "0") {
          Navigator.of(context).pop();
          Utils.showSnackBar(
              context: context,
              text: "${_acceptRejectModel.message.toString()}");
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Post Cancellation !!\n ",
        style: CommonStyles.greeen15900(),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "Do you want to cancel your Post !",
        style: CommonStyles.red12(),
        textAlign: TextAlign.center,
      ),
      actions: [noButton, okButton],
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
