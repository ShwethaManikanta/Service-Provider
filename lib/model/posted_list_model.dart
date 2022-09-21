class PostJobListModel {
  String? status;
  String? message;
  String? beforeImageUrl;
  String? afterImageUrl;
  String? userImageUrl;
  List<PostJobsList>? postJobsList;

  PostJobListModel(
      {this.status,
      this.message,
      this.beforeImageUrl,
      this.afterImageUrl,
      this.userImageUrl,
      this.postJobsList});

  PostJobListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    beforeImageUrl = json['before_image_url'];
    afterImageUrl = json['after_image_url'];
    userImageUrl = json['user_image_url'];
    if (json['post_jobs_list'] != null) {
      postJobsList = <PostJobsList>[];
      json['post_jobs_list'].forEach((v) {
        postJobsList!.add(new PostJobsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['before_image_url'] = this.beforeImageUrl;
    data['after_image_url'] = this.afterImageUrl;
    data['user_image_url'] = this.userImageUrl;
    if (this.postJobsList != null) {
      data['post_jobs_list'] =
          this.postJobsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostJobsList {
  String? id;
  String? postOtp;
  String? jobType;
  String? userId;
  String? postUserName;
  String? postUserMobile;
  String? assignUserId;
  String? jobTitle;
  List<String>? beforeJobImage;
  String? description;
  String? dateTime;
  String? fromDatetime;
  String? toDatetime;
  List<String>? afterJobImage;
  String? address;
  String? lat;
  String? long;
  String? landmark;
  String? workerCm;
  String? adminCm;
  String? gstTax;
  String? total;
  String? tripStatus;
  String? mobile;
  String? userName;
  WorkUserDetails? workUserDetails;

  PostJobsList(
      {this.id,
      this.postOtp,
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
      this.tripStatus,
      this.mobile,
      this.userName,
      this.workUserDetails});

  PostJobsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postOtp = json['post_otp'];
    jobType = json['job_type'];
    userId = json['user_id'];
    postUserName = json['post_user_name'];
    postUserMobile = json['post_user_mobile'];
    assignUserId = json['assign_user_id'];
    jobTitle = json['job_title'];
    beforeJobImage = json['before_job_image'].cast<String>();
    description = json['description'];
    dateTime = json['date_time'];
    fromDatetime = json['from_datetime'];
    toDatetime = json['to_datetime'];
    afterJobImage = json['after_job_image'].cast<String>();
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    landmark = json['landmark'];
    workerCm = json['worker_cm'];
    adminCm = json['admin_cm'];
    gstTax = json['gst_tax'];
    total = json['total'];
    tripStatus = json['trip_status'];
    mobile = json['mobile'];
    userName = json['user_name'];
    workUserDetails = json['work_user_details'] != null
        ? new WorkUserDetails.fromJson(json['work_user_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_otp'] = this.postOtp;
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
    data['trip_status'] = this.tripStatus;
    data['mobile'] = this.mobile;
    data['user_name'] = this.userName;
    if (this.workUserDetails != null) {
      data['work_user_details'] = this.workUserDetails!.toJson();
    }
    return data;
  }
}

class WorkUserDetails {
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
  String? jobPostStatus;
  String? status;
  String? createdAt;
  String? updatedAt;

  WorkUserDetails(
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
      this.jobPostStatus,
      this.status,
      this.createdAt,
      this.updatedAt});

  WorkUserDetails.fromJson(Map<String, dynamic> json) {
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
