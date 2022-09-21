class BannerModel {
  String? status;
  String? message;
  String? bannerUrl;
  List<BannerList>? bannerList;

  BannerModel({this.status, this.message, this.bannerUrl, this.bannerList});

  BannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    bannerUrl = json['banner_url'];
    if (json['banner_list'] != null) {
      bannerList = <BannerList>[];
      json['banner_list'].forEach((v) {
        bannerList!.add(new BannerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['banner_url'] = this.bannerUrl;
    if (this.bannerList != null) {
      data['banner_list'] = this.bannerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerList {
  String? id;
  String? title;
  String? bannerImage;
  String? status;
  String? createdAt;

  BannerList(
      {this.id, this.title, this.bannerImage, this.status, this.createdAt});

  BannerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    bannerImage = json['banner_image'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['banner_image'] = this.bannerImage;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}
