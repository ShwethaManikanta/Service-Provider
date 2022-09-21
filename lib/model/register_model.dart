class RegisterModel {
  String? status;
  String? message;
  UserDetails? userDetails;

  RegisterModel({this.status, this.message, this.userDetails});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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
  String? address;
  String? lat;
  String? long;
  String? landmark;
  String? aadhaarImage;
  String? panImage;
  String? aadharBackImage;
  String? accountNumber;
  String? accountIfsc;
  String? accountHolder;
  String? deviceType;
  String? deviceToken;
  String? profileUpdateStatus;
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
      this.accountNumber,
      this.accountIfsc,
      this.accountHolder,
      this.deviceType,
      this.deviceToken,
      this.profileUpdateStatus,
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
    aadharBackImage = json['aadhar_back_image'];
    accountNumber = json['account_number'];
    accountIfsc = json['account_ifsc'];
    accountHolder = json['account_holder'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    profileUpdateStatus = json['profile_update_status'];
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
    data['aadhar_back_image'] = this.aadharBackImage;
    data['account_number'] = this.accountNumber;
    data['account_ifsc'] = this.accountIfsc;
    data['account_holder'] = this.accountHolder;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['profile_update_status'] = this.profileUpdateStatus;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
