import 'dart:convert';
import 'package:http/http.dart' as http;
import 'image_model.dart';

String apiKey =
    'live_4SVYc2ZmWrRkkDlhTeSoC4DfbXilUD4JiZZ1gn2rXFYrx4a4hyNkX3viXFLKUQWb';

class ImageRepository {
  int limit = 10;
  Future<List<ImageModel>> fetchImages() async {
    final response = await http.get(Uri.parse(
        'https://api.thecatapi.com/v1/images/search?limit=$limit&api_key=$apiKey'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => ImageModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
