class ImageModel {
  final String url;

  ImageModel({required this.url});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'] as String,
    );
  }
}
