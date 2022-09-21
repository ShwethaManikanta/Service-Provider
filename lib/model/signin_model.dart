class SigninModel {
  String? status;
  String? message;
  String? userId;
  UserDetails? userDetails;

  SigninModel({this.status, this.message, this.userId, this.userDetails});

  SigninModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    userId = json['user_id'].toString();
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_id'] = this.userId.toString();
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
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
  String? password;
  String? decryptPassword;
  String? pwdOtp;
  String? dob;
  String? address;
  String? lat;
  String? long;
  String? landmark;
  String? aadhaarImage;
  String? panImage;
  String? aadharNumber;
  String? panNumber;
  String? deviceType;
  String? deviceToken;
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
      this.password,
      this.decryptPassword,
      this.pwdOtp,
      this.dob,
      this.address,
      this.lat,
      this.long,
      this.landmark,
      this.aadhaarImage,
      this.panImage,
      this.aadharNumber,
      this.panNumber,
      this.deviceType,
      this.deviceToken,
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
    password = json['password'];
    decryptPassword = json['decrypt password'];
    pwdOtp = json['pwd_otp'];
    dob = json['dob'];
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    landmark = json['landmark'];
    aadhaarImage = json['aadhaar_image'];
    panImage = json['pan_image'];
    aadharNumber = json['aadhar_number'];
    panNumber = json['pan_number'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
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
    data['password'] = this.password;
    data['decrypt password'] = this.decryptPassword;
    data['pwd_otp'] = this.pwdOtp;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['landmark'] = this.landmark;
    data['aadhaar_image'] = this.aadhaarImage;
    data['pan_image'] = this.panImage;
    data['aadhar_number'] = this.aadharNumber;
    data['pan_number'] = this.panNumber;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
