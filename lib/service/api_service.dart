import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serviceprovider/model/accept_reject_model.dart';
import 'package:serviceprovider/model/classical_job_post_model.dart';
import 'package:serviceprovider/model/content_translation_model.dart';
import 'package:serviceprovider/model/image_upload_model.dart';
import 'package:serviceprovider/model/mobile_verification_model.dart';
import 'package:serviceprovider/model/primary_post_job_model.dart';
import 'package:serviceprovider/model/register_model.dart';
import 'package:serviceprovider/model/signin_model.dart';
import 'package:path/path.dart';
import 'package:serviceprovider/model/support_model.dart';


APIService apiService = APIService();

class APIService {
  static String? userId;
  static String? deviceToken;
  static String lanKey = "en";

  Future<PrimaryPostJobModel?> primaryPost(
    String jobTitle,
    String before_image,
    String description,
    String address,
    String date,
    String time,
    String lat,
    String long,
    String payment,
  ) async {
    Uri url = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/post_job");
    http.Response response = await http.post(url, body: {
      "user_id": APIService.userId,
      "job_title": jobTitle,
      "before_job_image": before_image,
      "description": description,
      "address": address,
      "date": date,
      "time": time,
      "lat": lat,
      "long": long,
      "payment": payment,
    });
    print(response.statusCode);
    print(response.body);
    print("---------------------------------------");
    print("Response code " + response.statusCode.toString());
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse.toString());
    PrimaryPostJobModel _primaryPostJobModel =
        PrimaryPostJobModel.fromJson(jsonResponse);
    return _primaryPostJobModel;
  }

  Future<ClassicalPostJobModel?> classicPost(
    String jobTitle,
    String before_image,
    String description,
    String address,
    String fromDate,
    String fromTime,
    String toDate,
    String toTime,
    String lat,
    String long,
    String payment,
  ) async {
    Uri url = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/classical_post_job");
    http.Response response = await http.post(url, body: {
      "user_id": APIService.userId,
      "job_title": jobTitle,
      "before_job_image": before_image,
      "description": description,
      "address": address,
      "from_date": fromDate,
      "from_time": fromTime,
      "to_date": toDate,
      "to_time": toTime,
      "lat": lat,
      "long": long,
      "payment": payment,
    });
    print(response.statusCode);
    print(response.body);
    print("---------------------------------------");
    print("Response code " + response.statusCode.toString());
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse.toString());
    ClassicalPostJobModel _classicalPosjobModel =
        ClassicalPostJobModel.fromJson(jsonResponse);
    return _classicalPosjobModel;
  }

  Future<RegisterModel?> register(
    String countryId,
    String languageId,
    String mobileNo,
    String deviceToken,
  ) async {
    Uri url =
        Uri.parse("https://chillkrt.in/service_provider/index.php/Api/reg");
    http.Response response = await http.post(url, body: {
      "country_id": APIService.userId,
      "language_id": languageId,
      "mobile_no": mobileNo,
      "device_token": deviceToken,
    });
    print(response.statusCode);
    print(response.body);
    print("---------------------------------------");
    print("Response code " + response.statusCode.toString());
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse.toString());
    RegisterModel _registerModel = RegisterModel.fromJson(jsonResponse);
    return _registerModel;
  }

  Future<AcceptRejectModel?> getApplyJob(String orderID, String status) async {
    Uri url = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/assign_job_user");
    http.Response response = await http.post(url, body: {
      "accepted_user_id": APIService.userId,
      "order_id": orderID,
      "status": status
    });
    print(response.statusCode);
    print(response.body);
    print("---------------------------------------");
    print("Response code " + response.statusCode.toString());
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse.toString());
    AcceptRejectModel _acceptRejectModel =
        AcceptRejectModel.fromJson(jsonResponse);
    return _acceptRejectModel;
  }

  Future<MobileOTPModel?> getOTP(String mobileNumber) async {
    Uri url = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/mobileVerification");
    http.Response response =
        await http.post(url, body: {"mobile_no": mobileNumber});
    print(response.statusCode);
    print(response.body);
    print("---------------------------------------");
    print("Response code " + response.statusCode.toString());
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse.toString());
    MobileOTPModel _mobileOTP = MobileOTPModel.fromJson(jsonResponse);
    return _mobileOTP;
  }

  Future<SigninModel?> getSignin(
      String mobileNumber, String deviceToken) async {
    Uri url =
        Uri.parse("https://chillkrt.in/service_provider/index.php/Api/signIn");
    http.Response response = await http.post(url,
        body: {"mobile_no": mobileNumber, "device_token": deviceToken});
    print(response.statusCode);
    print(response.body);

    var jsonResponse = jsonDecode(response.body);

    SigninModel _signinModel = SigninModel.fromJson(jsonResponse);
    return _signinModel;
  }

  Future<ContentTranslationModel?> getTranslationWord(String content) async {
    Uri url = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/content_transalation");
    http.Response response = await http.post(url,
        body: {"lan_key": APIService.lanKey, "content": "ftgbsduhfb"});
    print(response.statusCode.toString());
    print(response.body.toString());
    print("---------------------------------------");
    print("Response code Content translate --------- " +
        response.statusCode.toString());
    var jsonResponse = jsonDecode(response.body);
    print("Content Translate" + jsonResponse.toString());
    ContentTranslationModel _contentTranslationModel =
        ContentTranslationModel.fromJson(jsonResponse);
    return _contentTranslationModel;
  }

  // Do Upload Method

  Future<ImageResponse> uploadImages(
      ImageUploadModel uploadImageService) async {
    var stream = http.ByteStream(
        Stream.castFrom(uploadImageService.fileName!.openRead()));

    var length = await uploadImageService.fileName!.length();

    Uri url = Uri.parse(
        'https://chillkrt.in/service_provider/index.php/Api/doupload');
    var request = http.MultipartRequest("POST", url);
    request.fields['file_type'] = uploadImageService.fileType!;
    var multipartFile = http.MultipartFile("file_name", stream, length,
        filename: basename(uploadImageService.fileName!.path));
    request.files.add(multipartFile);

    final response = await request.send();
    final respStr = await http.Response.fromStream(response);
    print("The response body   " + respStr.body);

    final jsonResponse = jsonDecode(respStr.body);

    ImageResponse imageResponseModel = ImageResponse.fromJson(jsonResponse);

    return imageResponseModel;
  }

  Future<SupportModel?> getSupport(
      String subject, String jobDescription) async {
    Uri url =
        Uri.parse("https://chillkrt.in/service_provider/index.php/Api/support");
    http.Response response = await http.post(url, body: {
      "user_id": APIService.userId,
      "subject": subject,
      "job_description": jobDescription
    });
    print(response.statusCode);
    print(response.body);
    print("---------------------------------------");
    print("Response code " + response.statusCode.toString());
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse.toString());
    SupportModel _supportModel = SupportModel.fromJson(jsonResponse);
    return _supportModel;
  }

  Future<AcceptRejectModel?> payForJob(
      String postId, String transactionId, String amount) async {
    Uri url = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/add_pay_user_details");
    http.Response response = await http.post(url, body: {
      "user_id": APIService.userId,
      "post_id": postId,
      "transaction_id": transactionId,
      "amount": amount
    });
    print(response.statusCode);
    print(response.body);
    print("---------------------------------------");
    print("Response code " + response.statusCode.toString());
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse.toString());
    AcceptRejectModel _acceptRejectModel =
        AcceptRejectModel.fromJson(jsonResponse);
    return _acceptRejectModel;
  }

  Future<AcceptRejectModel?> getOTPCompletedJob(
      String postId, String otp) async {
    Uri url = Uri.parse(
        "https://chillkrt.in/service_provider/index.php/Api/otp_verify");
    http.Response response =
        await http.post(url, body: {"post_id": postId, "otp": otp});
    print(response.statusCode);
    print(response.body);
    print("---------------------------------------");
    print("Response code " + response.statusCode.toString());
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse.toString());
    AcceptRejectModel _acceptRejectModel =
        AcceptRejectModel.fromJson(jsonResponse);
    return _acceptRejectModel;
  }
}
