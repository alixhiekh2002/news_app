import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gmaps/models/categories_news_model.dart';
import 'package:gmaps/models/news_channel_headlines_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(String name) async {
    String url =

        "https://newsapi.org/v2/top-headlines?sources=${name}&apiKey=e548734a6fc2475eadef8818d5e69c02";
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception("Error");
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=${category}&apiKey=e548734a6fc2475eadef8818d5e69c02";
    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception("Error");
  }
}

