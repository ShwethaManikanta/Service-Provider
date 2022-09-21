class ContentTranslationModel {
  String? status;
  String? message;
  String? languageContent;

  ContentTranslationModel({this.status, this.message, this.languageContent});

  ContentTranslationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    languageContent = json['language_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['language_content'] = this.languageContent;
    return data;
  }
}
