import 'dart:convert';
import 'dart:io';

class ImageUploadModel {
  String? fileType;
  File? fileName;
  ImageUploadModel({
    required this.fileName,
    required this.fileType,
  });

  ImageUploadModel copyWith({
    String? fileType,
    File? fileName,
  }) {
    return ImageUploadModel(
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'file_name': fileName,
      'file_type': fileType,
    };
  }

  factory ImageUploadModel.fromMap(Map<String, dynamic>? map) {
    return ImageUploadModel(
      fileName: map?['file_name'],
      fileType: map?['file_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageUploadModel.fromJson(String source) =>
      ImageUploadModel.fromMap(json.decode(source));

  @override
  String toString() => 'SignUpRequest(file_type: $fileType)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ImageUploadModel &&
        o.fileName == fileName &&
        o.fileType == fileType;
  }

  @override
  int get hashCode => fileName.hashCode ^ fileType.hashCode;
}

class ImageResponse {
  late String? fileUrl;
  late String? fileName;
  late String status;
  late String message;

  ImageResponse(
      {required this.fileUrl,
      required this.fileName,
      required this.status,
      required this.message});

  ImageResponse.fromJson(Map<String, dynamic> json) {
    if (json['file_url'] != null) {
      fileUrl = json['file_url'];
      fileName = json['file_name'];
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['file_url'] = fileUrl;
    data['file_name'] = fileName;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
