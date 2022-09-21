class PrimaryJobModel {
  String? status;
  String? message;
  String? beforeImageUrl;
  String? afterImageUrl;
  String? userImageUrl;
  List<PrimaryJobList>? primaryJobList;

  PrimaryJobModel(
      {this.status,
      this.message,
      this.beforeImageUrl,
      this.afterImageUrl,
      this.userImageUrl,
      this.primaryJobList});

  PrimaryJobModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    beforeImageUrl = json['before_image_url'];
    afterImageUrl = json['after_image_url'];
    userImageUrl = json['user_image_url'];
    if (json['primary_job_list'] != null) {
      primaryJobList = <PrimaryJobList>[];
      json['primary_job_list'].forEach((v) {
        primaryJobList!.add(new PrimaryJobList.fromJson(v));
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
    if (this.primaryJobList != null) {
      data['primary_job_list'] =
          this.primaryJobList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrimaryJobList {
  String? id;
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
  String? aadharNumber;
  Null? workUserDetails;

  PrimaryJobList(
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
      this.tripStatus,
      this.mobile,
      this.userName,
      this.aadharNumber,
      this.workUserDetails});

  PrimaryJobList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    aadharNumber = json['aadhar_number'];
    workUserDetails = json['work_user_details'];
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
    data['trip_status'] = this.tripStatus;
    data['mobile'] = this.mobile;
    data['user_name'] = this.userName;
    data['aadhar_number'] = this.aadharNumber;
    data['work_user_details'] = this.workUserDetails;
    return data;
  }
}
