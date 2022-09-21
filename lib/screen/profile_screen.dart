import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/common/common_text_form_fields.dart';
import 'package:serviceprovider/common/image_box.dart';
import 'package:serviceprovider/common/image_picker_service.dart';
import 'package:serviceprovider/common/loading_widget.dart';
import 'package:serviceprovider/common/pick_location.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/model/image_upload_model.dart';
import 'package:serviceprovider/model/profile_model.dart';
import 'package:serviceprovider/service/api_service.dart';
import 'package:serviceprovider/service/profile_api_provider.dart';
import 'package:serviceprovider/service/profile_update_api_provide.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';

class ProfileScreen extends StatefulWidget {
  final String lanKey;
  const ProfileScreen({Key? key, required this.lanKey}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  final accountNoKey = GlobalKey<FormState>();
  final accountNoController = TextEditingController();

  final accountNameKey = GlobalKey<FormState>();
  final accountNameController = TextEditingController();

  final accountIFSCKey = GlobalKey<FormState>();
  final accountIFSCController = TextEditingController();

  final emailKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final phoneNumberKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();

  final landMarkKey = GlobalKey<FormState>();
  final landMarkController = TextEditingController();

  bool edit = false;

  Future getProfile() async {
    if (context.read<ProfileAPIProvider>().profileModel == null) {
      context.read<ProfileAPIProvider>().getProfile().then((value) {
        nameController.text = context
            .read<ProfileAPIProvider>()
            .profileModel!
            .userDetails!
            .userName!;
        emailController.text = context
            .read<ProfileAPIProvider>()
            .profileModel!
            .userDetails!
            .email!;
        phoneNumberController.text = context
            .read<ProfileAPIProvider>()
            .profileModel!
            .userDetails!
            .mobile!;

        landMarkController.text = context
            .read<ProfileAPIProvider>()
            .profileModel!
            .userDetails!
            .landmark!;

        selectedAddress = context
            .read<ProfileAPIProvider>()
            .profileModel!
            .userDetails!
            .address!;

        accountNoController.text = context
            .read<ProfileAPIProvider>()
            .profileModel!
            .userDetails!
            .accountNumber!;

        accountNameController.text = context
            .read<ProfileAPIProvider>()
            .profileModel!
            .userDetails!
            .accountHolder!;

        accountIFSCController.text = context
            .read<ProfileAPIProvider>()
            .profileModel!
            .userDetails!
            .accountIfsc!;
      });
    } else {
      nameController.text = context
          .read<ProfileAPIProvider>()
          .profileModel!
          .userDetails!
          .userName!;
      emailController.text =
          context.read<ProfileAPIProvider>().profileModel!.userDetails!.email!;
      print("----------------------" +
          context
              .read<ProfileAPIProvider>()
              .profileModel!
              .userDetails!
              .mobile!
              .split(" ")
              .last);
      phoneNumberController.text = context
          .read<ProfileAPIProvider>()
          .profileModel!
          .userDetails!
          .mobile!
          .split(" ")
          .last;

      landMarkController.text = context
          .read<ProfileAPIProvider>()
          .profileModel!
          .userDetails!
          .landmark!;
      selectedAddress = context
          .read<ProfileAPIProvider>()
          .profileModel!
          .userDetails!
          .address!;

      accountNoController.text = context
          .read<ProfileAPIProvider>()
          .profileModel!
          .userDetails!
          .accountNumber!;

      accountNameController.text = context
          .read<ProfileAPIProvider>()
          .profileModel!
          .userDetails!
          .accountHolder!;

      accountIFSCController.text = context
          .read<ProfileAPIProvider>()
          .profileModel!
          .userDetails!
          .accountIfsc!;
    }
  }

  initializeLanKey() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
      print("Language Key --------" + widget.lanKey);
    }
  }

  @override
  void initState() {
    getProfile();
    initializeLanKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileAPIProvider = Provider.of<ProfileAPIProvider>(context);
    final translationAPiProvider = Provider.of<TranslationAPIProvider>(context);
    final profileUpdateAPIProvider =
        Provider.of<ProfileUpdateApiProvder>(context);

    final imagePickerService =
        Provider.of<ImagePickerService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        flexibleSpace: Container(),
        title: Text(
          "${translationAPiProvider.translationModel!.languageDetails![80]}",
          style: CommonStyles.whiteText16BoldW500(),
        ),
        actions: [
          Card(
            child: TextButton(
                onPressed: () async {
                  setState(() {
                    print("User Id -------" + APIService.userId!);
                    edit = !edit;
                  });
                  print(edit);
                  if (!edit) {
                    print("----" + edit.toString());
                    print(nameKey.currentState!.validate().toString());
                    print(emailKey.currentState!.validate().toString());
                    print(phoneNumberKey.currentState!.validate().toString());
                    print(landMarkKey.currentState!.validate().toString());
                    if (nameKey.currentState!.validate() &&
                        emailKey.currentState!.validate() &&
                        phoneNumberKey.currentState!.validate()) {
                      print("Validating  --------------");
                      if (nameController.text !=
                              profileAPIProvider
                                  .profileModel!.userDetails!.userName ||
                          emailController.text !=
                              profileAPIProvider
                                  .profileModel!.userDetails!.email ||
                          phoneNumberController.text !=
                              profileAPIProvider
                                  .profileModel!.userDetails!.mobile ||
                          landMarkController.text !=
                              profileAPIProvider
                                  .profileModel!.userDetails!.landmark ||
                          selectedAddress !=
                              profileAPIProvider
                                  .profileModel!.userDetails!.address ||
                          aadharImage != null ||
                          aadharBackImage != null ||
                          panImage != null ||
                          pcVerify != null ||
                          dl != null ||
                          accountNoController.text !=
                              profileAPIProvider
                                  .profileModel!.userDetails!.accountNumber ||
                          accountNameController.text !=
                              profileAPIProvider
                                  .profileModel!.userDetails!.accountHolder ||
                          accountIFSCController.text !=
                              profileAPIProvider
                                  .profileModel!.userDetails!.accountIfsc) {
                        print("Loading");
                        print("Land Mark ---------->> >>>" +
                            landMarkController.text);
                        showLoading(context);
                        ImageResponse? imageAadharResponse;
                        ImageResponse? imageAadharBackSideResponse;

                        ImageResponse? imagePanResponse;
                        ImageResponse? imagePCVerifyResponse;
                        ImageResponse? imageDrivingLicenseResponse;

                        if (aadharImage != null &&
                            aadharImage!.path != File("").path) {
                          imageAadharResponse = await apiService.uploadImages(
                              ImageUploadModel(
                                  fileName: aadharImage,
                                  fileType: "aadhar_image"));
                        }

                        if (aadharBackImage != null &&
                            aadharBackImage!.path != File("").path) {
                          imageAadharBackSideResponse =
                              await apiService.uploadImages(ImageUploadModel(
                                  fileName: aadharBackImage,
                                  fileType: "aadhar_back_image"));
                        }

                        if (panImage != null &&
                            panImage!.path != File("").path) {
                          imagePanResponse = await apiService.uploadImages(
                              ImageUploadModel(
                                  fileName: panImage, fileType: "pan_image"));
                        }

                        if (pcVerify != null &&
                            pcVerify!.path != File("").path) {
                          imagePCVerifyResponse = await apiService.uploadImages(
                              ImageUploadModel(
                                  fileName: pcVerify,
                                  fileType: "police_verification_image"));
                        }

                        if (dl != null && dl!.path != File("").path) {
                          imageDrivingLicenseResponse =
                              await apiService.uploadImages(ImageUploadModel(
                                  fileName: dl, fileType: "driving_license"));
                        }

                        await profileUpdateAPIProvider.updateProfileDetails(
                            ProfileUpdateRequestModel(
                                userId: APIService.userId!,
                                email: emailController.text,
                                userName: nameController.text,
                                mobile: phoneNumberController.text,
                                address: selectedAddress
                                        .isEmpty
                                    ? profileAPIProvider
                                        .profileModel!.userDetails!.address!
                                    : selectedAddress,
                                location: landMarkController.text,
                                aadhaarFrontImage:
                                    imageAadharResponse ==
                                            null
                                        ? profileAPIProvider.profileModel!
                                            .userDetails!.aadhaarImage!
                                        : imageAadharResponse.fileName!,
                                aadhaarBackImage:
                                    imageAadharBackSideResponse ==
                                            null
                                        ? profileAPIProvider.profileModel!
                                            .userDetails!.aadharBackImage!
                                        : imageAadharBackSideResponse.fileName!,
                                panImage: imagePanResponse ==
                                        null
                                    ? profileAPIProvider
                                        .profileModel!.userDetails!.panImage!
                                    : imagePanResponse.fileName!,
                                policeVerification: imagePCVerifyResponse ==
                                        null
                                    ? profileAPIProvider.profileModel!
                                        .userDetails!.policeVerification!
                                    : imagePCVerifyResponse.fileName!,
                                dl: imageDrivingLicenseResponse == null
                                    ? profileAPIProvider.profileModel!
                                        .userDetails!.driverLicense!
                                    : imageDrivingLicenseResponse.fileName!,
                                accountHolder: accountNameController.text,
                                accountNumber: accountNoController.text,
                                accountIFSC: accountIFSCController.text));
                        Navigator.of(context).pop();

                        if (profileUpdateAPIProvider.error) {
                          Utils.getSnackBar(
                              context, profileUpdateAPIProvider.errorMessage);
                        } else {
                          Utils.getSnackBar(
                              context,
                              profileUpdateAPIProvider
                                  .profileUpdateResponse!.message);
                          profileAPIProvider.getProfile();
                        }
                      }
                    }
                  }
                },
                child: Row(
                  children: [
                    Text(
                      "${translationAPiProvider.translationModel!.languageDetails![69]}",
                      style: CommonStyles.blue14900(),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    !edit
                        ? Icon(
                            Icons.edit,
                            size: 17,
                            color: Colors.indigo,
                          )
                        : Icon(
                            Icons.check,
                            size: 17,
                            color: Colors.green,
                          )
                  ],
                )),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: /* profileUpdateAPIProvider.ifLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 0.5,
                  ),
                )
              : */
              Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 20,
                  shadowColor: Colors.lightBlue,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                    child: Row(
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
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NameTextForm(
                                  nameController: nameController,
                                  nameKey: nameKey,
                                  edit: edit),
                              EmailTextForm(
                                  emailController: emailController,
                                  emailKey: emailKey,
                                  edit: edit),
                              MobileNoTextField(
                                  enabled: edit,
                                  mobileController: phoneNumberController,
                                  mobileKey: phoneNumberKey),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Utils.getSizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "${translationAPiProvider.translationModel!.languageDetails![71]}",
                    style: CommonStyles.blue14900(),
                    textAlign: TextAlign.center,
                  ),
                  if (edit)
                    InkWell(
                      onTap: () async {
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
                              context, "Getting Location");
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
                            latitude = result['latitude'].toString();
                            longitude = result['longitude'].toString();
                            selectedAddress = result['address'];
                            selectedPincode = result['pincode'];
                            locationProvided = true;
                          });
                        }
                      },
                      child: Card(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5),
                            child: Text(
                              translationAPiProvider
                                  .translationModel!.languageDetails![92],
                              style: CommonStyles.whiteText15BoldW500(),
                            ),
                          )),
                    )
                ],
              ),
              Utils.getSizedBox(height: 10),
              SizedBox(
                height: 70,
                child: Card(
                  elevation: 20,
                  shadowColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        selectedAddress.isEmpty
                            ? profileAPIProvider
                                .profileModel!.userDetails!.address!
                            : selectedAddress,
                        style: CommonStyles.black13(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Utils.getSizedBox(height: 20),
              Text(
                "${translationAPiProvider.translationModel!.languageDetails![72]}",
                style: CommonStyles.blue14900(),
                textAlign: TextAlign.center,
              ),
              Utils.getSizedBox(height: 10),
              SizedBox(
                height: 70,
                child: Card(
                  elevation: 20,
                  shadowColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: LandMarkTextForm(
                        edit: edit,
                        landMarkController: landMarkController,
                        landMarkKey: landMarkKey),
                  ),
                ),
              ),
              Utils.getSizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 20,
                  shadowColor: Colors.lightBlue,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${translationAPiProvider.translationModel!.languageDetails![73]}",
                          style: CommonStyles.blue14900(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AccountNumber(
                            accountNumberController: accountNoController,
                            accountNumberKey: accountNoKey,
                            edit: edit),
                        AccountName(
                            accountNameController: accountNameController,
                            accountNameKey: accountNameKey,
                            edit: edit),
                        AccountIFSC(
                            accountIFSCController: accountIFSCController,
                            accountIFSCKey: accountIFSCKey,
                            edit: edit)
                      ],
                    ),
                  ),
                ),
              ),
              Utils.getSizedBox(height: 20),
              Column(
                children: [
                  Text(
                    "${translationAPiProvider.translationModel!.languageDetails![74]}",
                    style: CommonStyles.blue14900(),
                    textAlign: TextAlign.center,
                  ),
                  Utils.getSizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 20),
                                child: aadharImage == null ||
                                        aadharImage!.path == File("").path
                                    ? GestureDetector(
                                        onTap: edit
                                            ? () async {
                                                aadharImage =
                                                    await imagePickerService
                                                        .chooseImageFile(
                                                            context);
                                                print("Pan Image ----Profile-" +
                                                    panImage.toString());
                                                setState(() {});
                                              }
                                            : null,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${profileAPIProvider.profileModel!.profileBaseurl}${profileAPIProvider.profileModel!.userDetails!.aadhaarImage!}",
                                        ),
                                      )
                                    : ProductImageBox(
                                        title: "Add Aadhar Image",
                                        circleRadius: 10,
                                        imageFile: aadharImage!,
                                        radius: 0,
                                        onPressed: () async {
                                          aadharImage = await imagePickerService
                                              .chooseImageFile(context);
                                          setState(() {});
                                        })),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 20),
                                child: aadharBackImage == null ||
                                        aadharBackImage!.path == File("").path
                                    ? GestureDetector(
                                        onTap: edit
                                            ? () async {
                                                aadharBackImage =
                                                    await imagePickerService
                                                        .chooseImageFile(
                                                            context);
                                                print("Pan Image ----Profile-" +
                                                    panImage.toString());
                                                setState(() {});
                                              }
                                            : null,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${profileAPIProvider.profileModel!.profileBaseurl}${profileAPIProvider.profileModel!.userDetails!.aadharBackImage!}",
                                        ),
                                      )
                                    : ProductImageBox(
                                        title: "Add Aadhar Back Image",
                                        circleRadius: 10,
                                        imageFile: aadharBackImage!,
                                        radius: 0,
                                        onPressed: () async {
                                          aadharBackImage =
                                              await imagePickerService
                                                  .chooseImageFile(context);
                                          setState(() {});
                                        })),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Utils.getSizedBox(height: 20),
              /*if (profileAPIProvider
                  .profileModel!.userDetails!.panImage!.isNotEmpty)*/
              Column(
                children: [
                  Text(
                    "${translationAPiProvider.translationModel!.languageDetails![75]}",
                    style: CommonStyles.blue14900(),
                    textAlign: TextAlign.center,
                  ),
                  Utils.getSizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 20,
                      shadowColor: Colors.lightBlue,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20),
                          child: panImage == null ||
                                  panImage!.path == File("").path
                              ? GestureDetector(
                                  onTap: edit
                                      ? () async {
                                          panImage = await imagePickerService
                                              .chooseImageFile(context);
                                          setState(() {});
                                        }
                                      : null,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${profileAPIProvider.profileModel!.profileBaseurl}${profileAPIProvider.profileModel!.userDetails!.panImage!}",
                                  ),
                                )
                              : ProductImageBox(
                                  title: "Add PAN Image",
                                  circleRadius: 10,
                                  imageFile: panImage!,
                                  radius: 0,
                                  onPressed: () async {
                                    panImage = await imagePickerService
                                        .chooseImageFile(context);
                                    setState(() {});
                                  })),
                    ),
                  ),
                ],
              ),
              Utils.getSizedBox(height: 20),
              /*if (profileAPIProvider
                  .profileModel!.userDetails!.panImage!.isNotEmpty)*/
              Column(
                children: [
                  Text(
                    "${translationAPiProvider.translationModel!.languageDetails![76]}",
                    style: CommonStyles.blue14900(),
                    textAlign: TextAlign.center,
                  ),
                  Utils.getSizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 20,
                      shadowColor: Colors.lightBlue,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20),
                          child: pcVerify == null ||
                                  pcVerify!.path == File("").path
                              ? GestureDetector(
                                  onTap: edit
                                      ? () async {
                                          pcVerify = await imagePickerService
                                              .chooseImageFile(context);
                                          setState(() {});
                                        }
                                      : null,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${profileAPIProvider.profileModel!.profileBaseurl}${profileAPIProvider.profileModel!.userDetails!.policeVerification!}",
                                  ),
                                )
                              : ProductImageBox(
                                  title: "Add Police Verification Image",
                                  circleRadius: 10,
                                  imageFile: pcVerify!,
                                  radius: 0,
                                  onPressed: () async {
                                    pcVerify = await imagePickerService
                                        .chooseImageFile(context);
                                    setState(() {});
                                  })),
                    ),
                  ),
                ],
              ),
              Utils.getSizedBox(height: 20),
              /*if (profileAPIProvider
                  .profileModel!.userDetails!.panImage!.isNotEmpty)*/
              Column(
                children: [
                  Text(
                    "${translationAPiProvider.translationModel!.languageDetails![77]}",
                    style: CommonStyles.blue14900(),
                    textAlign: TextAlign.center,
                  ),
                  Utils.getSizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 20,
                      shadowColor: Colors.lightBlue,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20),
                          child: dl == null || dl!.path == File("").path
                              ? GestureDetector(
                                  onTap: edit
                                      ? () async {
                                          dl = await imagePickerService
                                              .chooseImageFile(context);
                                          setState(() {});
                                        }
                                      : null,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${profileAPIProvider.profileModel!.profileBaseurl}${profileAPIProvider.profileModel!.userDetails!.driverLicense!}",
                                  ),
                                )
                              : ProductImageBox(
                                  title: "Add Police Verification Image",
                                  circleRadius: 10,
                                  imageFile: dl!,
                                  radius: 0,
                                  onPressed: () async {
                                    dl = await imagePickerService
                                        .chooseImageFile(context);
                                    setState(() {});
                                  })),
                    ),
                  ),
                ],
              ),
              Utils.getSizedBox(height: 50),
              NeumorphicButton(
                style: NeumorphicStyle(
                    color: Colors.lightBlueAccent, intensity: 30),
                onPressed: () {
                  /*  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ));*/
                },
                padding: EdgeInsets.all(15),
                child: Center(
                  child: Text(
                      "${translationAPiProvider.translationModel!.languageDetails![33]}",
                      style: CommonStyles.whiteText16BoldW500()),
                ),
              ),
              Utils.getSizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  String latitude = "", longitude = "", selectedAddress = "";
  String selectedPincode = "";
  bool locationProvided = false;

  File? aadharImage;
  File? aadharBackImage;
  File? panImage;
  File? pcVerify;
  File? dl;
}
