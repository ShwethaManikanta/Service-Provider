class TranslationModel {
  String? status;
  String? message;
  List<String>? languageDetails;

  TranslationModel({this.status, this.message, this.languageDetails});

  TranslationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    languageDetails = json['language_details'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['language_details'] = this.languageDetails;
    return data;
  }
}
