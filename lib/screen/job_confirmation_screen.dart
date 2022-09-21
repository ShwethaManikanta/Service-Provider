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
import 'package:serviceprovider/model/image_upload_model.dart';
import 'package:serviceprovider/model/profile_model.dart';
import 'package:serviceprovider/screen/post_job_screen.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/profile_api_provider.dart';
import 'package:serviceprovider/service/profile_update_api_provide.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class JobConfirmationScreen extends StatefulWidget {
  const JobConfirmationScreen({Key? key}) : super(key: key);

  @override
  _JobConfirmationScreenState createState() => _JobConfirmationScreenState();
}

class _JobConfirmationScreenState extends State<JobConfirmationScreen> {
  File aadharFrontImage = File('');
  File aadharBackImage = File('');
  File panImage = File('');
  File pcVerify = File('');
  File dlImage = File('');

  final nameController = TextEditingController();
  final mobileController = TextEditingController();

  final emailController = TextEditingController();
  final landMarkController = TextEditingController();
  final locationController = TextEditingController();

  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final accountIFSCController = TextEditingController();

  String latitude = "", longitude = "", selectedAddress = "";
  String selectedPincode = "";
  bool locationProvided = false;

  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();

      final imagePickerService =
          Provider.of<ImagePickerService>(context, listen: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePickerService =
        Provider.of<ImagePickerService>(context, listen: false);
    final translationAPiProvider = Provider.of<TranslationAPIProvider>(context);

    final profileUpdateAPIProvider =
        Provider.of<ProfileUpdateApiProvder>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            translationAPiProvider.translationModel!.languageDetails![93],
            style: CommonStyles.whiteText16BoldW500(),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Neumorphic(
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 4),
                  style: NeumorphicStyle(
                    intensity: 30,
                    depth: NeumorphicTheme.embossDepth(context),
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    // onChanged: this.widget.onChanged,
                    controller: nameController,
                    decoration: InputDecoration(
                      //   enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      //       disabledBorder: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 20,
                      ),
                      counterText: "",
                      hintText:
                          "  ${translationAPiProvider.translationModel!.languageDetails![36]}",
                    ),
                    style: CommonStyles.black13thin(),
                  ),
                ),
                Utils.getSizedBox(height: 20),
                Neumorphic(
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 4),
                  style: NeumorphicStyle(
                    intensity: 30,
                    depth: NeumorphicTheme.embossDepth(context),
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    // onChanged: this.widget.onChanged,
                    controller: emailController,
                    decoration: InputDecoration(
                      //   enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      //       disabledBorder: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Colors.blue,
                        size: 20,
                      ),
                      counterText: "",
                      hintText:
                          "   ${translationAPiProvider.translationModel!.languageDetails![37]}",
                    ),
                    style: CommonStyles.black13thin(),
                  ),
                ),
                Utils.getSizedBox(height: 20),
                Neumorphic(
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 4),
                  style: NeumorphicStyle(
                    intensity: 30,
                    depth: NeumorphicTheme.embossDepth(context),
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  child: TextFormField(
                    maxLength: 30,
                    keyboardType: TextInputType.text,
                    // onChanged: this.widget.onChanged,
                    controller: accountNameController,
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
                          "   ${translationAPiProvider.translationModel!.languageDetails![82]} ",
                    ),
                    style: CommonStyles.black13thin(),
                  ),
                ),
                Utils.getSizedBox(height: 20),
                Neumorphic(
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 4),
                  style: NeumorphicStyle(
                    intensity: 30,
                    depth: NeumorphicTheme.embossDepth(context),
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  child: TextFormField(
                    maxLength: 30,
                    keyboardType: TextInputType.text,
                    // onChanged: this.widget.onChanged,
                    controller: accountNumberController,
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
                          "   ${translationAPiProvider.translationModel!.languageDetails![84]}",
                    ),
                    style: CommonStyles.black13thin(),
                  ),
                ),
                Utils.getSizedBox(height: 20),
                Neumorphic(
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 4),
                  style: NeumorphicStyle(
                    intensity: 30,
                    depth: NeumorphicTheme.embossDepth(context),
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  child: TextFormField(
                    maxLength: 30,
                    keyboardType: TextInputType.text,
                    // onChanged: this.widget.onChanged,
                    controller: accountIFSCController,
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
                          "   ${translationAPiProvider.translationModel!.languageDetails![85]} ",
                    ),
                    style: CommonStyles.black13thin(),
                  ),
                ),
                Utils.getSizedBox(height: 20),
                Neumorphic(
                  padding: const EdgeInsets.all(20),
                  style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    depth: NeumorphicTheme.embossDepth(context),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ProductImageBox(
                            title:
                                "${translationAPiProvider.translationModel!.languageDetails![86]}",
                            circleRadius: 10,
                            imageFile: aadharFrontImage,
                            radius: 0,
                            onPressed: () async {
                              aadharFrontImage = await imagePickerService
                                  .chooseImageFile(context);
                            })),
                  ),
                ),
                Utils.getSizedBox(height: 20),
                Neumorphic(
                  padding: const EdgeInsets.all(20),
                  style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    depth: NeumorphicTheme.embossDepth(context),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ProductImageBox(
                            title:
                                "${translationAPiProvider.translationModel!.languageDetails![87]}",
                            circleRadius: 10,
                            imageFile: aadharBackImage,
                            radius: 0,
                            onPressed: () async {
                              aadharBackImage = await imagePickerService
                                  .chooseImageFile(context);
                            })),
                  ),
                ),
                Utils.getSizedBox(height: 20),
                Neumorphic(
                  padding: const EdgeInsets.all(20),
                  style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    depth: NeumorphicTheme.embossDepth(context),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ProductImageBox(
                            title:
                                "${translationAPiProvider.translationModel!.languageDetails![88]}",
                            circleRadius: 10,
                            imageFile: panImage,
                            radius: 0,
                            onPressed: () async {
                              panImage = await imagePickerService
                                  .chooseImageFile(context);
                            })),
                  ),
                ),

                // Pc Verification

                Utils.getSizedBox(height: 20),
                Neumorphic(
                  padding: const EdgeInsets.all(20),
                  style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    depth: NeumorphicTheme.embossDepth(context),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ProductImageBox(
                            title:
                                "${translationAPiProvider.translationModel!.languageDetails![89]}",
                            circleRadius: 10,
                            imageFile: pcVerify,
                            radius: 0,
                            onPressed: () async {
                              pcVerify = await imagePickerService
                                  .chooseImageFile(context);
                            })),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${translationAPiProvider.translationModel!.languageDetails![90]}",
                      style: CommonStyles.blue13(),
                    ),
                    InkWell(
                      onTap: () async {
                        await _launchURL();
                      },
                      child: const Text(
                        "Click Here",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // DL Image

                Utils.getSizedBox(height: 20),
                Neumorphic(
                  padding: const EdgeInsets.all(20),
                  style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    depth: NeumorphicTheme.embossDepth(context),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ProductImageBox(
                            title:
                                "${translationAPiProvider.translationModel!.languageDetails![91]}",
                            circleRadius: 10,
                            imageFile: dlImage,
                            radius: 0,
                            onPressed: () async {
                              dlImage = await imagePickerService
                                  .chooseImageFile(context);
                            })),
                  ),
                ),

                Utils.getSizedBox(height: 20),
                Neumorphic(
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 4),
                  style: NeumorphicStyle(
                    intensity: 30,
                    depth: NeumorphicTheme.embossDepth(context),
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        selectedAddress,
                        style: CommonStyles.black13(),
                      )),
                      InkWell(
                        onTap: () async {
                          LocationPermission permission;
                          permission = await Geolocator.requestPermission();
                          if (permission == LocationPermission.denied) {
                            permission = await Geolocator.requestPermission();
                            if (permission ==
                                LocationPermission.deniedForever) {
                              Utils.getSnackBar(context,
                                  "Oops!! Location Permission is denied");
                              return Future.error('Location Not Available');
                            }
                            Utils.getSnackBar(context,
                                "Oops!! Location Permission is denied");
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
                            setState(() {
                              locationController.text = selectedAddress;
                              latitude = result['latitude'].toString();
                              longitude = result['longitude'].toString();
                              selectedAddress = result['address'];
                              selectedPincode = result['pincode'];
                              locationProvided = true;
                            });
                          }
                        },
                        child: Card(
                          color: Colors.lightBlueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${translationAPiProvider.translationModel!.languageDetails![92]}",
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
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 4),
                  style: NeumorphicStyle(
                    intensity: 30,
                    depth: NeumorphicTheme.embossDepth(context),
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  child: TextFormField(
                    maxLength: 30,
                    keyboardType: TextInputType.text,
                    // onChanged: this.widget.onChanged,
                    controller: landMarkController,
                    decoration: InputDecoration(
                      //   enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      //       disabledBorder: InputBorder.none,
                      prefixIcon: const Icon(
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
                Utils.getSizedBox(height: 100),
                InkWell(
                  onTap: () async {
                    /*   print("name ------ >>>" + nameController.text);
                    print("mobile ------ >>>" + mobileController.text);
                    print("email ------ >>>" + emailController.text);

                    print("location ------ >>>" + locationController.text);
                    print("latitude ------ >>>" + latitude);
                    print("longitude ------ >>>" + longitude);
                    print("landMark ------ >>>" + landMarkController.text);*/

                    final imageAadharResponse = await apiService.uploadImages(
                        ImageUploadModel(
                            fileName: aadharFrontImage,
                            fileType: "aadhar_image"));

                    final imageAADharBackResponse =
                        await apiService.uploadImages(ImageUploadModel(
                            fileName: aadharBackImage, fileType: "pan_image"));

                    final imagePanResponse = await apiService.uploadImages(
                        ImageUploadModel(
                            fileName: panImage, fileType: "pan_image"));
                    final imagePcVerify = await apiService.uploadImages(
                        ImageUploadModel(
                            fileName: pcVerify,
                            fileType: "police_verification"));

                    final imageDriverLicenceResponse =
                        await apiService.uploadImages(ImageUploadModel(
                            fileName: dlImage, fileType: "driver_license"));

                    print("pan ------ >>>" + imageAadharResponse.fileName!);
                    print("aadhar ------ >>>" + imagePanResponse.fileName!);

                    if (imagePanResponse.status == "1" &&
                        imageAadharResponse.status == "1") {
                      await profileUpdateAPIProvider.updateProfileDetails(
                          ProfileUpdateRequestModel(
                              userId: APIService.userId!,
                              email: emailController.text,
                              userName: nameController.text,
                              mobile: context
                                  .read<ProfileAPIProvider>()
                                  .profileModel!
                                  .userDetails!
                                  .mobile!,
                              location: landMarkController.text,
                              address: selectedAddress,
                              aadhaarFrontImage: imageAadharResponse.fileName!,
                              aadhaarBackImage:
                                  imageAADharBackResponse.fileName!,
                              panImage: imagePanResponse.fileName!,
                              accountIFSC: accountIFSCController.text,
                              accountNumber: accountNumberController.text,
                              accountHolder: accountNameController.text,
                              policeVerification: imagePcVerify.fileName!,
                              dl: imageDriverLicenceResponse.fileName!));
                      if (profileUpdateAPIProvider
                              .profileUpdateResponse!.status ==
                          "1") {
                        Utils.showSnackBar(
                            context: context,
                            text: profileUpdateAPIProvider
                                .profileUpdateResponse!.message
                                .toString());

                        await context.read<ProfileAPIProvider>().getProfile();

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PostJobScreen()));
                      }
                      if (profileUpdateAPIProvider
                              .profileUpdateResponse!.status ==
                          "0") {
                        return Utils.showSnackBar(
                            context: context,
                            text:
                                "${profileUpdateAPIProvider.profileUpdateResponse!.message.toString()}");
                      }
                    } else {
                      Utils.showSnackBar(
                          context: context,
                          text: "Colud not Upload Aadhar & Pan Image");
                    }
                  },
                  child: SizedBox(
                    width: 200,
                    height: 60,
                    child: Neumorphic(
                      style: const NeumorphicStyle(
                          intensity: 40, color: Colors.lightBlueAccent),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Center(
                            child: Text(
                          "${translationAPiProvider.translationModel!.languageDetails![42]}",
                          style: CommonStyles.whiteText16BoldW500(),
                        )),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url =
        'https://www.karnatakaone.gov.in/Info/Public/PoliceVerification';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
