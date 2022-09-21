import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/model/accept_reject_model.dart';
import 'package:serviceprovider/model/content_translation_model.dart';
import 'package:serviceprovider/screen/job_confirmation_screen.dart';
import 'package:serviceprovider/screen/my_worked_job_screen.dart';
import 'package:serviceprovider/service/accepted_job_api_provider.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/post_view_API_Provider.dart';
import 'package:serviceprovider/service/posted_job_list_api_provider.dart';
import 'package:serviceprovider/service/primary_job_api_provider.dart';
import 'package:serviceprovider/service/profile_api_provider.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class JobViewScreen extends StatefulWidget {
  final String orderID;
  final String jobTitle;
  final String lanKey;

  const JobViewScreen(
      {Key? key,
      required this.orderID,
      required this.jobTitle,
      required this.lanKey})
      : super(key: key);

  @override
  State<JobViewScreen> createState() => _JobViewScreenState();
}

class _JobViewScreenState extends State<JobViewScreen> {
  List<Color> colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
      print("Language Key --------" + widget.lanKey);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeLanKey();
    if (context.read<PostViewAPIProvider>().postViewModel == null) {
      context.read<PostViewAPIProvider>().getPostView(widget.orderID);
    }

    super.initState();
  }

  animateToSlide(int index) {}
  int activeIndex = 0;
  final controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final postViewAPIProvider = Provider.of<PostViewAPIProvider>(context);
    final translationAPiProvider = Provider.of<TranslationAPIProvider>(context);

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          flexibleSpace: Container(),
          title: Text(
            widget.jobTitle,
            style: CommonStyles.whiteText16BoldW500(),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Column(children: [
            Center(
              child: Column(children: [
                postViewAPIProvider.ifLoading ||
                        postViewAPIProvider.postViewModel == null
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      )
                    : CarouselSlider.builder(
                        carouselController: controller,
                        itemCount: postViewAPIProvider.postViewModel!
                            .orderDetails!.beforeJobImage!.length,
                        itemBuilder: (context, currentIndex, realIndex) {
                          print("Post View Length ----------" +
                              postViewAPIProvider.postViewModel!.orderDetails!
                                  .beforeJobImage!.length
                                  .toString());
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 20),
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
                                    "${postViewAPIProvider.postViewModel!.beforeImageUrl}"
                                    "${postViewAPIProvider.postViewModel!.orderDetails!.beforeJobImage!}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 190,
                          autoPlay: false,
                          pageSnapping: true,
                          autoPlayCurve: Curves.easeInOut,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          autoPlayInterval: Duration(seconds: 2),
                          onPageChanged: (index, reason) =>
                              setState(() => activeIndex = index),
                        )),
                postViewAPIProvider.ifLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    :
                    /*  if (postViewAPIProvider.postViewModel == null ||
               postViewAPIProvider
                       .postViewModel!.orderDetails!.beforeJobImage !=
                   null)*/
                    AnimatedSmoothIndicator(
                        activeIndex: activeIndex,
                        count: postViewAPIProvider.postViewModel!.orderDetails!
                            .beforeJobImage!.length,
                        effect: const ScrollingDotsEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          activeDotColor: Colors.pink,
                          dotColor: Colors.grey,
                        ),
                        onDotClicked: animateToSlide,
                      ),
              ]),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: NeumorphicButton(
              style:
                  const NeumorphicStyle(intensity: 30, color: Colors.lightBlue),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${translationAPiProvider.translationModel!.languageDetails![13]}        :     ",
                      style: CommonStyles.whiteText15BoldW500(),
                    ),
                    postViewAPIProvider.postViewModel != null
                        ? Flexible(
                            child: Text(
                              postViewAPIProvider.postViewModel!.orderDetails!
                                          .jobType ==
                                      "1"
                                  ? "Premium Jobs"
                                  : "${translationAPiProvider.translationModel!.languageDetails![11]}",
                              style: CommonStyles.blackS18(),
                            ),
                          )
                        : const CircularProgressIndicator(
                            strokeWidth: 0.5,
                          ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: NeumorphicButton(
              padding: EdgeInsets.zero,
              style: const NeumorphicStyle(
                  lightSource: LightSource.top, intensity: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                width: MediaQuery.of(context).size.width * 1,
                child: postViewAPIProvider.postViewModel != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![14]}",
                                  style: CommonStyles.black11(),
                                ),
                              ),
                              Expanded(
                                child: Text(":"),
                              ),
                              if (postViewAPIProvider.postViewModel != null)
                                Expanded(
                                  flex: 6,
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      ColorizeAnimatedText(
                                          " ₹  ${postViewAPIProvider.postViewModel!.orderDetails!.total}",
                                          colors: colorizeColors,
                                          textStyle: CommonStyles.blue14900())
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![15]}",
                                  style: CommonStyles.black11(),
                                ),
                              ),
                              Expanded(
                                child: Text(":"),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  postViewAPIProvider
                                      .postViewModel!.orderDetails!.jobTitle!,
                                  style: CommonStyles.blue14900(),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![16]}",
                                  style: CommonStyles.black11(),
                                ),
                              ),
                              Expanded(
                                child: Text(":"),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  postViewAPIProvider
                                      .postViewModel!.orderDetails!.address!,
                                  style: CommonStyles.blue14900(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![17]}",
                                  style: CommonStyles.black11(),
                                ),
                              ),
                              Expanded(
                                child: Text(":"),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  postViewAPIProvider
                                      .postViewModel!.orderDetails!.dateTime!,
                                  style: CommonStyles.blue14900(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "${translationAPiProvider.translationModel!.languageDetails![18]}",
                                  style: CommonStyles.black11(),
                                ),
                              ),
                              Expanded(
                                child: Text(":"),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  postViewAPIProvider.postViewModel!
                                      .orderDetails!.fromDatetime!,
                                  style: CommonStyles.blue14900(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (postViewAPIProvider
                                  .postViewModel!.orderDetails!.jobType ==
                              "2")
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${translationAPiProvider.translationModel!.languageDetails![19]}            :   ",
                                      style: CommonStyles.black11(),
                                    ),
                                    Text(
                                      postViewAPIProvider.postViewModel!
                                          .orderDetails!.toDatetime!,
                                      style: CommonStyles.blue14900(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                        ],
                      )
                    : const CircularProgressIndicator(
                        strokeWidth: 0.5,
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: NeumorphicButton(
              style: const NeumorphicStyle(
                  lightSource: LightSource.top, surfaceIntensity: 0.50),
              child: Column(
                children: [
                  Text(
                    "${translationAPiProvider.translationModel!.languageDetails![20]} ",
                    style: CommonStyles.blue18900(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.lightBlue,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /* _contentTranslationModel == null ||
                          _contentTranslationModel.languageContent!.isEmpty
                      ? CircularProgressIndicator(
                          strokeWidth: 0.5,
                        )
                      :*/
                  /*postViewAPIProvider.postViewModel != null ||
                          postViewAPIProvider.postViewModel!.orderDetails !=
                              null ||*/
                  _contentTranslationModel.languageContent == null ||
                          _contentTranslationModel.languageContent!.isEmpty
                      ? Text(
                          postViewAPIProvider
                              .postViewModel!.orderDetails!.description!,
                          style: CommonStyles.black13thinW54(),
                        )
                      : Text(_contentTranslationModel.languageContent!),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: NeumorphicButton(
                      style: const NeumorphicStyle(color: Colors.lightBlue),
                      onPressed: () async {
                        await apiService
                            .getTranslationWord(postViewAPIProvider
                                .postViewModel!.orderDetails!.description!)
                            .then((value) => _contentTranslationModel = value!);

                        /*        await context
                            .read<PostViewAPIProvider>()
                            .getPostView(widget.orderID);*/
                      },
                      child: Text(
                        "Translate",
                        style: CommonStyles.whiteText15BoldW500(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ])),
        bottomNavigationBar: Container(
            alignment: Alignment.center,
            height: 60,
            decoration: const BoxDecoration(color: Colors.lightBlue),
            child: InkWell(
              onTap: () {
                context.read<ProfileAPIProvider>().profileModel == null ||
                        context
                                .read<ProfileAPIProvider>()
                                .profileModel!
                                .userDetails!
                                .profileUpdateStatus ==
                            "0" ||
                        context
                                .read<ProfileAPIProvider>()
                                .profileModel!
                                .userDetails!
                                .profileUpdateStatus ==
                            null
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const JobConfirmationScreen()))
                    : showAlertDialog(context, translationAPiProvider);
              },
              child: Text(
                  "${translationAPiProvider.translationModel!.languageDetails![21]}",
                  style: CommonStyles.whiteText16BoldW500()),
            )));
  }

  AcceptRejectModel _acceptRejectModel = AcceptRejectModel();

  showAlertDialog(
      BuildContext context, TranslationAPIProvider translationAPiProvider) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "${translationAPiProvider.translationModel!.languageDetails![23]}",
        style: CommonStyles.black13(),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "${translationAPiProvider.translationModel!.languageDetails![24]}",
        style: CommonStyles.black13(),
      ),
      onPressed: () async {
        await apiService
            .getApplyJob(widget.orderID, "2")
            .then((value) => _acceptRejectModel = value!);
        print("Order Placed ---- " +
            _acceptRejectModel.message.toString() +
            _acceptRejectModel.status.toString());

        if (_acceptRejectModel.status == "1") {
          Utils.showSnackBar(
              context: context,
              text: "${_acceptRejectModel.message.toString()}");

          await context.read<PrimaryJobAPIProvider>().getPrimaryJobs();
          await context.read<AcceptedJobAPIProvider>().getAcceptedJobList();
          await context.read<PostedJobAPIProvider>().getPostedJobList();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyWorkedJobScreen()),
          );
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
        "Service Provider",
        style: CommonStyles.black13(),
      ),
      content: Text(
        "${translationAPiProvider.translationModel!.languageDetails![22]}",
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

  ContentTranslationModel _contentTranslationModel = ContentTranslationModel();
}
