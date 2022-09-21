class PostViewModel {
  String? status;
  String? message;
  String? beforeImageUrl;
  String? afterImageUrl;
  String? userImageUrl;
  OrderDetails? orderDetails;

  PostViewModel(
      {this.status,
      this.message,
      this.beforeImageUrl,
      this.afterImageUrl,
      this.userImageUrl,
      this.orderDetails});

  PostViewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    beforeImageUrl = json['before_image_url'];
    afterImageUrl = json['after_image_url'];
    userImageUrl = json['user_image_url'];
    orderDetails = json['order_details'] != null
        ? new OrderDetails.fromJson(json['order_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['before_image_url'] = this.beforeImageUrl;
    data['after_image_url'] = this.afterImageUrl;
    data['user_image_url'] = this.userImageUrl;
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails!.toJson();
    }
    return data;
  }
}

class OrderDetails {
  String? id;
  String? jobType;
  String? userId;
  String? postUserName;
  String? postUserMobile;
  String? assignUserId;
  String? jobTitle;
  String? beforeJobImage;
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
  String? total;
  String? paymentMode;
  String? paidStatus;
  String? tripStatus;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? mobile;
  String? userName;
  String? aadharNumber;

  OrderDetails(
      {this.id,
      this.jobType,
      this.userId,
      this.postUserName,
      this.postUserMobile,
      this.assignUserId,
      this.jobTitle,
      this.beforeJobImage,
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
      this.total,
      this.paymentMode,
      this.paidStatus,
      this.tripStatus,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.mobile,
      this.userName,
      this.aadharNumber});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobType = json['job_type'];
    userId = json['user_id'];
    postUserName = json['post_user_name'];
    postUserMobile = json['post_user_mobile'];
    assignUserId = json['assign_user_id'];
    jobTitle = json['job_title'];
    beforeJobImage = json['before_job_image'];
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
    total = json['total'];
    paymentMode = json['payment_mode'];
    paidStatus = json['paid_status'];
    tripStatus = json['trip_status'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    mobile = json['mobile'];
    userName = json['user_name'];
    aadharNumber = json['aadhar_number'];
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
    data['total'] = this.total;
    data['payment_mode'] = this.paymentMode;
    data['paid_status'] = this.paidStatus;
    data['trip_status'] = this.tripStatus;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['mobile'] = this.mobile;
    data['user_name'] = this.userName;
    data['aadhar_number'] = this.aadharNumber;
    return data;
  }
}
