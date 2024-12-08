import 'package:gmaps/models/categories_news_model.dart';
import 'package:gmaps/models/news_channel_headlines_model.dart';
import 'package:gmaps/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(String name) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(name);
    return response;
  }
   Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}
