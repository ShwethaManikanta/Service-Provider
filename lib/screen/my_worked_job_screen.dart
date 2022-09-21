import 'dart:io';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/common/image_box.dart';
import 'package:serviceprovider/common/image_picker_service.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/model/accept_reject_model.dart';
import 'package:serviceprovider/model/image_upload_model.dart';
import 'package:serviceprovider/screen/home_screen.dart';
import 'package:serviceprovider/service/accepted_job_api_provider.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/post_completed_api_provider.dart';
import 'package:serviceprovider/service/posted_job_list_api_provider.dart';
import 'package:serviceprovider/service/profile_api_provider.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';

class MyWorkedJobScreen extends StatefulWidget {
  const MyWorkedJobScreen({Key? key}) : super(key: key);

  @override
  _MyWorkedJobScreenState createState() => _MyWorkedJobScreenState();
}

class _MyWorkedJobScreenState extends State<MyWorkedJobScreen>
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
        .getApplyJob(
            postedJobAPIProvider.postedJobListModel!.postJobsList!.first.id!,
            "3")
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
    initializeLanKey();
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    if (context.read<AcceptedJobAPIProvider>().postCompletedModel == null) {
      context.read<AcceptedJobAPIProvider>().getAcceptedJobList();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translationAPIProvider = Provider.of<TranslationAPIProvider>(context);
    final acceptedAPIJobAPIProvider =
        Provider.of<AcceptedJobAPIProvider>(context);
    final imagePickerService =
        Provider.of<ImagePickerService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "${translationAPIProvider.translationModel!.languageDetails![80]}",
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
                                  child: Text('Ongoing Jobs',
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
                            /*acceptedAPIJobAPIProvider.ifLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  )
                                : buildWorkedJobRequest(
                                    acceptedAPIJobAPIProvider,
                                    translationAPIProvider),*/
                            buildWorkedOngoingJobs(acceptedAPIJobAPIProvider,
                                translationAPIProvider, imagePickerService),
                            buildCompletedJob(acceptedAPIJobAPIProvider,
                                translationAPIProvider),
                            buildCancelledJobs(acceptedAPIJobAPIProvider,
                                translationAPIProvider)
                          ]),
                        )
                      ]))
                ])),
              ],
            ),
          )),
    );
  }

  // Assign Job Requested

  ListView buildWorkedJobRequest(AcceptedJobAPIProvider postedJobAPIProvider,
      TranslationAPIProvider translationAPIProvider) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 40),
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount:
            postedJobAPIProvider.postCompletedModel!.acceptedJobsList!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
            child: postedJobAPIProvider.postCompletedModel!
                        .acceptedJobsList![index].tripStatus ==
                    "Requested"
                ? Neumorphic(
                    padding: EdgeInsets.zero,
                    style: NeumorphicStyle(
                        lightSource: LightSource.top, intensity: 30),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                                postedJobAPIProvider.postCompletedModel!
                                    .acceptedJobsList![index].id!,
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
                                flex: 1,
                                child: Text(
                                  "${translationAPIProvider.translationModel!.languageDetails![14]}    : ",
                                  style: CommonStyles.black11(),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                        " ₹  ${postedJobAPIProvider.postCompletedModel!.acceptedJobsList![index].total}",
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
                                flex: 1,
                                child: Text(
                                  "${translationAPIProvider.translationModel!.languageDetails![15]}        : ",
                                  style: CommonStyles.black11(),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                        postedJobAPIProvider.postCompletedModel!
                                            .acceptedJobsList![index].jobTitle!,
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
                                flex: 1,
                                child: Text(
                                  "${translationAPIProvider.translationModel!.languageDetails![57]}     :",
                                  style: CommonStyles.black11(),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  postedJobAPIProvider.postCompletedModel!
                                      .acceptedJobsList![index].dateTime!,
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
                                flex: 1,
                                child: Text(
                                  "${translationAPIProvider.translationModel!.languageDetails![15]}         : ",
                                  style: CommonStyles.black11(),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  postedJobAPIProvider
                                              .postCompletedModel!
                                              .acceptedJobsList![index]
                                              .jobType ==
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
                                flex: 1,
                                child: Text(
                                  "${translationAPIProvider.translationModel!.languageDetails![16]} : ",
                                  style: CommonStyles.black11(),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  postedJobAPIProvider.postCompletedModel!
                                      .acceptedJobsList![index].address!,
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
                                flex: 1,
                                child: Text(
                                  "Job Status    : ",
                                  style: CommonStyles.green12(),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  postedJobAPIProvider.postCompletedModel!
                                      .acceptedJobsList![index].tripStatus!,
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
                                  .postCompletedModel!
                                  .acceptedJobsList![index]
                                  .beforeJobImage!
                                  .length,
                              itemBuilder: (context, currentIndex, realIndex) {
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
                                          "${postedJobAPIProvider.postCompletedModel!.beforeImageUrl}/${postedJobAPIProvider.postCompletedModel!.acceptedJobsList![index].beforeJobImage![currentIndex]}",
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
                          if (postedJobAPIProvider.postCompletedModel!
                                      .acceptedJobsList![index].tripStatus !=
                                  "Completed" ||
                              postedJobAPIProvider.postCompletedModel!
                                      .acceptedJobsList![index].tripStatus !=
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
                                        child: Text(
                                            "${translationAPIProvider.translationModel!.languageDetails![63]}",
                                            textAlign: TextAlign.center,
                                            style: CommonStyles
                                                .whiteText16BoldW500()),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 150,
                                      child: NeumorphicButton(
                                        style: NeumorphicStyle(
                                            color: Colors.green),
                                        onPressed: () async {
                                          /* openCheckout(postedJobAPIProvider
                                        .postedJobListModel!
                                        .postJobsList![index]
                                        .total!);*/
                                        },
                                        child: Text(
                                            "${translationAPIProvider.translationModel!.languageDetails![64]}",
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
                  )
                : SizedBox(),
          );
        });
  }

  // Assign job Ongoing

  Widget buildWorkedOngoingJobs(
      AcceptedJobAPIProvider postedJobAPIProvider,
      TranslationAPIProvider translationAPIProvider,
      ImagePickerService imagePickerService) {
    return postedJobAPIProvider.postCompletedModel == null
        ? Column(
            children: [
              Text(
                "No Jobs Found !!",
                style: CommonStyles.black13(),
              )
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 40),
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: postedJobAPIProvider
                .postCompletedModel!.acceptedJobsList!.length,
            itemBuilder: (context, index) {
              return postedJobAPIProvider.postCompletedModel!
                          .acceptedJobsList![index].tripStatus ==
                      "Ongoing"
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 10),
                      child: NeumorphicButton(
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
                                    postedJobAPIProvider.postCompletedModel!
                                        .acceptedJobsList![index].id!,
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
                                            " ₹  ${postedJobAPIProvider.postCompletedModel!.acceptedJobsList![index].total}",
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
                                                .postCompletedModel!
                                                .acceptedJobsList![index]
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
                                      "${translationAPIProvider.translationModel!.languageDetails![30]}",
                                      style: CommonStyles.black11(),
                                    ),
                                  ),
                                  Expanded(child: Text(":")),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      postedJobAPIProvider.postCompletedModel!
                                          .acceptedJobsList![index].dateTime!,
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
                                      postedJobAPIProvider
                                                  .postCompletedModel!
                                                  .acceptedJobsList![index]
                                                  .jobType ==
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
                                      "${translationAPIProvider.translationModel!.languageDetails![18]}",
                                      style: CommonStyles.black11(),
                                    ),
                                  ),
                                  Expanded(child: Text(":")),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      postedJobAPIProvider.postCompletedModel!
                                          .acceptedJobsList![index].address!,
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
                                      postedJobAPIProvider.postCompletedModel!
                                          .acceptedJobsList![index].tripStatus!,
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
                                      .postCompletedModel!
                                      .acceptedJobsList![index]
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
                                              "${postedJobAPIProvider.postCompletedModel!.beforeImageUrl}/${postedJobAPIProvider.postCompletedModel!.acceptedJobsList![index].beforeJobImage![currentIndex]}",
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
                                        width: 150,
                                        child: NeumorphicButton(
                                          style: NeumorphicStyle(
                                              color: Colors.red),
                                          onPressed: () async {
                                            await showAlertDialog(
                                                context,
                                                postedJobAPIProvider,
                                                index,
                                                translationAPIProvider);
                                          },
                                          child: Text("Cancel",
                                              textAlign: TextAlign.center,
                                              style: CommonStyles
                                                  .whiteText16BoldW500()),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: 150,
                                        child: NeumorphicButton(
                                          style: NeumorphicStyle(
                                              color: Colors.green),
                                          onPressed: () async {
                                            buildShowModalBottomSheet(
                                                context,
                                                postedJobAPIProvider,
                                                translationAPIProvider,
                                                imagePickerService,
                                                index);
                                          },
                                          child: Text("Complete",
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
                      ))
                  : SizedBox();
            });
  }

  Future<dynamic> buildShowModalBottomSheet(
      BuildContext context,
      AcceptedJobAPIProvider postedJobAPIProvider,
      TranslationAPIProvider translationAPIProvider,
      ImagePickerService imagePickerService,
      int index) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            height: 350,
            child: Column(
              children: [
                Text(
                  "Completed Job Confirmation",
                  style: CommonStyles.blue14900(),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Card(
                    elevation: 20,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Neumorphic(
                      padding: EdgeInsets.all(20),
                      style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(10)),
                        depth: NeumorphicTheme.embossDepth(context),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ProductImageBox(
                                title: "Add After Image",
                                circleRadius: 10,
                                imageFile: afterImage,
                                radius: 0,
                                onPressed: () async {
                                  afterImage = await imagePickerService
                                      .chooseImageFile(context);
                                })),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                NeumorphicButton(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                  onPressed: () async {
                    final imageAfterImageResponse =
                        await apiService.uploadImages(ImageUploadModel(
                            fileName: afterImage, fileType: "after_job_image"));

                    if (imageAfterImageResponse.status == "1") {
                      print("After Image ----" +
                          imageAfterImageResponse.fileUrl!);
                      buildOTPWorkedJobCompleted(
                          context, postedJobAPIProvider, index);
                    } else {
                      await Utils.showSnackBar(
                          context: context,
                          text: "After Job Image Cant Upload !!");
                    }
                  },
                  style: NeumorphicStyle(),
                  child: Text(
                    "Next",
                    style: CommonStyles.greeen15900(),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<dynamic> buildOTPWorkedJobCompleted(BuildContext context,
      AcceptedJobAPIProvider postedJobAPIProvider, int index) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            height: 350,
            child: Column(
              children: [
                Text(
                  "Enter a OTP from Job Post Member",
                  style: CommonStyles.blue14900(),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: OTPTextField(
                    length: 4,
                    width: MediaQuery.of(context).size.width,
                    //textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 60,

                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 15,
                    style: TextStyle(fontSize: 16),
                    onChanged: (pin) {
                      print("Changed: " + pin);
                    },
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                      getOTP = pin;
                      //  print("Get OTP ----SCREEN ---- ${getOTP}");
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                NeumorphicButton(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                  onPressed: () async {
                    await apiService
                        .getOTPCompletedJob(
                            postedJobAPIProvider.postCompletedModel!
                                .acceptedJobsList![index].id!,
                            getOTP!)
                        .then((value) => _acceptRejectModel = value!);

                    if (_acceptRejectModel.status == "1") {
                      await apiService
                          .getApplyJob(
                              postedJobAPIProvider.postCompletedModel!
                                  .acceptedJobsList![index].id!,
                              "3")
                          .then((value) => _acceptRejectModel = value!);
                      Utils.showSnackBar(
                          context: context,
                          text: "${_acceptRejectModel.message.toString()}");
                      await context
                          .read<AcceptedJobAPIProvider>()
                          .getAcceptedJobList();
                      await context
                          .read<PostedJobAPIProvider>()
                          .getPostedJobList();
                      Navigator.of(context).pop();
                    }
                    if (_acceptRejectModel.status == "0") {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      Utils.showSnackBar(
                          context: context,
                          text: "${_acceptRejectModel.message.toString()}");
                    }

                    /*  await apiService
                        .getApplyJob(
                            postedJobAPIProvider.postCompletedModel!
                                .acceptedJobsList![index].id!,
                            "3")
                        .then((value) => _acceptRejectModel = value!);
                    print("Order Placed ---- " +
                        _acceptRejectModel.message.toString() +
                        _acceptRejectModel.status.toString());

                    if (_acceptRejectModel.status == "1") {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Utils.showSnackBar(
                          context: context,
                          text: "${_acceptRejectModel.message.toString()}");
                      await context
                          .read<AcceptedJobAPIProvider>()
                          .getAcceptedJobList();
                      await context
                          .read<PostedJobAPIProvider>()
                          .getPostedJobList();
                      Navigator.of(context).pop();
                    }
                    if (_acceptRejectModel.status == "0") {
                      Navigator.of(context).pop();
                      Utils.showSnackBar(
                          context: context,
                          text: "${_acceptRejectModel.message.toString()}");
                    }
                    ;*/
                  },
                  style: NeumorphicStyle(),
                  child: Text(
                    "Completed",
                    style: CommonStyles.greeen15900(),
                  ),
                )
              ],
            ),
          );
        });
  }

  // Assign Job Completed

  Widget buildCompletedJob(AcceptedJobAPIProvider postedJobAPIProvider,
      TranslationAPIProvider translationAPIProvider) {
    return postedJobAPIProvider.postCompletedModel == null
        ? Column(
            children: [
              Text(
                "No Jobs Found !!",
                style: CommonStyles.black13(),
              )
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 40),
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: postedJobAPIProvider
                .postCompletedModel!.acceptedJobsList!.length,
            itemBuilder: (context, index) {
              return postedJobAPIProvider.postCompletedModel!
                          .acceptedJobsList![index].tripStatus ==
                      "Completed"
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 10),
                      child: NeumorphicButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
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
                                    postedJobAPIProvider.postCompletedModel!
                                        .acceptedJobsList![index].id!,
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
                                            " ₹  ${postedJobAPIProvider.postCompletedModel!.acceptedJobsList![index].total}",
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
                                                .postCompletedModel!
                                                .acceptedJobsList![index]
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
                                      "Date & Time",
                                      style: CommonStyles.black11(),
                                    ),
                                  ),
                                  Expanded(child: Text(":")),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      postedJobAPIProvider.postCompletedModel!
                                          .acceptedJobsList![index].dateTime!,
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
                                      postedJobAPIProvider
                                                  .postCompletedModel!
                                                  .acceptedJobsList![index]
                                                  .jobType ==
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
                                      "${translationAPIProvider.translationModel!.languageDetails![18]}",
                                      style: CommonStyles.black11(),
                                    ),
                                  ),
                                  Expanded(child: Text(":")),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      postedJobAPIProvider.postCompletedModel!
                                          .acceptedJobsList![index].address!,
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
                                      postedJobAPIProvider.postCompletedModel!
                                          .acceptedJobsList![index].tripStatus!,
                                      style: CommonStyles.greeen15900(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Before Image",
                                style: CommonStyles.black13(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CarouselSlider.builder(
                                  carouselController: controller,
                                  itemCount: postedJobAPIProvider
                                      .postCompletedModel!
                                      .acceptedJobsList![index]
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
                                              "${postedJobAPIProvider.postCompletedModel!.beforeImageUrl}${postedJobAPIProvider.postCompletedModel!.acceptedJobsList![index].beforeJobImage![currentIndex]}",
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

                              // AFTER IMAGE

                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "After Image",
                                style: CommonStyles.black13(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CarouselSlider.builder(
                                  carouselController: afterImageController,
                                  itemCount: postedJobAPIProvider
                                      .postCompletedModel!
                                      .acceptedJobsList![index]
                                      .afterJobImage!
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
                                              "${postedJobAPIProvider.postCompletedModel!.afterImageUrl}${postedJobAPIProvider.postCompletedModel!.acceptedJobsList![index].afterJobImage![currentIndex]}",
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
                              /*SizedBox(
                        height: 20,
                      ),*/
                              /*   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: NeumorphicButton(
                              style: NeumorphicStyle(color: Colors.red),
                              onPressed: () {},
                              child: Text("Cancel",
                                  textAlign: TextAlign.center,
                                  style:
                                      CommonStyles.whiteText16BoldW500()),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: NeumorphicButton(
                              style: NeumorphicStyle(color: Colors.green),
                              onPressed: () {},
                              child: Text("Completed",
                                  textAlign: TextAlign.center,
                                  style:
                                      CommonStyles.whiteText16BoldW500()),
                            ),
                          )
                        ],
                      ),*/
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox();
            });
  }

  // Assign Job Cancelled

  Widget buildCancelledJobs(AcceptedJobAPIProvider postedJobAPIProvider,
      TranslationAPIProvider translationAPIProvider) {
    return postedJobAPIProvider.postCompletedModel == null
        ? Column(
            children: [
              Text(
                "No Jobs Found !!",
                style: CommonStyles.black13(),
              )
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 40),
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: postedJobAPIProvider
                .postCompletedModel!.acceptedJobsList!.length,
            itemBuilder: (context, index) {
              return postedJobAPIProvider.postCompletedModel!
                          .acceptedJobsList![index].tripStatus ==
                      "Cancelled"
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 10),
                      child: NeumorphicButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
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
                                    postedJobAPIProvider.postCompletedModel!
                                        .acceptedJobsList![index].id!,
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
                                            " ₹  ${postedJobAPIProvider.postCompletedModel!.acceptedJobsList![index].total}",
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
                                                .postCompletedModel!
                                                .acceptedJobsList![index]
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
                                      postedJobAPIProvider.postCompletedModel!
                                          .acceptedJobsList![index].dateTime!,
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
                                      postedJobAPIProvider
                                                  .postCompletedModel!
                                                  .acceptedJobsList![index]
                                                  .jobType ==
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
                                      "${translationAPIProvider.translationModel!.languageDetails![18]}",
                                      style: CommonStyles.black11(),
                                    ),
                                  ),
                                  Expanded(child: Text(":")),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      postedJobAPIProvider.postCompletedModel!
                                          .acceptedJobsList![index].address!,
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
                                      postedJobAPIProvider.postCompletedModel!
                                          .acceptedJobsList![index].tripStatus!,
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
                                      .postCompletedModel!
                                      .acceptedJobsList![index]
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
                                              "${postedJobAPIProvider.postCompletedModel!.beforeImageUrl}${postedJobAPIProvider.postCompletedModel!.acceptedJobsList![index].beforeJobImage![currentIndex]}",
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
                  : SizedBox();
            });
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
            "${translationAPIProvider.translationModel!.languageDetails![61]}",
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
            "${translationAPIProvider.translationModel!.languageDetails![62]}",
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
        "${translationAPIProvider.translationModel!.languageDetails![59]} !!\n ",
        style: CommonStyles.greeen15900(),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "${translationAPIProvider.translationModel!.languageDetails![60]}",
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

  File afterImage = File('');

  // Payment
  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  void openCheckout(String toPay) async {
    final profileViewProvider =
        Provider.of<ProfileAPIProvider>(context, listen: false);
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
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
      print("eeeeee" + e.toString());
    }
  }

  String? getOTP;
}
