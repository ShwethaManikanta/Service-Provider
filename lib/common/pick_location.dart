import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;

class PickLocationGoogleMapsScreen extends StatefulWidget {
  const PickLocationGoogleMapsScreen(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  final double? latitude, longitude;

  @override
  _PlacePickGoogleMapsState createState() => _PlacePickGoogleMapsState();
}

class _PlacePickGoogleMapsState extends State<PickLocationGoogleMapsScreen> {
  Location location = Location();

  TextEditingController controllerAddress = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  late LatLng latLngCamera;

  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;

  @override
  void initState() {
    print("Init state pronted");
    super.initState();
    latLngCamera = LatLng(widget.latitude!, widget.longitude!);

    print(latLngCamera.latitude.toString() +
        "Lat long camera" +
        latLngCamera.longitude.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  bool _isWidgetLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SizedBox(
            height: deviceHeight(context),
            width: deviceWidth(context),
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: LatLng(latLngCamera.latitude, latLngCamera.longitude),
                  zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                getJsonFile("assets/mapStyle.json")
                    .then((value) => controller.setMapStyle(value));
                _controller.complete(controller);
                mapController = controller;
              },
              onCameraIdle: () {
                setState(() {
                  _isWidgetLoading = false;
                });
              },
              onCameraMove: (value) {
                latLngCamera = value.target;
              },
              onCameraMoveStarted: () {
                setState(() {
                  _isWidgetLoading = true;
                });
              },
            ),
          ),
          Positioned(
            top: (deviceHeight(context) - 35 - 35) / 2,
            right: (deviceWidth(context) - 40) / 2,
            child: const Align(
              alignment: Alignment.center,
              child: Icon(
                FontAwesomeIcons.mapPin,
                color: Colors.blue,
                size: 35,
              ),
            ),
          ),
          goToLocationMap(),
          Positioned(
              top: 50.0,
              right: 15.0,
              left: 15.0,
              child: _isWidgetLoading
                  ? Container(
                      height: 100,
                      width: deviceWidth(context) * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 1, color: Colors.amber),
                          color: Colors.blue),
                      child: const Center(
                        child: SizedBox(
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.white,
                          ),
                          width: 25,
                        ),
                      ),
                    )
                  : ReverseGeoCodingTextFormField(
                      latitude: latLngCamera.latitude,
                      longitude: latLngCamera.longitude,
                      controllerAddress: controllerAddress,
                      pincodeController: pincodeController,
                    ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        onPressed: _isWidgetLoading
            ? () {}
            : () async {
                // Navigator.pushNamed(context, 'RentelPackages');
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => BookVehiclePage(
                //           toLatitude: latLngCamera.latitude,
                //           toLongitude: latLngCamera.longitude,
                //           address: controllerAddress.text,
                //         )));
                Map<String, dynamic> mapValue = {
                  'latitude': latLngCamera.latitude,
                  'longitude': latLngCamera.longitude,
                  'address': controllerAddress.text,
                  'pincode': pincodeController.text
                };
                Navigator.of(context).pop(mapValue);

                // Navigator.of(context).pop(EditCartAddressRequestModel(
                //     userId: ApiService.userID!,
                //     address: controllerAddress.text,
                //     latitude: latLngCamera.latitude.toString(),
                //     longitude: latLngCamera.longitude.toString()));
                // setState(() {
                //   _goToTheLake(latLngCamera.latitude, latLngCamera.longitude);
                // });
              },
        tooltip: 'Press to Select Location',
        label: Text(
          "Select Location",
          style: CommonStyles.whiteText15BoldW500(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  final globalFormKey = GlobalKey<FormState>();

  enterNameAndPhoneNumber() {
    return Form(
      key: globalFormKey,
      child: Column(
        children: [
          TextFormField(),
          TextFormField(),
        ],
      ),
    );
  }

  goToLocationMap() {
    // final homePageProvider = Provider.of<HomePageProvider>(context);

    // if (_list == null ||
    //     homePageProvider.state == HomePageProviderState.Uninitialized) {
    //   return const Center(
    //     child: SizedBox(
    //       height: 25,
    //       width: 25,
    //       child: CircularProgressIndicator(
    //         strokeWidth: 1,
    //       ),
    //     ),
    //   );
    // }

    return Positioned(
      top: (deviceHeight(context) - 35 - 35 - 60) / 2,
      right: 10,
      child: Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(widget.latitude!, widget.longitude!),
                    zoom: 15),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 110, 3, 3),
                border: Border.all(color: Colors.blue)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.my_location_outlined,
                color: Colors.white.withOpacity(0.95),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReverseGeoCodingTextFormField extends StatefulWidget {
  const ReverseGeoCodingTextFormField({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.controllerAddress,
    required this.pincodeController,
  }) : super(key: key);
  final double latitude, longitude;
  final TextEditingController controllerAddress;
  final TextEditingController pincodeController;
  @override
  _ReverseGeoCodingTextFormFieldState createState() =>
      _ReverseGeoCodingTextFormFieldState();
}

class _ReverseGeoCodingTextFormFieldState
    extends State<ReverseGeoCodingTextFormField> {
  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    await geoCoding.GeocodingPlatform.instance
        .placemarkFromCoordinates(widget.latitude, widget.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: deviceWidth(context) * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: Colors.amber),
          color: Colors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Location From Map",
              style: CommonStyles.whiteText15BoldW500(),
            ),
          ),
          FutureBuilder<List<geoCoding.Placemark>>(
              future: geoCoding.GeocodingPlatform.instance
                  .placemarkFromCoordinates(widget.latitude, widget.longitude),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                  );
                }
                if (snapshot.data != null) {
                  widget.controllerAddress.text = snapshot.data!.first.street! +
                      " " +
                      snapshot.data!.first.subLocality! +
                      ", " +
                      snapshot.data!.first.locality! +
                      ", " +
                      /*snapshot.data!.first.postalCode! +
                      ", " +*/
                      snapshot.data!.first.administrativeArea!;

                  widget.pincodeController.text =
                      snapshot.data!.first.postalCode!;
                  print(
                      "PINCODE =========== .      >>>>>>>>>>>>${widget.pincodeController.text}");
                  final url = "https://www.google.co.in/maps/@" +
                      widget.latitude.toString() +
                      "," +
                      widget.longitude.toString() +
                      ",19z";
                  print(url);
                } else {
                  widget.controllerAddress.text = "No Address Found";
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Text(
                          "${widget.controllerAddress.text} - ${widget.pincodeController.text}",
                          style: CommonStyles.whiteText15BoldW500(),
                        ),
                      ),
                    ),
                    /* Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SingleChildScrollView(
                        child: Text(
                          "Pincode : " + widget.pincodeController.text,
                          style: CommonStyles.textDataWhite15(),
                        ),
                      ),
                    ),*/
                  ],
                );
              }),
        ],
      ),
    );
  }
}
