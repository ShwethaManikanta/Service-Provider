class PrimaryPostJobModel {
  String? status;
  String? message;
  UserDetails? userDetails;

  PrimaryPostJobModel({this.status, this.message, this.userDetails});

  PrimaryPostJobModel.fromJson(Map<String, dynamic> json) {
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
  String? jobType;
  String? userId;
  String? postUserName;
  String? postUserMobile;
  String? assignUserId;
  String? jobTitle;
  String? beforeJobImage;
  String? panCard;
  String? aadharCard;
  String? description;
  String? dateTime;
  String? payment;
  String? serviceTaxes;
  String? afterJobImage;
  String? address;
  String? lat;
  String? long;
  String? landmark;
  String? total;
  String? paymentMode;
  String? paidStatus;
  String? tripStatus;
  String? status;
  String? createdAt;
  String? updatedAt;

  UserDetails(
      {this.id,
      this.jobType,
      this.userId,
      this.postUserName,
      this.postUserMobile,
      this.assignUserId,
      this.jobTitle,
      this.beforeJobImage,
      this.panCard,
      this.aadharCard,
      this.description,
      this.dateTime,
      this.payment,
      this.serviceTaxes,
      this.afterJobImage,
      this.address,
      this.lat,
      this.long,
      this.landmark,
      this.total,
      this.paymentMode,
      this.paidStatus,
      this.tripStatus,
      this.status,
      this.createdAt,
      this.updatedAt});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobType = json['job_type'];
    userId = json['user_id'];
    postUserName = json['post_user_name'];
    postUserMobile = json['post_user_mobile'];
    assignUserId = json['assign_user_id'];
    jobTitle = json['job_title'];
    beforeJobImage = json['before_job_image'];
    panCard = json['pan_card'];
    aadharCard = json['aadhar_card'];
    description = json['description'];
    dateTime = json['date_time'];
    payment = json['payment'];
    serviceTaxes = json['service_taxes'];
    afterJobImage = json['after_job_image'];
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    landmark = json['landmark'];
    total = json['total'];
    paymentMode = json['payment_mode'];
    paidStatus = json['paid_status'];
    tripStatus = json['trip_status'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_type'] = this.jobType;
    data['user_id'] = this.userId;
    data['post_user_name'] = this.postUserName;
    data['post_user_mobile'] = this.postUserMobile;
    data['assign_user_id'] = this.assignUserId;
    data['job_title'] = this.jobTitle;
    data['before_job_image'] = this.beforeJobImage;
    data['pan_card'] = this.panCard;
    data['aadhar_card'] = this.aadharCard;
    data['description'] = this.description;
    data['date_time'] = this.dateTime;
    data['payment'] = this.payment;
    data['service_taxes'] = this.serviceTaxes;
    data['after_job_image'] = this.afterJobImage;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['landmark'] = this.landmark;
    data['total'] = this.total;
    data['payment_mode'] = this.paymentMode;
    data['paid_status'] = this.paidStatus;
    data['trip_status'] = this.tripStatus;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
