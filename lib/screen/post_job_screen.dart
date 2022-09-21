import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/common/image_box.dart';
import 'package:serviceprovider/common/image_picker_service.dart';
import 'package:serviceprovider/common/loading_widget.dart';
import 'package:serviceprovider/common/pick_location.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/model/classical_job_post_model.dart';
import 'package:serviceprovider/model/image_upload_model.dart';
import 'package:serviceprovider/model/primary_post_job_model.dart';
import 'package:serviceprovider/screen/home_screen.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/classic_job_api_provider.dart';
import 'package:serviceprovider/service/posted_job_list_api_provider.dart';
import 'package:serviceprovider/service/primary_job_api_provider.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({Key? key}) : super(key: key);

  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final jobNameController = TextEditingController();
  final jobDescriptionController = TextEditingController();
  final jobAmountController = TextEditingController();
  final landMarkController = TextEditingController();
  final locationController = TextEditingController();

  File selectedProductImageFile = File('');

  String latitude = "", longitude = "", selectedAddress = "";
  String selectedPincode = "";
  bool locationProvided = false;

  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
    }
  }

  PrimaryPostJobModel _primaryPostJobModel = PrimaryPostJobModel();
  ClassicalPostJobModel _classicalPostJobModel = ClassicalPostJobModel();

  @override
  void initState() {
    initializeLanKey();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translationAPiProvider = Provider.of<TranslationAPIProvider>(context);

    final imagePickerService =
        Provider.of<ImagePickerService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Job Post",
          style: CommonStyles.whiteText16BoldW500(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: SingleChildScrollView(
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
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: ProductImageBox(
                            title:
                                "${translationAPiProvider.translationModel!.languageDetails![43]}",
                            imageFile: selectedProductImageFile,
                            radius: 0,
                            circleRadius: 50,
                            onPressed: () async {
                              selectedProductImageFile =
                                  await imagePickerService
                                      .chooseImageFile(context);
                            }),
                      )),
                ),
              ),
              Utils.getSizedBox(height: 20),
              Neumorphic(
                margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                style: NeumorphicStyle(
                  intensity: 30,
                  depth: NeumorphicTheme.embossDepth(context),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  // onChanged: this.widget.onChanged,
                  controller: jobNameController,
                  decoration: InputDecoration(
                    //   enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    //       disabledBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.wallet_travel_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                    counterText: "",
                    hintText:
                        "   ${translationAPiProvider.translationModel!.languageDetails![44]}",
                  ),
                  style: CommonStyles.black13thin(),
                ),
              ),
              Utils.getSizedBox(height: 20),
              Neumorphic(
                margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                style: NeumorphicStyle(
                  intensity: 30,
                  depth: NeumorphicTheme.embossDepth(context),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  // onChanged: this.widget.onChanged,
                  controller: jobDescriptionController,
                  decoration: InputDecoration(
                    //   enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    //       disabledBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.wallet_travel_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                    counterText: "",
                    hintText:
                        "   ${translationAPiProvider.translationModel!.languageDetails![45]}",
                  ),
                  style: CommonStyles.black13thin(),
                ),
              ),
              Utils.getSizedBox(height: 20),
              Neumorphic(
                margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                style: NeumorphicStyle(
                  intensity: 30,
                  depth: NeumorphicTheme.embossDepth(context),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: TextFormField(
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  // onChanged: this.widget.onChanged,
                  controller: jobAmountController,
                  decoration: InputDecoration(
                    //   enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    //       disabledBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.currency_rupee,
                      color: Colors.blue,
                      size: 20,
                    ),
                    counterText: "",
                    hintText:
                        "   ${translationAPiProvider.translationModel!.languageDetails![46]}",
                  ),
                  style: CommonStyles.black13thin(),
                ),
              ),
              Utils.getSizedBox(height: 20),
              Neumorphic(
                margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                style: NeumorphicStyle(
                  intensity: 30,
                  depth: NeumorphicTheme.embossDepth(context),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        // onChanged: this.widget.onChanged,
                        controller: locationController,
                        decoration: InputDecoration(
                          //   enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          //       disabledBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 20,
                          ),
                          counterText: "",
                          hintText: "    ",
                        ),
                        style: CommonStyles.black13thin(),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        print("Location Permission");
                        LocationPermission permission;
                        permission = await Geolocator.requestPermission();
                        if (permission == LocationPermission.denied) {
                          permission = await Geolocator.requestPermission();
                          if (permission == LocationPermission.deniedForever) {
                            Utils.getSnackBar(context,
                                "Oops!! Location Permission is denied");
                            return Future.error('Location Not Available');
                          }
                          Utils.getSnackBar(
                              context, "Oops!! Location Permission is denied");
                        } else {
                          showLoadingWithCustomText(
                              context, "Getting Locaiton");
                          final position =
                              await Geolocator.getCurrentPosition();

                          Navigator.of(context).pop();

                          final Map<String, dynamic> result =
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PickLocationGoogleMapsScreen(
                                            latitude: position.latitude,
                                            longitude: position.longitude,
                                          )));
                          print(result['address'] +
                              " ----- " +
                              result['pincode']);

                          latitude = result['latitude'].toString();
                          longitude = result['longitude'].toString();
                          selectedAddress = result['address'];
                          selectedPincode = result['pincode'];
                          locationProvided = true;
                          locationController.text = selectedAddress;
                          print("Loaction Post" + locationController.text);
                          setState(() {});
                        }
                      },
                      child: Card(
                        color: Colors.lightBlueAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            translationAPiProvider
                                .translationModel!.languageDetails![92],
                            style: CommonStyles.whiteText15BoldW500(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Utils.getSizedBox(height: 20),
              Neumorphic(
                margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                style: NeumorphicStyle(
                  intensity: 30,
                  depth: NeumorphicTheme.embossDepth(context),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  // onChanged: this.widget.onChanged,
                  controller: landMarkController,
                  decoration: InputDecoration(
                    //   enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    //       disabledBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.location_history,
                      color: Colors.blue,
                      size: 20,
                    ),
                    counterText: "",
                    hintText:
                        "   ${translationAPiProvider.translationModel!.languageDetails![41]}",
                  ),
                  style: CommonStyles.black13thin(),
                ),
              ),
              Utils.getSizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        FittedBox(
                          child: Text(
                            "${translationAPiProvider.translationModel!.languageDetails![47]}",
                            style: CommonStyles.black1254W700(),
                          ),
                        ),
                        Utils.getSizedBox(height: 10),
                        Neumorphic(
                          style: NeumorphicStyle(intensity: 20),
                          child: SizedBox(
                            height: 60.0,
                            child: ListView(
                              primary: false,
                              children: [
                                ListTile(
                                  title: _isDateSelected
                                      ? FittedBox(
                                          child: Text(
                                              "${currentDate.day} / ${currentDate.month} / ${currentDate.year}"),
                                        )
                                      : FittedBox(
                                          child: Text(
                                              "${translationAPiProvider.translationModel!.languageDetails![49]}")),
                                  trailing: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  leading: const Icon(
                                    Icons.today,
                                    color: Colors.blue,
                                  ),
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        FittedBox(
                          child: Text(
                            "${translationAPiProvider.translationModel!.languageDetails![48]}",
                            style: CommonStyles.black1254W700(),
                          ),
                        ),
                        Utils.getSizedBox(height: 10),
                        Neumorphic(
                          style: NeumorphicStyle(intensity: 20),
                          child: SizedBox(
                            height: 60.0,
                            child: ListView(
                              primary: false,
                              children: [
                                ListTile(
                                  title: _isTimeSelected
                                      ? FittedBox(
                                          child: Text(currentTime
                                              .format(context)
                                              .toString()),
                                        )
                                      : FittedBox(
                                          child: const Text("Select Time")),
                                  trailing: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  leading: const Icon(
                                    Icons.schedule,
                                    color: Colors.blue,
                                  ),
                                  onTap: () {
                                    _selectTime(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Utils.getSizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        FittedBox(
                          child: Text(
                            "To Date",
                            style: CommonStyles.black1254W700(),
                          ),
                        ),
                        Utils.getSizedBox(height: 10),
                        Neumorphic(
                          style: NeumorphicStyle(intensity: 20),
                          child: SizedBox(
                            height: 60.0,
                            child: ListView(
                              primary: false,
                              children: [
                                ListTile(
                                  title: _isToDateSelected
                                      ? FittedBox(
                                          child: Text(
                                              "${tocurrentDate.day} / ${tocurrentDate.month} / ${tocurrentDate.year}"),
                                        )
                                      : FittedBox(
                                          child: Text(
                                              "${translationAPiProvider.translationModel!.languageDetails![49]}")),
                                  trailing: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  leading: const Icon(
                                    Icons.today,
                                    color: Colors.blue,
                                  ),
                                  onTap: () {
                                    _toselectDate(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        FittedBox(
                          child: Text(
                            "To Time",
                            style: CommonStyles.black1254W700(),
                          ),
                        ),
                        Utils.getSizedBox(height: 10),
                        Neumorphic(
                          style: NeumorphicStyle(intensity: 20),
                          child: SizedBox(
                            height: 60.0,
                            child: ListView(
                              primary: false,
                              children: [
                                ListTile(
                                  title: _isToTimeSelected
                                      ? FittedBox(
                                          child: Text(tocurrentTime
                                              .format(context)
                                              .toString()),
                                        )
                                      : FittedBox(
                                          child: const Text("Select Time")),
                                  trailing: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  leading: const Icon(
                                    Icons.schedule,
                                    color: Colors.blue,
                                  ),
                                  onTap: () {
                                    _toselectTime(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Utils.getSizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: NeumorphicButton(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              onPressed: () async {
                if (selectDate != null && selectTime != null
                    /*toselectDate != null &&
                    toselectTime != null*/
                    ) {
                  final imageResponse = await apiService.uploadImages(
                      ImageUploadModel(
                          fileName: selectedProductImageFile,
                          fileType: "before_job_image"));

                  print("Image Response -------" + imageResponse.fileName!);
                  print("Image Response URL-------" + imageResponse.fileUrl!);
                  if (imageResponse.status == "1") {
                    await apiService
                        .primaryPost(
                            jobNameController.text,
                            imageResponse.fileName!,
                            jobDescriptionController.text,
                            locationController.text,
                            selectDate.toString(),
                            selectTime!.format(context).toString(),
                            /*toselectDate!.isUtc.toString(),
                            toselectTime!.format(context).toString(),*/
                            latitude,
                            longitude,
                            jobAmountController.text)
                        .then((value) => _primaryPostJobModel = value!);
                    print("Primary Post ------- " +
                        _primaryPostJobModel.message!.toString() +
                        _primaryPostJobModel.status!.toString());
                    if (_primaryPostJobModel.status == "1") {
                      Utils.showSnackBar(
                          context: context,
                          text: "${_primaryPostJobModel.message.toString()}");
                      Navigator.of(context).pop();
                      await context
                          .read<PrimaryJobAPIProvider>()
                          .getPrimaryJobs();
                      await context
                          .read<PostedJobAPIProvider>()
                          .getPostedJobList();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    }

                    if (_primaryPostJobModel.status == "0") {
                      return Utils.showSnackBar(
                          context: context,
                          text: "${_primaryPostJobModel.message.toString()}");
                    }
                  } else {
                    Utils.showSnackBar(
                        context: context, text: "Could not upload Image !!");
                  }
                } else {
                  Utils.showErrorDialog(context,
                      "Classical Job Information \n\n It doesn't contains To Date & Time !!");
                }
              },
              child: Text(
                "${translationAPiProvider.translationModel!.languageDetails![11]}",
                style: CommonStyles.whiteText15BoldW500(),
                textAlign: TextAlign.center,
              ),
              style:
                  NeumorphicStyle(intensity: 20, color: Colors.lightBlueAccent),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            flex: 3,
            child: NeumorphicButton(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              onPressed: () async {
                print("Selected Date --------->>" + selectDate!.toString());
                //    print("Selected Time --------->>" + selectTime!.format(context).toString());
                //  print("Selected Image --------->>" + selectedProductImageFile.path);

                if (selectDate != null &&
                    selectTime != null &&
                    toselectDate != null &&
                    toselectTime != null) {
                  final imageResponse = await apiService.uploadImages(
                      ImageUploadModel(
                          fileName: selectedProductImageFile,
                          fileType: "before_job_image"));

                  print("Image Response -------" + imageResponse.fileName!);
                  print("Image Response URL-------" + imageResponse.fileUrl!);
                  if (imageResponse.status == "1") {
                    await apiService
                        .classicPost(
                            jobNameController.text,
                            imageResponse.fileName!,
                            jobDescriptionController.text,
                            locationController.text,
                            selectDate!.isUtc.toString(),
                            selectTime!.format(context).toString(),
                            toselectDate!.isUtc.toString(),
                            toselectTime!.format(context).toString(),
                            latitude,
                            longitude,
                            jobAmountController.text)
                        .then((value) => _classicalPostJobModel = value!);
                    print("Primary Post ------- " +
                        _classicalPostJobModel.message!.toString() +
                        _classicalPostJobModel.status!.toString());
                    if (_classicalPostJobModel.status == "1") {
                      Utils.showSnackBar(
                          context: context,
                          text: "${_classicalPostJobModel.message.toString()}");
                      Navigator.of(context).pop();
                      await context
                          .read<PostedJobAPIProvider>()
                          .getPostedJobList();
                      await context
                          .read<ClassicJobAPIProvider>()
                          .getClassicJobs();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    }

                    if (_classicalPostJobModel.status == "0") {
                      return Utils.showSnackBar(
                          context: context,
                          text: "${_classicalPostJobModel.message.toString()}");
                    }
                  } else {
                    Utils.showSnackBar(
                        context: context, text: "Could not upload Image !!");
                  }
                } else {
                  Utils.showErrorDialog(context,
                      "Premium Job Information !! \n\n It contains From and To Date and Time !!");
                }
              },
              child: Text(
                translationAPiProvider.translationModel!.languageDetails![12],
                style: CommonStyles.whiteText15BoldW500(),
                textAlign: TextAlign.center,
              ),
              style:
                  NeumorphicStyle(intensity: 20, color: Colors.lightBlueAccent),
            ),
          ),
        ],
      ),
    );
  }

  bool _isTimeSelected = false;
  bool _isDateSelected = false;
  bool _autovalidate = false;
  TimeOfDay currentTime = TimeOfDay.now();
  DateTime currentDate = DateTime.now();

  TimeOfDay? selectTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      //you may change text and input
      initialEntryMode: TimePickerEntryMode.input,
      helpText: "Choose your Time",
      confirmText: "Choose Now",
      cancelText: "Later",
    );

    //if function is to update and picked time
    if (pickedTime != null && pickedTime != currentTime) {
      setState(() {
        currentTime = pickedTime as TimeOfDay;
        _isTimeSelected = true;
      });
    }
    print(
        "Picked Time === == = = = = = ${pickedTime!.format(context).toString()}");
    selectTime = pickedTime;
    print(
        "Select Time === == = = = = = ${selectTime!.format(context).toString()}");
  }

//date function
  DateTime? selectDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2050, 12, 31),

      //you may change text and input
      // initialEntryMode: TimePickerEntryMode.input,
      helpText: "Choose your Date",
      confirmText: "Choose Now",
      cancelText: "Later",
    );

    //if function is to update and picked time
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate as DateTime;
        _isDateSelected = true;
      });
    }
    print("Picked Date === == = = = = = $pickedDate");
    selectDate = pickedDate!;
    print("Select Date === == = = = = = $selectDate");
  }

  //
//
//
//

  ///
  ///
  ///
  // To Date And Time Functions

  bool _isToTimeSelected = false;
  bool _isToDateSelected = false;
  bool _autoTovalidate = false;
  TimeOfDay tocurrentTime = TimeOfDay.now();
  DateTime tocurrentDate = DateTime.now();

  TimeOfDay? toselectTime;

  Future<void> _toselectTime(BuildContext context) async {
    final TimeOfDay? topickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      //you may change text and input
      initialEntryMode: TimePickerEntryMode.input,
      helpText: "Choose your Time",
      confirmText: "Choose Now",
      cancelText: "Later",
    );

    //if function is to update and picked time
    if (topickedTime != null && topickedTime != tocurrentTime) {
      setState(() {
        tocurrentTime = topickedTime as TimeOfDay;
        _isToTimeSelected = true;
      });
    }
    print(
        "Picked Time === == = = = = = ${topickedTime!.format(context).toString()}");
    toselectTime = topickedTime;
    print(
        "Select Time === == = = = = = ${toselectTime!.format(context).toString()}");
  }

//date function
  DateTime? toselectDate;

  Future<void> _toselectDate(BuildContext context) async {
    final DateTime? topickedDate = await showDatePicker(
      context: context,
      initialDate: tocurrentDate,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2050, 12, 31),

      //you may change text and input
      // initialEntryMode: TimePickerEntryMode.input,
      helpText: "Choose your Date",
      confirmText: "Choose Now",
      cancelText: "Later",
    );

    //if function is to update and picked time
    if (topickedDate != null && topickedDate != tocurrentDate) {
      setState(() {
        tocurrentDate = topickedDate as DateTime;
        _isToDateSelected = true;
      });
    }
    print("Picked Date === == = = = = = $topickedDate");
    toselectDate = topickedDate!;
    print("Select Date === == = = = = = $toselectDate");
  }
}
