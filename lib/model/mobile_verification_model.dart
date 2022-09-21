class MobileOTPModel {
  String? status;
  String? message;
  String? mobileOtp;

  MobileOTPModel({this.status, this.message, this.mobileOtp});

  MobileOTPModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    mobileOtp = json['mobile_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['mobile_otp'] = this.mobileOtp;
    return data;
  }
}
