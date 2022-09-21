class ProfileModel {
  String? status;
  String? message;
  String? userId;
  String? walletAmount;
  List<WalletDetails>? walletDetails;
  UserDetails? userDetails;
  String? profileBaseurl;

  ProfileModel(
      {this.status,
      this.message,
      this.userId,
      this.walletAmount,
      this.walletDetails,
      this.userDetails,
      this.profileBaseurl});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    walletAmount = json['wallet_amount'];
    if (json['wallet_details'] != null) {
      walletDetails = <WalletDetails>[];
      json['wallet_details'].forEach((v) {
        walletDetails!.add(new WalletDetails.fromJson(v));
      });
    }
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
    profileBaseurl = json['profile_baseurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['wallet_amount'] = this.walletAmount;
    if (this.walletDetails != null) {
      data['wallet_details'] =
          this.walletDetails!.map((v) => v.toJson()).toList();
    }
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    data['profile_baseurl'] = this.profileBaseurl;
    return data;
  }
}

class WalletDetails {
  String? id;
  String? serviceUser;
  String? orderId;
  String? amount;
  String? status;
  String? createdAt;
  String? updateAt;

  WalletDetails(
      {this.id,
      this.serviceUser,
      this.orderId,
      this.amount,
      this.status,
      this.createdAt,
      this.updateAt});

  WalletDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceUser = json['service_user'];
    orderId = json['order_id'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_user'] = this.serviceUser;
    data['order_id'] = this.orderId;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['update_at'] = this.updateAt;
    return data;
  }
}

class UserDetails {
  String? id;
  String? languageType;
  String? countryId;
  String? userName;
  String? mobile;
  String? email;
  String? address;
  String? lat;
  String? long;
  String? landmark;
  String? aadhaarImage;
  String? panImage;
  String? aadharBackImage;
  String? policeVerification;
  String? driverLicense;
  String? accountNumber;
  String? accountIfsc;
  String? accountHolder;
  String? deviceType;
  String? deviceToken;
  String? profileUpdateStatus;
  String? jobPostStatus;
  String? status;
  String? createdAt;
  String? updatedAt;

  UserDetails(
      {this.id,
      this.languageType,
      this.countryId,
      this.userName,
      this.mobile,
      this.email,
      this.address,
      this.lat,
      this.long,
      this.landmark,
      this.aadhaarImage,
      this.panImage,
      this.aadharBackImage,
      this.policeVerification,
      this.driverLicense,
      this.accountNumber,
      this.accountIfsc,
      this.accountHolder,
      this.deviceType,
      this.deviceToken,
      this.profileUpdateStatus,
      this.jobPostStatus,
      this.status,
      this.createdAt,
      this.updatedAt});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageType = json['language_type'];
    countryId = json['country_id'];
    userName = json['user_name'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    landmark = json['landmark'];
    aadhaarImage = json['aadhaar_image'];
    panImage = json['pan_image'];
    policeVerification = json['police_verification'];
    driverLicense = json['driver_license'];
    aadharBackImage = json['aadhar_back_image'];
    accountNumber = json['account_number'];
    accountIfsc = json['account_ifsc'];
    accountHolder = json['account_holder'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    profileUpdateStatus = json['profile_update_status'];
    jobPostStatus = json['job_post_status'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language_type'] = this.languageType;
    data['country_id'] = this.countryId;
    data['user_name'] = this.userName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['landmark'] = this.landmark;
    data['aadhaar_image'] = this.aadhaarImage;
    data['pan_image'] = this.panImage;
    data['police_verification'] = this.policeVerification;
    data['driver_license'] = this.driverLicense;
    data['aadhar_back_image'] = this.aadharBackImage;
    data['account_number'] = this.accountNumber;
    data['account_ifsc'] = this.accountIfsc;
    data['account_holder'] = this.accountHolder;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['profile_update_status'] = this.profileUpdateStatus;
    data['job_post_status'] = this.jobPostStatus;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ProfileUpdateResponseModel {
  late String status;
  late String message;
  late UserDetails? userDetails;

  ProfileUpdateResponseModel(
      {required this.status, required this.message, required this.userDetails});

  ProfileUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (userDetails != null) {
      data['user_details'] = userDetails!.toJson();
    }
    return data;
  }
}

class ProfileUpdateRequestModel {
  final String userId,
      email,
      userName,
      mobile,
      location,
      address,
      aadhaarFrontImage,
      aadhaarBackImage,
      panImage,
      accountNumber,
      accountIFSC,
      accountHolder,
      policeVerification,
      dl;

  ProfileUpdateRequestModel(
      {required this.userId,
      required this.email,
      required this.userName,
      required this.mobile,
      required this.location,
      required this.address,
      required this.aadhaarFrontImage,
      required this.aadhaarBackImage,
      required this.panImage,
      required this.accountIFSC,
      required this.accountNumber,
      required this.accountHolder,
      required this.policeVerification,
      required this.dl});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'mobile': mobile,
      'user_name': userName,
      'email': email,
      'landmark': location,
      'address': address,
      'aadhaar_image': aadhaarFrontImage,
      'aadhar_back_image': aadhaarBackImage,
      'pan_image': panImage,
      'account_number': accountNumber,
      'account_ifsc': accountIFSC,
      'account_holder': accountHolder,
      'police_verification': policeVerification,
      'driver_license': dl,
    };
  }

  String toString() {
    return "User ID = $userId,"
        " Mobile = $mobile,"
        " UserName = $userName,"
        " email = $email, "
        "landmark = $location,"
        " address = $address,"
        "aadhaar_image= $aadhaarFrontImage,"
        "aadhar_back_image = $aadhaarBackImage,"
        " panImage = $panImage,"
        "account_number= $accountNumber,"
        "account_ifsc = $accountIFSC,"
        "account_holder = $accountHolder,"
        "police_verification = $policeVerification,"
        "driver_license = $dl";
  }
}
