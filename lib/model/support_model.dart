class SupportModel {
  String? status;
  String? message;
  UserDetails? userDetails;

  SupportModel({this.status, this.message, this.userDetails});

  SupportModel.fromJson(Map<String, dynamic> json) {
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
  String? transactionId;
  String? payId;
  String? jobType;
  String? userId;
  String? postUserName;
  String? postUserMobile;
  String? assignUserId;
  String? jobTitle;
  String? beforeJobImage;
  String? subject;
  String? jobDescription;
  String? description;
  String? dateTime;
  String? fromDatetime;
  String? toDatetime;
  String? afterJobImage;
  String? address;
  String? lat;
  String? long;
  String? landmark;
  String? workerCm;
  String? adminCm;
  String? gstTax;
  String? withoutTax;
  String? total;
  String? paymentMode;
  String? paidStatus;
  String? ongoingStatus;
  String? tripStatus;
  String? status;
  String? createdAt;
  String? updatedAt;

  UserDetails(
      {this.id,
      this.transactionId,
      this.payId,
      this.jobType,
      this.userId,
      this.postUserName,
      this.postUserMobile,
      this.assignUserId,
      this.jobTitle,
      this.beforeJobImage,
      this.subject,
      this.jobDescription,
      this.description,
      this.dateTime,
      this.fromDatetime,
      this.toDatetime,
      this.afterJobImage,
      this.address,
      this.lat,
      this.long,
      this.landmark,
      this.workerCm,
      this.adminCm,
      this.gstTax,
      this.withoutTax,
      this.total,
      this.paymentMode,
      this.paidStatus,
      this.ongoingStatus,
      this.tripStatus,
      this.status,
      this.createdAt,
      this.updatedAt});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    payId = json['pay_id'];
    jobType = json['job_type'];
    userId = json['user_id'];
    postUserName = json['post_user_name'];
    postUserMobile = json['post_user_mobile'];
    assignUserId = json['assign_user_id'];
    jobTitle = json['job_title'];
    beforeJobImage = json['before_job_image'];
    subject = json['subject'];
    jobDescription = json['job_description'];
    description = json['description'];
    dateTime = json['date_time'];
    fromDatetime = json['from_datetime'];
    toDatetime = json['to_datetime'];
    afterJobImage = json['after_job_image'];
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    landmark = json['landmark'];
    workerCm = json['worker_cm'];
    adminCm = json['admin_cm'];
    gstTax = json['gst_tax'];
    withoutTax = json['without_tax'];
    total = json['total'];
    paymentMode = json['payment_mode'];
    paidStatus = json['paid_status'];
    ongoingStatus = json['ongoing_status'];
    tripStatus = json['trip_status'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_id'] = this.transactionId;
    data['pay_id'] = this.payId;
    data['job_type'] = this.jobType;
    data['user_id'] = this.userId;
    data['post_user_name'] = this.postUserName;
    data['post_user_mobile'] = this.postUserMobile;
    data['assign_user_id'] = this.assignUserId;
    data['job_title'] = this.jobTitle;
    data['before_job_image'] = this.beforeJobImage;
    data['subject'] = this.subject;
    data['job_description'] = this.jobDescription;
    data['description'] = this.description;
    data['date_time'] = this.dateTime;
    data['from_datetime'] = this.fromDatetime;
    data['to_datetime'] = this.toDatetime;
    data['after_job_image'] = this.afterJobImage;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['landmark'] = this.landmark;
    data['worker_cm'] = this.workerCm;
    data['admin_cm'] = this.adminCm;
    data['gst_tax'] = this.gstTax;
    data['without_tax'] = this.withoutTax;
    data['total'] = this.total;
    data['payment_mode'] = this.paymentMode;
    data['paid_status'] = this.paidStatus;
    data['ongoing_status'] = this.ongoingStatus;
    data['trip_status'] = this.tripStatus;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
