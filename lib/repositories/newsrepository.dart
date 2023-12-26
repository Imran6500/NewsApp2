import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/news_cateogoy.dart';
import 'package:news_app/models/news_channel_api_model.dart';

class NewsRepository {
  static Future<NewsChhannelHeadlinesModel> fetchNewsChannelHeadingApi() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=bfe968196ecf4829a91d8d6e228acbdb';
    final response = await http.get(Uri.parse(url));
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChhannelHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  static Future<CategoryNewsModel> fetchCategoryNewsApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=bfe968196ecf4829a91d8d6e228acbdb';
    final response = await http.get(Uri.parse(url));
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoryNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
