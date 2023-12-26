import 'package:news_app/models/news_cateogoy.dart';
import 'package:news_app/models/news_channel_api_model.dart';
import 'package:news_app/repositories/newsrepository.dart';

class NewsViewModel {
  Future<NewsChhannelHeadlinesModel> fetchNewsChannelHeadingApi() async {
    final response = await NewsRepository.fetchNewsChannelHeadingApi();
    return response;
  }

  Future<CategoryNewsModel> fetchcategoryNewsApi(String category) async {
    final response = await NewsRepository.fetchCategoryNewsApi(category);
    return response;
  }
}
